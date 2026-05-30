Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C93239B4A6;
	Sat, 30 May 2026 17:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161294; cv=none; b=rA/BKW05ACyNPA58Cp4FkIhOsZvdifxAWRzl1Idpq5F+v7fXPMYsL9U2xD5P6pGClEzPh5M1vepq6Y3dV/RcjjdfW097dGQ80S5b/EoJA0q2P1bYl7GOpE93M/fszkcD99CSppWSoyK5yoPr5vDK4W8xBhYAjJK6v4MYY7wjZuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161294; c=relaxed/simple;
	bh=hSQ3aMpMpntLpPUdw2PJq4LwNV1fOq7iSbu5s0yS3Ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C4I/SaI0qip4RDLk2ctfM7ackgPQOF3222QkA+BwQtMlZGhYoW09zCoR9Z5Pn4hcbY+rJfuPNC2nneRdoxwHgR+O2F33f5t7xqnOBvM+vX0ov5lPxRHFjFBaxU2v7zcBVNG+pTA4Q3WIvXxJtllPyRRiFI1UnyUn/oJI31KDchs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hqCfxKAI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hqCfxKAI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478741F00893;
	Sat, 30 May 2026 17:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161292;
	bh=C8CdbX9snlmc/P08V0AfSzszRR/H5lHkoUV0Ophzeuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hqCfxKAIqGhIC6uZcCUU3dPH6llWbk7n9/gqGmZOlJfMVzf+EHZ74Kdh+YPEkCZxF
	 5cb7ooUAPf2a+4Hx1SfnJ4B1+V53I3h/BJt3+0xDdWAp85g4NnSwI1oRnDPyBhQP6l
	 1s4rS22SFy4zgcCijBr55GmlgIr7okf/+UHiyHVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 582/969] arm64: dts: qcom: sm8450: Enable UHS-I SDR50 and SDR104 SD card modes
Date: Sat, 30 May 2026 18:01:46 +0200
Message-ID: <20260530160316.481046156@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 49502cdd1d4e0..c9ca7bd886397 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -3191,9 +3191,6 @@ sdhc_2: sdhci@8804000 {
 			bus-width = <4>;
 			dma-coherent;
 
-			/* Forbid SDR104/SDR50 - broken hw! */
-			sdhci-caps-mask = <0x3 0x0>;
-
 			status = "disabled";
 
 			sdhc2_opp_table: opp-table {
-- 
2.53.0



