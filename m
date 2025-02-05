Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B8C1519BE;
	Wed,  5 Feb 2025 14:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765262; cv=none; b=UhMMCerXXfM5I1u94AeU8a0X3ZnVpSjrOv+XVk0cELH8vlbvq7xCmqh0WyirPosskRxs6b3cWEfQOwZ3Enuo5vTP7eKUFpwRcVm5wlTy3UQSbhSJ86w1De3s/RD4eKsn0AVDXeXmC2FOqbaFRqAgfEXrCil2OoIJaa3tKziNNLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765262; c=relaxed/simple;
	bh=iH/yw/0gY9Vj1DERraTNe+koU/98rl5exS+Uk8SQtNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M75LHkk7AY3mPdiJeV+LCtMvi0Y1szNRPiSN98ZOziNtrBpGjm5r7LPDpUS6wQ5abYKvCRJzLEYLn4J3TgCk3FNrcqg8mlVlSvOG5rdt61GUuAd3vikoiB6jl1ALxZwyegiWdxifS1NQFMctNZkcBav3Vp1jdEH5ZBLtahW4hgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dBNprbKW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dBNprbKW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D943C4CED1;
	Wed,  5 Feb 2025 14:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765262;
	bh=iH/yw/0gY9Vj1DERraTNe+koU/98rl5exS+Uk8SQtNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dBNprbKWH8mC2Fa0Xc8EQtjRt1BJ+A5mQxZlQKI7Xag+PeDZndWTB6U+9G8r7w/Ke
	 z/Mb/IpXiy62yuktcu474vFn9k8Up7z5DLRvPSAetKda5v93gZXj3E2Z/zzcOw7GUl
	 rwmbwDgDmJCqFrY6QvhcBY3aqYvFVamRfotXNJTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 236/393] arm64: dts: qcom: msm8939: correct sleep clock frequency
Date: Wed,  5 Feb 2025 14:42:35 +0100
Message-ID: <20250205134429.336984689@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 5c775f586cde4fca3c5591c43b6dc8b243bc304c ]

The MSM8939 platform uses PM8916 to provide sleep clock. According to the
documentation, that clock has 32.7645 kHz frequency. Correct the sleep
clock definition.

Fixes: 61550c6c156c ("arm64: dts: qcom: Add msm8939 SoC")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-2-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8939.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8939.dtsi b/arch/arm64/boot/dts/qcom/msm8939.dtsi
index 3fd64cafe99c5..c844e01f9aa15 100644
--- a/arch/arm64/boot/dts/qcom/msm8939.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8939.dtsi
@@ -33,7 +33,7 @@
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
 			#clock-cells = <0>;
-			clock-frequency = <32768>;
+			clock-frequency = <32764>;
 		};
 	};
 
-- 
2.39.5



