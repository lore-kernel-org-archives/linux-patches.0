Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113142F2341;
	Tue, 17 Jun 2025 15:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175524; cv=none; b=IRNmBXh1vjiPizl7Bs4SkK8V/jnql0xgGj90IEsy/hIr3hH90rpaKpWWC6Ff8NWod+tjuNIviR4wPDVaFm6G8LMHknMkY1IH3q1bd0ClAOlXS0OChBTIwajAIWd3OST0oq+Mda4Wkl3G0jOJeSnlaXbxnhrWM62DHFdNFI/Td6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175524; c=relaxed/simple;
	bh=vYxmsqenLOJWn/JO1j8MJDPTqyMaPrrYMCq4NgAMB2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pIcs+7OXs63F1lBxhaqYamyNJJurzoakRwElh0+Qh4J0S2DUHa5sT7WX0lkGI8ZnnD9jMPH80yB5FXnoR9rsEzsRo+KtVivfRadHWxgu0qdhnRAcqs9hQp5bqENnrCK/NzuxEAtwULxMMVeYUsoVt9OC+iTgC77zZ+Iy7JGP4OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=alWiZ18N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="alWiZ18N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CE0EC4CEE3;
	Tue, 17 Jun 2025 15:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175523;
	bh=vYxmsqenLOJWn/JO1j8MJDPTqyMaPrrYMCq4NgAMB2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=alWiZ18NA8epvhlTqrnRqNKOw62AQeOfHlYyTQ4kfypPbN01uG+QNralu1nCUEaU0
	 7CyqpQbWfGw2CcMg9K6TEpmrgCmKtD+mk75/rZhbHjQqzTZ0DzUtPDDUk/LLiTHTGZ
	 qh8Hmvd4PPievO0/wmfOLUov+Bc0qesTZ7Hl6rWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Minnekhanov <alexeymin@postmarketos.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 167/356] arm64: dts: qcom: sdm660-xiaomi-lavender: Add missing SD card detect GPIO
Date: Tue, 17 Jun 2025 17:24:42 +0200
Message-ID: <20250617152344.943558312@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3c47410ba94c0..ec4245bbfffaf 100644
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



