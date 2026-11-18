Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040880;
	b=Ka+pkzDQ2Y9L+Y0E7upEXO0Rm3P/5YP13QpDlKHtjqpBK4xwXAMwfwSJhaXCHLQgIIkv
	 OWhKY3ueFWeC/gXJol1CdbmYbxxiKXWuJ6+A3C9u/uzQfYw6ui02f64EwX7cE8dcMDW1f
	 gyYvwNde4PtzsEq6ijFrCJ3/mLDHW2s/VJtqP334tDhnbCm81VzhHMl1ZcYQjk0HMPBD0
	 1h/7tgRHIJ91mpshQwasRq5hLU/ZXel/DRpl9IZQvpUivlODhxlsQnqiFclj6iQvOwZii
	 8OmUv2UBYSKBrJlbY/wY7C+/PeD4+NMdDtX1dmLL6KF+i8oKPiwlID4FHMVHCDbYmSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040880;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0tg9QU5rDW1sLKagfwr9lGI003ruPcp86vfopK1rIq4=;
	b=U6N7YMsuuQRzDx7f8uciQcfYJqk4zzYIJ12SM5mV4GuZZCpC63jdvnQGK1OdGZEd5r31
	 c8Vibu/Wjj1FgHOAmyLDnpC7goeTo41mZXgic8cOVk0wSftkE/5ZHpa2IkxEZwYRdhEba
	 cdK9mVhF4BvDmXDsbJYhafVGo47WY0EeAieX7UQXym6qmzZpHsUf9HqyVZDkxwsEpQawI
	 byyv/y07pQCJRJuUsCNgDioQ9lGNCF+BnKfImMMgSO55+KKB1c4Ok9+IBpA/FpZsSk9FF
	 jlLIbhYRjfktCxxJpm2hBM54LV/sK5c82URjwqz7ahmCrSQenXMU1n/zJVwI4bUzjcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tfU3rQHC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28781606A32A;
	Wed, 18 Nov 2026 22:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tfU3rQHC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A4F1F000C7;
	Wed, 18 Nov 2026 22:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040880;
	bh=0tg9QU5rDW1sLKagfwr9lGI003ruPcp86vfopK1rIq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tfU3rQHClOIBxG6V6aQVzRX/jcZwYei2Wt2yO3ivaRaEqMmqmSPcdJOPSw7FIIl5o
	 FWa+yb6UGW4yZqzmfBEUCyLIiknBdoBZrOy8mpRqKkoN3KbSoCGRPrib4XcjEWYmoT
	 8yDwgh14WDws/QL85dezNoJgyi2KfHk0OOTWKDwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2613/3318] dmaengine: ste_dma40: Validate disabled channel indexes
Date: Wed, 18 Nov 2026 15:53:55 +0100
Message-ID: <20261118150439.522114393@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit c96e9f056095825b5f8d4a11f4107fc174892f92 ]

d40_of_probe() checks how many entries disabled-channels contains, but not
the channel numbers themselves. d40_phy_res_init() later uses every value
as an index into base->phy_res, whose size is the number of channels found
in this DMA40 instance. An out-of-range value can therefore write beyond
the allocation.

Validate each disabled channel against the detected hardware channel count
before allocating and initializing the channel resources.

Fixes: 499c2bc3cc89 ("dmaengine: ste_dma40: Fetch disabled channels from DT")
Assisted-by: LLM
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260927-dma40-fixes-v7-16-89f595e8851d@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 4902efa0dc906..7048274fcfeb8 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3230,6 +3230,15 @@ static int __init d40_hw_detect_init(struct platform_device *pdev,
 
 	num_phy_chans = min(num_phy_chans, STEDMA40_MAX_PHYS);
 
+	for (i = 0; plat_data->disabled_channels[i] != -1; i++) {
+		int chan = plat_data->disabled_channels[i];
+
+		if (chan < 0 || chan >= num_phy_chans) {
+			dev_err(dev, "Invalid disabled channel %d\n", chan);
+			return -EINVAL;
+		}
+	}
+
 	/* The number of channels used for memcpy */
 	num_memcpy_chans = plat_data->num_of_memcpy_chans;
 	num_log_chans = num_phy_chans * D40_MAX_LOG_CHAN_PER_PHY;
-- 
2.53.0



