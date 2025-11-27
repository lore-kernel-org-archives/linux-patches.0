Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9949130DED3;
	Thu, 27 Nov 2025 14:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255242; cv=none; b=AMaxhlc9sMJ4lDYPX8faedrLkpksqgiS8qQBb/IaDqbxq9ah5mjQ4tm04t54DJciEuAhbV73Enc71FjRp48rkwLQvPAQtIvIPwcxs/CX8zRMaRzuYlV2D1jFqS2CBO/Mv/jAZYVhLGBxJ1ChTp9yZjqF5Q2Fw+G00eK9CVpOENU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255242; c=relaxed/simple;
	bh=z03SE3HVYA9dA3pzRp9Qj0u19RyFZajJ/RkkgDWuUZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ems1OozCY4AVeJUmrLhgOlXAVhQ3b8TuWFpeeqFYbYEemjwtJ8ni/YiMXckThqZUpNpPWPfVIXE9NETR2aMou6OzIMbdtFU/VDxgTXKm63dASWT5bm2JaK+Gs7m5Ae0n4oT4huB3Wgy1vYClo9mhbECy6QEVXZVp98973e090n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A+lktcwY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A+lktcwY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC3EC4CEF8;
	Thu, 27 Nov 2025 14:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255241;
	bh=z03SE3HVYA9dA3pzRp9Qj0u19RyFZajJ/RkkgDWuUZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A+lktcwYI8CbEy3PU5q1gG3placFvUV9yqBFUCl5qFh9aKqj/H41+5qk4LqDZe9Uv
	 JZj64gwXRjJueH53yyv0tFMe3FhHNIHXxQTHjy1kqVxz4etViyxUJSFakDaflDT0sz
	 Deju8aTz9XrQmk+TBv58nefY5RnRR4NebkpWWcSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu-Chun Lin <eleanor.lin@realtek.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 055/112] pinctrl: realtek: Select REGMAP_MMIO for RTD driver
Date: Thu, 27 Nov 2025 15:45:57 +0100
Message-ID: <20251127144034.855799775@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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



