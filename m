Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E871519BE;
	Wed,  5 Feb 2025 14:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765228; cv=none; b=oPJD2WDQ7Qbbz25pL592fGgAtUYlwCWuF4QhOAksMjjdJr0uNlaxGiMLkVWBG4PPcdm8kRvFdIbF57YKYMRxXeDjETSM9OmbDs6KMCHX5pmAUMeArn8KtXZQeK+uqqn82j4weDakv9iAOfYhhghNSgdBU5/+SDUpmQvV31H2vFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765228; c=relaxed/simple;
	bh=SvHFcQGMP9effPxut+NnCgetKmMDpxgdVsqa7bXrXac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VBllrSprsvpZ03X4mhN3pDm9bhNbzOGApI9wwd7HoOsGCZT60ZbqYOf5zwJEP+YRnhFG7nH7v+zeF4CRx9L6n5GV9TPLlFO5wh0mo4s957GDxq10VXzG/8midbO878RGMXhBJJf7RzyPakNXYNp3Ev0JpDOp8Co9IxT6dOzBWU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U4fU+2Ps; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U4fU+2Ps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2FF4C4CED1;
	Wed,  5 Feb 2025 14:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765228;
	bh=SvHFcQGMP9effPxut+NnCgetKmMDpxgdVsqa7bXrXac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U4fU+2Pss9oeb9rJleQntwEBAnPYeONhIQItOfMuyeym52Aq1AzUiTRXDizm9Wy/n
	 XoSBvH3PcLCpwnytQPwWT0fg/myuAphWEal7Svh/TSASGjMCSvvCCqQLUYTshRxvce
	 J8XcmrOvt0iJJ2FLsVh9QugnkjK6mxVMQ6kxzNiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 245/393] arm64: dts: qcom: sm6375: correct sleep clock frequency
Date: Wed,  5 Feb 2025 14:42:44 +0100
Message-ID: <20250205134429.680790635@linuxfoundation.org>
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

[ Upstream commit 223382c94f1f07c475d39713e4c058401480b441 ]

The SM6375 platform uses PM6125 to provide sleep clock. According to the
documentation, that clock has 32.7645 kHz frequency. Correct the sleep
clock definition.

Fixes: 59d34ca97f91 ("arm64: dts: qcom: Add initial device tree for SM6375")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-12-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6375.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm6375.dtsi b/arch/arm64/boot/dts/qcom/sm6375.dtsi
index e56f7ea4ebc6a..c5f7715626a09 100644
--- a/arch/arm64/boot/dts/qcom/sm6375.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6375.dtsi
@@ -29,7 +29,7 @@
 
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
-			clock-frequency = <32000>;
+			clock-frequency = <32764>;
 			#clock-cells = <0>;
 		};
 	};
-- 
2.39.5



