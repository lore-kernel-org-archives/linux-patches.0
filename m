Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017519;
	b=q7JvSDZ6Qyo/Sa3dKeFWTO4Q+MCD9i9mnmXYKBsW2rWTEWlbjza2Zy1dpgD7Rw0vXCcN
	 WGxShTfIOovYzeEznUiK37dR653tLtI6OtY3k+RuONLC+kmF90rtDzyTdh6QotCs0Z5bE
	 RJV+zsyhsIGxg1ATSFXkTqlUVjw1xH72bCW8IxUSWkdNVp75zK8HC1IbXO/lFMZwZpDEj
	 h0PymZFVGWOU/F1wMFCuYzBCvGYh5T6qO544XYh0d43lKpLAQUFz6/r54/eaOhxMX3Dnf
	 UVc9y8zaPEKYoTeXhWc/Ej1vbgF6yrzwxwzfg87Ub1zk8nc/4Vx9o7LImRLZXlv64lQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017519;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xu//GPKlHj68CeVdiqa9uW75dZjajJZNLRH1CapVohE=;
	b=mcYgTv0+aJ/R5kdN+hZcZRFd/P3P86cFn4SYJWR9cCbZ5ySYWS6clZmGtf/RBfpI3rYB
	 GmGTKuItPpH4IljQ0uWAUaAf1u9WLlXG/r3FhbaUIbx6FOjFzadZBRhpSFFoEEhPUq01m
	 k9NAxygyM4jv+QeVyQ99l7yrF+nHLNQgB6OlqrURxaACLRMjZ5ugI6wOyASuQ4bsR259l
	 Gm4q30JjoQyBbmu0hUlXN4ZEbRb/0bGQRJa5Proz7iois89X0r9I+aI9khA7X0U+CDRDM
	 oT36mNt77VJHKn9xmYLTa1bXCcgPrNyYVr4VpS/cvdZ1kGNFPCG9Bk9v1yWYM0qmQ7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w6MFwRaB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06380606A31C;
	Wed, 18 Nov 2026 15:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w6MFwRaB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57F4C1F000C4;
	Wed, 18 Nov 2026 15:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017518;
	bh=xu//GPKlHj68CeVdiqa9uW75dZjajJZNLRH1CapVohE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w6MFwRaBw3snFWUm7J7y94GnVZBLpGB46UKR1Zc/CZjJRZTmb8SXLXU1Kbo+cbIIH
	 dyn4UPrpZnGyT2vU/tyuvhXp9x4Sx9BHg8zHa2ncdTNDTMdSgVMZ2dVcplEjUUcoWL
	 oMdNV07PUjwUXn7WFqit2SKvtHC5kxFWVQjXkhdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Sajna <sajattack@postmarketos.org>,
	David Heidelberg <david@ixit.cz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0872/2651] arm64: dts: qcom: sdm845-lg: fix sdcard pinctrl nodes
Date: Wed, 18 Nov 2026 15:35:12 +0100
Message-ID: <20261118150319.249395145@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Sajna <sajattack@postmarketos.org>

[ Upstream commit e57d572ed779eb53e7eb5b8f9546731eff21bc93 ]

sdcard was previously rather unreliable during boot on sdm845-lg-judyln

Identified and applied correct settings from downstream lineageos kernel.

Verified card was properly detected over 5 reboots with rootfs on sdcard.

Refer to downstream: https://github.com/LineageOS/android_kernel_lge_sdm845/blob/efa8458f79dffeb380d43b38b9403407f87d9f05/arch/arm64/boot/dts/qcom/sdm845-pinctrl.dtsi#L148-L303

Fixes: 28ae8aa3923c ("arm64: dts: qcom: add device tree for LG G7 and LG V35")
Signed-off-by: Paul Sajna <sajattack@postmarketos.org>
Reviewed-by: David Heidelberg <david@ixit.cz>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260802-judyln-sdcard-fix-v1-1-b3477cfc42cc@postmarketos.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-lg-common.dtsi | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-lg-common.dtsi b/arch/arm64/boot/dts/qcom/sdm845-lg-common.dtsi
index b030a10009c58..84f0e1f0bcd32 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-lg-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-lg-common.dtsi
@@ -581,33 +581,26 @@ &tlmm {
 	sdc2_clk: sdc2-clk-state {
 		pins = "sdc2_clk";
 		bias-disable;
-
-		/*
-		 * It seems that mmc_test reports errors if drive
-		 * strength is not 16 on clk, cmd, and data pins.
-		 *
-		 * TODO: copy-pasted from mtp, try other values
-		 * on these devices.
-		 */
 		drive-strength = <16>;
 	};
 
 	sdc2_cmd: sdc2-cmd-state {
 		pins = "sdc2_cmd";
 		bias-pull-up;
-		drive-strength = <16>;
+		drive-strength = <10>;
 	};
 
 	sdc2_data: sdc2-data-state {
 		pins = "sdc2_data";
 		bias-pull-up;
-		drive-strength = <16>;
+		drive-strength = <10>;
 	};
 
 	sd_card_det_n: sd-card-det-n-state {
 		pins = "gpio126";
 		function = "gpio";
 		bias-pull-up;
+		drive-strength = <2>;
 	};
 };
 
-- 
2.53.0



