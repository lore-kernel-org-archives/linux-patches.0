Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027590;
	b=WQjMuFLLO4wAVRiRP5oTccfZYDkBZ9tvvmWuLkeTM9W5UZtEHBPc1UMeTOjGc0aUSKzG
	 8C7TK+mrb+jWHbv6AwYBDvevmj6MBtAa6iF+RnNOkY53sEUJdL9ygbe4jSzTBk9TiaooJ
	 aUQFP+QKpGtt5VYVmu93PFSkI9uO366gwftjI6nSkYmauhYG1Tl2B2RTHplp5BB51VWTy
	 nBMuAYdWkJUkZeIEwLL6OMKhdUFPtaVCBbhqTE4vp83gj2Sjt4aV7zV6Fa8zIz8hZb9HA
	 eZXYVLJrLPPKoUBWqbAoDkKeE2JmmIm+6/fkE7vNvo63389Ta2tO0Pd59En0fAHxQ/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027590;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oJHs6msuM8EsfOjB9fHjlqN9y0ZZkaPkooi4C7MzbdY=;
	b=3ig2tVRZp2MCH2pZpG3Z17aU7CcqTH/ih3ZeJOmFJNEUFA4x+4ynMoxOMsttHoevlnBl
	 at7c+MigMPLEl219fruogCMfhx0nriJNylPA0YTMBs/RuhQusWrmWd7qJrRQuL60XYpXh
	 +ZpNuo5S+guDVP6IYf15vzJuR5V+/hCGR3ZBKZTJBh6zyBzrCZtJe0iz/6sBHACL13TLY
	 4TgwviTQdL3/8KXqUjFxtyjBM4pCkN5LXKW6n6cfcizPh/yfzDrhJuyg9fif6Ai++dXqo
	 O2XL4Jf28cBJU55CQz6dYYJttdN/IkhSzhW5E3qbzFCVWWuBKE1tDW/YvfelW+kXK/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mhu7GWbh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341F160A260F;
	Wed, 18 Nov 2026 18:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mhu7GWbh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87DB41F000C4;
	Wed, 18 Nov 2026 18:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027590;
	bh=oJHs6msuM8EsfOjB9fHjlqN9y0ZZkaPkooi4C7MzbdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mhu7GWbhc7tV9rYR9myAQXzkq6JmnOp/BslQkVeLbfQsvP3DkygEX9ODpT6pRzOGy
	 kpl1tJCZ2NPG7jcEmhLDAkNg38OPM/aQZf3zYk/NxofDaNUo8Ur3dHsxPcXINamCs5
	 aTNEjCnyBxZKbpq95j3sIYZ3QG1ApgxI97sufv1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Hu <huhai@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1843/2151] ksmbd: fix link speed query in fsctl_query_iface_info_ioctl()
Date: Wed, 18 Nov 2026 15:59:38 +0100
Message-ID: <20261118150228.932675527@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henry Hu <huhai@kylinos.cn>

[ Upstream commit 2bc1d25fc8597fa6cbf6b1ff92653881939a6436 ]

fsctl_query_iface_info_ioctl() used to call
netdev->ethtool_ops->get_link_ksettings() directly and never checked the
return value. If the callback fails, cmd.base.speed may be left
uninitialized. Also, SPEED_UNKNOWN (-1) is treated as a numeric link speed
and would be converted into a bogus link speed.

Use __ethtool_get_link_ksettings() to acquire the per-netdev ops lock when
needed. Fall back to 1Gbps when the query fails, or when the reported speed
is 0 or SPEED_UNKNOWN.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: Henry Hu <huhai@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 55d4727facc51..b871003341e7c 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8243,6 +8243,7 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 	struct sockaddr_storage_rsp *sockaddr_storage;
 	unsigned int flags;
 	unsigned long long speed;
+	struct ethtool_link_ksettings cmd;
 
 	rtnl_lock();
 	for_each_netdev(&init_net, netdev) {
@@ -8277,10 +8278,8 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 		nii_rsp->Next = cpu_to_le32(152);
 		nii_rsp->Reserved = 0;
 
-		if (netdev->ethtool_ops->get_link_ksettings) {
-			struct ethtool_link_ksettings cmd;
-
-			netdev->ethtool_ops->get_link_ksettings(netdev, &cmd);
+		if (!__ethtool_get_link_ksettings(netdev, &cmd) &&
+		    cmd.base.speed && cmd.base.speed != SPEED_UNKNOWN) {
 			speed = cmd.base.speed;
 		} else {
 			ksmbd_debug(SMB, "%s %s\n", netdev->name,
-- 
2.53.0



