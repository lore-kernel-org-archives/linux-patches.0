Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042218;
	b=zb9weEpYOpTfKmhyH8X4sv5/73lOr0pcCeN/hGFvY/RBzf/+71+7PX95vtPU7Hewr5N8
	 xvi3xO2lQqOnazAswtTu9uXK8GxwK9L3KgwaKXhajXYAGIqtkxqkZzwJ3FddnBuPZge3a
	 s+ik6NBd+57UJ6Xi6L0O3nYiZXwCJxceF0A+z2DNvXIhiixu35/NnZxRsNvXgxIXOEgiV
	 FfV9XVrZl4L1vcGGRVFu1nETh/IeuVWfNF432mchjhVbDFVSNZN7hrjrGTsmn6knvbpqW
	 cvkMzzVIz4i357zmPvj5OiLSUBJWOUwEJz4a7x4q0sl6GUwuPlggUjtvmMhz7eUEHUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042218;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5OKtgmDSKt/+iOnD0yp0d3b8et7r8jm3bQHpZjKRKyQ=;
	b=fvupLU6KyfEWBExm//ie1Um+QfLdldZt38OFmzaQk4ETcxwa5GSCc/D3DvCUQM7odBYW
	 BZgEOjd6b4+Zq7iMkmx6uabXLUG5XWDceEjEt1eQtaZOJtBUeXFg0+N141vBgoteuroXX
	 wLCcRxwDHVZTf7enE0+97f4NKK03k44DlNLGeDTDGL+7ZOt1zDzbeWguZtAeTL+nx5XU6
	 uiAXjB+HVMnGj6Nci3zwlKY1IZAOqjIeyBYuhUPcJ647YSM5MXXtlNl1xSi907C21UCR+
	 jbu5Ya0iKpgwOAV2+HUBVPNfn8scrOMOSEQQvfI02ot8+0lWnJWeZ6dKCPtk4OkXlCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qKbeh8sC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA138606A320;
	Wed, 18 Nov 2026 22:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qKbeh8sC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407741F000C4;
	Wed, 18 Nov 2026 22:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042218;
	bh=5OKtgmDSKt/+iOnD0yp0d3b8et7r8jm3bQHpZjKRKyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qKbeh8sC0smnfld3hgsvozZDdfUEO8rgYovghuk8vGb85MgoNa1a0GATHc6M7GrNZ
	 V0T/npyPV0xy9eo0Srmejc2xkN7zyaeL9V1ZXpI0zf0B6Dn9Igbv3r9vJwTAFW3Rgh
	 Do/RDGntPn5wACVx4HGwi6oakOMblDZ9vws6ced0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3092/3318] smb: move smb_sockaddr_in and smb_sockaddr_in6 to common/smb2pdu.h
Date: Wed, 18 Nov 2026 16:01:54 +0100
Message-ID: <20261118150452.789763280@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ZhangGuoDong <zhangguodong@kylinos.cn>

[ Upstream commit 7844d50ca239f0788e732608820f7026cb0cc8fb ]

Rename 4 places:

  - iface_info_ipv4 -> smb_sockaddr_in
  - iface_info_ipv6 -> smb_sockaddr_in6
  - IPv4address -> IPv4Address
  - IPv6address -> IPv6Address

Then move duplicate definitions to common header file.

Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: bb0326a58060 ("ksmbd: report IPv4 and IPv6 addresses independently in iface query")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2ops.c |  8 ++++----
 fs/smb/client/smb2pdu.h | 13 -------------
 fs/smb/common/smb2pdu.h | 15 +++++++++++++++
 fs/smb/server/smb2pdu.c |  4 ++--
 fs/smb/server/smb2pdu.h | 13 -------------
 5 files changed, 21 insertions(+), 32 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 8ba99ac5b9a3f..84acf669f88a2 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -593,8 +593,8 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 	struct network_interface_info_ioctl_rsp *p;
 	struct sockaddr_in *addr4;
 	struct sockaddr_in6 *addr6;
-	struct iface_info_ipv4 *p4;
-	struct iface_info_ipv6 *p6;
+	struct smb_sockaddr_in *p4;
+	struct smb_sockaddr_in6 *p6;
 	struct cifs_server_iface *info = NULL, *iface = NULL, *niface = NULL;
 	struct cifs_server_iface tmp_iface;
 	__be16 port;
@@ -656,7 +656,7 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 		 */
 		case INTERNETWORK:
 			addr4 = (struct sockaddr_in *)&tmp_iface.sockaddr;
-			p4 = (struct iface_info_ipv4 *)p->Buffer;
+			p4 = (struct smb_sockaddr_in *)p->Buffer;
 			addr4->sin_family = AF_INET;
 			memcpy(&addr4->sin_addr, &p4->IPv4Address, 4);
 
@@ -668,7 +668,7 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 			break;
 		case INTERNETWORKV6:
 			addr6 =	(struct sockaddr_in6 *)&tmp_iface.sockaddr;
-			p6 = (struct iface_info_ipv6 *)p->Buffer;
+			p6 = (struct smb_sockaddr_in6 *)p->Buffer;
 			addr6->sin6_family = AF_INET6;
 			memcpy(&addr6->sin6_addr, &p6->IPv6Address, 16);
 
diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
index 2eb15f3a7fe66..f1548d2f4a8ad 100644
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -275,19 +275,6 @@ struct network_interface_info_ioctl_rsp {
 	__u8 Buffer[126];
 } __packed;
 
-struct iface_info_ipv4 {
-	__be16 Port;
-	__be32 IPv4Address;
-	__be64 Reserved;
-} __packed;
-
-struct iface_info_ipv6 {
-	__be16 Port;
-	__be32 FlowInfo;
-	__u8   IPv6Address[16];
-	__be32 ScopeId;
-} __packed;
-
 #define NO_FILE_ID 0xFFFFFFFFFFFFFFFFULL /* general ioctls to srv not to file */
 
 struct compress_ioctl {
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index e89fea92734cd..a5e2d759ec2a1 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1402,6 +1402,21 @@ struct smb2_ioctl_rsp {
 	__u8   Buffer[];
 } __packed;
 
+/* See MS-SMB2 2.2.32.5.1.1 */
+struct smb_sockaddr_in {
+	__be16 Port;
+	__be32 IPv4Address;
+	__u8   Reserved[8];
+} __packed;
+
+/* See MS-SMB2 2.2.32.5.1.2 */
+struct smb_sockaddr_in6 {
+	__be16 Port;
+	__be32 FlowInfo;
+	__u8   IPv6Address[16];
+	__be32 ScopeId;
+} __packed;
+
 /* this goes in the ioctl buffer when doing FSCTL_SET_ZERO_DATA */
 struct file_zero_data_information {
 	__le64	FileOffset;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 19ede9fffb6fe..20775992fccca 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8245,7 +8245,7 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 			idev = __in_dev_get_rtnl(netdev);
 			if (!idev)
 				continue;
-			sockaddr_storage->addr4.IPv4address =
+			sockaddr_storage->addr4.IPv4Address =
 						idev_ipv4_address(idev);
 			nbytes += sizeof(struct network_interface_info_ioctl_rsp);
 			ipv4_set = true;
@@ -8253,7 +8253,7 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 		} else {
 			struct inet6_dev *idev6;
 			struct inet6_ifaddr *ifa;
-			__u8 *ipv6_addr = sockaddr_storage->addr6.IPv6address;
+			__u8 *ipv6_addr = sockaddr_storage->addr6.IPv6Address;
 
 			sockaddr_storage->Family = cpu_to_le16(INTERNETWORKV6);
 			sockaddr_storage->addr6.Port = 0;
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index 00c239b1440ed..bbba41bf653b6 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -144,19 +144,6 @@ struct smb2_buffer_desc_v1 {
 
 #define SMB2_0_IOCTL_IS_FSCTL 0x00000001
 
-struct smb_sockaddr_in {
-	__be16 Port;
-	__be32 IPv4address;
-	__u8 Reserved[8];
-} __packed;
-
-struct smb_sockaddr_in6 {
-	__be16 Port;
-	__be32 FlowInfo;
-	__u8 IPv6address[16];
-	__be32 ScopeId;
-} __packed;
-
 #define INTERNETWORK	0x0002
 #define INTERNETWORKV6	0x0017
 
-- 
2.53.0



