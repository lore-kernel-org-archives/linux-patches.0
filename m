Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254AE14B959;
	Wed,  5 Feb 2025 14:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765353; cv=none; b=IhJKnLbADZFVZNobSzfDobBdzZJEUIk+6UUC5TxzrQwrQ2LUXP40Belxq+yKbnhPzGURfmhjRWgaDDlRU8hxkiHXtPA5zAvmEFHlBaMWkV+/I3OZrHIXnqyAgESKVQhorRU3guEGmzzrpM+shrAH9un4whk5Xh9e+BNNdnQZ9IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765353; c=relaxed/simple;
	bh=sDGxqtBTCj60WyZDy+ABk3ft0mOdvnkdSVCbsUC1b/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i5D3JmhPj0/eWxWeGX+lU8jJhjgVZYKgmA0EEtuUsXsmUIDqlPs0Z0OWqWt+tyRgbZEIgdkwTdoczP3vkVBenHaPBFCStgoTn1ZTAKgVkXq2G67KQ6XjUZyXCCvLSn3bTtksikncPBaMIJ1NyoN69uVOzeHhYzjK6QgGPGmb3EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vBVwZtN3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vBVwZtN3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89ECCC4CED1;
	Wed,  5 Feb 2025 14:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765353;
	bh=sDGxqtBTCj60WyZDy+ABk3ft0mOdvnkdSVCbsUC1b/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vBVwZtN3nLbzJrXJR8ioNT/RadJIs/18yQHJHXO7N+PX2VWYflPr+4xlYrsXCEOqK
	 1/Ux4JjcZAEltp7NNuryKhI5iQYJOB0uGs9j2RFqpMX1kR4wr2mICtCaFZZTCjmgjR
	 RB1+c7d3UmpWN+DSDqFSYm9PjSudO4e1mpZW2ta4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 237/393] arm64: dts: qcom: msm8994: correct sleep clock frequency
Date: Wed,  5 Feb 2025 14:42:36 +0100
Message-ID: <20250205134429.374805515@linuxfoundation.org>
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

[ Upstream commit a4148d869d47d8c86da0291dd95d411a5ebe90c8 ]

The MSM8994 platform uses PM8994/6 to provide sleep clock. According to the
documentation, that clock has 32.7645 kHz frequency. Correct the sleep
clock definition.

Fixes: feeaf56ac78d ("arm64: dts: msm8994 SoC and Huawei Angler (Nexus 6P) support")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-3-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8994.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8994.dtsi b/arch/arm64/boot/dts/qcom/msm8994.dtsi
index 875d50c574e95..a7f9259dda6de 100644
--- a/arch/arm64/boot/dts/qcom/msm8994.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8994.dtsi
@@ -34,7 +34,7 @@
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
 			#clock-cells = <0>;
-			clock-frequency = <32768>;
+			clock-frequency = <32764>;
 			clock-output-names = "sleep_clk";
 		};
 	};
-- 
2.39.5



