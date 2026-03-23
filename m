Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158ED3AE1A8;
	Mon, 23 Mar 2026 14:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275258; cv=none; b=Udht5ghZUfP9OsfBF2Sz+TE18TpBJvFPOfkuJyMjwYLeUri1NteAHi9lgJQdXO47PApekyFtQ/CxTDTph6Bb3M+eAfx0076b9cgjcVsfaKGlFcuxcdvy0FhdAUQ/XQX00S6LAirb4OJTh9AqGiP0XmpQXFKWdCtdes02leRLwFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275258; c=relaxed/simple;
	bh=MLetU5hVk1Op76tPfmBVLExcj3j0408xy+A/ItblcOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A7nzZY4yXl6OhK8CsOw6n6qMewFu+3D4oTgaAFcCcGgabou0a8w6demGlcse5NHcvWu+dh8ztZvMFZVEWlatgjvtblx//abSZAl8igy9yWu/fvk5dU4nIlwIPKHahxxhOPmPml06kYHxhLsjGVy6dKQPrBJkRPGJq2e6Fz248QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qT+0vpQD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qT+0vpQD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A33D6C4CEF7;
	Mon, 23 Mar 2026 14:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275258;
	bh=MLetU5hVk1Op76tPfmBVLExcj3j0408xy+A/ItblcOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qT+0vpQDQ18FCfxtO01lprXdfuZ0C7IDZSbkWrbTT5vs92/0vcrpSCBfnToPQYUJL
	 f0t22hbjySXLzs79pHOLUqsmrKJ5W8dRPOfl4tdf6BoyXJ1JWgYgC7rZTIUGGPpIFx
	 xGFIBjb4/Gn1cdmMpsTfYKckhYPFDE/2tc3Qjlxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mieczyslaw Nalewaj <namiltd@yahoo.com>,
	Luiz Angelo Daros de Luca <luizluca@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Linus Walleij <linusw@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 031/460] net: dsa: realtek: rtl8365mb: remove ifOutDiscards from rx_packets
Date: Mon, 23 Mar 2026 14:40:27 +0100
Message-ID: <20260323134527.464103583@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mieczyslaw Nalewaj <namiltd@yahoo.com>

[ Upstream commit f76a93241d71fbba8425e3967097b498c29264ed ]

rx_packets should report the number of frames successfully received:
unicast + multicast + broadcast. Subtracting ifOutDiscards (a TX
counter) is incorrect and can undercount RX packets. RX drops are
already reported via rx_dropped (e.g. etherStatsDropEvents), so
there is no need to adjust rx_packets.

This patch removes the subtraction of ifOutDiscards from rx_packets
in rtl8365mb_stats_update().

Link: https://lore.kernel.org/netdev/878777925.105015.1763423928520@mail.yahoo.com/
Fixes: 4af2950c50c8 ("net: dsa: realtek-smi: add rtl8365mb subdriver for RTL8365MB-VC")
Signed-off-by: Mieczyslaw Nalewaj <namiltd@yahoo.com>
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Acked-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260303-realtek_namiltd_fix2-v1-1-bfa433d3401e@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/realtek/rtl8365mb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index 74a8336174e50..4cb986988f1ad 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -1480,8 +1480,7 @@ static void rtl8365mb_stats_update(struct realtek_priv *priv, int port)
 
 	stats->rx_packets = cnt[RTL8365MB_MIB_ifInUcastPkts] +
 			    cnt[RTL8365MB_MIB_ifInMulticastPkts] +
-			    cnt[RTL8365MB_MIB_ifInBroadcastPkts] -
-			    cnt[RTL8365MB_MIB_ifOutDiscards];
+			    cnt[RTL8365MB_MIB_ifInBroadcastPkts];
 
 	stats->tx_packets = cnt[RTL8365MB_MIB_ifOutUcastPkts] +
 			    cnt[RTL8365MB_MIB_ifOutMulticastPkts] +
-- 
2.51.0



