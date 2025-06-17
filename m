Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A859F2F9489;
	Tue, 17 Jun 2025 16:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178036; cv=none; b=epyKX8tvmikkPT+OrysLNRhHQXzTOKh6CO69QQyjZCz0jiN+CWkbed8w3ThH02ZAySYAS1FnHMgTBcXnl5nlnAYkS2TTB2KtBno5OJRJzygdX9DpInSqk2dR/t9z4ypv0lG0J84cFCPQC8mU6C66hpDgbrcdeGltMNWWfEuD6As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178036; c=relaxed/simple;
	bh=TQc3yZmCxpLFkjkyoOnhyCSpYLL6j+Yh7kEAdA5ByEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SW+fpUArdwlzTo3X5aXDW7naotU2mFHoys6GNDPQmNLm38OMrhRL2bl5vu1pAQMrMCc9M07p2RgXPVlOh/pMH+frV73aD63KUD6qml8up4cYLMTxq1vUe499dROwC1T7mWPAKylnN+fmQW39A4J/XHYdh0PFAJRpx1EyPF/3NxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gZACHnUo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gZACHnUo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17953C4CEE3;
	Tue, 17 Jun 2025 16:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178036;
	bh=TQc3yZmCxpLFkjkyoOnhyCSpYLL6j+Yh7kEAdA5ByEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gZACHnUo3svFIPswLeW7eQGtPajWqS+4NmSWm6C+MFpym4ErlgmG5zC4CYaurnirn
	 PkQsywm8m2e6oEYj5I7YW8HW8HNzJsfd19JoYgU/y5K/XQ/CFkTnUlAuzENRhvtrpJ
	 UppK7zFt1ABgeMqSOqxRxdg/F0LryIrjHTTmLNZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 399/780] ARM: dts: qcom: apq8064: add missing clocks to the timer node
Date: Tue, 17 Jun 2025 17:21:47 +0200
Message-ID: <20250617152507.700968197@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 4b0eb149df58b6750cd8113e5ee5b3ac7cc51743 ]

In order to fix DT schema warning and describe hardware properly, add
missing sleep clock to the timer node.

Fixes: f335b8af4fd5 ("ARM: dts: qcom: Add initial APQ8064 SoC and IFC6410 board device trees")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250318-fix-nexus-4-v2-6-bcedd1406790@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom/qcom-apq8064.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/qcom/qcom-apq8064.dtsi b/arch/arm/boot/dts/qcom/qcom-apq8064.dtsi
index 5f1a6b4b76449..ba99e794dcd22 100644
--- a/arch/arm/boot/dts/qcom/qcom-apq8064.dtsi
+++ b/arch/arm/boot/dts/qcom/qcom-apq8064.dtsi
@@ -326,6 +326,8 @@
 				     <GIC_PPI 3 (GIC_CPU_MASK_SIMPLE(2) | IRQ_TYPE_EDGE_RISING)>;
 			reg = <0x0200a000 0x100>;
 			clock-frequency = <27000000>;
+			clocks = <&sleep_clk>;
+			clock-names = "sleep";
 			cpu-offset = <0x80000>;
 		};
 
-- 
2.39.5



