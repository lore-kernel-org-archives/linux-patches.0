Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B88234966;
	Mon, 10 Mar 2025 18:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630836; cv=none; b=U0IAcj1WnWdjKS0vFacwZ5seRJRSaCx12+sWbvxTfrZUnPfLTY1caNWu7zr5q7nvUNy421m2xheNJybPYr/IWX/DXuh/cB8KCcrOrJRl/F3Dvml8Nr7L/rkm26f2ytObRusyxNlaWDk2TI/HnT02UFvir0aS/2BRBRb0rbO8dQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630836; c=relaxed/simple;
	bh=h4VaJ82Qj92sj+vELKQ1cGXMbSwdCpaTDzROKpW/AAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bvPjK6Jr/dzzCGm4XakJp753XZ54DjaICQBk8CeJ2R1uSjqVElqfFHHw0pNrhjVyJD4xrcraRf3TWvknf6Rwm6QgRjvvrfi638v4bhP+pRxeK54zVjZS7+j9R+bfX5TumTwUB2SaRWEM2KKvlqObamZZW3Qs/8qCDzSo5Om/u1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mH0wvquk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mH0wvquk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9572AC4AF0B;
	Mon, 10 Mar 2025 18:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630836;
	bh=h4VaJ82Qj92sj+vELKQ1cGXMbSwdCpaTDzROKpW/AAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mH0wvqukffDcI7TwIVa8koNLMHFHzzOwQ0wMk13pIu8EUOl5PoDvOfDj71R9tsuCF
	 DGbcr9xnEkHpNHtg2wGHmjEXw1E0KytXKWZjPxlCNWpQ5EZFl2UrgYVnaIUtSvL05+
	 qHDSPdo2CqHA52HejgpovOQpo4b06+SblF8iXw7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaustabh Chakraborty <kauschluss@disroot.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Anand Moon <linux.amoon@gmail.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 524/620] phy: exynos5-usbdrd: fix MPLL_MULTIPLIER and SSC_REFCLKSEL masks in refclk
Date: Mon, 10 Mar 2025 18:06:10 +0100
Message-ID: <20250310170606.234605851@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -288,9 +288,9 @@ exynos5_usbdrd_pipe3_set_refclk(struct p
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
@@ -332,9 +332,9 @@ exynos5_usbdrd_utmi_set_refclk(struct ph
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


