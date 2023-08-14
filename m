Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD43BA29
	for <patches@lists.linux.dev>; Mon, 14 Aug 2023 09:24:33 +0000 (UTC)
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-522bd411679so5405080a12.0
        for <patches@lists.linux.dev>; Mon, 14 Aug 2023 02:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692005072; x=1692609872;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1rK9u+QG+h40KeQlb16juGHEUBxcT1xsPJuDKC4iwu8=;
        b=jl6S281Liiq2X1xqIZFiWQlaY8suE5U4GTxZauc4fQXZNus1PQw37KGjBix9ruCPvF
         UJARaoJPUd0wfnRIr5iCx4kxFA/Cw0mI41oQH5jp/JckcS5VfXTujf10SZsHPzKQVx+K
         5yEG4aFNVeCJYRN4+dtmWnZocOljXiH4hMASbKaBhF5mxYkW7XrXZz/YBL9icsOtG1j8
         v18np/ZduIJ5Sj3vwF2jkPEgcPrVt9Lz3oV8u+os88AIzWZY6XcXSzPbYf/es22Ur2UZ
         zfcv0cPECIbOHBTd7vQ34iWpJTh8NhYVSQGmyaPthTAvI0j7tf7S+2TAJZMyJV9QPC4v
         N+Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692005072; x=1692609872;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1rK9u+QG+h40KeQlb16juGHEUBxcT1xsPJuDKC4iwu8=;
        b=QSCRMmZVK3J4zuuAc/FDlW+om4Zs7lkPaen6Ta0VWwvW122epWbbbh+w205o3jf+58
         qFrBPHbM9JJjNi2kvPe8Spr7RPyPL09V+3SXStyuezKS7WnfjjFzPOJQ/TGIm5A7l11v
         hNzvI/0T56fBBU4neEqLOGl9iYTq4F+LmevXkiTd+pl9+xiDmElbEV8652WtyAA74az9
         ZpBoWnYxZec2DlXnaW4ux5HX3eageo3eQTVdyp5z69+/JcTlVz744nRaqlo9Yp65M/Ze
         YAfaSZW2wlfdIns2wGpojFVXQA/ksTv9y8s16nC3LnSwuJGsA0uK1YQ6SB9fJr9SdC8y
         CxMQ==
X-Gm-Message-State: AOJu0YzshyOaYcWOIBaRnSMtKdZ0CRAc6vfUIIw51d5+z5H49m+Xotfp
	MuNSnDT97nzY1t9wAm90fwg=
X-Google-Smtp-Source: AGHT+IFjBxrPkAdmZDbVFsJlDFwxO37AjM7o+M1mH41Nfk3J31zWtIZ1bYoqo5L/kpWOja0YMOaHAg==
X-Received: by 2002:aa7:d486:0:b0:522:cb97:f196 with SMTP id b6-20020aa7d486000000b00522cb97f196mr8437549edr.36.1692005072002;
        Mon, 14 Aug 2023 02:24:32 -0700 (PDT)
Received: from micheledallerive.home ([2a02:1210:6051:ec00:61e9:3767:83a6:9bd9])
        by smtp.gmail.com with ESMTPSA id b5-20020aa7c6c5000000b005224d960e66sm5314879eds.96.2023.08.14.02.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 02:24:31 -0700 (PDT)
From: Michele Dalle Rive <dallerivemichele@gmail.com>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	"David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Alice Ryhl <aliceryhl@google.com>,
	Davide Rovelli <davide.rovelli@usi.ch>,
	rust-for-linux@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Michele Dalle Rive <dallerivemichele@gmail.com>
Subject: [RFC PATCH 7/7] rust: net: add socket UDP wrappers.
Date: Mon, 14 Aug 2023 11:23:02 +0200
Message-ID: <20230814092302.1903203-8-dallerivemichele@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230814092302.1903203-1-dallerivemichele@gmail.com>
References: <20230814092302.1903203-1-dallerivemichele@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a UDP socket wrapper, which allows to handle UDP sockets conveniently.

This interface is intended to be as close as possible to the one in `std::net`.

Signed-off-by: Michele Dalle Rive <dallerivemichele@gmail.com>
---
 rust/kernel/net.rs     |   1 +
 rust/kernel/net/udp.rs | 182 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 183 insertions(+)
 create mode 100644 rust/kernel/net/udp.rs

diff --git a/rust/kernel/net.rs b/rust/kernel/net.rs
index c7d9d4b0bcab..c527bd1fb0a8 100644
--- a/rust/kernel/net.rs
+++ b/rust/kernel/net.rs
@@ -14,6 +14,7 @@
 pub mod ip;
 pub mod socket;
 pub mod tcp;
+pub mod udp;
 
 /// The address family.
 ///
diff --git a/rust/kernel/net/udp.rs b/rust/kernel/net/udp.rs
new file mode 100644
index 000000000000..9193292a30f6
--- /dev/null
+++ b/rust/kernel/net/udp.rs
@@ -0,0 +1,182 @@
+// SPDX-License-Identifier: GPL-2.0
+
+//! UDP socket wrapper.
+//!
+//! This module contains wrappers for a UDP Socket ([`UdpSocket`]).
+//! The wrapper is just convenience structs around the generic [`Socket`] type.
+//!
+//! The API is inspired by the Rust standard library's [`UdpSocket`](https://doc.rust-lang.org/std/net/struct.UdpSocket.html).
+
+use crate::error::Result;
+use crate::net::addr::SocketAddr;
+use crate::net::ip::IpProtocol;
+use crate::net::socket::flags::{FlagSet, ReceiveFlag, SendFlag};
+use crate::net::socket::{opts::SocketOption, MessageHeader, SockType, Socket};
+use crate::net::AddressFamily;
+use kernel::net::socket::opts::WritableOption;
+
+/// A UDP socket.
+///
+/// Provides an interface to send and receive UDP packets, removing
+/// all the socket functionality that is not needed for UDP.
+///
+/// # Examples
+/// ```rust
+/// use kernel::flag_set;
+/// use kernel::net::udp::UdpSocket;
+/// use kernel::net::addr::*;
+///
+/// let socket = UdpSocket::new().unwrap();
+/// socket.bind(SocketAddr::V4(SocketAddrV4::new(Ipv4Addr::LOOPBACK, 8000))).unwrap();
+/// let mut buf = [0u8; 1024];
+/// while let Ok((len, addr)) = socket.receive_from(&mut buf, flag_set!()) {
+///     socket.send_to(&buf[..len], &addr, flag_set!()).unwrap();
+/// }
+/// ```
+pub struct UdpSocket(pub(crate) Socket);
+
+impl UdpSocket {
+    /// Creates a UDP socket.
+    ///
+    /// Returns a [`UdpSocket`] on success.
+    pub fn new() -> Result<Self> {
+        Ok(Self(Socket::new(
+            AddressFamily::Inet,
+            SockType::Datagram,
+            IpProtocol::Udp,
+        )?))
+    }
+
+    /// Binds the socket to the given address.
+    pub fn bind(&self, address: SocketAddr) -> Result {
+        self.0.bind(address)
+    }
+
+    /// Returns the socket's local address.
+    ///
+    /// This function assumes the socket is bound,
+    /// i.e. it must be called after [`bind()`](UdpSocket::bind).
+    ///
+    /// # Examples
+    /// ```rust
+    /// use kernel::net::udp::UdpSocket;
+    /// use kernel::net::addr::*;
+    ///
+    /// let socket = UdpSocket::new().unwrap();
+    /// let local_addr = SocketAddr::V4(SocketAddrV4::new(Ipv4Addr::LOOPBACK, 8000));
+    /// socket.bind(local_addr).unwrap();
+    /// assert_eq!(socket.sockname().unwrap(), local_addr);
+    pub fn sockname(&self) -> Result<SocketAddr> {
+        self.0.sockname()
+    }
+
+    /// Returns the socket's peer address.
+    ///
+    /// This function assumes the socket is connected,
+    /// i.e. it must be called after [`connect()`](UdpSocket::connect).
+    ///
+    /// # Examples
+    /// ```rust
+    /// use kernel::net::udp::UdpSocket;
+    /// use kernel::net::addr::*;
+    ///
+    /// let socket = UdpSocket::new().unwrap();
+    /// let peer_addr = SocketAddr::V4(SocketAddrV4::new(Ipv4Addr::LOOPBACK, 8000));
+    /// socket.connect(&peer_addr).unwrap();
+    /// assert_eq!(socket.peername().unwrap(), peer_addr);
+    pub fn peername(&self) -> Result<SocketAddr> {
+        self.0.peername()
+    }
+
+    /// Receive a message from the socket.
+    ///
+    /// The given flags are used to modify the behavior of the receive operation.
+    /// See [`ReceiveFlag`] for more.
+    ///
+    /// The returned [`MessageHeader`] contains metadata about the received message.
+    ///
+    /// See [`Socket::receive_msg()`] for more.
+    pub fn receive_msg(
+        &self,
+        buf: &mut [u8],
+        flags: FlagSet<ReceiveFlag>,
+    ) -> Result<(usize, MessageHeader)> {
+        self.0.receive_msg(buf, flags)
+    }
+
+    /// Receives data from another socket.
+    ///
+    /// The given flags are used to modify the behavior of the receive operation.
+    /// See [`ReceiveFlag`] for more.
+    ///
+    /// Returns the number of bytes received and the address of the sender.
+    pub fn receive_from(
+        &self,
+        buf: &mut [u8],
+        flags: FlagSet<ReceiveFlag>,
+    ) -> Result<(usize, SocketAddr)> {
+        self.0
+            .receive_from(buf, flags)
+            .map(|(size, addr)| (size, addr.unwrap()))
+    }
+
+    /// Sends data to another socket.
+    ///
+    /// The given flags are used to modify the behavior of the send operation.
+    /// See [`SendFlag`] for more.
+    ///
+    /// Returns the number of bytes sent.
+    pub fn send_to(
+        &self,
+        buf: &[u8],
+        address: &SocketAddr,
+        flags: FlagSet<SendFlag>,
+    ) -> Result<usize> {
+        self.0.send_to(buf, address, flags)
+    }
+
+    /// Connects the socket to the given address.
+    ///
+    /// # Examples
+    /// ```rust
+    /// use kernel::net::udp::UdpSocket;
+    /// use kernel::net::addr::*;
+    ///
+    /// let socket = UdpSocket::new().unwrap();
+    /// let peer_addr = SocketAddr::V4(SocketAddrV4::new(Ipv4Addr::LOOPBACK, 8000));
+    /// socket.connect(&peer_addr).unwrap();
+    /// ```
+    pub fn connect(&self, address: &SocketAddr) -> Result {
+        self.0.connect(address, 0)
+    }
+
+    /// Receives data from the connected socket.
+    ///
+    /// This function assumes the socket is connected,
+    /// i.e. it must be called after [`connect()`](UdpSocket::connect).
+    ///
+    /// Returns the number of bytes received.
+    pub fn receive(&self, buf: &mut [u8], flags: FlagSet<ReceiveFlag>) -> Result<usize> {
+        self.0.receive(buf, flags)
+    }
+
+    /// Sends data to the connected socket.
+    ///
+    /// This function assumes the socket is connected,
+    /// i.e. it must be called after [`connect()`](UdpSocket::connect).
+    ///
+    /// Returns the number of bytes sent.
+    pub fn send(&self, buf: &[u8], flags: FlagSet<SendFlag>) -> Result<usize> {
+        self.0.send(buf, flags)
+    }
+
+    /// Sets the value of the given option.
+    ///
+    /// See [`Socket::set_option()`](Socket::set_option) for more.
+    pub fn set_option<O>(&self, value: impl Into<O::Type>) -> Result
+    where
+        O: SocketOption + WritableOption,
+    {
+        self.0.set_option::<O>(value)
+    }
+}
-- 
2.41.0

