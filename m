Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618853;
	b=XsevDF3Li2oEGbs/dT8JahpppVMOzbfekCa1BIwu2dGPDVu13F+5HMIr+f91bMV3MK2+
	 ovg/qrhkhBvi1p4vzkMcC+p6982UqGRfpd4WmKGhUR1qxDE+EOEHGKM00ERGWNmcSFID7
	 //eFPZMXNWN3w/yNoWb4rRUlLBMWGN6pYTMuNKEu9Adz4aUjbZ1A63IRxJOrWmMMDIEyv
	 ElGO/ifhaR/VCgnunjVM4Kk+Oyp8Bw0UEyRfB8Pq7BR1LS/9upQRmICflOXQb/QgQ/oGe
	 /UAxEwwOnlW2x0COu4rNPharBsG0fm/kafNMznAVz0P+iY2xT5hq7k69A6XW93DEZUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618853;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=22vbyxGiRlagj2Wsv+kpVZddLJ6YGbIoI8qwEMECiJk=;
	b=puCxg2CsCY+g2cBMH1ObMFU2j1SyulXYBmhUmNkdP/xg/Ms1kqY0wh9URXOwY6PiwODh
	 wwBTE0oI98DBH7zQ1V+az4CSwPUJRQzSXBlIks+kW9D267DE7OBc74B1maDwMx7XxLK6w
	 rGq+g9G7Hdg5oOJBiZPyyTbXBnEEsUQl1uhIljn0Y86yoK/Lgsc3SuPcDOrth4Bk5RTtm
	 IW6qNNoLlWM954Y/jmxys/1Dnr4TqWUWy1lwbKEXauHxia/Td7bADrqttpr8MV+Q+/5z7
	 QkbtjwKZYue5kQZt6JYDwc0+RLOU+1BwDXX/w6g3RjfqAvbg09hnVV8eMBbofODKkQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NxWtyyyr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4AB606A326;
	Wed, 25 Nov 2026 15:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NxWtyyyr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1768F1F000C0;
	Wed, 25 Nov 2026 15:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618852;
	bh=22vbyxGiRlagj2Wsv+kpVZddLJ6YGbIoI8qwEMECiJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NxWtyyyrPpbA1iCio3JoR4lBmFfVjgPQOQeykQQhh140J6yIDYk6UnOTE+5oQHKDn
	 yXtoP7b9dy5hYa0/9anZr3KzkmCsoLiluirOHKt1vUUwq//lDYYcoKg/GSqfhlY2oj
	 e9GhWbV4Occ2+jCUVI+wCd1JC/PcojQLvkGThPSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anil Kaushik <anilkaushikwireless@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0364/1005] netlink: Do not call the unbind callback with the table locked
Date: Wed, 25 Nov 2026 15:28:22 +0100
Message-ID: <20261125143830.258855733@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anil Kaushik <anilkaushikwireless@gmail.com>

[ Upstream commit a36b9e205cb3c452ab96cc783e63465d466fe615 ]

When netlink_bind() fails to insert the socket, it calls
netlink_undo_bind() with the table locked. genl_unbind() then takes
cb_lock, while genl_unregister_family() and genl_register_family() take
cb_lock for writing and then wait in netlink_table_grab() for the table
users to go away:

  netlink_bind()                 genl_unregister_family()
    netlink_lock_table()           down_write(&cb_lock)
    netlink_insert() fails
    netlink_undo_bind()            netlink_table_grab()
      genl_unbind()                  waits for nl_table_users == 0
        down_read(&cb_lock)

An unprivileged user can get here by binding to a port ID that is in
use, with nl_groups set. Lockdep does not see it, as nl_table_users is a
plain counter.

Unlock the table first, as the comment in netlink_release() asks for.

Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261101101347.3910654-1-anilkaushikwireless@gmail.com
Fixes: 3de21a8990d3 ("genetlink: Add per family bind/unbind callbacks")
Signed-off-by: Anil Kaushik <anilkaushikwireless@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261102120929.4077030-1-anilkaushikwireless@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/af_netlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 510fb5ebf9ff8..4850bac3a3f81 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1050,8 +1050,9 @@ static int netlink_bind(struct socket *sock, struct sockaddr_unsized *addr,
 			netlink_insert(sk, nladdr->nl_pid) :
 			netlink_autobind(sock);
 		if (err) {
+			netlink_unlock_table();
 			netlink_undo_bind(BITS_PER_TYPE(u32), groups, sk);
-			goto unlock;
+			return err;
 		}
 	}
 
-- 
2.53.0



