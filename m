Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451E121C9EA;
	Fri, 17 Oct 2025 15:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716586; cv=none; b=K7/w3RaSw7LkTP9EDe99yq18ilq3NG9M1ryCqINx4hp4Wny86svlimE6XPKugPxVEzU3wE4ibmlEpv9XZmIxdpBA61bsmZq75sA1jMulNmm9vh38mE6kGTlTo3UhDS271LAT52FaGlqQoVOMEO70TpMCZmCdTnefz2BFraNMwiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716586; c=relaxed/simple;
	bh=QbAwGDAedkg68d5zy06yFYsWongnZkcUfLTYAB2/kZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iGYEGHjcoUWsBLbHIUZ5Yg2EfWMM3IO462RV+bZS1w914NELuGk3OryKwgsk9CyIean/vtyuQOK8XPKJ+OZfGdmH9fWRfHiy2RvbQFuxne9/xE980rDecF2Cw58n5GdNn+rJBH5s3WDJq2IcHs2b8/2w+hcH7Gj7nOrjhgB8o04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WyZzSQhs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WyZzSQhs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7EE3C4CEE7;
	Fri, 17 Oct 2025 15:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716586;
	bh=QbAwGDAedkg68d5zy06yFYsWongnZkcUfLTYAB2/kZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WyZzSQhsRJE+yEJH0t3wZ8hadvK95QaIlvFF7E5dBvaMkonYkmwPQy1289M4r5FcW
	 cW5qr2H/yoEzdPdTz+1A+LI78tKWduVkanVZQsFK/Gz3br2lWe4bDnZKeKj4xZLjaP
	 b+Xiqq9VoZwQvMpipojPCBcblRa9cJBM9ZEtNv3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 241/276] arm64: dts: qcom: sdm845: Fix slimbam num-channels/ees
Date: Fri, 17 Oct 2025 16:55:34 +0200
Message-ID: <20251017145151.270159081@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan.gerhold@linaro.org>

[ Upstream commit 316294bb6695a43a9181973ecd4e6fb3e576a9f7 ]

Reading the hardware registers of the &slimbam on RB3 reveals that the BAM
supports only 23 pipes (channels) and supports 4 EEs instead of 2. This
hasn't caused problems so far since nothing is using the extra channels,
but attempting to use them would lead to crashes.

The bam_dma driver might warn in the future if the num-channels in the DT
are wrong, so correct the properties in the DT to avoid future regressions.

Cc: stable@vger.kernel.org
Fixes: 27ca1de07dc3 ("arm64: dts: qcom: sdm845: add slimbus nodes")
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250821-sdm845-slimbam-channels-v1-1-498f7d46b9ee@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -4839,11 +4839,11 @@
 			compatible = "qcom,bam-v1.7.0";
 			qcom,controlled-remotely;
 			reg = <0 0x17184000 0 0x2a000>;
-			num-channels  = <31>;
+			num-channels = <23>;
 			interrupts = <GIC_SPI 164 IRQ_TYPE_LEVEL_HIGH>;
 			#dma-cells = <1>;
 			qcom,ee = <1>;
-			qcom,num-ees = <2>;
+			qcom,num-ees = <4>;
 			iommus = <&apps_smmu 0x1806 0x0>;
 		};
 


