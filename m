Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018807;
	b=ZHA5Ah3G0amcxn483ZqaVy8/VXeShz4UlRmnUIdJgLbtZWAdpR0fjqSFHYNDgIgZOsRU
	 nk8nunxGg/je+CwOwbSPZO9MmdSqf10YHtUIJZCQxSPVR0Ybd3K7KLWVq+HvLq6ioYSh+
	 /AeHjWtc72v5HG0AkxmAGDI+uWdLUlLYWCi+SjsHj6UM+zuQ67hmGtISkTSYJyr5LGaRI
	 NKLZDlNLfoRLV1pZH6FXXXwxtlncjpdv6IBPUtEWUJygfWkIlqHUv5jhRsGetrZkHiYH7
	 YzETpqBqhF00K5pAJT6FO2lHlRo5RSZIJ+05XQlgh1mkeusIIDQ3yH1E52+2rQk7ouA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018807;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R+rDxB/q0JN9xQH5uVxHJBnXI71JNe838RrqTbZ6SVc=;
	b=4wqQGVru5meQwrH16ge2gC1pwIuyJ9ikH4DQTNpWbhsCREg9hSyBaonqkJLsi/Q6i226
	 BP7npEPuqu3ILCjtWxwZ74fnS3fOBUoQxA8UCgTwdldsmSyWn90Fk0RDVqQbR/v733K+y
	 b0K4em8Axvuy95o5Z5Li8BfjpBGqAc7npetOdGetJkqYOeJauw3b39qYVYQTbmEjRSYl2
	 VHC+KN2kPEcNDnXP7tBRxkKSlKhJ0hw3Wuepe8hpFvEUUsM+Gp9rVwXsnyv3ZORL49WNG
	 hcd798UDjXYipIxo3UWdbRrQ9+8bRxiDOUGvsPAmIGYl8ioMtsgStlwHPwLBOqkV7pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="VvfR7SF/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90D2606A331;
	Wed, 18 Nov 2026 16:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VvfR7SF/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4728A1F000C6;
	Wed, 18 Nov 2026 16:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018806;
	bh=R+rDxB/q0JN9xQH5uVxHJBnXI71JNe838RrqTbZ6SVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VvfR7SF/XcLatSIZWn/vl9sS1yiSA4xeKHBEJ7qwvzMiu+mY4mm6xFi/jzcwH+79w
	 H27qR1KH9ebHSg8TCFP6veITeJr6KHg0HbBllKOGREdsTJsaYbASJUdEutuXHKy+Dk
	 YnQoCyhz9l1ERw08qkq4nMDqch3q5pdKsPrVWvN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1371/2651] sh: defconfig: Enable the current M66592 UDC symbol
Date: Wed, 18 Nov 2026 15:43:31 +0100
Message-ID: <20261118150337.385684037@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 9b65dcd94222c37febf98127b1ac5452c94a16d0 ]

The M66592 UDC provider is built under CONFIG_USB_M66592. Several
SuperH defconfigs still enable the removed CONFIG_USB_GADGET_M66592
symbol.

Replace the stale entries with the current provider symbol.

Fixes: 193ab2a6070039e7 ("usb: gadget: allow multiple gadgets to be built")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Assisted-by: Codex:gpt-5
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be> # build-tested
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sh/configs/migor_defconfig   | 2 +-
 arch/sh/configs/sdk7786_defconfig | 2 +-
 arch/sh/configs/shx3_defconfig    | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/sh/configs/migor_defconfig b/arch/sh/configs/migor_defconfig
index 1d9d543eef4c0..bde70f3bf8572 100644
--- a/arch/sh/configs/migor_defconfig
+++ b/arch/sh/configs/migor_defconfig
@@ -72,7 +72,7 @@ CONFIG_LOGO=y
 # CONFIG_LOGO_LINUX_VGA16 is not set
 # CONFIG_LOGO_LINUX_CLUT224 is not set
 CONFIG_USB_GADGET=y
-CONFIG_USB_GADGET_M66592=y
+CONFIG_USB_M66592=y
 CONFIG_USB_G_SERIAL=m
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_RS5C372=y
diff --git a/arch/sh/configs/sdk7786_defconfig b/arch/sh/configs/sdk7786_defconfig
index d6fa3a422e24d..d40be415dcb96 100644
--- a/arch/sh/configs/sdk7786_defconfig
+++ b/arch/sh/configs/sdk7786_defconfig
@@ -147,7 +147,7 @@ CONFIG_USB_MON=y
 CONFIG_USB_OHCI_HCD=y
 CONFIG_USB_STORAGE=y
 CONFIG_USB_GADGET=y
-CONFIG_USB_GADGET_M66592=y
+CONFIG_USB_M66592=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_MAX6900=y
 CONFIG_RTC_DRV_SH=y
diff --git a/arch/sh/configs/shx3_defconfig b/arch/sh/configs/shx3_defconfig
index 0cb69a0b92cbc..d7496ea9a9fc0 100644
--- a/arch/sh/configs/shx3_defconfig
+++ b/arch/sh/configs/shx3_defconfig
@@ -79,7 +79,7 @@ CONFIG_USB=y
 CONFIG_USB_MON=y
 CONFIG_USB_R8A66597_HCD=m
 CONFIG_USB_GADGET=y
-CONFIG_USB_GADGET_M66592=y
+CONFIG_USB_M66592=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_SH=y
 CONFIG_UIO=m
-- 
2.53.0



