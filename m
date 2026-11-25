Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623978;
	b=4frMllMaaKCxKFlF89onWpLiAWu8+S7wfcLtdzM6meSEYkQXboTLBkXD0FivNlnrdF9H
	 lW356Sa28ckpd0aYpljTrNF7uIi3ZlRYdPPnFk0w+0HifxpzbdBedKyfuVpLGyH1hZSP9
	 fRTeZIiMup2nKpwh0liTLI0CV3Hj1Yv12ydg54WL2s8/Tt60La7I3XxCouveIAogDLOKr
	 HFO8+GEHYMjx8LzZKhlwlXDkrBWEqemLUlifF1Dt781jQm+pG3nCAdeqTEyeR4wCaDWsp
	 UzN/BPvty+h61mEEK73o4bUkc94wjrYvZO4InQKtCFKE4G0USRmcX/Ft1/4bf96ynDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623978;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jvjAGHYUTbvftkXNcYyQ/Fginn21wzsMF6hot0xh9XI=;
	b=GEZNyQFAhjWhXeYcVZC5vpECaTVCVd/z1gIUkQdbMBBA/n3oLzicg8FlGS23VQbCL6Vm
	 F4tBqOoPJ2FbEizNAPBFbpj804i2bxFUrRO7/g+xEt2zI2PId8x6zOUcdtOK5JK7s6La8
	 P/JEhP5jzIoOVR0LA2/xdsoN0WSVJNYnA2EnKk/SvAXZzWceUOVMLpkgZiLVUQ12Q7jtf
	 PF9S9Lmx9++OfK82+TkZoT1QSfDaODaQtUl/hE9DLNRmq/NRfSG37CRrV9h55qr9bVo/A
	 iB9GkFel/unbop/ysPO4whJbSBx6zwObv5MWZihVHvxcZUtt4gtNPLvK2XOyATNvsTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="SXLEvY/v";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD14606A31E;
	Wed, 25 Nov 2026 16:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SXLEvY/v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C80731F000C0;
	Wed, 25 Nov 2026 16:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623978;
	bh=jvjAGHYUTbvftkXNcYyQ/Fginn21wzsMF6hot0xh9XI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SXLEvY/vn6yyhGn7PjLk+TGp/yNiaYNtMLSP163YcGacpbUXlP5exSUA0Q92EBM68
	 DG4cLi4R4LMILlv3x9vZR8w4nMyGs6m2oagtOa7CeTnZSMD00bTDcSGU08qKKFQhGB
	 8CbN7mpmQeuwlGKrBrF0CWC+Cs65lI5cIFgaOAtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Sandeen <sandeen@redhat.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 048/816] net/9p: move structures and macros to header files
Date: Wed, 25 Nov 2026 15:26:36 +0100
Message-ID: <20261125143850.332172426@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Sandeen <sandeen@redhat.com>

[ Upstream commit c44393d84149d6fc91d94fa39321c9657e91b388 ]

With the new mount API all option parsing will need to happen
in fs/v9fs.c, so move some existing data structures and macros
to header files to facilitate this. Rename some to reflect
the transport they are used for (rdma, fd, etc), for clarity.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Message-ID: <20251010214222.1347785-3-sandeen@redhat.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Stable-dep-of: 37dce65a0b43 ("9p: use fc->net_ns for network namespace in RDMA and socket transports")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/9p/client.h    |  6 ++++++
 include/net/9p/transport.h | 39 ++++++++++++++++++++++++++++++++++++++
 net/9p/client.c            |  6 ------
 net/9p/trans_fd.c          | 20 ++-----------------
 net/9p/trans_rdma.c        | 25 ++----------------------
 5 files changed, 49 insertions(+), 47 deletions(-)

diff --git a/include/net/9p/client.h b/include/net/9p/client.h
index 4f785098c67a1..2d46f8017bd57 100644
--- a/include/net/9p/client.h
+++ b/include/net/9p/client.h
@@ -16,6 +16,12 @@
 /* Number of requests per row */
 #define P9_ROW_MAXTAG 255
 
+/* DEFAULT MSIZE = 32 pages worth of payload + P9_HDRSZ +
+ * room for write (16 extra) or read (11 extra) operands.
+ */
+
+#define DEFAULT_MSIZE ((128 * 1024) + P9_IOHDRSZ)
+
 /** enum p9_proto_versions - 9P protocol versions
  * @p9_proto_legacy: 9P Legacy mode, pre-9P2000.u
  * @p9_proto_2000u: 9P2000.u extension
diff --git a/include/net/9p/transport.h b/include/net/9p/transport.h
index 766ec07c95999..88702953b1ef2 100644
--- a/include/net/9p/transport.h
+++ b/include/net/9p/transport.h
@@ -14,6 +14,45 @@
 #define P9_DEF_MIN_RESVPORT	(665U)
 #define P9_DEF_MAX_RESVPORT	(1023U)
 
+#define P9_FD_PORT 564
+
+#define P9_RDMA_PORT		5640
+#define P9_RDMA_SQ_DEPTH	32
+#define P9_RDMA_RQ_DEPTH	32
+#define P9_RDMA_TIMEOUT		30000		/* 30 seconds */
+
+/**
+ * struct p9_fd_opts - per-transport options for fd transport
+ * @rfd: file descriptor for reading (trans=fd)
+ * @wfd: file descriptor for writing (trans=fd)
+ * @port: port to connect to (trans=tcp)
+ * @privport: port is privileged
+ */
+
+struct p9_fd_opts {
+	int rfd;
+	int wfd;
+	u16 port;
+	bool privport;
+};
+
+/**
+ * struct p9_rdma_opts - Collection of mount options for rdma transport
+ * @port: port of connection
+ * @privport: Whether a privileged port may be used
+ * @sq_depth: The requested depth of the SQ. This really doesn't need
+ * to be any deeper than the number of threads used in the client
+ * @rq_depth: The depth of the RQ. Should be greater than or equal to SQ depth
+ * @timeout: Time to wait in msecs for CM events
+ */
+struct p9_rdma_opts {
+	short port;
+	bool privport;
+	int sq_depth;
+	int rq_depth;
+	long timeout;
+};
+
 /**
  * struct p9_trans_module - transport module interface
  * @list: used to maintain a list of currently available transports
diff --git a/net/9p/client.c b/net/9p/client.c
index 17f7b1290f6b9..d7802d67724cd 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -29,12 +29,6 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/9p.h>
 
-/* DEFAULT MSIZE = 32 pages worth of payload + P9_HDRSZ +
- * room for write (16 extra) or read (11 extra) operands.
- */
-
-#define DEFAULT_MSIZE ((128 * 1024) + P9_IOHDRSZ)
-
 /* Client Option Parsing (code inspired by NFS code)
  *  - a little lazy - parse all client options
  */
diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index a516745f732f7..fdaebb549aa8f 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -31,28 +31,12 @@
 
 #include <linux/syscalls.h> /* killme */
 
-#define P9_PORT 564
 #define MAX_SOCK_BUF (1024*1024)
 #define MAXPOLLWADDR	2
 
 static struct p9_trans_module p9_tcp_trans;
 static struct p9_trans_module p9_fd_trans;
 
-/**
- * struct p9_fd_opts - per-transport options
- * @rfd: file descriptor for reading (trans=fd)
- * @wfd: file descriptor for writing (trans=fd)
- * @port: port to connect to (trans=tcp)
- * @privport: port is privileged
- */
-
-struct p9_fd_opts {
-	int rfd;
-	int wfd;
-	u16 port;
-	bool privport;
-};
-
 /*
   * Option Parsing (code inspired by NFS code)
   *  - a little lazy - parse all fd-transport options
@@ -742,7 +726,7 @@ static int p9_fd_cancelled(struct p9_client *client, struct p9_req_t *req)
 static int p9_fd_show_options(struct seq_file *m, struct p9_client *clnt)
 {
 	if (clnt->trans_mod == &p9_tcp_trans) {
-		if (clnt->trans_opts.tcp.port != P9_PORT)
+		if (clnt->trans_opts.tcp.port != P9_FD_PORT)
 			seq_printf(m, ",port=%u", clnt->trans_opts.tcp.port);
 	} else if (clnt->trans_mod == &p9_fd_trans) {
 		if (clnt->trans_opts.fd.rfd != ~0)
@@ -768,7 +752,7 @@ static int parse_opts(char *params, struct p9_fd_opts *opts)
 	int option;
 	char *options, *tmp_options;
 
-	opts->port = P9_PORT;
+	opts->port = P9_FD_PORT;
 	opts->rfd = ~0;
 	opts->wfd = ~0;
 	opts->privport = false;
diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index d9f53f1da2c21..92b166a4a1e52 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -32,14 +32,10 @@
 #include <rdma/ib_verbs.h>
 #include <rdma/rdma_cm.h>
 
-#define P9_PORT			5640
-#define P9_RDMA_SQ_DEPTH	32
-#define P9_RDMA_RQ_DEPTH	32
 #define P9_RDMA_SEND_SGE	4
 #define P9_RDMA_RECV_SGE	4
 #define P9_RDMA_IRD		0
 #define P9_RDMA_ORD		0
-#define P9_RDMA_TIMEOUT		30000		/* 30 seconds */
 #define P9_RDMA_MAXSIZE		(1024*1024)	/* 1MB */
 
 /**
@@ -110,23 +106,6 @@ struct p9_rdma_context {
 	};
 };
 
-/**
- * struct p9_rdma_opts - Collection of mount options
- * @port: port of connection
- * @privport: Whether a privileged port may be used
- * @sq_depth: The requested depth of the SQ. This really doesn't need
- * to be any deeper than the number of threads used in the client
- * @rq_depth: The depth of the RQ. Should be greater than or equal to SQ depth
- * @timeout: Time to wait in msecs for CM events
- */
-struct p9_rdma_opts {
-	short port;
-	bool privport;
-	int sq_depth;
-	int rq_depth;
-	long timeout;
-};
-
 /*
  * Option Parsing (code inspired by NFS code)
  */
@@ -151,7 +130,7 @@ static int p9_rdma_show_options(struct seq_file *m, struct p9_client *clnt)
 {
 	struct p9_trans_rdma *rdma = clnt->trans;
 
-	if (rdma->port != P9_PORT)
+	if (rdma->port != P9_RDMA_PORT)
 		seq_printf(m, ",port=%u", rdma->port);
 	if (rdma->sq_depth != P9_RDMA_SQ_DEPTH)
 		seq_printf(m, ",sq=%u", rdma->sq_depth);
@@ -178,7 +157,7 @@ static int parse_opts(char *params, struct p9_rdma_opts *opts)
 	int option;
 	char *options, *tmp_options;
 
-	opts->port = P9_PORT;
+	opts->port = P9_RDMA_PORT;
 	opts->sq_depth = P9_RDMA_SQ_DEPTH;
 	opts->rq_depth = P9_RDMA_RQ_DEPTH;
 	opts->timeout = P9_RDMA_TIMEOUT;
-- 
2.53.0



