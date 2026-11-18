Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024508;
	b=e60d8YfwYANJa216qwvreHJeV9QBcVi4DvkBmSkmVaHfHmipZSqzNOfa0DyYWVBOVP+x
	 tKu4ZEbZntoakoa4Hs9fMGfMbfTQlF6pE1B6qESc0esO4d1zEDR3CvCzcnsfgbCDl+EVN
	 Hsab8XUVy+E+p5XYi/LN/xkU/MnpLAKckjgZQ0TmLT0SDhEzYGvAA/GYgEF27ILBq4lPn
	 pcA8kaDmTE4dgdQ53upAoBxJ19Q/GSFe934caGiuYUfDJQ5Pa76axR+7bVlKGwa6t0smp
	 wcta7gFIyOJXoKsaF0POn+5G8qcXeMXHGs1zFlF/aCLt4Rsy2/u/x/+q0/1yGZTfLVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024508;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YGQ2IWkZloGuLx6cL9bBjfzx/KMiySprcVqxkPQbTV0=;
	b=BUOTqEvNTtfFVEeYBI4FpG843VkpMReOOvDltEqfdRkjtYvDlO/XtO0jT6VRFOB9zn3+
	 b1MfHFShFP4JahDhR+TXViziJd9c7py4NIiBTVpwDsCi0iv/GfAAcibzVuflxb4oXPeu6
	 B7QPbmy7wcO3ue6JXOcN96HgNbrVcqy8tV8mxPhrqEkFtQSdqXC4DuzsHCC7vts1gAsnJ
	 Dr5V/0mRIogUwVtxLdhvqCiPKA8y08j/CVqCm/EiRQjUZyJfEdGrTw6G8H0oZMTxvmgxP
	 ywjWe3d5Fi5sP/FIm90OkKg4kpfnPjvayoWZW21t2YLut7vKkm7tH9OdlbOGjoEGWKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FyiLQwAV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D138D606A31C;
	Wed, 18 Nov 2026 17:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FyiLQwAV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF731F000C5;
	Wed, 18 Nov 2026 17:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024508;
	bh=YGQ2IWkZloGuLx6cL9bBjfzx/KMiySprcVqxkPQbTV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FyiLQwAV6M+grxnyHvKwiBlDB+i50OynSIJ4i2Ay7UQ0K5lsS9htzwv42bS4FN+ry
	 b/1PJMAbCuKrfDzuDZQSwtl6e+n7q9jS4cXyRTuSjz2z9UMXvL315WBSH/vuaM/nbJ
	 s6K9dG1HkeUJa4YJCUF60xuUllRHMEoAQXlpLfgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Sajna <sajattack@postmarketos.org>,
	David Heidelberg <david@ixit.cz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0751/2151] arm64: dts: qcom: sdm845-lg: fix sdcard pinctrl nodes
Date: Wed, 18 Nov 2026 15:41:26 +0100
Message-ID: <20261118150149.384688525@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 99dafc6716e76..db05fb2e99cf2 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-lg-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-lg-common.dtsi
@@ -556,33 +556,26 @@ &tlmm {
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



