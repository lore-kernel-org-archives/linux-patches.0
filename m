Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D7B1FBEA8;
	Tue, 17 Jun 2025 16:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177718; cv=none; b=QPYHJV++hWBBEbtiNpm/NuFLZD/BQZT88jbpXPgvWFm/QuMBXcwAjXkDzrCeWH3+d5qKQhERtHjVHJ7F7uD7Gf5DCNm874YsEbFLr4ueHxbd/LoFYb0vKkZ6V+94ZZWYUFWlAOEl+12MJ6wki+wjxfZ8OX2SXxAbBeAwrgXq754=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177718; c=relaxed/simple;
	bh=pZ41FbTikQJ76kJwHgabu/aa4FOZwBqOHabK+4pEfUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qt2ORNGSiF05aImugsntdYMyCUdJnQi0RIxA4bCRjP1d53X3hRuZpENBMg9FQ/lPaLhkn8RnAigPLBWyZdtxvzy9NMRxiF0Fl1Opb6e5VdcFQ1l+GminevW40N4mTpRMv+NItMyoHY+y73E1EQZ5xWzs2ZB5RuugTt7K7PlMETQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qYXwM0mw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qYXwM0mw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC4DC4CEE3;
	Tue, 17 Jun 2025 16:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177717;
	bh=pZ41FbTikQJ76kJwHgabu/aa4FOZwBqOHabK+4pEfUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qYXwM0mwGdngIzZWjoIwQFluD9XkdYZe5RBYr+RP9dd2/3ZkElxC2xb7KEKYOe84c
	 xkVn0hxx6NCe6xzjw7xd4V39TwI5fb/89uex1sBU1l6dlhSVkTAR4k2mW9Zhr0Dc7h
	 a5rY4b2rlZ/r+vcLSsRA7nauTDNKKWQA+3rXFs/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dzmitry Sankouski <dsankouski@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 350/780] arm64: dts: qcom: sdm845-starqltechn: fix usb regulator mistake
Date: Tue, 17 Jun 2025 17:20:58 +0200
Message-ID: <20250617152505.708580841@linuxfoundation.org>
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

From: Dzmitry Sankouski <dsankouski@gmail.com>

[ Upstream commit 242e4126ee007b95765c21a9d74651fdcf221f2b ]

Usb regulator was wrongly pointed to vreg_l1a_0p875.
However, on starqltechn it's powered from vreg_l5a_0p8.

Fixes: d711b22eee55 ("arm64: dts: qcom: starqltechn: add initial device tree for starqltechn")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Dzmitry Sankouski <dsankouski@gmail.com>
Link: https://lore.kernel.org/r/20250225-starqltechn_integration_upstream-v9-3-a5d80375cb66@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts b/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts
index 6fc30fd1262b8..f3f2b25883d81 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts
@@ -135,8 +135,6 @@
 		vdda_sp_sensor:
 		vdda_ufs1_core:
 		vdda_ufs2_core:
-		vdda_usb1_ss_core:
-		vdda_usb2_ss_core:
 		vreg_l1a_0p875: ldo1 {
 			regulator-min-microvolt = <880000>;
 			regulator-max-microvolt = <880000>;
@@ -157,6 +155,7 @@
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
 		};
 
+		vdda_usb1_ss_core:
 		vdd_wcss_cx:
 		vdd_wcss_mx:
 		vdda_wcss_pll:
-- 
2.39.5



