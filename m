Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C4D36656B;
	Tue, 16 Dec 2025 12:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888250; cv=none; b=ix/evFSq3hPtCKbYICRGuNTUmCOgiSOwCfh7D9UtheDy4WhnvoNRy1BTRuDokM2mFG1B+4pp7S/JUi3A4COPNlW/mwezFpbx0uomOqIbfxwzIgVg5yVfTtoDoGPrg2nF9mORv1Wb7EFb5zO1FSk6vMtVLopIenK/5Uv0jb04zIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888250; c=relaxed/simple;
	bh=qsWgy/IKvmGMPtFzB5c/NGqLyQBaGhcTdH89/L3ICOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HfCRwZ5UOQX4paVfhNlRM+m/czjnlklsJUylyTLe848ULOXzcEPgSIKjx+25qTtnRwSfbwGGQqU1CgqvG/txkDlGreBTpBmsz1m3PCDf3losEgxSar1q/knCgYkUtymGHdMvxkgLfF2612CekR2RnlEnPi3Bbrf3QAXge7gGBvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H2iRysj1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H2iRysj1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6277C19425;
	Tue, 16 Dec 2025 12:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888250;
	bh=qsWgy/IKvmGMPtFzB5c/NGqLyQBaGhcTdH89/L3ICOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H2iRysj1+JRIKF5x1zAyjOH0Gf7MQmUrfhEaFju2AFtOgi9bwk1gMausXBm53LnQA
	 0RDLG0LBSD3KmlFkXLl9VMcPSqbINnsIlDUMFmoRQ3Eb80YD8pZcDxMqEJBPQNspg3
	 2L8HafML5jEtNs+De+HkHPZCs57BAdMR3qhZfYU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 477/614] ARM: dts: samsung: exynos4412-midas: turn off SDIO WLAN chip during system suspend
Date: Tue, 16 Dec 2025 12:14:04 +0100
Message-ID: <20251216111418.652428793@linuxfoundation.org>
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
index 05ddddb565ee3..48245b1665a69 100644
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



