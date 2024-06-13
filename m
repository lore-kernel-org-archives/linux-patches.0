Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F921448DA;
	Thu, 13 Jun 2024 12:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281366; cv=none; b=tFoGZAjCB4Dt5OgFBq7DVsd0Ayv735e4/+GjSJYIYmQi9zC+6yoV49F1IVkfU1aFnH+9Ro1eOrSF4yqAUH1yqcuvWPWmOujSdZ//gl51EHZqJVazQtjv9KaoSs7MbsmuZsU8VoUX19gRZQbbwDDKyDV/ZfEp4kqWoyvM0gsvtAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281366; c=relaxed/simple;
	bh=yHcBHgwYcLi3Sj/NhwQH+Tag+rCHcJyvF3AypkKah2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c594HFl0E9mf6b7pTzHcCb4DtCiJXEVKUyv1tNO5IN0WeHdtvZmG7Pe5g/M9hcXHleesInZQNBwQ59dUsBiquNyQml0Uo964x0pxniajR04eri2uPLAGc/sPhaWKsgR6bMud+8jtfjvok1Lh6HRJbcwH/4VjmFXyskr38ZAaWXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NKaHwooZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NKaHwooZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E1BFC2BBFC;
	Thu, 13 Jun 2024 12:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281366;
	bh=yHcBHgwYcLi3Sj/NhwQH+Tag+rCHcJyvF3AypkKah2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NKaHwooZJapYv89cdiAR5DsFbbXYF9GLBrdX0bQfKr/VAd4zCbTm/0k29VJAS8OkG
	 7hUhChkjqp5aPsLKc9CUDVs/f/znVL5GGy/iAHY0FwTcQliqfCIvwBv9jQdjxNSnaR
	 Cy6aUxE2RgYc4mlqa5PwDMfx80aT5hjw24zdgpDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 200/317] mmc: sdhci_am654: Add ITAPDLYSEL in sdhci_j721e_4bit_set_clock
Date: Thu, 13 Jun 2024 13:33:38 +0200
Message-ID: <20240613113255.292872457@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Judith Mendez <jm@ti.com>

[ Upstream commit 9dff65bb5e09903c27d9cff947dff4d22b6ea6a1 ]

Add ITAPDLYSEL to sdhci_j721e_4bit_set_clock function.
This allows to set the correct ITAPDLY for timings that
do not carry out tuning.

Fixes: 1accbced1c32 ("mmc: sdhci_am654: Add Support for 4 bit IP on J721E")
Signed-off-by: Judith Mendez <jm@ti.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20240320223837.959900-7-jm@ti.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci_am654.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/sdhci_am654.c b/drivers/mmc/host/sdhci_am654.c
index 1968381b93100..879ead07f8022 100644
--- a/drivers/mmc/host/sdhci_am654.c
+++ b/drivers/mmc/host/sdhci_am654.c
@@ -319,6 +319,7 @@ static void sdhci_j721e_4bit_set_clock(struct sdhci_host *host,
 	unsigned char timing = host->mmc->ios.timing;
 	u32 otap_del_sel;
 	u32 itap_del_ena;
+	u32 itap_del_sel;
 	u32 mask, val;
 
 	/* Setup DLL Output TAP delay */
@@ -328,13 +329,18 @@ static void sdhci_j721e_4bit_set_clock(struct sdhci_host *host,
 	val = (0x1 << OTAPDLYENA_SHIFT) |
 	      (otap_del_sel << OTAPDLYSEL_SHIFT);
 
+	/* Setup Input TAP delay */
 	itap_del_ena = sdhci_am654->itap_del_ena[timing];
+	itap_del_sel = sdhci_am654->itap_del_sel[timing];
 
-	mask |= ITAPDLYENA_MASK;
-	val |= (itap_del_ena << ITAPDLYENA_SHIFT);
+	mask |= ITAPDLYENA_MASK | ITAPDLYSEL_MASK;
+	val |= (itap_del_ena << ITAPDLYENA_SHIFT) |
+	       (itap_del_sel << ITAPDLYSEL_SHIFT);
 
+	regmap_update_bits(sdhci_am654->base, PHY_CTRL4, ITAPCHGWIN_MASK,
+			   1 << ITAPCHGWIN_SHIFT);
 	regmap_update_bits(sdhci_am654->base, PHY_CTRL4, mask, val);
-
+	regmap_update_bits(sdhci_am654->base, PHY_CTRL4, ITAPCHGWIN_MASK, 0);
 	regmap_update_bits(sdhci_am654->base, PHY_CTRL5, CLKBUFSEL_MASK,
 			   sdhci_am654->clkbuf_sel);
 
-- 
2.43.0



