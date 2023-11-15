Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6303A8CC
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QSfqRc7j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1152C433C7;
	Wed, 15 Nov 2023 19:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077407;
	bh=kD7Mw32m0avOajGKDvELbgYH1oNYRdPN4Y0jBC0VsI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QSfqRc7jWyo//fbMpjqUcTXtqEPY9THrE7MMI/zn9x9AiXnb9Xbx8FadQEgYBt5cu
	 1rHl53rVwsxZ0W2u+FxZAQ9e9AX1FKLDgRaoXunXo05dX/VW+FhzuMp3MiJgPybkSb
	 UsZexdz5bW/RqJwj6/4ZfpwhAsz1Jzq/gicGo0/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 283/603] arm64: dts: qcom: qrb2210-rb1: Swap UART index
Date: Wed, 15 Nov 2023 14:13:48 -0500
Message-ID: <20231115191632.964784168@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 973c015facabcbd320063648010942c51992c1a1 ]

Newer RB1 board revisions have a debug UART on QUP0. Sadly, it looks
like even when ordering one in retail, customers receive prototype
boards with "Enginering Sample" written on them.

Use QUP4 for UART to make all known RB1 boards boot.

Fixes: e18771961336 ("arm64: dts: qcom: Add initial QTI RB1 device tree")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reported-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20230906-topic-rb1_features_sans_icc-v1-1-e92ce6fbde16@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qrb2210-rb1.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/qrb2210-rb1.dts b/arch/arm64/boot/dts/qcom/qrb2210-rb1.dts
index eadba066972e8..5cda5b761455b 100644
--- a/arch/arm64/boot/dts/qcom/qrb2210-rb1.dts
+++ b/arch/arm64/boot/dts/qcom/qrb2210-rb1.dts
@@ -13,7 +13,7 @@ / {
 	compatible = "qcom,qrb2210-rb1", "qcom,qrb2210", "qcom,qcm2290";
 
 	aliases {
-		serial0 = &uart0;
+		serial0 = &uart4;
 		sdhc1 = &sdhc_1;
 		sdhc2 = &sdhc_2;
 	};
@@ -357,7 +357,7 @@ key_volp_n: key-volp-n-state {
 };
 
 /* UART connected to the Micro-USB port via a FTDI chip */
-&uart0 {
+&uart4 {
 	compatible = "qcom,geni-debug-uart";
 	status = "okay";
 };
-- 
2.42.0



