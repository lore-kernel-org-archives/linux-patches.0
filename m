Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497D61519BE;
	Wed,  5 Feb 2025 14:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765184; cv=none; b=YkRUFuxQThNMf8/TgSeStDvKghGzbHyQdQLK2jkBtY2oQjIGWcBS1q7h3UqWu313v6FB5QQpcQbaCyJ6HsO07wtgu+MBCyVfueOKmvQwrjrCCT4dJ2PGHEF9botp0CZ1chtZphRLedQ1sIxqWWVhildvn6B6iI4Ip3/HxjD1p70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765184; c=relaxed/simple;
	bh=T0jKdShjcIyFVXozVca0bcm6da1lxTZQmAIjwu+21F8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uV1WH//ICkcuFUcfg519H0taQmzJnd6DWTNbQo8Vi8jBjvz5bhKxnnU1or5f5TSI5AkCqdbPwiigwWPTaN/SglHXYnxOza4ZrdUrI0+6h4qhjKZQyP+eVeOU1pZP1JxtqKgO5UT4xIRJmKf/ZqEXYeVg6og/6iaRUwjxrXMI7Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c1/0TiCX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c1/0TiCX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A86CEC4CED1;
	Wed,  5 Feb 2025 14:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765184;
	bh=T0jKdShjcIyFVXozVca0bcm6da1lxTZQmAIjwu+21F8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c1/0TiCXTZKiokp1ajOBbeje5xUA5Rib2ckk2vs2IYS5Ewxzv04OsghLIrCx3S2MB
	 GThoh0V4wSDi9eA2CB36LsyxSqr5KtBj2raknfGYREAwQJF6m/8CWWk8VuJt6OrROM
	 01h3b8wSmbviofgUIXmQ6F6OzRnUDjWIH13ZwIx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 235/393] arm64: dts: qcom: msm8916: correct sleep clock frequency
Date: Wed,  5 Feb 2025 14:42:34 +0100
Message-ID: <20250205134429.298543648@linuxfoundation.org>
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

[ Upstream commit f088b921890cef28862913e5627bb2e2b5f82125 ]

The MSM8916 platform uses PM8916 to provide sleep clock. According to the
documentation, that clock has 32.7645 kHz frequency. Correct the sleep
clock definition.

Fixes: f4fb6aeafaaa ("arm64: dts: qcom: msm8916: Add fixed rate on-board oscillators")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-1-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8916.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8916.dtsi b/arch/arm64/boot/dts/qcom/msm8916.dtsi
index 961ceb83a91fa..6f5f96853ba1c 100644
--- a/arch/arm64/boot/dts/qcom/msm8916.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8916.dtsi
@@ -104,7 +104,7 @@
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
 			#clock-cells = <0>;
-			clock-frequency = <32768>;
+			clock-frequency = <32764>;
 		};
 	};
 
-- 
2.39.5



