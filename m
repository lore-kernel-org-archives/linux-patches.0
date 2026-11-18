Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042207;
	b=blcR0AJB8vf4M77S4KTIFT3eI/a922hKJ4jINVnAmEstXUQz8l67kOO51FTNiL9H6nar
	 o7VvHP3CE/gvZNngc0IAi/lOp9QGUfV6ZKWN57E2E88grhECwctEv9dEIDg4KwfbkZwjP
	 aQlBoNW3ROy6nyX9SLmEzmMvetkvo+o2Ot3tg49v55rC9MAVOWbnn8UXeet8XLHrKrKeP
	 FZAa6sUT0XJlXXGQiwGLw6OBoo9BV2evbrvQ5B0G6L6dA91jmcm385wLctBaD3nQ4jFYI
	 QFv0sgw+/uaYDw1X9aowBpvVUropiq8ffj/rLnmMDfvEc849nAkorpGHho8BRU1LxmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042207;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wn75OJcUq1oBpLNtJFszYKFsTH5OUw98d6TM3HrRtXI=;
	b=lUBLFK0IePEKbdva3saK9z7x8fAiKEESXadc9VIDG7ChJCbIzB5Cd8hVdBteT5e/jwEA
	 QgU6+TwdQGYR5pyhcNxXXa9hR3ZsW1LmMoh4/PRS9DfMp5HsGVD+7sg9iqM7EAC47vMDe
	 2wLahd2dst3+RzBGwyDJrSnlqgKyvb7I1x7ZWcIbJdBYGTUqNG0+N82jv4F7dKnrlMWy4
	 fQiv+P+RX+rORUqlsXsM9x6Wb0Ibu1jpz5jnniNkXefHwkPyoCzDR63dzc33ul3dXBxnz
	 4aWlgtTf5YM1+yIA8ztd7ET7vBO+iqc4fS0+/U2u6XLKjWkQluqhgFTLoXRaptvZW2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wHieGwV8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B555B606A31C;
	Wed, 18 Nov 2026 22:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wHieGwV8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 166621F000C4;
	Wed, 18 Nov 2026 22:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042207;
	bh=wn75OJcUq1oBpLNtJFszYKFsTH5OUw98d6TM3HrRtXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wHieGwV8nYbdAUA1RYBxEh6RyrC3fDm8oQsChR5CGEmOB4/hYwjAORALFsOOoFSYa
	 Xh8FVW+3UKppUAacVGHgWT6QncJGfrbBA6OAFoTxTinIJkq9Yo13M/E+1/ZHgqr6Oc
	 TV1R93zERxgxy663Ihqjt908y+Yit5HXTLoczijU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Hu <huhai@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3088/3318] ksmbd: fix link speed query in fsctl_query_iface_info_ioctl()
Date: Wed, 18 Nov 2026 16:01:50 +0100
Message-ID: <20261118150452.684908081@linuxfoundation.org>
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
index 146a911718ee0..b30370ec981d3 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8185,6 +8185,7 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 	struct sockaddr_storage_rsp *sockaddr_storage;
 	unsigned int flags;
 	unsigned long long speed;
+	struct ethtool_link_ksettings cmd;
 
 	rtnl_lock();
 	for_each_netdev(&init_net, netdev) {
@@ -8219,10 +8220,8 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
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



