Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3226D3876CE;
	Tue, 10 Mar 2026 11:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141218; cv=none; b=kBnfe/RsHVDfT2Pa+eh4KS/AWxvoUmdfPtgj02ThCZKCukPDVJIJVGHScWbYkEngGvPvuUH3OHflIiHK17twUS19O4TKY7qEkkuUn+vXOMytbOKc0GMRx07J1Im309QbNw6t+D5TBKJ7SLozsoHaHCMdWLb6x+PKi/PdzZXRqFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141218; c=relaxed/simple;
	bh=cNOkuW0T7m86aoqIh9ZNZhJDWqKobpfeFNflLfoodtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AlF0dJsZqD76I4R01CKcJWK/rmTvaeNNG+MD3IAS/92Wivv+5QHzgZwUBhIidUyLROwtClRWDlwbyxgJmUnmQsO5h0ayYyzUs8BwOxj5Ew7tbI7vUjG2w80lrl7niY91zGu5wcbeBdO7NjcDe6pa4Fs11119DWI0kkdwgWFqviI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kPLqMbYN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kPLqMbYN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E5EC2BC86;
	Tue, 10 Mar 2026 11:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141218;
	bh=cNOkuW0T7m86aoqIh9ZNZhJDWqKobpfeFNflLfoodtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kPLqMbYNr4A0K9hF6qxha0vwEsfO5mS98tAqNPXHvTIxdvydf4hegIyuD1WwmVSz2
	 XWqLYi83bABRxgU3rNsc89sO2Esx3unMHNb7zqjG/QJClBaPohZqjhf8bPcjNbz/bW
	 6r6sSeYkXVgX1GXNEgaLIEie6q0+XjlTI//F/PsviaGsU5JgrwHb+WX76IdQZPLE4H
	 kmiiZaJYXHbpDzRqM2btiGkz79t98DCd2nEl7bM0v13oOq7glpCoYIn0lK9C1IwdvP
	 RM8h27V5e5wOShooUcPHAuFcHLXuLudLyXS5/nrdjPNUjrCWj01L34iI8z/V0tMt5l
	 IjYFDA8MfZ+KQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Oliver Hartkopp <socketcan@hartkopp.net>,
	Vincent Mailhol <mailhol@kernel.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 219/311] can: dummy_can: dummy_can_init(): fix packet statistics
Date: Tue, 10 Mar 2026 07:04:26 -0400
Message-ID: <21317b8513ff3d7b1640de0e7d65c3d4bfe4ef64.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Oliver Hartkopp <socketcan@hartkopp.net>

[ Upstream commit c77bfbdd6aac31b152ee81522cd90ad1de18738f ]

The former implementation was only counting the tx_packets value but not
the tx_bytes as the skb was dropped on driver layer.

Enable CAN echo support (IFF_ECHO) in dummy_can_init(), which activates the
code for setting and retrieving the echo SKB and counts the tx_bytes
correctly.

Fixes: 816cf430e84b ("can: add dummy_can driver")
Cc: Vincent Mailhol <mailhol@kernel.org>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Reviewed-by: Vincent Mailhol <mailhol@kernel.org>
Link: https://patch.msgid.link/20260126104540.21024-1-socketcan@hartkopp.net
[mkl: make commit message imperative]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/dummy_can.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/can/dummy_can.c b/drivers/net/can/dummy_can.c
index 41953655e3d3c..cd23de488edce 100644
--- a/drivers/net/can/dummy_can.c
+++ b/drivers/net/can/dummy_can.c
@@ -241,6 +241,7 @@ static int __init dummy_can_init(void)
 
 	dev->netdev_ops = &dummy_can_netdev_ops;
 	dev->ethtool_ops = &dummy_can_ethtool_ops;
+	dev->flags |= IFF_ECHO; /* enable echo handling */
 	priv = netdev_priv(dev);
 	priv->can.bittiming_const = &dummy_can_bittiming_const;
 	priv->can.bitrate_max = 20 * MEGA /* BPS */;
-- 
2.51.0

