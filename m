Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8937A21E085;
	Thu, 12 Dec 2024 16:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019637; cv=none; b=RmbAgP8fJD87hQCm/jsqjo7V+2zQHhtbCr8CYWlnUC3/1xjYNHejWeTCM3YK/3kJ1iTk50YBEi1YmkgUOy5W7TvRLpMIBb/9G9t9I/a3G8FD+edFP8RFU0YPS6O/P5pDdaitHJpiRNi2bHy8CrCcQCMm5Hq94PeylfCRIel5OO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019637; c=relaxed/simple;
	bh=XcfsvSjIg/Ryg26giY0IQdAw+Wd0Xkd9TkgDWg0eU4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pSHekaD9OhpJMvNbE6Qfp7XbhzmzkTNca2jRE3685kfsclDZKB9F8xG9ArB6zuSZIF/EmwEYTZyVj1uU7zLFJqaPSR+tdp1cfIvKguSCivIcTjSMmX0tKTiELTQhcpHjQYInidz+moy0P9ZQaIIVp9ety3yWU2wCEaR6TLjJLPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z8hcJMTV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z8hcJMTV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11FFC4CECE;
	Thu, 12 Dec 2024 16:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019637;
	bh=XcfsvSjIg/Ryg26giY0IQdAw+Wd0Xkd9TkgDWg0eU4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z8hcJMTVfRPrhxrXQ4UwdPEcoAKY6E1ltVDeuE7DfV633dWGqsNO7BMwgzzKuLeXG
	 ylwUE/sbwXCKsly8D7nt0o/6Ifh6JDLXykgVlZeb6tce7OntWJeesfk1wbGfLSIGdC
	 LBy6imBhbYnWrTICX3h4Dx7P0rdNSPyO4/FDlTYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 229/772] clk: sunxi-ng: d1: Fix PLL_AUDIO0 preset
Date: Thu, 12 Dec 2024 15:52:54 +0100
Message-ID: <20241212144359.377188955@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit e0f253a52ccee3cf3eb987e99756e20c68a1aac9 ]

To work around a limitation in our clock modelling, we try to force two
bits in the AUDIO0 PLL to 0, in the CCU probe routine.
However the ~ operator only applies to the first expression, and does
not cover the second bit, so we end up clearing only bit 1.

Group the bit-ORing with parentheses, to make it both clearer to read
and actually correct.

Fixes: 35b97bb94111 ("clk: sunxi-ng: Add support for the D1 SoC clocks")
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Link: https://patch.msgid.link/20241001105016.1068558-1-andre.przywara@arm.com
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sunxi-ng/ccu-sun20i-d1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/sunxi-ng/ccu-sun20i-d1.c b/drivers/clk/sunxi-ng/ccu-sun20i-d1.c
index 8ef3cdeb79625..cb4bf038e17f5 100644
--- a/drivers/clk/sunxi-ng/ccu-sun20i-d1.c
+++ b/drivers/clk/sunxi-ng/ccu-sun20i-d1.c
@@ -1360,7 +1360,7 @@ static int sun20i_d1_ccu_probe(struct platform_device *pdev)
 
 	/* Enforce m1 = 0, m0 = 0 for PLL_AUDIO0 */
 	val = readl(reg + SUN20I_D1_PLL_AUDIO0_REG);
-	val &= ~BIT(1) | BIT(0);
+	val &= ~(BIT(1) | BIT(0));
 	writel(val, reg + SUN20I_D1_PLL_AUDIO0_REG);
 
 	/* Force fanout-27M factor N to 0. */
-- 
2.43.0



