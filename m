Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C592826A08F;
	Tue, 16 Dec 2025 11:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884655; cv=none; b=VTXSExOobhPCpdic19/wB5jLExWnZ/FTx5OKXW7cwHdJNvt6PE6HAU4NGUuI5jx0nhYFwpxfPJX4Ih7hXrJe2X2QTXRm2XWUn144yqMmSGAIB+J/v+moq/c+3seIRsOIRhXn8dVXp5iZy7aSaZZzsRlE1FBNtCwcuVhtkDu0Kbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884655; c=relaxed/simple;
	bh=kNVwH7Ga64YJh9y+hcKqxfJyqz5iPHN0HaRf5iz/j3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oPtzSoB4sFx5zWzqkwuCzFk9ipNhTYT0T2PfA7z5K+apXVYxFL3GSxiUthF9xJx0iIDz94sU0Rdlxc/LaRrIafpFWlJK9+OENX2PqZsuXFz0OJPI+QUQFFFmzzEVSMfbyMgmKkvwFzQb7u6WqYmnKmDAngyTH7BeWhxXvCABMYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R91rUyKK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R91rUyKK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ABBFC4CEF1;
	Tue, 16 Dec 2025 11:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884655;
	bh=kNVwH7Ga64YJh9y+hcKqxfJyqz5iPHN0HaRf5iz/j3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R91rUyKK7SBT7vIP4KqMoC2JlI6kPEH2B2w8YPME1O1jVHVnCOr0Hxb7SnSHjEraX
	 XUipDY4eaB6Ic3lQhomJGEWxFdYiWbm+oV8L/44tarQn6DoM1Patiq2QadAQSuhbHO
	 227H+/7sxsV8kwDyzny6aIPYw0P3aHyqX4FH8i4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 260/354] ARM: dts: samsung: exynos4412-midas: turn off SDIO WLAN chip during system suspend
Date: Tue, 16 Dec 2025 12:13:47 +0100
Message-ID: <20251216111330.337460636@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 2ff147fdfa99b8cbb8c2833e685fde7c42580ae6 ]

Commit 8c3170628a9c ("wifi: brcmfmac: keep power during suspend if board
requires it") changed default behavior of the BRCMFMAC driver, which now
keeps SDIO card powered during system suspend to enable optional support
for WOWL. This feature is not supported by the legacy Exynos4 based
boards and leads to WLAN disfunction after system suspend/resume cycle.
Fix this by annotating SDIO host used by WLAN chip with
'cap-power-off-card' property, which should have been there from the
beginning.

Fixes: f77cbb9a3e5d ("ARM: dts: exynos: Add bcm4334 device node to Trats2")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://patch.msgid.link/20251126102618.3103517-5-m.szyprowski@samsung.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/samsung/exynos4412-midas.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/samsung/exynos4412-midas.dtsi b/arch/arm/boot/dts/samsung/exynos4412-midas.dtsi
index 3d5aace668dc5..977ecc838b0cb 100644
--- a/arch/arm/boot/dts/samsung/exynos4412-midas.dtsi
+++ b/arch/arm/boot/dts/samsung/exynos4412-midas.dtsi
@@ -1440,6 +1440,7 @@ &sdhci_3 {
 	#address-cells = <1>;
 	#size-cells = <0>;
 	non-removable;
+	cap-power-off-card;
 	bus-width = <4>;
 
 	mmc-pwrseq = <&wlan_pwrseq>;
-- 
2.51.0



