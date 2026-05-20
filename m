Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB7E3630BC;
	Wed, 20 May 2026 16:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295719; cv=none; b=uB+sRI0tTRRc2SgsODk4XkmGVOQ59P0V6RC/LyW9n0WE1rmQ5Xdo3YU4WH8tQI0/upzXUWOSqIywD/6JNl+wEi1vhZbRb+pNPuwFDcivPg7WmznsfB/zD5JrJrxAMRbJzqM8LO1qf7EESLtXd+0HBktR/ZMdIFAo+X3KsYo++DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295719; c=relaxed/simple;
	bh=EYIuvwSwF97FwtXcZJccar0P33LHMda5Js3lPZp567M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fh5K6FMn1SkuWn8PZ9pZZZXL/cXNt+hUaS3zy4OyTFJlpz0g3cImCfmFH7LLuCuX2V2zNtO5Gws9dKUHuqSktUsTHa8sazRAQBwcJlrDzDgNc4ISwVqdF+udaznikje8rNJDYJ9zs3HjLF1rOBUjODSsaZNTCUhvDm6JXJF03rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JMWg5Rv3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JMWg5Rv3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D701F00893;
	Wed, 20 May 2026 16:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295716;
	bh=rHrVOq0IViqwvAiZdqeRSDli/FahAQE+Wfbg+eeRl+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JMWg5Rv3vUB9ENWXUN4FOt8xQ4me1edyylKzNztPcpF2v12JJxksmatzH/tRSSTWE
	 RPeJX5v7blp25prGibRjt3worfZXspHMEnKolsUAdh36DcS4ZD2oqIFRry23Vt7AmQ
	 AATKdLXSU2NHQOEZd1KbRewMahYYei+RJ+0oV9sE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0526/1146] arm64: dts: qcom: sm8450: Enable UHS-I SDR50 and SDR104 SD card modes
Date: Wed, 20 May 2026 18:12:56 +0200
Message-ID: <20260520162200.087096370@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

[ Upstream commit db0c5ef1abda6effdc5c85d6688fb6af2b351ae5 ]

The reported problem of some non-working UHS-I speed modes on SM8450
originates in commit 0a631a36f724 ("arm64: dts: qcom: Add device tree
for Sony Xperia 1 IV"), and then it was spread to all SM8450 powered
platforms by commit 9d561dc4e5cc ("arm64: dts: qcom: sm8450: disable
SDHCI SDR104/SDR50 on all boards").

The tests show that the rootcause of the problem was related to an
overclocking of SD cards, and it's fixed later on by commit a27ac3806b0a
("clk: qcom: gcc-sm8450: Use floor ops for SDCC RCGs").

Since then both SDR50 and SDR104 speed modes are working fine on SM8450,
tested on SM8450-HDK:

SDR50 speed mode:

    mmc0: new UHS-I speed SDR50 SDHC card at address 0001
    mmcblk0: mmc0:0001 00000 14.6 GiB
     mmcblk0: p1

    % dd if=/dev/mmcblk0p1 of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB, 1.0 GiB) copied, 24.6254 s, 43.6 MB/s

SDR104 speed mode:

    mmc0: new UHS-I speed SDR104 SDHC card at address 59b4
    mmcblk0: mmc0:59b4 USDU1 28.3 GiB
     mmcblk0: p1

    % dd if=/dev/mmcblk0p1 of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB, 1.0 GiB) copied, 12.3266 s, 87.1 MB/s

Remove the restrictions on SD card speed modes from the SM8450 platform
dtsi file and enable UHS-I speed modes.

Fixes: 9d561dc4e5cc ("arm64: dts: qcom: sm8450: disable SDHCI SDR104/SDR50 on all boards")
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Link: https://lore.kernel.org/r/20260314023715.357512-5-vladimir.zapolskiy@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8450.dtsi | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
index 1ac74ff586b86..dd60843e022ef 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -5429,9 +5429,6 @@ sdhc_2: mmc@8804000 {
 			bus-width = <4>;
 			dma-coherent;
 
-			/* Forbid SDR104/SDR50 - broken hw! */
-			sdhci-caps-mask = <0x3 0x0>;
-
 			status = "disabled";
 
 			sdhc2_opp_table: opp-table {
-- 
2.53.0



