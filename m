Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061437;
	b=h5fOa0OesvEde2yNa8EVRMj7LPsmop+uvbO1Y6kGhBmuaovn1GuEgnYFgL+9/z5nsLsa
	 9HrFgG363NiOVXJ15rcMiSZSHsprOPy2swlEEZBk475KaSXTWADM5jKCUtkcn9XNE6Crm
	 tb7FHsZpRDOkO8mpDQ9redqoZE9wQDBO6z1pGwaRIOOck9yIhkHNq0rlPOrYQE7tYEYUQ
	 +ccx3jk+h2YJ+Enaup1uE665E5VA98bt4TmxKuL8OlF7C4Smz6aWJc8K+qqf5EI4b1rsi
	 NblfJugYCuV2HAD9QP0cuGDhIFMm9JV+Ur/MrLt4/13TUlFs98lTKFbw7TzvT3xuhOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061437;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iiN9z8Xpu6VkX/gC9wUMzhXyeKXmzF4lUesmUYTMzHE=;
	b=uw3W0sAMW6vYiSc5p8gIQ0a9acmf/YAb0xKW6cGaL2lM9hwIzii3SUaakbWgdLQZ0TCA
	 oW6J89D2EUkNqLxfa8kdIjzyRrLnRFUcsa/mUEn82U+iGkyKtli84V53Q+2M8Sz1Xgz+4
	 uyAzKwJwJciANE/x/XmnGspusREkZntD2hy1epPAyKc3ue/kjjWTNCBad46irJl1nPN27
	 LYSnpKDGpWvZK+EWZMevoyyLKTb2kFwBoi2yc7nTq0kJDZeTXyP8+MMwwqRoUH7s6aMKU
	 MNgp05YOpD24EKHjyxMFHxEeM8aVcVxC8Zg87t2T3WZhP9B0yC8uWCcKXuHp9/Q+NTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UTOdu1iL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A226606A32A;
	Thu, 19 Nov 2026 04:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UTOdu1iL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C49E61F000C4;
	Thu, 19 Nov 2026 04:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061437;
	bh=iiN9z8Xpu6VkX/gC9wUMzhXyeKXmzF4lUesmUYTMzHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UTOdu1iL6rmu5B4YXJIuloDUCsQwqUZlLDS6awi17F4ji5WqwhOGn9p3rMEkL0c/5
	 vnJoRePe+CAtVjThoeCCAMA/yh3Q5BXAin2T4RTpF/GiP65/E0hhxChLa4iM6/OJHt
	 rp9c9fAg1nMOUpiehYHVEktPONBF5y/3k9+JMt64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1511/1848] sh: defconfig: Enable the current M66592 UDC symbol
Date: Wed, 18 Nov 2026 15:59:09 +0100
Message-ID: <20261118150022.565010327@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a24cf8cd2cea5..e9bcf362752ed 100644
--- a/arch/sh/configs/migor_defconfig
+++ b/arch/sh/configs/migor_defconfig
@@ -76,7 +76,7 @@ CONFIG_LOGO=y
 # CONFIG_LOGO_SUPERH_MONO is not set
 # CONFIG_LOGO_SUPERH_CLUT224 is not set
 CONFIG_USB_GADGET=y
-CONFIG_USB_GADGET_M66592=y
+CONFIG_USB_M66592=y
 CONFIG_USB_G_SERIAL=m
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_RS5C372=y
diff --git a/arch/sh/configs/sdk7786_defconfig b/arch/sh/configs/sdk7786_defconfig
index 61bec46ebd66a..e0fc69b015de8 100644
--- a/arch/sh/configs/sdk7786_defconfig
+++ b/arch/sh/configs/sdk7786_defconfig
@@ -156,7 +156,7 @@ CONFIG_USB_MON=y
 CONFIG_USB_OHCI_HCD=y
 CONFIG_USB_STORAGE=y
 CONFIG_USB_GADGET=y
-CONFIG_USB_GADGET_M66592=y
+CONFIG_USB_M66592=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_MAX6900=y
 CONFIG_RTC_DRV_SH=y
diff --git a/arch/sh/configs/shx3_defconfig b/arch/sh/configs/shx3_defconfig
index dc2be2514b623..ff3377f2e8f29 100644
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



