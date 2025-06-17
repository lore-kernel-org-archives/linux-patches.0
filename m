Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6A42FA632;
	Tue, 17 Jun 2025 16:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178043; cv=none; b=lBBJPTg6fS2hEmIma9JV84Pw5MsRz3k08mFCE6S6tFvnNGL4YPfZJSXFVNm4qpL1TBufDVQKJpa5wMN7recMmG8Zjgmgwpftfx0LgY+wQqoES1Zj2xNWnG5YCCRcUmPFL++HrK6kK6KLHwlP/PmkWK37DUGr4n2PvyE62yPfqdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178043; c=relaxed/simple;
	bh=zREpKdp5fixnbKBpftb8kaukh9ZxjnsZQrsIqbsWiE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NxReBjw9v3cXJ5Q5Q5kD0pQA2jJTHJ1a0ebBalRTj37DlRTzk8+OewTJ+GPZQ9qsrJtVpaC96pmi3c+aoZyV9VJEngPby9yAhpmpu7GVtbaoEQxuM42ID0UmXnBaXOnMJ4aCt4+/PWTiKR1kIUfNdToFKFE/tIfavofnt3gf/MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CyMfr/1x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CyMfr/1x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D062FC4CEE7;
	Tue, 17 Jun 2025 16:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178043;
	bh=zREpKdp5fixnbKBpftb8kaukh9ZxjnsZQrsIqbsWiE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CyMfr/1xLIpWOU69wDWqlLGpHxjBMaazUO5Mt5LLUuobA8VUoHhwd1UfmWYV/KLQI
	 NDGpjLMGyanuh3vJTgayg276zwAvxTqxP5/k3SCfFVWfA2dVph3YRhRl7AvHU44CUy
	 woK2hWs1zRI9UsWcxJn9K19mTfPYnEscNkQCU17o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 400/780] ARM: dts: qcom: apq8064 merge hw splinlock into corresponding syscon device
Date: Tue, 17 Jun 2025 17:21:48 +0200
Message-ID: <20250617152507.742509595@linuxfoundation.org>
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

[ Upstream commit 325c6a441ae1f8fcb1db9bb945b8bdbd3142141e ]

Follow up the expected way of describing the SFPB hwspinlock and merge
hwspinlock node into corresponding syscon node, fixing several dt-schema
warnings.

Fixes: 24a9baf933dc ("ARM: dts: qcom: apq8064: Add hwmutex and SMEM nodes")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250318-fix-nexus-4-v2-7-bcedd1406790@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom/qcom-apq8064.dtsi | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/arm/boot/dts/qcom/qcom-apq8064.dtsi b/arch/arm/boot/dts/qcom/qcom-apq8064.dtsi
index ba99e794dcd22..41f8dcde20819 100644
--- a/arch/arm/boot/dts/qcom/qcom-apq8064.dtsi
+++ b/arch/arm/boot/dts/qcom/qcom-apq8064.dtsi
@@ -213,12 +213,6 @@
 		};
 	};
 
-	sfpb_mutex: hwmutex {
-		compatible = "qcom,sfpb-mutex";
-		syscon = <&sfpb_wrapper_mutex 0x604 0x4>;
-		#hwlock-cells = <1>;
-	};
-
 	smem {
 		compatible = "qcom,smem";
 		memory-region = <&smem_region>;
@@ -305,9 +299,10 @@
 			pinctrl-0 = <&ps_hold_default_state>;
 		};
 
-		sfpb_wrapper_mutex: syscon@1200000 {
-			compatible = "syscon";
-			reg = <0x01200000 0x8000>;
+		sfpb_mutex: hwmutex@1200600 {
+			compatible = "qcom,sfpb-mutex";
+			reg = <0x01200600 0x100>;
+			#hwlock-cells = <1>;
 		};
 
 		intc: interrupt-controller@2000000 {
-- 
2.39.5



