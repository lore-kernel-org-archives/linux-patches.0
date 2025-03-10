Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0DC822D7A6;
	Mon, 10 Mar 2025 17:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628933; cv=none; b=cYG6BiMzuc8r1R9c/esAQ/pCiaKaL6a1ZxOvxmRHlMurJHMCkN+wF8LbolDVK1D+Y3uDmjCQqxYaZuGSseo0Jzt7lPpbWCRgPttPxeOX3B5Ry38FcqOe1NC9YHcOHiTPzH1E3H42D1WGRBTk1InVuphRj6v7krhlU+xfNFwQ6l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628933; c=relaxed/simple;
	bh=4LV/FX5DmYgDx2ZL9Q2xCnGd2uv+3ozl2czwK8J87Ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a/jDVpe1+D5Aqbr5eX7RvME0S2W2rtOcY6qVBNLiG2qo0sEdqwCXvo2iT3PYZ3L3aLvJ8SrqW1AyABHhXy0HdJ9ESCtk48U97Mmd+Ez2O58JZmIZHFSmtBua3XAwkfm2JWKnDd8XdJJaV/PYweRDhF8gUsPVtRtXgH1NyMTMkTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M98EI5UC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M98EI5UC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 380A6C4CEE5;
	Mon, 10 Mar 2025 17:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628933;
	bh=4LV/FX5DmYgDx2ZL9Q2xCnGd2uv+3ozl2czwK8J87Ns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M98EI5UCCB3w1rPNUtEdO6GegNJPXRjM09G58SWphQXedC+enaEeemqd7tZM9fCA5
	 x9sYbO894iM72Q9hpECN4WWcRVZbCDzPjC9fpTQ74VaT6wFORtBmyBc17q7blF9CJh
	 Pe+Ikjp7O6KVfjPuol6h9FEMS1oO/JdR652TC7FI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 120/620] arm64: dts: qcom: msm8994: correct sleep clock frequency
Date: Mon, 10 Mar 2025 17:59:26 +0100
Message-ID: <20250310170550.339080796@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index fafeb790c5c59..1ae2fbef90582 100644
--- a/arch/arm64/boot/dts/qcom/msm8994.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8994.dtsi
@@ -25,7 +25,7 @@
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



