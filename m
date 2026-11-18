Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032729;
	b=U5jTrp1USeiwpGd/3zBMQSLucEsXMvgzfCyGADsCnyOZA8P1ASxchXmYeJckEwgIYJuW
	 TnUwHH/Rokof0FJf4Zknd+TYG7PgpfRAusSmXwIotFquYJ5vy2cA2rsC0d47SrX0WbaHK
	 ni/XPbwuimZQlU8EGJpDv03aiiu0wM0rEDuQHXj7cB7iATpfno9D7fMNRywsZy4wUfxRz
	 7gz/nR3kxaRU9e5fMKB7KkYpdhspL2zOe5up8T0ayVSsMCz5zSqRPRnPCpOY2Foc/8Tg/
	 1z1FenLI3CFAii5ylvTe8IyBdHHRo4AwpIjGe9Ru5TA8gAWcX0dT1YyKRJQiPMyE1CA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032729;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dBzUWLziH+nVZVt3Eh2r9jtNSicz13Lv7GeBvPKyyJ4=;
	b=Sgy4guoNPxK7uToaycj1sma4/O0EXlmHHxGGjyzBNeRe0pQrgceXudVcnqY9SouxEg+d
	 gQpogTDSAD8z8izBsYY04tCuZ76Y0AXBBTsxYPyW97YnNasyaPKojzZgZnjYYZnuH1Pz6
	 54FAQ94D85TUvrW4a1p4Q30VMBGr3moubW4SMxogn8b9qoLXkSIKorFFhh64hMkLig6Cx
	 mpUWUH6FMc4LPTwFXsLM600OAdoG6BufA/hYUxCHxQ1hhCGxoQWRrUU2tR9Pm9w87sA4M
	 UyDwtBR6GFVXmmW5bSOGu+u6e2/o2veDpdi2mjeztkbxoYeTz4Xul8KUYHpDSe5TqzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ESu6eo9T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F137606A31C;
	Wed, 18 Nov 2026 20:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ESu6eo9T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83ECA1F000C4;
	Wed, 18 Nov 2026 20:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032729;
	bh=dBzUWLziH+nVZVt3Eh2r9jtNSicz13Lv7GeBvPKyyJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ESu6eo9TXRImUYme6610+Ndm6ur5WJskYkUrE8o+uxyhtdWnZyKONCPqUhq7CXxj3
	 Di8U/NOVec/ejotMoHqkEeLm7PagVQu1h/GKH5NjnPwU5aeqtKNXruOxKw6FJcI5j0
	 GW6HUtfiWr6jc/19fQ160OLNqBbHzAoeW3InGqbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Hu <huhai@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1471/1756] ksmbd: fix link speed query in fsctl_query_iface_info_ioctl()
Date: Wed, 18 Nov 2026 15:59:58 +0100
Message-ID: <20261118150107.576826122@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 2577fbce80c4f..7c7eb542caf10 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8205,6 +8205,7 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 	struct sockaddr_storage_rsp *sockaddr_storage;
 	unsigned int flags;
 	unsigned long long speed;
+	struct ethtool_link_ksettings cmd;
 
 	rtnl_lock();
 	for_each_netdev(&init_net, netdev) {
@@ -8239,10 +8240,8 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
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



