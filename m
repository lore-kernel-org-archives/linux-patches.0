Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06236282EE;
	Wed,  5 Feb 2025 14:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765181; cv=none; b=Bk2jDZ2dA4Cg2vh1yqpuqOOoXAmXzXjC9UGqd1p3mVa8mBQPQwhNqUR6K6+fsA/A5td7Qyjip/fXWhCQeRzv//NT3W89Dz6bwoqFppdRGiTM+CfbhgO/CnJ313+RO8hHBjoYO0hDPXC/joCD7YCruWy3p0PDiNRWPCWd4y0fBhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765181; c=relaxed/simple;
	bh=FusrwCuNfhjYnpZ3DqSvTStRdLVoDKWGiV4tTDsrN2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hoq3G456D3EpPwWz8KSoZqR/iwkH6T5q1JWakQMUh8O+/VRUYnRlKR9OV7rk9k8YimmddE0JAYryu65RRT2VOxoUsPXx45XmSTIg/ip0We9eq1z1JNc4LFB6bCIwqGm0GQ3ytb8sILRoUbDgTj6JxbfeJAWR/qA7gIiUHpkcyHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bAtL0Hjv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bAtL0Hjv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64BC9C4CED1;
	Wed,  5 Feb 2025 14:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765180;
	bh=FusrwCuNfhjYnpZ3DqSvTStRdLVoDKWGiV4tTDsrN2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bAtL0HjvklThHULkszOadppCfKAGmdjV7vEh6YSMrAxtB4cqt9JUTfurvEbJ8n5In
	 uHokrxrFTYi1u7gQ7UVBbNR0zIVXvOXBL9DRTPT8UCwI/NjvaeqLZXRwfqEes99d6q
	 qCwi2LTq2zB5sRREHgXxzVsEMFt+ertVBpHJREVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 241/393] arm64: dts: qcom: sc7280: correct sleep clock frequency
Date: Wed,  5 Feb 2025 14:42:40 +0100
Message-ID: <20250205134429.525899457@linuxfoundation.org>
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

[ Upstream commit f6ccdca14eac545320ab03d6ca91ca343e7372e5 ]

The SC7280 platform uses PMK8350 to provide sleep clock. According to the
documentation, that clock has 32.7645 kHz frequency. Correct the sleep
clock definition.

Fixes: 7a1f4e7f740d ("arm64: dts: qcom: sc7280: Add basic dts/dtsi files for sc7280 soc")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-8-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index 149c7962f2cbb..81e95604ef987 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -80,7 +80,7 @@
 
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
-			clock-frequency = <32000>;
+			clock-frequency = <32764>;
 			#clock-cells = <0>;
 		};
 	};
-- 
2.39.5



