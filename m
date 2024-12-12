Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0676221660C;
	Thu, 12 Dec 2024 15:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015866; cv=none; b=EbrEflgbDMA2pNd9WyR6U9mg7eyETPbwpLQn8E2OGETCqE08Ptr4tP89yXqqZAcbsdPXzJkw5/VIkwn3u0ssYJw2JjyqgiLGJPYl3GSgaDKq1/xi8rn/Qy7OUeU/iDHYmPKE6hKm4h4oQrUW2OhiVH/+0uQFDdav4726nyhUvy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015866; c=relaxed/simple;
	bh=v4QIljcFrdEU6gdwJxofXdbBA9jJ+mSwu1Vxp15D4s0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ii5E0PPsoeM8U+hAO/aMVu9ZKKLuUuJChaINMVozxtG7culQDA51Ukeul7lB3tKpYvuWMsxDiIxSTsFaalpmm2+pHT4qHs3/8p0X/2PfCiFB3xCa58g0yh2K7MsI/G0FRSD1DirF6bbTPaVCnJeG3VE85nH1UzbDhSYe3TgsvPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lphJoewr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lphJoewr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65601C4CECE;
	Thu, 12 Dec 2024 15:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015865;
	bh=v4QIljcFrdEU6gdwJxofXdbBA9jJ+mSwu1Vxp15D4s0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lphJoewrCpkqCBFyXsMKQWyjTHZI3PMhH7wlG/gQKqyNrBabmc3mIkQA99at42Ymq
	 WZpOxNuZzTp+2fTnabowVi//RJ5vABLDUuM7ApE3JrgAq27Hi4Jw+/5pPjrazGQbBx
	 zgDGu9HsXk7SXuFpdkcDt0clDQArMud047K5fk6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Shkolnyy <kshk@linux.ibm.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 059/466] vsock/test: fix parameter types in SO_VM_SOCKETS_* calls
Date: Thu, 12 Dec 2024 15:53:48 +0100
Message-ID: <20241212144309.149802958@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Shkolnyy <kshk@linux.ibm.com>

[ Upstream commit 3f36ee29e732b68044d531f47d31f22d265954c6 ]

Change parameters of SO_VM_SOCKETS_* to unsigned long long as documented
in the vm_sockets.h, because the corresponding kernel code requires them
to be at least 64-bit, no matter what architecture. Otherwise they are
too small on 32-bit machines.

Fixes: 5c338112e48a ("test/vsock: rework message bounds test")
Fixes: 685a21c314a8 ("test/vsock: add big message test")
Fixes: 542e893fbadc ("vsock/test: two tests to check credit update logic")
Fixes: 8abbffd27ced ("test/vsock: vsock_perf utility")
Signed-off-by: Konstantin Shkolnyy <kshk@linux.ibm.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/vsock/vsock_perf.c |  4 ++--
 tools/testing/vsock/vsock_test.c | 22 +++++++++++++++++-----
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/tools/testing/vsock/vsock_perf.c b/tools/testing/vsock/vsock_perf.c
index 22633c2848cc7..8e0a6c0770d37 100644
--- a/tools/testing/vsock/vsock_perf.c
+++ b/tools/testing/vsock/vsock_perf.c
@@ -33,7 +33,7 @@
 
 static unsigned int port = DEFAULT_PORT;
 static unsigned long buf_size_bytes = DEFAULT_BUF_SIZE_BYTES;
-static unsigned long vsock_buf_bytes = DEFAULT_VSOCK_BUF_BYTES;
+static unsigned long long vsock_buf_bytes = DEFAULT_VSOCK_BUF_BYTES;
 static bool zerocopy;
 
 static void error(const char *s)
@@ -162,7 +162,7 @@ static void run_receiver(int rcvlowat_bytes)
 	printf("Run as receiver\n");
 	printf("Listen port %u\n", port);
 	printf("RX buffer %lu bytes\n", buf_size_bytes);
-	printf("vsock buffer %lu bytes\n", vsock_buf_bytes);
+	printf("vsock buffer %llu bytes\n", vsock_buf_bytes);
 	printf("SO_RCVLOWAT %d bytes\n", rcvlowat_bytes);
 
 	fd = socket(AF_VSOCK, SOCK_STREAM, 0);
diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index 7fd25b814b4b6..0b7f5bf546da5 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -429,7 +429,7 @@ static void test_seqpacket_msg_bounds_client(const struct test_opts *opts)
 
 static void test_seqpacket_msg_bounds_server(const struct test_opts *opts)
 {
-	unsigned long sock_buf_size;
+	unsigned long long sock_buf_size;
 	unsigned long remote_hash;
 	unsigned long curr_hash;
 	int fd;
@@ -634,7 +634,8 @@ static void test_seqpacket_timeout_server(const struct test_opts *opts)
 
 static void test_seqpacket_bigmsg_client(const struct test_opts *opts)
 {
-	unsigned long sock_buf_size;
+	unsigned long long sock_buf_size;
+	size_t buf_size;
 	socklen_t len;
 	void *data;
 	int fd;
@@ -655,13 +656,20 @@ static void test_seqpacket_bigmsg_client(const struct test_opts *opts)
 
 	sock_buf_size++;
 
-	data = malloc(sock_buf_size);
+	/* size_t can be < unsigned long long */
+	buf_size = (size_t)sock_buf_size;
+	if (buf_size != sock_buf_size) {
+		fprintf(stderr, "Returned BUFFER_SIZE too large\n");
+		exit(EXIT_FAILURE);
+	}
+
+	data = malloc(buf_size);
 	if (!data) {
 		perror("malloc");
 		exit(EXIT_FAILURE);
 	}
 
-	send_buf(fd, data, sock_buf_size, 0, -EMSGSIZE);
+	send_buf(fd, data, buf_size, 0, -EMSGSIZE);
 
 	control_writeln("CLISENT");
 
@@ -1360,6 +1368,7 @@ static void test_stream_credit_update_test(const struct test_opts *opts,
 	int recv_buf_size;
 	struct pollfd fds;
 	size_t buf_size;
+	unsigned long long sock_buf_size;
 	void *buf;
 	int fd;
 
@@ -1371,8 +1380,11 @@ static void test_stream_credit_update_test(const struct test_opts *opts,
 
 	buf_size = RCVLOWAT_CREDIT_UPD_BUF_SIZE;
 
+	/* size_t can be < unsigned long long */
+	sock_buf_size = buf_size;
+
 	if (setsockopt(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_SIZE,
-		       &buf_size, sizeof(buf_size))) {
+		       &sock_buf_size, sizeof(sock_buf_size))) {
 		perror("setsockopt(SO_VM_SOCKETS_BUFFER_SIZE)");
 		exit(EXIT_FAILURE);
 	}
-- 
2.43.0



