Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C224746A9;
	Sat, 12 Sep 2026 12:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215660; cv=none; b=ZcoViHJOgcQuAp0Z/3DPEv/LIDaZGHqoEzXUjMezYof+u40SQq+d+2W1g8cFdaNGNssIQxvNaW5hZj4MoACR/5fozfAmfPxF2m8RiXaZM90IYB+YgNvlTzNhlpkR2n3G+iIVS2ReGi+pCKTB45BzFb4G9rBg8HZWnXiGgxL9QNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215660; c=relaxed/simple;
	bh=bEnWtEPJG+I/xdvbftKZj1G3xxn/3nLQL6QLi+GCUnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NDs9FDYjcP9dL0O55as4f/IjWlY3nAZyaAB98IRJIH7syqOdqWdNwS4Uf7hK4xLTtW6vqoTLWUfaJWsLaCWNvfFHLeZN1bFV2XY4eFJ6lbe9lS6lYPixqijgU21hZWvUKmv1Pgm6b+UxM6q7S012QSqCibIMjHMEOZxdoojxI0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G/BOZv1W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G/BOZv1W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8CE01F000FF;
	Sat, 12 Sep 2026 12:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215659;
	bh=U5mI5ssq7AYYigN4y8tYEwfXyEB/2Yvl+wdQrtU6O3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G/BOZv1WGCjpHFolF1TKldi1h+fu4105XNVZbKbMIPHyDajFQtD+cFZDRK1EGGAPi
	 RC1HZWO74e8337/6Dfa83IO6r7G5qERQEirWFdO0Int2UyNkaJazUW63nSnO6bdKM6
	 4KLjg7M7a/V+jHUGJFKC86jy5b/vcXHy4gVm5DQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengyu Luo <mitltlatltl@gmail.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0560/1376] arm64: dts: qcom: sc8280xp-x13s: Fix the drive-strength of mclk pin
Date: Sat, 12 Sep 2026 08:49:46 +0200
Message-ID: <20260912065620.015350451@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8e5951da5920d..4dfe29caa52d2 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
+++ b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
@@ -1488,7 +1488,7 @@ cam_rgb_default: cam-rgb-default-state {
 		mclk-pins {
 			pins = "gpio17";
 			function = "cam_mclk";
-			drive-strength = <16>;
+			drive-strength = <6>;
 			bias-disable;
 		};
 
-- 
2.53.0



