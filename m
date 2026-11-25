Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623970;
	b=s8j77dHP0cT9Ots24NtkAIOEt1iVo5tlaBf2h9ba+/gdHILVB0Ucv2SrsuVI/kpNpk1L
	 deQn1nPBgHS277P5TcMcrYvTSFU8hrMz8Y93rTnuiqxPV/1P9EpKuU4sYMW+qZPtGcANd
	 gpdWJeTxfFu3QveGefq1Ce87JEI7GKQa7Vxpx5X8O4BP8OqGpC5WvXutWvUtpJ19ZYdqk
	 FqDnjevZseYDM4SEpiQXObYlBKK6Xpxvo3ze/lT2NqERbUkRxuxx54NOUMt0YtVuPTDZW
	 7xAAm48Yb/C8dRvXZ/OcRuNVuhg1fayZ/rLaD2gL1PBwhQJdZDwrxfzGTWjPPe179XA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623970;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8Hl6ZTVEnkm0ujm8GGujk0rfb+4+OogS2uoWJ83VPpo=;
	b=gQ+BvIiyXbcJUUOsWNMUlZdID575bFSd0Gh2Tys4fFIwUbY+DbMpf3jkkrvWh39IqkxV
	 nBo7AjBTWGcm1LbQydgfiP7AhJXiAxAEGGvDRcR8flIV2SgFOVDlALqGuejVQk8ynvKCR
	 sYKwp3rziTa0fBMEZL9n0ape6n41pqClQWSkchHP/H0U9w/tKgtqILNiHmHZW9PCJGa2i
	 nQAcz1sm4FtqGUFcRizwk+Yxqs5rPVqiGtijMt44ynviMzeWJWFAeCI9WoIXldueMRDe2
	 RZZcfff8g8KrbnyP2hbqu2b6zlkg0llCl40SeiR5pLH6YH6DamXntj5LNgRbuh+evbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ljD8a8Jh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0A9606A31E;
	Wed, 25 Nov 2026 16:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ljD8a8Jh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4321F000C4;
	Wed, 25 Nov 2026 16:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623969;
	bh=8Hl6ZTVEnkm0ujm8GGujk0rfb+4+OogS2uoWJ83VPpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ljD8a8JhYHDTR4GMOJCsudK7olZ6KwCUAxM4G7TLC+ASjsdkOXyrtHGSOK7J/UGih
	 afigJMd9/Y57KStvkWBAGOue8vZlgcR4rLQqkb/1TJo8m0oET0MY80RlZ8rIe75BLT
	 MO7Ke7Fg0PZs/87zzpwjwopMinX48GOkMkgRsWvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Murphy <joshuamurphy@posteo.net>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 045/816] net/9p/fd: support ipv6 for trans=tcp
Date: Wed, 25 Nov 2026 15:26:33 +0100
Message-ID: <20261125143850.264979578@linuxfoundation.org>
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

From: Joshua Murphy <joshuamurphy@posteo.net>

[ Upstream commit a22a29655c42d0263a7a84d5d808bfd55f20c53a ]

Allows specifying an IPv6 address when mounting a remote 9p file system.

Signed-off-by: Joshua Murphy <joshuamurphy@posteo.net>
Message-ID: <20250118192122.327-2-joshuamurphy@posteo.net>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Stable-dep-of: 37dce65a0b43 ("9p: use fc->net_ns for network namespace in RDMA and socket transports")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_fd.c | 56 ++++++++++++++++++++---------------------------
 1 file changed, 24 insertions(+), 32 deletions(-)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 5bdfc25689169..a516745f732f7 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -11,6 +11,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/in.h>
+#include <linux/in6.h>
 #include <linux/module.h>
 #include <linux/net.h>
 #include <linux/ipv6.h>
@@ -950,64 +951,55 @@ static void p9_fd_close(struct p9_client *client)
 	kfree(ts);
 }
 
-/*
- * stolen from NFS - maybe should be made a generic function?
- */
-static inline int valid_ipaddr4(const char *buf)
-{
-	int rc, count, in[4];
-
-	rc = sscanf(buf, "%d.%d.%d.%d", &in[0], &in[1], &in[2], &in[3]);
-	if (rc != 4)
-		return -EINVAL;
-	for (count = 0; count < 4; count++) {
-		if (in[count] > 255)
-			return -EINVAL;
-	}
-	return 0;
-}
-
 static int p9_bind_privport(struct socket *sock)
 {
-	struct sockaddr_in cl;
+	struct sockaddr_storage stor = { 0 };
 	int port, err = -EINVAL;
 
-	memset(&cl, 0, sizeof(cl));
-	cl.sin_family = AF_INET;
-	cl.sin_addr.s_addr = htonl(INADDR_ANY);
+	stor.ss_family = sock->ops->family;
+	if (stor.ss_family == AF_INET)
+		((struct sockaddr_in *)&stor)->sin_addr.s_addr = htonl(INADDR_ANY);
+	else
+		((struct sockaddr_in6 *)&stor)->sin6_addr = in6addr_any;
 	for (port = p9_ipport_resv_max; port >= p9_ipport_resv_min; port--) {
-		cl.sin_port = htons((ushort)port);
-		err = kernel_bind(sock, (struct sockaddr *)&cl, sizeof(cl));
+		if (stor.ss_family == AF_INET)
+			((struct sockaddr_in *)&stor)->sin_port = htons((ushort)port);
+		else
+			((struct sockaddr_in6 *)&stor)->sin6_port = htons((ushort)port);
+		err = kernel_bind(sock, (struct sockaddr *)&stor, sizeof(stor));
 		if (err != -EADDRINUSE)
 			break;
 	}
 	return err;
 }
 
-
 static int
 p9_fd_create_tcp(struct p9_client *client, const char *addr, char *args)
 {
 	int err;
+	char port_str[6];
 	struct socket *csocket;
-	struct sockaddr_in sin_server;
+	struct sockaddr_storage stor = { 0 };
 	struct p9_fd_opts opts;
 
 	err = parse_opts(args, &opts);
 	if (err < 0)
 		return err;
 
-	if (addr == NULL || valid_ipaddr4(addr) < 0)
+	if (!addr)
 		return -EINVAL;
 
+	sprintf(port_str, "%u", opts.port);
+	err = inet_pton_with_scope(current->nsproxy->net_ns, AF_UNSPEC, addr,
+				   port_str, &stor);
+	if (err < 0)
+		return err;
+
 	csocket = NULL;
 
 	client->trans_opts.tcp.port = opts.port;
 	client->trans_opts.tcp.privport = opts.privport;
-	sin_server.sin_family = AF_INET;
-	sin_server.sin_addr.s_addr = in_aton(addr);
-	sin_server.sin_port = htons(opts.port);
-	err = __sock_create(current->nsproxy->net_ns, PF_INET,
+	err = __sock_create(current->nsproxy->net_ns, stor.ss_family,
 			    SOCK_STREAM, IPPROTO_TCP, &csocket, 1);
 	if (err) {
 		pr_err("%s (%d): problem creating socket\n",
@@ -1026,8 +1018,8 @@ p9_fd_create_tcp(struct p9_client *client, const char *addr, char *args)
 	}
 
 	err = READ_ONCE(csocket->ops)->connect(csocket,
-				    (struct sockaddr *)&sin_server,
-				    sizeof(struct sockaddr_in), 0);
+					       (struct sockaddr *)&stor,
+					       sizeof(stor), 0);
 	if (err < 0) {
 		pr_err("%s (%d): problem connecting socket to %s\n",
 		       __func__, task_pid_nr(current), addr);
-- 
2.53.0



