Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF29C3F7863;
	Tue, 17 Mar 2026 17:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767221; cv=none; b=Bcxadtp3EgF9aVKNoSC5pW6q7GgdgkwecwTYpuXMV6LpuJDyBBgqOqRhRmZLv3KxqoZ08mwihN9MyKVNIgCzoPlcoiz8R5LlbqXR23EDBJgpYzXIDVyliW7ABuinEXgrZXsQmQf5g0MtyO5BPhh/uJYBdRlEifqWrTgtaQNxb4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767221; c=relaxed/simple;
	bh=L/jGbvOz74qRWfghKsUNOK5xqEPhQ9UJCQNUZ5a/H9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aZzaAG13UcKizkzTO+QbbBkSQ8W5cub2WS2S26eAoJmyEwNzj9wsa7xynYX542QwqmshahjpY4o/sXwZM2oVBf9aQ5/+9hbOPjx1S5BEFuS1dNZNlMAGdvDs/jYi8+4nG1VqdGVJkA8SvYB3436MyxvafgD9bOBr/2NHrzTZ5vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I+urTPLt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I+urTPLt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3688EC19424;
	Tue, 17 Mar 2026 17:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767221;
	bh=L/jGbvOz74qRWfghKsUNOK5xqEPhQ9UJCQNUZ5a/H9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I+urTPLtFajCIxD3x+Ep5xrtacX6ls8Y7K+fO3XqK6QkhkLECX4wcFMc2bIg5+QSK
	 ams0AzRhawi7JUlwkC+e++KfQVowVqThd/CxXYgB4XyKVeVq1AFC36ymwXzRtHTrkS
	 wjKsyV0XBRx3XZzG5nQng9gCIeJN8oCjAf9cLE1Y=
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
Subject: [PATCH 6.18 033/333] net: dsa: realtek: rtl8365mb: remove ifOutDiscards from rx_packets
Date: Tue, 17 Mar 2026 17:31:02 +0100
Message-ID: <20260317163000.590724642@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d06b384d47643..3a48db295e7e4 100644
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



