Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F207C2F2367;
	Tue, 17 Jun 2025 16:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176483; cv=none; b=fRHyMTjxCz9Uk/uR0dWFeB/LAb0sCsxBHGcfpVyGPlrLOZwPlhAjjjdzrfPmcO32kNLqQ3epfrxdgMDFJDRFIhgiOXWWbH6qiVhpF7BFV+NrhpPRjF+iUAMTRwaqJvU1rgicFfs4+ba2DgOizuD6xNuQ2a5yvasmKMtISR9pWK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176483; c=relaxed/simple;
	bh=UUTnPYcAEcO7Vr6xJLBaGBT3dslaRDwOckZ0y7WBd34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GILh88Q5RFvO8eTVwfAyoHOp0JzG9VFS9KtSiYxSw23ss6NADnFmulOlMEtTg2fprzq2KWnL0I4ZG5EyUa3ni5WsDOijgaYdJZ5bB72IVprBiEg1pVBHB6vADKPybDTPOYukAzZ2YXrZJWb0gQJiVlJl9pLQWqS02llB7przrao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jOQrligg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jOQrligg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5850FC4CEE3;
	Tue, 17 Jun 2025 16:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176482;
	bh=UUTnPYcAEcO7Vr6xJLBaGBT3dslaRDwOckZ0y7WBd34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jOQrliggMxD9JvWb99YRG70UOXY5ROd0KfNs8B+m8DHNEEhZdSN9tokcBtFtP3aHC
	 FUahlP+VA7cP9pQv/GR+P76U7eJQ2QlXDNcDb/DCX509r8nFbASq/SYSNK+19oCofV
	 xrumgRe+gnSCAIkUQIt6uWulQmn6J4YhOXJRYu1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Minnekhanov <alexeymin@postmarketos.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 234/512] arm64: dts: qcom: sdm660-xiaomi-lavender: Add missing SD card detect GPIO
Date: Tue, 17 Jun 2025 17:23:20 +0200
Message-ID: <20250617152429.107263937@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Minnekhanov <alexeymin@postmarketos.org>

[ Upstream commit 2eca6af66709de0d1ba14cdf8b6d200a1337a3a2 ]

During initial porting these cd-gpios were missed. Having card detect is
beneficial because driver does not need to do polling every second and it
can just use IRQ. SD card detection in U-Boot is also fixed by this.

Fixes: cf85e9aee210 ("arm64: dts: qcom: sdm660-xiaomi-lavender: Add eMMC and SD")
Signed-off-by: Alexey Minnekhanov <alexeymin@postmarketos.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250415130101.1429281-1-alexeymin@postmarketos.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm660-xiaomi-lavender.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm660-xiaomi-lavender.dts b/arch/arm64/boot/dts/qcom/sdm660-xiaomi-lavender.dts
index 7167f75bced3f..0b4d71c14a772 100644
--- a/arch/arm64/boot/dts/qcom/sdm660-xiaomi-lavender.dts
+++ b/arch/arm64/boot/dts/qcom/sdm660-xiaomi-lavender.dts
@@ -404,6 +404,8 @@
 &sdhc_2 {
 	status = "okay";
 
+	cd-gpios = <&tlmm 54 GPIO_ACTIVE_HIGH>;
+
 	vmmc-supply = <&vreg_l5b_2p95>;
 	vqmmc-supply = <&vreg_l2b_2p95>;
 };
-- 
2.39.5



