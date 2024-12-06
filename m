Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FEE413E03A;
	Fri,  6 Dec 2024 15:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497530; cv=none; b=F1+SJIUSfX1vZpBtKxAHegtINdZ0SlgaFLEe0BwAwEj0ZCp/fB5nzTox7AaUj+NG0l4a6Q1Zcyg8xL3tLzWrPMghabqtNrkKYSnUQQgm16nauIhTR8IBqrQk3cWU4WRcrV+dhvG0X3WkiGViVktjJNgxqzTipjHwHubrvAZf/mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497530; c=relaxed/simple;
	bh=oVEZZiY1fBYleMZeKwxQi+oZA3tb0K8PJE6HEZhEBho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eDVm31Afv81YgtDj7+GVsHjp+V/M2zWrdhX3UY9r93AITZiGlEm+6iBoIZjeS1qikzDpEnmsGwSkTCMzO+VgapRrEc1+MVuIfSDyO991K040TTDr2we2TSYT/+j+IkXwNnuPLk7tLXWb5GR7bObqI9NeLeSxGpygGiu/9Y45hW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TcQA/Bpp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TcQA/Bpp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD80C4CED1;
	Fri,  6 Dec 2024 15:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497529;
	bh=oVEZZiY1fBYleMZeKwxQi+oZA3tb0K8PJE6HEZhEBho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TcQA/BppBFD4J8v4SC7pqqT3Fm6tuAb92/JD2F/8XtgdZZw5a5K8eGxe/sZbhTHXQ
	 2O/PKT5VGCrKMhLVBaTQDzd6dGgxJuPiQLWUtR4ALiL8M6UJSgOaapJrlv07x8n9sh
	 dlLGayekq7nRZx6H0eP9Hf/fNXmpe53uOkb+SiE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 286/676] clk: sunxi-ng: d1: Fix PLL_AUDIO0 preset
Date: Fri,  6 Dec 2024 15:31:45 +0100
Message-ID: <20241206143704.513297770@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 48a8fb2c43b74..f95c3615ca772 100644
--- a/drivers/clk/sunxi-ng/ccu-sun20i-d1.c
+++ b/drivers/clk/sunxi-ng/ccu-sun20i-d1.c
@@ -1371,7 +1371,7 @@ static int sun20i_d1_ccu_probe(struct platform_device *pdev)
 
 	/* Enforce m1 = 0, m0 = 0 for PLL_AUDIO0 */
 	val = readl(reg + SUN20I_D1_PLL_AUDIO0_REG);
-	val &= ~BIT(1) | BIT(0);
+	val &= ~(BIT(1) | BIT(0));
 	writel(val, reg + SUN20I_D1_PLL_AUDIO0_REG);
 
 	/* Force fanout-27M factor N to 0. */
-- 
2.43.0



