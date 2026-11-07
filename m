Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060773;
	b=mVgp/zJ2qghpbzR+yjUcULrL/rKCiYk72tCGKkAwC9Vyk2IQKJCUcB8dogNMvOBDPOAm
	 QJ3DcJGfdaymOejVn/Oz353dbm6lhqo9Bm1fr3+/BXL8agNXFy1wvlK07D+yyuIR6hciu
	 ARcoUAi/VrQSWSF6BZUK/h0TElvy+gTx44ibugx0tLdRQRTLXmze4xtvh7jkqh5sj8X04
	 qI/2+HM3kuDXubEWbKJpLMHn4gsd8p8EjqO8+JFQPDaP1xLSYxPDmve+U6RssX5yh9UIk
	 jyq9MXHnXXZuIxfReqWeMkKGIxwvAY/BKrREtUZGKHh85NzMqt685STNjBaysakfRcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060773;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JDPScyye4AegKSI6eyO2VPZ5gS8FRpn96+uoZR67rL0=;
	b=Oj7OVtdvwJgmMiqnGD6C3/nmeMjYPgMDlfd32KTSsJerZ5MoRvcY+U0B0pvr2yXCW4El
	 p3LNo6WlOOUeTcnGoB3jmkWk4gJ3AZV7CzkctEUoN+ZQYDryrqwwr52woRgjuTygDt76g
	 z1NuMYvksnq6ff5TZlYtUEX8Qh/lCfX4w+55y8F0EofyyjDRPympnWaKioVMtIhsMi8wd
	 CE7QNCiKwXf65shxHniB+2EvEM4FUNFPuiwNlZHwCfSCHh7xgiGH0RHmEoghf4P6l/txr
	 B014OFl7KYVik69Vx6/G1nmiYaSUTwqpNmqhHvUMggNqQXmB/vtT+3TnFH8PPBp/AIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HmYN3lCH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA93606A330;
	Sat,  7 Nov 2026 14:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HmYN3lCH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C041F1F0089F;
	Sat,  7 Nov 2026 14:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060773;
	bh=JDPScyye4AegKSI6eyO2VPZ5gS8FRpn96+uoZR67rL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HmYN3lCHvKPv5WaqC8i8rj9bpYnXsYStW1iOqZuC+zkJFcQobpZdFPRZjZXNv88/8
	 bp5+EFWR1Y8xlDL08xR2M4UoLvxb6RwBnBqqJeXXcVXDfkiXVO7ON7iThfi76Echh9
	 AfO3KmEw9NB0wmXlENF6iSThUI7vmxiOOjCYjVI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Yuyang Huang <yuyanghuang@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0182/1536] net: prestera: ignore duplicate RIF destruction events
Date: Sat,  7 Nov 2026 08:36:38 -0500
Message-ID: <20261107135002.771509568@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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



