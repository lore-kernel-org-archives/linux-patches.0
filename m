Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049341;
	b=EwIJFdQ3hKwSo/ARzPe/SIdALzVzk3eS3J7ce9qqT+jtw49VJDopzekxxGgx4ZnUs3Sw
	 J2zVz35/QPDn99Yl3hFpVaPIah6CFWQDOvo8JPoxYgBYkEqcmIu9RzcaQpKnS1fTlEZ51
	 VLDyGtpvNPQlnh0Sh9fj1tBgPG8tzl/K2ldWRrbhu5eZWgXMr1a36Hyf3rQCvIj+a7RR3
	 pVdrnwON1l9vhswRWfl4ejqke7R5KAmCGyw+7LkcXpqY5EDhEWu/2I7wxGe7bqWun02ie
	 PD9WK5qGDSe5jOH4qzfYLKdkw+71CBcvqy0W7CJbGGD/EdfY4J5CeNo5gC5ooASAOGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049341;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9JqYJHwgBxwnbgSUrx08jpgVbAjXxvXLOHXdPMFQAzo=;
	b=FTSbAKUsZmJOc4yi7dz3aQeXqdiKksCntMtrnTJsWYtIm365eBtoHJyufhBFR3JfW1MV
	 Qfc/lEkywNvng59YTSbP6TFodQlC4YstPyURgmI48JnaFhjlvsTcBdhKApkBBS891DQGr
	 joXF2hyrD4QiwH9IeNYxs5iAOlgNlijc8X7+d7QmtwiL7vsykMlqd3McLGEjR+k6uQ+U3
	 Uo9v+CvfFGYaCibZigOJXgyG9np5g00Fba5dYHHDwghmqlLjXl+O4XJpDLYLtu4Rpo2DT
	 9bzLBMfteQHt/zEvmb2IiBnlHP6toz2scx8BAnVyOjMPNsfLexY7RD6mMSQumJo/eBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NcXZF2Yo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3FB606A32A;
	Thu, 19 Nov 2026 00:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NcXZF2Yo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F11D11F000C4;
	Thu, 19 Nov 2026 00:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049341;
	bh=9JqYJHwgBxwnbgSUrx08jpgVbAjXxvXLOHXdPMFQAzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NcXZF2YoUvuhJrIpg16D9WqbMV8D6kFWyDaOsKly0ojRwtMSjW2DziKQr7qSeVmVY
	 F78EY2YRw+l9IFdQ2sOnPJKSR5ftvDiLADi5BM8FnEWFjUgqraWL60rysfjm4ULKKK
	 VcNCrtO+00fBQKJL7q3TZj/nNwzvNEyC3Wl3uUdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2276/2857] sh: defconfig: Enable the current M66592 UDC symbol
Date: Wed, 18 Nov 2026 15:55:10 +0100
Message-ID: <20261118150323.403171592@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4859cd30cfc4c..04a72ac6f67f7 100644
--- a/arch/sh/configs/migor_defconfig
+++ b/arch/sh/configs/migor_defconfig
@@ -75,7 +75,7 @@ CONFIG_LOGO=y
 # CONFIG_LOGO_SUPERH_MONO is not set
 # CONFIG_LOGO_SUPERH_CLUT224 is not set
 CONFIG_USB_GADGET=y
-CONFIG_USB_GADGET_M66592=y
+CONFIG_USB_M66592=y
 CONFIG_USB_G_SERIAL=m
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_RS5C372=y
diff --git a/arch/sh/configs/sdk7786_defconfig b/arch/sh/configs/sdk7786_defconfig
index 97b7356639ed8..f3b26cc4dd180 100644
--- a/arch/sh/configs/sdk7786_defconfig
+++ b/arch/sh/configs/sdk7786_defconfig
@@ -150,7 +150,7 @@ CONFIG_USB_MON=y
 CONFIG_USB_OHCI_HCD=y
 CONFIG_USB_STORAGE=y
 CONFIG_USB_GADGET=y
-CONFIG_USB_GADGET_M66592=y
+CONFIG_USB_M66592=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_MAX6900=y
 CONFIG_RTC_DRV_SH=y
diff --git a/arch/sh/configs/shx3_defconfig b/arch/sh/configs/shx3_defconfig
index 32ec6eb1eabcf..2ef24c4914ac2 100644
--- a/arch/sh/configs/shx3_defconfig
+++ b/arch/sh/configs/shx3_defconfig
@@ -80,7 +80,7 @@ CONFIG_USB=y
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



