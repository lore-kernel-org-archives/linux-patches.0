Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829616;
	b=hh1L5UwwMesMgS4Oz/H7acRi7uCRL9XCzAZWhUzpUqM6Jt3/mzvOC5PVGo4vcEUhr+L8
	 OAblhwntJhK8NEwWUarQf1XhbDofAeYlf5MLruoOK2ax3Mb3P6V0dTqE6XYy1qwp3u/vo
	 SeW21Fj1XJJVARXsWmbp9WiVaJPQb6PH1RM9FaMwzwbg5ygecmPFvCxONQ3AbHyrYgc/d
	 WFVh+oxsKtUbBrjERJw08TX5fPgfwV7tq+SmGnvZmS9BTUHrgVNCvuabktk7fvXYBtMN8
	 0czTgm/9i2bS+I0AAc7CGV20oqkBwtak/6CWbtceyHGeUKS5v+hkymgCx84jX9vq4Bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829616;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bFtGiHGr/r6ka9lwDajl685kAgQt99VChKWwVfC1JiI=;
	b=0o579GGnR+zZYWNjaolzY3D5VE2uwaUOktd0sQ6wDOMF2HHDmKdZzP6nO/KL+ogx/YbJ
	 jr07eZKXcziJ7HJ9kqj/bXS8rhMtO+WaqPTkVJLG1R/RQ6IkSWkUgCdMVh10EzDSEElaw
	 cY4QXr+QDnYxfWGG3akxxLv52KBZMM/or4doGm2P5j6s0T/IdUAOYrQ5cD+xyxK29wtQd
	 JS/MYjNxbEtgHsLWuohq2a+5ixt1CIX8kRGn4jO/A1z3sBNeAG56YWwBT4msDVgzk+zHE
	 9mjG2HsLSt63n+5XY8cpVQezqydZd26dZwLVN4OgKLw6CjivHil9JkpGbEGIXrEGaxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fwBuGtF8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538E0606B2DB;
	Wed,  4 Nov 2026 22:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fwBuGtF8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 312A41F000C1;
	Wed,  4 Nov 2026 22:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829616;
	bh=bFtGiHGr/r6ka9lwDajl685kAgQt99VChKWwVfC1JiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fwBuGtF8o9mbqdN/cDoRk6X+Equ2oQaL4ZX5GYPD+dYsoUR1bEBq/R5ZEgZ5kb40/
	 gDNOkds8C5iw6qw/pWr8PTyELO7HJR8L92SnQYDstm0E1aMbeRYi/q/qVuAkAnmkQW
	 AC4UTbAP9st5qVMAVM4YPEMkHj1CyZXRHnJY7Na0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Yuyang Huang <yuyanghuang@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0219/1005] net: prestera: ignore duplicate RIF destruction events
Date: Wed,  4 Nov 2026 15:59:12 -0500
Message-ID: <20261104211049.951016933@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Yuyang Huang <yuyanghuang@google.com>

[ Upstream commit 3cbbc9fa33382d03f2813118e672eb318eba9cde ]

During address teardown, the inetaddr notifier may be called multiple
times for the same interface. Ignore NETDEV_DOWN events if the RIF has
already been destroyed, rather than returning -EEXIST, which aborts the
notifier chain.

Cc: Ido Schimmel <idosch@nvidia.com>
Cc: Kuniyuki Iwashima <kuniyu@google.com>
Signed-off-by: Yuyang Huang <yuyanghuang@google.com>
Link: https://patch.msgid.link/20260711005405.2861680-2-yuyanghuang@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/prestera/prestera_router.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index de317179a7dcc..e36d023fe9c30 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -1302,10 +1302,8 @@ static int __prestera_inetaddr_port_event(struct net_device *port_dev,
 		dev_hold(port_dev);
 		break;
 	case NETDEV_DOWN:
-		if (!re) {
-			NL_SET_ERR_MSG_MOD(extack, "Can't find RIF");
-			return -EEXIST;
-		}
+		if (!re)
+			return 0;
 		prestera_rif_entry_destroy(port->sw, re);
 		dev_put(port_dev);
 		break;
-- 
2.53.0



