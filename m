Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040208;
	b=lw4Mv1HKR5n+h2AHVTYFDeVMixlnuTfuPh+bj7arrhftjon5upZGZWejiBwYKjTErulM
	 d8pSpNC4Pk6kjIO1pclyPzjjjBaMyMqnn5VIvrya/E1d2WkKc8oBNac+3O3TEjm0TQs0e
	 uKmTDMC/fcijnaDPLzQjD0hwsoiqXq5Q/wNz0SusjTmQj7zhlFAD6si64Nqs806JcdjEP
	 l6ZaxnENUJ7YZZw63rhJyPCNo7kqo1yQRs26KpIy11viKAho08ZUxqBFx1cncTpD/fFeR
	 i+YQwoxH0mChEwxCEujstI9YB8Et3hHDKxukTvpAGU5vzbyDScLrIarbYVayW461qLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040208;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i7jetyMV9I6hXaZieScxefkvPUzdbw26jwTfIgfd5Hg=;
	b=XOFTMOkHIxluNa7TVYMHW+1HM+jVtTmo65K5Mn5o7pDPlTHnlp3bP4LYZn0Q4rX5rcJP
	 qTALYSziHVS6aKPJOuNZnqMTJhk3l2+zZCHxkmisqShCUlZZF7boFIoQH6GJNxt+AnNgp
	 8fcvlZ6mA485VAN7+r98Tu0HTNV1Qis3VAY7hmPTG5IpphxLd9vw6fDtPGdZ6V+qNl2NT
	 dpIdfs/anBMRMEj9gbDJFtpdTiWUhs0wZJI1TmnT45gCuc+NSvOuUIoEBrGrGGUmREIoc
	 dYXLPAp9mKO2mUC6gWdrQ5onQMjawObR6KEyALqz+3gLBolrpVxwAB70DQ+IWgGDbzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wzo1MCVj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0313E606A320;
	Wed, 18 Nov 2026 22:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wzo1MCVj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A0531F000C4;
	Wed, 18 Nov 2026 22:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040207;
	bh=i7jetyMV9I6hXaZieScxefkvPUzdbw26jwTfIgfd5Hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wzo1MCVjDEkmZrBKaJhQ6RkN+y3Vwu6ohZVE7yQFY4M5Zx0RBsbV1RKUl9dEIlshL
	 ubmNuBFY3fS7GE4ThjVD7368FoExBsuFSGQbtUuKiZaRKvPcXBn/5wA6M0X2i+Wc6P
	 296E/MBbdYjhsDAqwEy1iyrfk+k+IhkfIlH4jyrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Sajna <sajattack@postmarketos.org>,
	David Heidelberg <david@ixit.cz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2376/3318] arm64: dts: qcom: sdm845-lg: fix sdcard pinctrl nodes
Date: Wed, 18 Nov 2026 15:49:58 +0100
Message-ID: <20261118150432.828548829@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f942c5afea9b5..8737f461fb1dd 100644
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



