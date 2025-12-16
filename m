Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77407378304;
	Tue, 16 Dec 2025 12:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888244; cv=none; b=iyODiNoDL+gBW0zWr5F6ee65h7iZp44VduN/6BFyMle7gMtEH8/O3ewRVkoOSWXNNQ5BxB1nPeQtOTRGJYlm1ELwA0103JdErXFXSszIf0uVYgLKrEfLxVOD5s0e/T+zowFVfEJ8/rw8eyWGqxGy/rmbHIB9QCgEwWuTUagzeMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888244; c=relaxed/simple;
	bh=TNk9y4gEiRjBCerHtfdGwiKKjzeTrQGihDxDUHrrOlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aC790CXbNHFu54pxhLpQ41WQg8wkC4XPaUMxDpcQfPr/E80lvoF6XxU4dxJCTyQxbwBsJ2+80iQ0LiyVF3td7dnV394ODR46yUOsk10J1qXy/ai9mEzapOdmMG/gev9U6xTxhthbLySDdxNXxOaFlLAidLYdlnOQk/8PhDZRx+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LEy1CXFz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LEy1CXFz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE10AC4CEF5;
	Tue, 16 Dec 2025 12:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888244;
	bh=TNk9y4gEiRjBCerHtfdGwiKKjzeTrQGihDxDUHrrOlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LEy1CXFzoyfTAN9yrg4I/jIIsUd0qFcgjO4AszFUKLnQAZncgNuo3Ge+koZQI08PA
	 zk3amjP3SZUnPaWSAQHNC06fZVwQUAIOT0o0ppgxWwNB89zA01tZr6DAMIbnV9aY/w
	 sx24IqLyD/iwoZlFkuDmUh+lj1X+ydJ7zDjTrB7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 475/614] ARM: dts: samsung: exynos4210-i9100: turn off SDIO WLAN chip during system suspend
Date: Tue, 16 Dec 2025 12:14:02 +0100
Message-ID: <20251216111418.580725760@linuxfoundation.org>
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
index df229fb8a16be..8a635bee59fa9 100644
--- a/arch/arm/boot/dts/samsung/exynos4210-i9100.dts
+++ b/arch/arm/boot/dts/samsung/exynos4210-i9100.dts
@@ -853,6 +853,7 @@ &sdhci_3 {
 	#size-cells = <0>;
 
 	non-removable;
+	cap-power-off-card;
 	bus-width = <4>;
 	mmc-pwrseq = <&wlan_pwrseq>;
 	vmmc-supply = <&vtf_reg>;
-- 
2.51.0



