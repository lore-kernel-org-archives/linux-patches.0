Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884011DE4EF;
	Wed, 19 Feb 2025 09:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956400; cv=none; b=URhEILwDraAX6415RwThwekpNL/3R9AqK5gNQOYIyoXeDPfrINTgLAvgmOlD4gx2EaxUKv0UGY4AIcovs8KF1n90SNmeczfyLFccYAUMryr7L7bljK3SjU74wbDv652qQqEeXDl5BnLUlC8Txc4Di22J2dgsREaoiy0Y0xFPo9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956400; c=relaxed/simple;
	bh=TXfpSK8dVN0GV0iD8Wjh+EMu8rfQYUl/nnDZaJkMhnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ClzcAgUB59/K1gZCHm35ISi+HA1jaI6aV4Tb40aWCeotI3zf7MxftuVx8vL6n2dRCrkm4PnYQKQ3oJZl7bI9dUTHiwZ6iQy9c0yIyFHGXCEEYKEZtXzkzQPoFuK7IHoKmkYurjKYzkLSdFFi0SfAMmn7p4NVAwamw4N5kHKX9dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f+Qhg5zE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f+Qhg5zE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08373C4CED1;
	Wed, 19 Feb 2025 09:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956400;
	bh=TXfpSK8dVN0GV0iD8Wjh+EMu8rfQYUl/nnDZaJkMhnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f+Qhg5zElVDRWOuj1XuFO34b0jKhd5aE66AEQ/xYFJgYdsfec8RsnQtd3Qx2AJzyF
	 ynTWMzqEG9So9Pteb3q95AhFR3OY99qtxWekBigoOZ3Olx2Qy5SUJKf9BjRS9LouCK
	 LFkO8FciLEMNKE2K+1lg97aDq9b7a3Zy8bfex7w8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 166/578] arm64: dts: qcom: sc7180: Add compat qcom,sc7180-dsi-ctrl
Date: Wed, 19 Feb 2025 09:22:50 +0100
Message-ID: <20250219082659.496153554@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

[ Upstream commit a45d0641d110e81826710aa92711e1c2eedecb43 ]

Add silicon specific compatible qcom,sc7180-dsi-ctrl to the
mdss-dsi-ctrl block. This allows us to differentiate the specific bindings
for sc7180 against the yaml documentation.

Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221223021025.1646636-14-bryan.odonoghue@linaro.org
Stable-dep-of: aa09de104d42 ("arm64: dts: qcom: sc7180-trogdor-quackingstick: add missing avee-supply")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7180.dtsi | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
index 13fe1c92bf351..b4775159dde0b 100644
--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -2985,7 +2985,8 @@
 			};
 
 			dsi0: dsi@ae94000 {
-				compatible = "qcom,mdss-dsi-ctrl";
+				compatible = "qcom,sc7180-dsi-ctrl",
+					     "qcom,mdss-dsi-ctrl";
 				reg = <0 0x0ae94000 0 0x400>;
 				reg-names = "dsi_ctrl";
 
-- 
2.39.5



