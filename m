Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0175347FF8
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302538; cv=none; b=HHxkD2udAyKxGi/p4v3BOf+JjcdplhJS2RMykeevWukBki/+AzbevezzphkeTgCmuIBUVE1Ky+Ze13MC3j3i+iVPSaippt2skIJlBedNJJU8GN0w4nLeYw4DK3qBbZxJye5iaQmUcdfmN5dqbnZhCVlwMehzm/pR0rdOarzbgE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302538; c=relaxed/simple;
	bh=fJAUufCRKcleQ2idj0zudljddEuuneFi/X3xaB3hJ/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rZOkLKUCYA8121b7cykCz/oilFCCPKv9qJZHkaBEWeMk8y2xXJZQDgDB4PYp73b+Djf/O2SPzzlN6/u3OM50CmsCetPBwiz1Ok6o9NO+YYOT6MQguKWqRXNwcQWaQrTip/oer0PwxgClizQcZa4/sdY8iJGx+XlqO+R4wigz9PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yl5Gbf9G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yl5Gbf9G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC5BC2BC87;
	Sat, 28 Feb 2026 18:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302538;
	bh=fJAUufCRKcleQ2idj0zudljddEuuneFi/X3xaB3hJ/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yl5Gbf9Gjazd5wsbNyglmAyifhbu54wS+0t+MB5ABQ/X7FXF0iv7O8CN2ogjlvQo6
	 ZjjjHUMMyIcT0R/3JAeqwjXV6dKZ4t04hpjotxx9DIsi/AGaZhh2bNsrZ+NuLjjySO
	 ad9R14l5NsZv6p9jFPJNomGHAfFXoQIhZQ3HdqibBQAC3sMAyk9lUtIWdN2fcxvAHe
	 qrzzkGYGrxPhi/PdOh1yoyPLe0FvE+UYIUDByJKwwBobxCzQV3eM9D2Ouh2B+0DLqu
	 LaD9D/OAtupYug7JFqDysCUPGECzqmyvrJwWghXTCZtm1YHkhLPuECEAwqJ6n6ZgSd
	 3ZXCN53nsczfA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chen-Yu Tsai <wens@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 039/164] ARM: dts: allwinner: sun5i-a13-utoo-p66: delete "power-gpios" property
Date: Sat, 28 Feb 2026 13:12:58 -0500
Message-ID: <20260228181505.1600663-39-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Chen-Yu Tsai <wens@kernel.org>

[ Upstream commit 0b2761eb1287bd9f62367cccf6626eb3107cef6f ]

The P66's device tree includes the reference design dtsi files, which
defines a node and properties for the touchpanel in the common design.
The P66 dts file then overrides all the properties to match its own
design, but as the touchpanel model is different, a different schema
is matched. This other schema uses a different name for the GPIO.

The original submission added the correct GPIO property, but did not
delete the one inherited from the reference design, causing validation
errors.

Explicitly delete the incorrect GPIO property.

Fixes: 2a53aff27236 ("ARM: dts: sun5i: Enable touchscreen on Utoo P66")
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://patch.msgid.link/20251225103616.3203473-4-wens@kernel.org
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sun5i-a13-utoo-p66.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/sun5i-a13-utoo-p66.dts b/arch/arm/boot/dts/sun5i-a13-utoo-p66.dts
index be486d28d04fa..428cab5a0e906 100644
--- a/arch/arm/boot/dts/sun5i-a13-utoo-p66.dts
+++ b/arch/arm/boot/dts/sun5i-a13-utoo-p66.dts
@@ -102,6 +102,7 @@ &touchscreen {
 	/* The P66 uses a different EINT then the reference design */
 	interrupts = <6 9 IRQ_TYPE_EDGE_FALLING>; /* EINT9 (PG9) */
 	/* The icn8318 binding expects wake-gpios instead of power-gpios */
+	/delete-property/ power-gpios;
 	wake-gpios = <&pio 1 3 GPIO_ACTIVE_HIGH>; /* PB3 */
 	touchscreen-size-x = <800>;
 	touchscreen-size-y = <480>;
-- 
2.51.0

