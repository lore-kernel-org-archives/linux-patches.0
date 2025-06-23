Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D65725392D;
	Mon, 23 Jun 2025 13:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684932; cv=none; b=QvSNL4uAtsHYx9qjZQcjAvacC4RmLHJfHKKl7DUlbGYlbhNsLA/s36eypfl0zJNyaOGq6KcLwi26tIp5o2CFz9BpxE8iuITL9Df+V5bQeJ3+xbrwTSL+kDOPpP0g+QJfUaH3uy6YTVP0OLGjECC8YGga/s/fyboGFC0+icz7h7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684932; c=relaxed/simple;
	bh=5TuYd4uhNbr6DpKoZkMk4ULXsKWnrpYD6wnw91OSLA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JcZMNFYfiol0Vkzf8R/PrANTFRTVnib4PRdg/mi/N19yEy2ROPfWi7Kk70ge07u27q3DCY/mUaVBey45jXm11fWDHfg4ge7f9V6q3zpiqP9m1pvnv8UywUvkodD7Or9xw+a79tLoMz5JRO+OjN+t5jqYrbr1JQ0SgA/mz7lTNEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hEVVcx3Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hEVVcx3Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E299AC4CEEA;
	Mon, 23 Jun 2025 13:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684932;
	bh=5TuYd4uhNbr6DpKoZkMk4ULXsKWnrpYD6wnw91OSLA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hEVVcx3YMUlM9SmYpqCEgh9KzR070zvFHm4Qi/sPt0K5tc+rciR87EeKVLszXbVq0
	 e8Hd8+7cBUJ2hchJt0GcnZJxX755VkoieEivQtbVhqTfgwugh+WXWUTW20uvs4NmRE
	 8fjdRekqkE0fNfS1qIoDqmI+CUYzYbt7ljPKfLrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 048/222] ARM: dts: qcom: apq8064 merge hw splinlock into corresponding syscon device
Date: Mon, 23 Jun 2025 15:06:23 +0200
Message-ID: <20250623130613.426088133@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/boot/dts/qcom-apq8064.dtsi | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-apq8064.dtsi b/arch/arm/boot/dts/qcom-apq8064.dtsi
index cd200910ccdf8..f3131dae731ac 100644
--- a/arch/arm/boot/dts/qcom-apq8064.dtsi
+++ b/arch/arm/boot/dts/qcom-apq8064.dtsi
@@ -211,12 +211,6 @@
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
@@ -359,9 +353,10 @@
 			pinctrl-0 = <&ps_hold>;
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



