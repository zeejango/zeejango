// Copyright (c) 2024 Rohan Vashisht

// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:

// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#ifndef ZEEJANGO_H
#define ZEEJANGO_H

#include <arpa/inet.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

struct zeejango_structure {
  int server_fd;
  struct sockaddr_in address_struct;
  int address_length;
};

inline struct zeejango_structure zeejangoinit(int port) {
  int server_file_descriptor;
  struct sockaddr_in address_struct;
  int address_length = sizeof(address_struct);

  if ((server_file_descriptor = socket(AF_INET, SOCK_STREAM, 0)) == 0) {
    perror("socket failed");
    exit(EXIT_FAILURE);
  }

  address_struct.sin_family = AF_INET;
  address_struct.sin_addr.s_addr = INADDR_ANY;
  address_struct.sin_port = htons(port);
  if (bind(server_file_descriptor, (struct sockaddr *)&address_struct,
           sizeof(address_struct)) < 0) {
    perror("bind failed");
    exit(EXIT_FAILURE);
  }

  if (listen(server_file_descriptor, 300) < 0) {
    perror("listen");
    exit(EXIT_FAILURE);
  }
  struct zeejango_structure ini;
  ini.server_fd = server_file_descriptor;
  ini.address_struct = address_struct;
  ini.address_length = address_length;
  return ini;
}

typedef char *(*FunctionPtr)(char *);

inline void zeejango_listener(struct zeejango_structure y, FunctionPtr func) {
  int new_socket;
  while (1) {
    if ((new_socket = accept(y.server_fd, (struct sockaddr *)&y.address_struct,
                             (socklen_t *)&y.address_length)) < 0) {
      perror("accept");
      exit(EXIT_FAILURE);
    }

    char buffer[30000] = {0};
    read(new_socket, buffer, 30000);
    printf("%s\n", buffer);

    char *responce = func(buffer);

    write(new_socket, responce, strlen(responce));
    close(new_socket);
  }
}

#endif // ZEEJANGO_H