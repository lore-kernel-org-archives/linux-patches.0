Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB73633C53C;
	Fri,  9 Jan 2026 11:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959950; cv=none; b=iAEAfesi/YguYBflfre8/KyHf5i+VJswTLmswk0rn/UIt8jZpvEzYH610sqkZx1yrSHIdMq+DbuNZ5xV3VhuYxjw0CFsETVpWu4A1ASsFU907nkiqYaIhUObi5OXMsZGcgarE9NI2PBRBPiv4Km77lUnUse5lxqZk4JdSWiVXKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959950; c=relaxed/simple;
	bh=KlE+GJFUllNvsHL5dOJ89u5WS96wEOSsEfqiwWUIyik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XIHEavBA1CQ4RS86Nux9Qyqsz8piT11CgrD+gA5qTmIKPRRzBhDHKT8rhypNCn+DVSYnQ4bbv7CCxvTOLKouQNzIsjP6awDZHMj3xnRyFFrrQUNM0+DEwUmBZUFcbtcBVqQ9T4ZY2vDSHN/ANDGVhE8KcOKKlMg6wwsphfaFNcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FXb4v8ro; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FXb4v8ro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1E3C19421;
	Fri,  9 Jan 2026 11:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959950;
	bh=KlE+GJFUllNvsHL5dOJ89u5WS96wEOSsEfqiwWUIyik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FXb4v8ro1K0wpEWipIySOdhaLI73Pl+ktFFXsfcOcTqb++97Bq5ZCPo3IW5QRUjd7
	 hmPTzgcr0OBtp8tQhaqRkisp3lVxLJstOjHeO2JRuSmwblgfRS03KzUb7mIOOscwEQ
	 N+VbpkEAdGj8soRKdcoAa2cMLbaTyTtw0bD5mQDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 232/737] ARM: dts: samsung: exynos4210-i9100: turn off SDIO WLAN chip during system suspend
Date: Fri,  9 Jan 2026 12:36:11 +0100
Message-ID: <20260109112142.726581651@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 863d69923bdb6f414d0a3f504f1dfaeacbc00b09 ]

Commit 8c3170628a9c ("wifi: brcmfmac: keep power during suspend if board
requires it") changed default behavior of the BRCMFMAC driver, which now
keeps SDIO card powered during system suspend to enable optional support
for WOWL. This feature is not supported by the legacy Exynos4 based
boards and leads to WLAN disfunction after system suspend/resume cycle.
Fix this by annotating SDIO host used by WLAN chip with
'cap-power-off-card' property, which should have been there from the
beginning.

Fixes: 8620cc2f99b7 ("ARM: dts: exynos: Add devicetree file for the Galaxy S2")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://patch.msgid.link/20251126102618.3103517-3-m.szyprowski@samsung.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/samsung/exynos4210-i9100.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/samsung/exynos4210-i9100.dts b/arch/arm/boot/dts/samsung/exynos4210-i9100.dts
index a076a1dfe41f8..d7adf2bd8f87e 100644
--- a/arch/arm/boot/dts/samsung/exynos4210-i9100.dts
+++ b/arch/arm/boot/dts/samsung/exynos4210-i9100.dts
@@ -815,6 +815,7 @@ &sdhci_3 {
 	#size-cells = <0>;
 
 	non-removable;
+	cap-power-off-card;
 	bus-width = <4>;
 	mmc-pwrseq = <&wlan_pwrseq>;
 	vmmc-supply = <&vtf_reg>;
-- 
2.51.0



