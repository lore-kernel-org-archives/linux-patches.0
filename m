Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB70620FAAB;
	Thu, 27 Nov 2025 15:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255711; cv=none; b=ANO55wH4JKX8bejOqOSwRBzSxBjGPMxTujPSiNm+mKomPa0xx/vEQ96+7KJHnJu43S2W06Ko+zeY3zir1mYakzJoj6n8ByZC/KM+FkkVn1SAcifC+edBsxJsnp2Ctvyn5kY7H9y4KKVpQWWFyNlHLnxySbFwiFbMZV39UH3Yp0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255711; c=relaxed/simple;
	bh=2JrgQ+y8N9utT3TW03t9lU//cq8LXLTvE7uEG/GcLcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u4Nz/L0rEIVAUUpp1oODNmo7iXItnOPbnQGZHEm0BkJweh/VCw0AoH4YYpMkpEjnBl0/UlJIxNJo4asNXROA7dc6/yUzYOgyQQeiCrJMclrnysl5Kjx4090fxOUb5J8qLULyotpsPWcz2NCEl+TxM8RTp/m+jY/9qVp7uTMgc/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=00HxbWR5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="00HxbWR5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6234C4CEF8;
	Thu, 27 Nov 2025 15:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255710;
	bh=2JrgQ+y8N9utT3TW03t9lU//cq8LXLTvE7uEG/GcLcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=00HxbWR5GelPI+9mKfzMVpt3Q6I+pdCg7OJh7efLxblVuy7Cp+jJW93DiptYdeDTg
	 39+xxtWMEmqt5taiAdHbwur2cukAw644IRXTxmCMU5Dk6j/5lppTtKbzXbBOXbHCaI
	 u0aDrkeCcx9LDW5rdTsdRKT/s83fTKb1yRTMbcds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu-Chun Lin <eleanor.lin@realtek.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 087/175] pinctrl: realtek: Select REGMAP_MMIO for RTD driver
Date: Thu, 27 Nov 2025 15:45:40 +0100
Message-ID: <20251127144046.141404957@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu-Chun Lin <eleanor.lin@realtek.com>

[ Upstream commit 369f772299821f93f872bf1b4d7d7ed2fc50243b ]

The pinctrl-rtd driver uses 'devm_regmap_init_mmio', which requires
'REGMAP_MMIO' to be enabled.

Without this selection, the build fails with an undefined reference:
aarch64-none-linux-gnu-ld: drivers/pinctrl/realtek/pinctrl-rtd.o: in
function rtd_pinctrl_probe': pinctrl-rtd.c:(.text+0x5a0): undefined
reference to __devm_regmap_init_mmio_clk'

Fix this by selecting 'REGMAP_MMIO' in the Kconfig.

Fixes: e99ce78030db ("pinctrl: realtek: Add common pinctrl driver for Realtek DHC RTD SoCs")
Signed-off-by: Yu-Chun Lin <eleanor.lin@realtek.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/realtek/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/realtek/Kconfig b/drivers/pinctrl/realtek/Kconfig
index 0fc6bd4fcb7ec..400c9e5b16ada 100644
--- a/drivers/pinctrl/realtek/Kconfig
+++ b/drivers/pinctrl/realtek/Kconfig
@@ -6,6 +6,7 @@ config PINCTRL_RTD
 	default y
 	select PINMUX
 	select GENERIC_PINCONF
+	select REGMAP_MMIO
 
 config PINCTRL_RTD1619B
 	tristate "Realtek DHC 1619B pin controller driver"
-- 
2.51.0



