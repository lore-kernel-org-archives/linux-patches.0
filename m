Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A91257AD1;
	Tue, 16 Dec 2025 11:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884652; cv=none; b=ibf/UdYSuK5a+APStdyCe0YzhKqV6JUtlH/QYQln6yJ5ov2x33ZQo1w87EF7uGB1DbILAqSGMY9KaoGfIn0Hy8Yrh96lR8ryNCjgWgK01IErJJl+PI60AswuHleALSQoxv4294AxfuWp6vA6VrAVKiV3QHG+FgRS45lbnvJMAsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884652; c=relaxed/simple;
	bh=OjkZ7lQQRiQNcbMk90XR92nAgN8tqplGMs0A3GOQSWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EnBnDCVfZFmCiJoJbvV9ojwg/1XuOoERTKicJpCR3N4AVJ0zkwpc0Fq7FCVjP86TKslNGgi+XAZp17gE/0lkrXrUJ1lnBzOyZce64A7jbRytEqkGdKpRQ9XdjDvxGv6xYJF/6RoFseNJVPzUa2Fezg2UG+yf42tKs9M/kckKyng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F4dj5ijm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F4dj5ijm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75BF6C4CEF1;
	Tue, 16 Dec 2025 11:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884651;
	bh=OjkZ7lQQRiQNcbMk90XR92nAgN8tqplGMs0A3GOQSWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F4dj5ijmoymkPBdoBD5ZbVPncAXtqaaMbydoERnZYi0/ayvaqWJvhITn/Ge20sx99
	 e4T04bDC/CGyCUOtsg0sSqb70ntfep7sS05fH+YNqrSZnoivYWE02kgFoOEo+z1ZhM
	 i4V1qu2KfZsJsRG/2LeGlS1YJZbPSriltBgh/0H0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 259/354] ARM: dts: samsung: exynos4210-trats: turn off SDIO WLAN chip during system suspend
Date: Tue, 16 Dec 2025 12:13:46 +0100
Message-ID: <20251216111330.301480571@linuxfoundation.org>
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

[ Upstream commit 97cc9c346b2c9cde075b9420fc172137d2427711 ]

Commit 8c3170628a9c ("wifi: brcmfmac: keep power during suspend if board
requires it") changed default behavior of the BRCMFMAC driver, which now
keeps SDIO card powered during system suspend to enable optional support
for WOWL. This feature is not supported by the legacy Exynos4 based
boards and leads to WLAN disfunction after system suspend/resume cycle.
Fix this by annotating SDIO host used by WLAN chip with
'cap-power-off-card' property, which should have been there from the
beginning.

Fixes: a19f6efc01df ("ARM: dts: exynos: Enable WLAN support for the Trats board")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://patch.msgid.link/20251126102618.3103517-4-m.szyprowski@samsung.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/samsung/exynos4210-trats.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/samsung/exynos4210-trats.dts b/arch/arm/boot/dts/samsung/exynos4210-trats.dts
index 95e0e01b6ff6b..6bd902cb8f4ad 100644
--- a/arch/arm/boot/dts/samsung/exynos4210-trats.dts
+++ b/arch/arm/boot/dts/samsung/exynos4210-trats.dts
@@ -518,6 +518,7 @@ &sdhci_3 {
 	#size-cells = <0>;
 
 	non-removable;
+	cap-power-off-card;
 	bus-width = <4>;
 	mmc-pwrseq = <&wlan_pwrseq>;
 	vmmc-supply = <&tflash_reg>;
-- 
2.51.0



