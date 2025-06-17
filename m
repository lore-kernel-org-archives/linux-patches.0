Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694922DFF13;
	Tue, 17 Jun 2025 16:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176895; cv=none; b=ccn81w3PchVWnZ8wJh1gCMZvzbPrZwA7akZEk83JsFJr+4JHE8Sm/wn6qo4zJJe0MkCQMKL++2PZ8diMzU7dRn/26TS+DFFrDFEEAGIOffnui+/7rzqia5/FHM6IvjXo+JaxZlxCl5Aueecarxs4CibLwSe8FcfqGnnowS+xMLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176895; c=relaxed/simple;
	bh=yTQMG3mAJSn382L0S/fs4wiAUVraoEaLua2qdaFG7UY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WxoIOmu3EXjGb8rcReIb8aPIEL+jlBUSN+MriikHAGx9QaLbwdviMEEYpW1sdrZro1W6n6aT0JowhbnJ0IhsGfcDe1H9B0kHMdiQclaCkrorEr9m7e/sM5hP9LDkVhadqYhwJRNJjNV70et4qQOn30ojkWDpdv/WKi1iYDRiq44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SziTHUr0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SziTHUr0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB251C4CEF0;
	Tue, 17 Jun 2025 16:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176895;
	bh=yTQMG3mAJSn382L0S/fs4wiAUVraoEaLua2qdaFG7UY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SziTHUr0i9jyz0/ribCrdmMFmJZEfAUWhY1HQkeVz8ICFm7rN7ASsVw7oY8w8XU4o
	 MJgcaNiiIsmqz2awUZtcFlsyEc6BZJY98roCL2m/dSzjlvn1mqqm0qRzY+sl+2mDsx
	 pqTROJe/ob7QzWwE+1alG5hgRNh9IMVVVAgyduZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 258/512] ARM: dts: qcom: apq8064 merge hw splinlock into corresponding syscon device
Date: Tue, 17 Jun 2025 17:23:44 +0200
Message-ID: <20250617152430.046196249@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1d802d931028d..38ce6f5fe6b48 100644
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



