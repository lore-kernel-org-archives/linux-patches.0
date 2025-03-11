Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E5F1EA80;
	Tue, 11 Mar 2025 15:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706173; cv=none; b=BPIFs+5I7qdSbQHfP0sKf1Nhrc17Pw4OjHilb+CkjVuDIhS1eqCVNLUHdCtBbfjeZV/gyoVKpGAiUyZ4Zi5OaYhMyv2JA2QcrAC/Gyzc9u3DahPrGqioKXP2q0Pt9SCQ4eSXV9q4LIR9ps6ATiN/RD2U8PShF22CNqtX7bBnu/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706173; c=relaxed/simple;
	bh=/VDs2nhg9zdPQvEYsvk7J1hH4W7hJmiYmzAqJw5xsd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XpI71qHiVlMLUhSChTF1sP+g5y5KlfTaX8eMWM+2Q+kD3wsjS3EekDXle8LB0h6acj+vcmVqI2ZnslzHSY7WTR/Mtac3llkdBqsAEhdNufXApn6t94NWdtih7rQXjECErQMQbCtgHGuL+VEpjflBP1LDlKpdSceiJq0xxvuPMa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e93XCF2W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e93XCF2W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B56C3C4CEE9;
	Tue, 11 Mar 2025 15:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706173;
	bh=/VDs2nhg9zdPQvEYsvk7J1hH4W7hJmiYmzAqJw5xsd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e93XCF2WJ+Oql/78wodR5JrFXvCVecUF9EsI9cVh2NHNPg/OHPpAMuteFursumB0k
	 eWGQxD6/kzemU8u1sUgcx6GMxkegPoI4NjJvMLA1apW3lHqXS8YlKdo+V8xGQg6M3/
	 f8IXuEWE0jM+/fsz3eb7dnRsbCAaZ5nR7/pm8hCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaustabh Chakraborty <kauschluss@disroot.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Anand Moon <linux.amoon@gmail.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.4 269/328] phy: exynos5-usbdrd: fix MPLL_MULTIPLIER and SSC_REFCLKSEL masks in refclk
Date: Tue, 11 Mar 2025 16:00:39 +0100
Message-ID: <20250311145725.599321981@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kaustabh Chakraborty <kauschluss@disroot.org>

commit e2158c953c973adb49383ddea2504faf08d375b7 upstream.

In exynos5_usbdrd_{pipe3,utmi}_set_refclk(), the masks
PHYCLKRST_MPLL_MULTIPLIER_MASK and PHYCLKRST_SSC_REFCLKSEL_MASK are not
inverted when applied to the register values. Fix it.

Cc: stable@vger.kernel.org
Fixes: 59025887fb08 ("phy: Add new Exynos5 USB 3.0 PHY driver")
Signed-off-by: Kaustabh Chakraborty <kauschluss@disroot.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Anand Moon <linux.amoon@gmail.com>
Link: https://lore.kernel.org/r/20250209-exynos5-usbdrd-masks-v1-1-4f7f83f323d7@disroot.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/samsung/phy-exynos5-usbdrd.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/phy/samsung/phy-exynos5-usbdrd.c
+++ b/drivers/phy/samsung/phy-exynos5-usbdrd.c
@@ -287,9 +287,9 @@ exynos5_usbdrd_pipe3_set_refclk(struct p
 	reg |=	PHYCLKRST_REFCLKSEL_EXT_REFCLK;
 
 	/* FSEL settings corresponding to reference clock */
-	reg &= ~PHYCLKRST_FSEL_PIPE_MASK |
-		PHYCLKRST_MPLL_MULTIPLIER_MASK |
-		PHYCLKRST_SSC_REFCLKSEL_MASK;
+	reg &= ~(PHYCLKRST_FSEL_PIPE_MASK |
+		 PHYCLKRST_MPLL_MULTIPLIER_MASK |
+		 PHYCLKRST_SSC_REFCLKSEL_MASK);
 	switch (phy_drd->extrefclk) {
 	case EXYNOS5_FSEL_50MHZ:
 		reg |= (PHYCLKRST_MPLL_MULTIPLIER_50M_REF |
@@ -331,9 +331,9 @@ exynos5_usbdrd_utmi_set_refclk(struct ph
 	reg &= ~PHYCLKRST_REFCLKSEL_MASK;
 	reg |=	PHYCLKRST_REFCLKSEL_EXT_REFCLK;
 
-	reg &= ~PHYCLKRST_FSEL_UTMI_MASK |
-		PHYCLKRST_MPLL_MULTIPLIER_MASK |
-		PHYCLKRST_SSC_REFCLKSEL_MASK;
+	reg &= ~(PHYCLKRST_FSEL_UTMI_MASK |
+		 PHYCLKRST_MPLL_MULTIPLIER_MASK |
+		 PHYCLKRST_SSC_REFCLKSEL_MASK);
 	reg |= PHYCLKRST_FSEL(phy_drd->extrefclk);
 
 	return reg;


