Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033846;
	b=eRr/gg+u8I6zAQaQfz/aYhfvDgl/JcSl98sD/U9mmEN+q3zdkou3p0sN6MWLyhUSk8x7
	 G0FCQR4yaOuCyy97VpDXb5GUjpz56jGGEGDsK/zQSgxaI6ygtYwAbTQw+ouEC/eDyaoeb
	 Fxcvuopy+73nN8GiLcvK+t9KGWnxlLGiwsKzSiUUfI923AoM+t6CLO8nVQ5kfG8pD2Ltj
	 OPOC3213HTKkbmS5yYMxMilllxN9IJuX0bwQA5yjvndSiSZa61VfBVvTonbYEgnmZBDdP
	 D9dC0fZI/Psc7rN7civcZv5z+6/syrphelxEPhkG5WllH+HEIB5Yf4rAk+Ia3F4vZ9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033846;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zeEGBh7dYKbtEwFObFxknfiuihxpB4Lr3IYtWyNwdYQ=;
	b=hfHeHB95uxBq55PP/akGwN/AobZIavTxpeyD6Cj68VhRTTSxNsaHWsANZj54hZnQcGOb
	 2Z1wrBt3WjQb7NB7EUVzr92NnMZdZB4PYksmYt5Nl8vXuRe2zO3zppOp35dFCsP3U8TOq
	 hgW/WsxNr+t+hO8BLoyeUiJshGGkTKGU2LMU5GgrcuZ6tlwf09HHZNOFh1q0aCumNBbNl
	 lu4zrYW3HILBtx7O7mL0+Cb7vEqmsKcpoYaTJhGUpTb4QJX9YKt9Jam5PfkvRmpyt5O9g
	 oh043XvRPfR+IiVD8IdiW7rFzzq3fn6fMVYx6SB2RQHCpV/qUSF6GlLq5XbuZiWNRlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XYzb5vgc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BED606A338;
	Wed, 18 Nov 2026 20:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XYzb5vgc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 062D91F000C5;
	Wed, 18 Nov 2026 20:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033845;
	bh=zeEGBh7dYKbtEwFObFxknfiuihxpB4Lr3IYtWyNwdYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XYzb5vgcQ8Gc5YSOsHWkyQIh9I1dwfxXfd0RhtZNc0PLh2HUycv3HMZAQ948S2LPY
	 Qt/zH6XF7se8AxLDTwWG8yHPZkkNyPK130iyJfg6eY40CA1NTx185TMd+jOYUntMNk
	 nWWvt0Y61bFES/hXujlPQLhFmnFiR+pDmvdoOCgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Yuyang Huang <yuyanghuang@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0157/3318] net: prestera: ignore duplicate RIF destruction events
Date: Wed, 18 Nov 2026 15:12:59 +0100
Message-ID: <20261118150319.263957752@linuxfoundation.org>
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



