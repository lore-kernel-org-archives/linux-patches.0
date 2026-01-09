Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1463633C511;
	Fri,  9 Jan 2026 11:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959956; cv=none; b=dm/TovCKZApYZ3FdH1QeCs+EjMdIBodxonCr+M1qbc6zZIwRXgLSeroBYeUXwCvHgnfDtCDOk3X6uZUs3jltVrCl3aTcGSetakkaqd/keu+0gkb8LgHADWwv6waBTwccpZ/EZxvRfPup1HqYv3chEdNhMKEmRiA+9WIAqVJ48AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959956; c=relaxed/simple;
	bh=Z12e10FKobwSlweUy+ugYHBkJOJ6i/DxhY/WAs4DDZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Usu+fLEcv7F0fqwR1zY+9UCxYKVEMv1X1hLKNPoX6G0UHnU72fkH9EnlrYXZGxVLr6x9ytJpDRxUMDaVBYKhvZ9EjdB4dfazTPIiBLX3J+bSYtXzsupSqlFYBkAIPmF7iQbHJMeqxVz1kD8/anonzoXhOXou/NGrEInOZABGc5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fEu07Yk9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fEu07Yk9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB2DC4CEF1;
	Fri,  9 Jan 2026 11:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959956;
	bh=Z12e10FKobwSlweUy+ugYHBkJOJ6i/DxhY/WAs4DDZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fEu07Yk9hgXf4nIWbyD0401N5loNIpFzBHkCgEXazoYGjDuyGmq92YQD3TR+QO50n
	 tSYDNwxS/HEimVf6Dv5HkrQJsWBtZzkFBSfhONz+GNjyyxi4AAzX6gbMqFG5t2cjtv
	 GvFJ+uzK9GsqJBsnsKNtdyCKsAffJRYQhyuc0yro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 234/737] ARM: dts: samsung: exynos4412-midas: turn off SDIO WLAN chip during system suspend
Date: Fri,  9 Jan 2026 12:36:13 +0100
Message-ID: <20260109112142.801401488@linuxfoundation.org>
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
index 7daf25865551b..a77e57645f217 100644
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



