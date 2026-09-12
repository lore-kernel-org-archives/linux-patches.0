Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815C634252D;
	Sat, 12 Sep 2026 07:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198767; cv=none; b=D6oNLAkgM+OGW/tCn04xBv6/e+S/u09lW+voM0AKz4j2aPDJuNVTdjwmy7/XB6E7mi9dJ/leVNizYdK5n5HVB/lgZncV/iFQKNKnzhnQrpXIXogsa3dT8h16Tw73OpjsR2JZrEV0pshY3Cc9ZL/vRr29PU7TvpKaP9pb4kkxBsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198767; c=relaxed/simple;
	bh=h97K9VFtBxYhJmmI4W9DRS8PPEmoCiUaW6pDZ7D/qYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V+UsPLLXxd9ysH21nOqgBhZJJcVkExNma9za+61tUgbnA7uHOAqELPz3TK6It5PIbMQ+a+HpXN3Ln0xRNk4u4sMncjDbL13369Q7BjdmdYqVZW+5QK930CFHlhuvK/XgJwfM8JNMS/vTBLqDwgo4kSP3ywm4R8JfkCIAzSf1A4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CyFBE2KO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CyFBE2KO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 384B21F000FF;
	Sat, 12 Sep 2026 07:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198766;
	bh=svK9Dq7UhJSydPze0ydhojoG6Y/vmZE5RrQ8rya/L00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CyFBE2KOalxprIiPO0c75C5o/xlr1+1iALgIvmk9WCPw+HeFJ2ag5e7B78zgyJ9Y/
	 aqYTxcCQEgs3HkWf240yc7Iy/2CCbq5kxHkOdtKyK8YC0FOyrh6la/KpIOnHajMdcY
	 0hAeeSLu1lL0CTF5J0n2syi89YAkymPTgbLzuF9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengyu Luo <mitltlatltl@gmail.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0447/1815] arm64: dts: qcom: sc8280xp-x13s: Fix the drive-strength of mclk pin
Date: Sat, 12 Sep 2026 08:36:37 +0200
Message-ID: <20260912065659.387305420@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index abd9c5a67b9ff..3ddd44e16e67f 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
+++ b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
@@ -1555,7 +1555,7 @@ cam_rgb_default: cam-rgb-default-state {
 		mclk-pins {
 			pins = "gpio17";
 			function = "cam_mclk";
-			drive-strength = <16>;
+			drive-strength = <6>;
 			bias-disable;
 		};
 
-- 
2.53.0



