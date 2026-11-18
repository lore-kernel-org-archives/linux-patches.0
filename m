Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041042;
	b=S3T7mL9iNJnifzNAjWAvPhNFmwPZHB5wmBFfMqi3h7kQ36WgxgWyU/EPUN2KqFZObOt5
	 PInwah6WV9ctzUNvkWBui09dQzkdCTIL3GV/6Q6hhKhRwnshm0UA3Y1oDyjdBxFbPo5EO
	 sga9EyKns7a6v57cPPHYRth2QHoDQIQ+s32sup00D08a07CMQ48gQukWOC/pLw+tP7I2e
	 BfyN0p1YaGXnMoMtfdXqYL42ocO69Fn4QdWxU/1U7lM4jeznwD5LchmojLoCVGcjxQyar
	 1y2rEoMsVb0NJttIihqC2TvNZqrC62rm7gV1a1JQ+PNd68Uxo3qXN/RWi9IT2KInRbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041042;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o8SXaElE+T2FMeo3uOJNHLyzJCkaDRpLeHGo6jTHTOc=;
	b=r1IX+KPHc1SKyJ/mq8MsYcP+o0+U8djnKskBdg04zNEEMeQWJLv2Cb0bt7CYfKpjjPS8
	 jK6Rb5gE3MmYk5xtKJuhSTwxzzUVNIBi/Cq139q3NYL0lkxvejf4ntpz4oFDVcOQhzGY/
	 OwMNTmXaekKxF2NXVlb8Q2rd4PKqvQoCzmvRwCV1ILYTGkADjUGLIa6pLBmCQYF0QVNPe
	 qcpbmIVg+oIVS/v/DIKraKSkI+UZ7WYrLPvmsUH7Wr81F9RHbobYvaug6VLjMDws+zExW
	 f3KX1dPU5pDNKWh7Phgk2Y8yY6M5IHWnNWdYAU2v5vL+kY3Xq6a6YcVILcj14WddtqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dubuSekh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF7F606A320;
	Wed, 18 Nov 2026 22:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dubuSekh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69FAA1F000C6;
	Wed, 18 Nov 2026 22:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041042;
	bh=o8SXaElE+T2FMeo3uOJNHLyzJCkaDRpLeHGo6jTHTOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dubuSekhCbA1U7Oidi+qZyi6jdITAUabPqnsuuZAQDoFapK0xRaeN5nNF1Q6Ula+2
	 DAVJD5trwhGSGbm4JHOkzO5Lz3YOSREM5Z/9D23lU4hP005q8Xi3RfjDGhz28bnhZI
	 fD1EqNZvGL7bWQdAfheXmTYXYMUN2PLztB/bT3O8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2632/3318] sh: defconfig: Enable the current M66592 UDC symbol
Date: Wed, 18 Nov 2026 15:54:14 +0100
Message-ID: <20261118150440.050428696@linuxfoundation.org>
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
index 2d1e65cad2398..b203a46354363 100644
--- a/arch/sh/configs/migor_defconfig
+++ b/arch/sh/configs/migor_defconfig
@@ -74,7 +74,7 @@ CONFIG_LOGO=y
 # CONFIG_LOGO_SUPERH_MONO is not set
 # CONFIG_LOGO_SUPERH_CLUT224 is not set
 CONFIG_USB_GADGET=y
-CONFIG_USB_GADGET_M66592=y
+CONFIG_USB_M66592=y
 CONFIG_USB_G_SERIAL=m
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_RS5C372=y
diff --git a/arch/sh/configs/sdk7786_defconfig b/arch/sh/configs/sdk7786_defconfig
index cf59b98446e4d..ac4c55fa8e9de 100644
--- a/arch/sh/configs/sdk7786_defconfig
+++ b/arch/sh/configs/sdk7786_defconfig
@@ -149,7 +149,7 @@ CONFIG_USB_MON=y
 CONFIG_USB_OHCI_HCD=y
 CONFIG_USB_STORAGE=y
 CONFIG_USB_GADGET=y
-CONFIG_USB_GADGET_M66592=y
+CONFIG_USB_M66592=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_MAX6900=y
 CONFIG_RTC_DRV_SH=y
diff --git a/arch/sh/configs/shx3_defconfig b/arch/sh/configs/shx3_defconfig
index aa353dff7f193..53e735d7a5deb 100644
--- a/arch/sh/configs/shx3_defconfig
+++ b/arch/sh/configs/shx3_defconfig
@@ -81,7 +81,7 @@ CONFIG_USB=y
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



