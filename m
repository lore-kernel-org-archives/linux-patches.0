Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034711;
	b=4wnpCZwpc6H2h8FCW5mRj397AmNnm0SnrIcRv/cyGWMWXwDJxOwoBSB9F+25sMWi4Zkr
	 jCYapAnoXBIVdv+vtFwkbGTF1IvJT8dCFG3ThT48NAYfhdi10JMP1YLx10n0cNjvL8+ex
	 ewK0BxEtQNothxW9s2WEByJDvKeXgRfkn+VLBSaF3lli1iEsBEmdUq8rQ0lR6gBrAsVMm
	 l0jVAZLCY8fRrrc/7RRi2pP4THB16NpZJkShvpuOLa+CaGUInsWM/V7MxmGmAwiENefbB
	 hUaAZhGlAhzJ2TSqPm4wY+TgMqyL6d5ENOm2LV+AAZt2XEmmJ8JiqLJpAu++juTR5uA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034711;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=qwpX5iN/azocnDZZbHHvw5ZIYIfsEFBRdveGJn7mje4=;
	b=j6ICVkYXiijRQgNajuy5mF9kTzGX95p/r9uYpQc4CC3HqYpWutku2UCeRXTevcf516s/
	 CvlroJuFnDXe25C+4j5Gs2eC8FRzgP05qPxyn084r+XGzvPdJW5NebdQ4bYd4rLyPYjSO
	 S+QVepZ93RKZ+1qTRw0ku0e1gf0sD1KOb6jNBWSf2IIMJnmjjhozf7U5g2v3rG2YIdvNi
	 Wsx3CPk/8oU8gCB88bDwnN8yWiDdB1OiK2K+A9CZnxVaPEVwbS76bGIhymjbo7fsKjQVS
	 aZEoJ19iXhmXYR3bsP3bTyoQVInIxmXmCcwjRbVLrn7A3rjodTMHlBJUGRa40wSpL3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PB5E2ZJZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1AE606A320;
	Wed, 18 Nov 2026 20:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PB5E2ZJZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B3A11F000C4;
	Wed, 18 Nov 2026 20:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034710;
	bh=qwpX5iN/azocnDZZbHHvw5ZIYIfsEFBRdveGJn7mje4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PB5E2ZJZE8/fU2oj5g5Fma6Y+jvxFe0kCtDjiEyEQzOza6AxtWad9LtKbs1W8O7P/
	 ApRfZoyekKvV5jwDQfw3ZXR9lAhCON4b4lTDzYPBYBm9rZBu36GwhOhmC6hBhRLH6G
	 nDMdsZbsGWwQRf7UCHDrUrHcKR4MDkioS2tcOE1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0465/3318] net: macb: initialize PTP state before registering clock
Date: Wed, 18 Nov 2026 15:18:07 +0100
Message-ID: <20261118150330.801794042@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit e1406330d70e56dd44fa6fbafc86e77e5c80c122 ]

gem_ptp_init() registers the PTP clock before initializing
bp->tsu_clk_lock and the TSU hardware. Since ptp_clock_register()
publishes the PTP character device, userspace may invoke PTP callbacks
before the lock and hardware are ready.

In addition, gem_ptp_init() is called from both the interface open and
resume paths. Reinitializing tsu_clk_lock there can reset the lock while
timestamp processing is using it.

This race is theoretical and has not been observed in practice.

Initialize tsu_clk_lock once during probe and initialize the TSU before
registering the PTP clock.

Fixes: ab91f0a9b5f4 ("net: macb: Add hardware PTP support")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/netdev/20260904030439.3994047-1-runyu.xiao@seu.edu.cn/
Reviewed-by: Théo Lebrun <theo.lebrun@bootlin.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20260908103924.607033-1-runyu.xiao@seu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ sashal: Renamed net_device parameter references from netdev to dev in the ptp_clock_register() context line to match this branch's naming. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 1 +
 drivers/net/ethernet/cadence/macb_ptp.c  | 5 +----
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 1dfd199cb97d3..ec912a32bba9a 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -5218,6 +5218,7 @@ static int macb_probe(struct platform_device *pdev)
 	}
 	spin_lock_init(&bp->lock);
 	spin_lock_init(&bp->stats_lock);
+	spin_lock_init(&bp->tsu_clk_lock);
 
 	/* setup capabilities */
 	macb_configure_caps(bp, macb_config);
diff --git a/drivers/net/ethernet/cadence/macb_ptp.c b/drivers/net/ethernet/cadence/macb_ptp.c
index 702397469c3cf..15af468c0d390 100644
--- a/drivers/net/ethernet/cadence/macb_ptp.c
+++ b/drivers/net/ethernet/cadence/macb_ptp.c
@@ -341,6 +341,7 @@ void gem_ptp_init(struct net_device *dev)
 	bp->tsu_rate = bp->ptp_info->get_tsu_rate(bp);
 	bp->ptp_clock_info.max_adj = bp->ptp_info->get_ptp_max_adj();
 	gem_ptp_init_timer(bp);
+	gem_ptp_init_tsu(bp);
 	bp->ptp_clock = ptp_clock_register(&bp->ptp_clock_info, &dev->dev);
 	if (IS_ERR(bp->ptp_clock)) {
 		pr_err("ptp clock register failed: %ld\n",
@@ -352,10 +353,6 @@ void gem_ptp_init(struct net_device *dev)
 		return;
 	}
 
-	spin_lock_init(&bp->tsu_clk_lock);
-
-	gem_ptp_init_tsu(bp);
-
 	dev_info(&bp->pdev->dev, "%s ptp clock registered.\n",
 		 GEM_PTP_TIMER_NAME);
 }
-- 
2.53.0



