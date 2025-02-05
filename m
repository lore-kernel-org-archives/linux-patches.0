Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433811DDA14;
	Wed,  5 Feb 2025 14:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767319; cv=none; b=L1GOSjttZAjUJgQHibzEpfMv8Lb2YwMqbub5He87x2FPrYw4IYpbee5qlUAu8JoOONLt53q9z8Mh8ND7KvunbQ15SUjBJo2Hvc/8ndbnFf+t8AaXjQgO1keOhE0lYE6SEOtUExWTTEYfNnckt7rm8bpEgMgCmqUez0s+MDCbImg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767319; c=relaxed/simple;
	bh=kAwxZZemDLioWFfL9dbnq6cI1wPKisX/vAVfr6X33Sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KjM0YaArFU3OHOc+sdtbyxHis8I4AjRFc5AvZIyYUaVVZ4g7TUbVgJO8cFFLjCmLJvihrWk9hZU44W3Oqr7GJVshXLjFhhEUpliVvKT+ogGQdKdkzcRvQWoO126w9X3GI1eugSu9+9li92lz9DSRD3Br9jVMZ1SICgSlm0uIKEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2lnLh6d9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2lnLh6d9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD528C4CED1;
	Wed,  5 Feb 2025 14:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767319;
	bh=kAwxZZemDLioWFfL9dbnq6cI1wPKisX/vAVfr6X33Sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2lnLh6d9hPsCLmoIOPhUhrjbH9GXKYFvDKlaTCD/RQqbZ6rOY2YaTz/fJGFE9h25z
	 EII6c0GjFNEcJbUJ/MweG9cPH1eZpqi7ygEMfaweS7SE0S44vFAPzs1Xb6ap3lpdUo
	 5nYtLZnt2tRLKho8AeoQ9vpMeQNdKzsabQ/2NbMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 387/623] arm64: dts: qcom: sm8250: correct sleep clock frequency
Date: Wed,  5 Feb 2025 14:42:09 +0100
Message-ID: <20250205134511.027510034@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 75420e437eed69fa95d1d7c339dad86dea35319a ]

The SM8250 platform uses PM8150 to provide sleep clock. According to the
documentation, that clock has 32.7645 kHz frequency. Correct the sleep
clock definition.

Fixes: 9ff8b0591fcf ("arm64: dts: qcom: sm8250: use the right clock-freqency for sleep-clk")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-13-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index 48318ed1ce98a..f39318304da8d 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -84,7 +84,7 @@
 
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
-			clock-frequency = <32768>;
+			clock-frequency = <32764>;
 			#clock-cells = <0>;
 		};
 	};
-- 
2.39.5



