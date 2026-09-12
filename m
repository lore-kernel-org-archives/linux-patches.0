Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C539A246BCD;
	Sat, 12 Sep 2026 10:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207694; cv=none; b=FtpG33M/9Pui0582jtmhlwrxjxH+fZe+mBzpD9gsNvtUx2W1rlCM8+LCgCwkUzITnXrIWCdRTkVe0WtjEQ8I+O97VzNm+TqqPajHwnBTOaTpSmglbgBHNF8yPPWQY2TWGWHpY2TNc0LpnX3WcXmcKdmnQt9+B+HVyrpjcO28cDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207694; c=relaxed/simple;
	bh=qDNd7aOpYFIMsQlznnIZd1qRzlJBfKcM24XDI4Qv2kM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g5qXKOU9i+GvclFceBXmqSJCXEOidF4QeQOTJgfij1VhcrfRyjuj9m1cOZpeB7KV4EqMmU7VLf8UfT26mhBuxecrlwGAnAGwpFz+Ars4PFpGWug/3nNDWr5VxVF4Lkimkc9U5SVka7Ii5mUmOSpfSGbbp+58EDM8OH2iaFx3d08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mGWt/rO+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mGWt/rO+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F071F000FF;
	Sat, 12 Sep 2026 10:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207693;
	bh=RVj1PrMVrJF+ov/RtLSoV7HXbvWdMPOpL0+fRI6NTRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mGWt/rO+VukWASWeh7nJHnRazeIbt75Ix0oEBQ3K3S7F/tjSlPGb+pVftO2jjeoMf
	 +x9SdvnSD50ZodMfXaoqCW0zCslm0/zFNB+rf8aiKf9uO7K/hs7RUm/lk8Vstc3aBp
	 nPVucIfLU4WMUmKZgro3fNuK9a7Z6vQ27vgG82Xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengyu Luo <mitltlatltl@gmail.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0412/1518] arm64: dts: qcom: sc8280xp-x13s: Fix the drive-strength of mclk pin
Date: Sat, 12 Sep 2026 08:43:01 +0200
Message-ID: <20260912065632.776227962@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengyu Luo <mitltlatltl@gmail.com>

[ Upstream commit 09531bb8e0de5081fdbe215877dd7f2ec8b2f0e1 ]

The value can be retrieve via windbg on Windows.

lkd> !dd f111000 L8

ctl_reg => 0x284

in drivers/pinctrl/qcom/pinctrl-msm.c
function msm_gpio_dbg_show_one()
...
drive = (ctl_reg >> g->drv_bit) & 7; // (0x284 >> 6) & 7 == 2
...
seq_printf(s, " %dmA", msm_regval_to_drive(drive)); // (drive + 1) * 2 == 6;
...

So the value is 6, not 16, it matches Windows now.

Fixes: 21927e94caa5 ("arm64: dts: qcom: sc8280xp-x13s: Enable RGB sensor")
Signed-off-by: Pengyu Luo <mitltlatltl@gmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260629065905.15651-2-mitltlatltl@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
index 637430719e6d7..a7559eb411018 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
+++ b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
@@ -1561,7 +1561,7 @@ cam_rgb_default: cam-rgb-default-state {
 		mclk-pins {
 			pins = "gpio17";
 			function = "cam_mclk";
-			drive-strength = <16>;
+			drive-strength = <6>;
 			bias-disable;
 		};
 
-- 
2.53.0



