Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C96617CA0E;
	Tue, 16 Jul 2024 16:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146203; cv=none; b=CFZJTbciWTxPebhPeopFxQuqUfozZdK+o4ThypbQmn+z8Km6JaLXhfQFjelWJrJNwecLw/BM329+SiUzdSFrew0uPLa2UxymBYQvqHtW5OHuEOVQP1Il8DW7CoIklToOAhIuDu/ewl7D3uQy7LqPkfCK4XVsrsUh+t/Ypld0r5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146203; c=relaxed/simple;
	bh=8nMQ+MWcHVHB6oSTourBRzAGC5sHl8a9kih/Q+dHNzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kjBgYEhJSjjv7VlOkCuX9LZcg3gJCVV3KFn0ftTZVkF7uwU40rYX5LdUuK4+pO3PufAMbVfLdzvCsChvV+auGHyvVeP22CA0nHSMqePNTPlS9vkhExZInIi4vevgoTjGIhnWsniuud8XIGxJ21dHFeagIkkMOdYJ9qolHEEMp3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KKlvdXod; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KKlvdXod"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96027C116B1;
	Tue, 16 Jul 2024 16:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146203;
	bh=8nMQ+MWcHVHB6oSTourBRzAGC5sHl8a9kih/Q+dHNzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KKlvdXod7UshGtBIafkIawvWVc73jB4cyvwlpZQ070P33urGP5jX9YHB0H5Dzsf4V
	 jt5y8bWYNy590WwH4Wcj/e9HYDAvz9GSHW9iIzi1V2gL1L1oIgu0pmUhEr/40FO7Aq
	 PI/zunFSMG35+YNBlo7Ca6PqIMlMrSpO9mC7GjqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 088/144] net: lantiq_etop: add blank line after declaration
Date: Tue, 16 Jul 2024 17:32:37 +0200
Message-ID: <20240716152755.925231394@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit 4c46625bb586a741b8d0e6bdbddbcb2549fa1d36 ]

This patch adds a missing line after the declaration and
fixes the checkpatch warning:

WARNING: Missing a blank line after declarations
+		int desc;
+		for (desc = 0; desc < LTQ_DESC_NUM; desc++)

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Link: https://lore.kernel.org/r/20211228220031.71576-1-olek2@wp.pl
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: e1533b6319ab ("net: ethernet: lantiq_etop: fix double free in detach")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/lantiq_etop.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/lantiq_etop.c b/drivers/net/ethernet/lantiq_etop.c
index 057d655d17692..d9911b3b9172d 100644
--- a/drivers/net/ethernet/lantiq_etop.c
+++ b/drivers/net/ethernet/lantiq_etop.c
@@ -214,6 +214,7 @@ ltq_etop_free_channel(struct net_device *dev, struct ltq_etop_chan *ch)
 		free_irq(ch->dma.irq, priv);
 	if (IS_RX(ch->idx)) {
 		int desc;
+
 		for (desc = 0; desc < LTQ_DESC_NUM; desc++)
 			dev_kfree_skb_any(ch->skb[ch->dma.desc]);
 	}
-- 
2.43.0



