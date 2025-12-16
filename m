Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8A0378302;
	Tue, 16 Dec 2025 12:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888242; cv=none; b=AJfGp10dBrNbqHJuceZdrSq8LIhhTAGAiCpQuTE2lensaj3N1x0tUvrT3qAR9Rvi6ihuYhP5vamGTDfEtBdApr8qfOzjFURSKFEr9ZnQMcSa/cg4fPnecWU7HTmOb65O0dSWLv9XFRDPt/Thanwaw9QrP5JRrb5+Zk13sChHQZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888242; c=relaxed/simple;
	bh=GMAVTshxLwT9FDwRkCWkO95rFidctVXNHrg/tIidjJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fD2plJWF2DKha/1SzjrQA/dUNN3SnVW/EbOP0agPpisEtTLtUfbMjKtehRq7qyrca4/l95KxV/9+ahjeeRqSMNcIBHs5R+EVBh28i5Z/+1xjGZcwkwhXzaH2K1k+sa6oGelJtM1fglNhUs1uaAZTpbEq6e5V5/u2GC4cg4eCXYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RLb2ainr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RLb2ainr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3254AC4CEF1;
	Tue, 16 Dec 2025 12:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888241;
	bh=GMAVTshxLwT9FDwRkCWkO95rFidctVXNHrg/tIidjJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RLb2ainrGvonEO1A1CSvp0/fFsdeKvEMpdam01YoRMRbgRINitPdcNPyWIj1FQI28
	 87/BHFbWnadc+ENw80dQ/Sqraj2raDuZcA/hu9gwwRBGgwlRpPoHJqnAFPrME4JWDa
	 CcUPvpwJNZPdy9ONG6Qd6e9aSW5hadGaTnwWQD7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 474/614] ARM: dts: samsung: universal_c210: turn off SDIO WLAN chip during system suspend
Date: Tue, 16 Dec 2025 12:14:01 +0100
Message-ID: <20251216111418.543253435@linuxfoundation.org>
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

[ Upstream commit 97aee67e2406ea381408915e606c5f86448f3949 ]

Commit 8c3170628a9c ("wifi: brcmfmac: keep power during suspend if board
requires it") changed default behavior of the BRCMFMAC driver, which now
keeps SDIO card powered during system suspend to enable optional support
for WOWL. This feature is not supported by the legacy Exynos4 based
boards and leads to WLAN disfunction after system suspend/resume cycle.
Fix this by annotating SDIO host used by WLAN chip with
'cap-power-off-card' property, which should have been there from the
beginning.

Fixes: f1b0ffaa686f ("ARM: dts: exynos: Enable WLAN support for the UniversalC210 board")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://patch.msgid.link/20251126102618.3103517-2-m.szyprowski@samsung.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/samsung/exynos4210-universal_c210.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/samsung/exynos4210-universal_c210.dts b/arch/arm/boot/dts/samsung/exynos4210-universal_c210.dts
index bdc30f8cf748f..91490693432b6 100644
--- a/arch/arm/boot/dts/samsung/exynos4210-universal_c210.dts
+++ b/arch/arm/boot/dts/samsung/exynos4210-universal_c210.dts
@@ -610,6 +610,7 @@ &sdhci_3 {
 	#size-cells = <0>;
 
 	non-removable;
+	cap-power-off-card;
 	bus-width = <4>;
 	mmc-pwrseq = <&wlan_pwrseq>;
 	vmmc-supply = <&ldo5_reg>;
-- 
2.51.0



