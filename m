Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6310B313E17;
	Mon, 27 Oct 2025 18:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591374; cv=none; b=fJsMWjuISTolDu3mzcVDQyhzaNu9EMGqKWVF9Ow3Zl4R6helel+bGxD/rYCYj/VQn48SPeEthsfFUmTmVhx4ACFQcnsDkSEE2rN2ImjFk7qnY1ax7LkESiUKQ8Glx8XImZrl/4T+ZkuRV5R0MjIdYgWcEVqbU14Q/XvXELd4UXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591374; c=relaxed/simple;
	bh=6Y9DdmTCvLeqLwV29EMm/4fWhVvVJ5wVjcj4yW76RpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WJHVf/lhlojOA9vzdSQrDrYnaNE50jdxHlWwdiM133y4iZXpaQpRGmH2x6PUEycSnkNdsDxUP6G0WBAMnh9rTZNulFzfPexB0Dqbx2MMod39q6Y4F2le4FNv5hROOJNI2jJeLGJGnvWF1XMjxQ+tDGlbng99J36SQPElfqoi+bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KmFftZIL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KmFftZIL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAA84C4CEF1;
	Mon, 27 Oct 2025 18:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591374;
	bh=6Y9DdmTCvLeqLwV29EMm/4fWhVvVJ5wVjcj4yW76RpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KmFftZILckMHKuPR4FqNOpVenp2txStB3eN4Gd1iMT7j+2xZgLZlFxLPUUQykJ2u5
	 hCRcxE02rBK8WyNOlxqg4Os323QzQ7O4gT/HuctNhXfI2HRSLxrHaCyWF1HhAezkq6
	 vnAfDSUV+7Uw3zq5Tp9oYhfzYzY+3P6cx8QaMLw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 172/332] arm64: dts: qcom: sdm845: Fix slimbam num-channels/ees
Date: Mon, 27 Oct 2025 19:33:45 +0100
Message-ID: <20251027183529.170616018@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4492,11 +4492,11 @@
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
 


