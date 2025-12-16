Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44FE8378319;
	Tue, 16 Dec 2025 12:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888247; cv=none; b=SCegjtTbxKlhqel86riFktwONGkCvNdZ0QpY094b/ul1qleOxMt66WwSJFzXOG9IZWz76vhETj2WB6xSiYxJ+a0YryUJEzT5ncRy6LZS2mfnqS53UOcvNUUoUw4GC29IhQIz78b+SaMhPwFd/HmjXzdn5uiq465mGhOsHUxY6LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888247; c=relaxed/simple;
	bh=2CXTmNpIQBVjd5vinhsuZDSkC7p6CgjMefUR7O6rixw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nctVzyw5u74bhlFopTY1rZsiOk6AfG2awVN/PsJEGgcN3uzHY89Zav5BVclZ3UmwbBaAI2rkJTytCA55z8CfKWAL+gWZNR6fr+qdx8VET3Xn6LkDA2nETP+DqnGtQRThcNzFlsWO4j5713RScT9EtRjdoEezlBvWzLcev00mNMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VR1YgHlH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VR1YgHlH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA9CC4CEF5;
	Tue, 16 Dec 2025 12:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888247;
	bh=2CXTmNpIQBVjd5vinhsuZDSkC7p6CgjMefUR7O6rixw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VR1YgHlHswuANnjRd72qtI2/A1O/ZPiwRCDNJ8B7PItSDRgXJjT+TwDyrOK9rl6dy
	 C+SnfUrDS7iAv8tcfLfdEHixxcSDPZVizZb2SvL0niLbuUzmD+E+CyStqTSQDF/wbq
	 1u5QGX8as6b6AnWaDz/XHUZznZeEimPF4weoiqfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 476/614] ARM: dts: samsung: exynos4210-trats: turn off SDIO WLAN chip during system suspend
Date: Tue, 16 Dec 2025 12:14:03 +0100
Message-ID: <20251216111418.616575647@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



