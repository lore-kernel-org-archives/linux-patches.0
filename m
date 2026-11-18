Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025663;
	b=dQzN9OwI1vDam8TSbT4QiJd95CrZClVk5OV109cPyJvc2YG9l0kY/UF9AWFTxyS9Oc3V
	 53M40L1It5vElrpHzrZ+3vVnbqQOw4Xw16m5Mu+KyM6h/WpnpKEEBrU+aXGekm/GOA5tD
	 batUWUCB6fN7iun+v+CBEPgr3s9k9+casCmxjq1TOTtfJPgl725mk1l/mYlzYbEtsVltZ
	 ZDuJ8Ss9WEHAIhZRwC463/03lyHi3cGPt/UeHhQNCzpcDHjyDxYeh3iQRi4MjPMDmXxlK
	 Bki0lxfA0XHbrIiBHxFqGXxeKE5jrqRjQLrE9hd7MBsSKioSKDE5i6aB/3X3p0UPoLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025663;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8mcfPANpUs3ITFHwJRT9fYezOyGCoZdwpsaLFmJXGQA=;
	b=j0hGoyhu/R9HyscWc9z0Aq70LwUJ3kiHcbvEVq8DaLmiKiEJ+I204DV947axfIG9l668
	 DeaExKiH3N2oVXra+DI/uW+qRYTCEgUWG5OnkALkzWv3E5k7wkpb3XALhQyBum/lpZXxU
	 y1sO+HQ6ZB0Wt4vtuIMjvoVcoNwLZ1taY5AN6B3u97lXx4tHIG9X3I8dklTnp3m0+j1i4
	 zbpFEYgMnx/fO7IdmAbZs2MAgodmn7G/W2PyXR3afbier6g25sflxkXAI2WoQtDlU1OQb
	 xV2k5zmLOTZzxws5QvuSgt7hV4JEWQ+Ix+FV0uqrM5MAy/MGomTefn7mr6Br/mQYZxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XWTNMy0A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9049E606A31C;
	Wed, 18 Nov 2026 18:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XWTNMy0A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C4A1F000C5;
	Wed, 18 Nov 2026 18:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025663;
	bh=8mcfPANpUs3ITFHwJRT9fYezOyGCoZdwpsaLFmJXGQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XWTNMy0AxOlVKEes+Qf/THbLrOH6BOQeRZs8+KlJlzdDghFRjkEHLVTRGUZVg3qqv
	 kCq/ykE8d/RMlaJi5BLLBlBMwUEyU2XIlwi2fdn6eRoPFGnw/3K970jtLsl6BAGYDD
	 PtKJ6SxP4QnVPhMUPlHD27GkUb7fmdCXxqwY6iZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1152/2151] sh: defconfig: Enable the current M66592 UDC symbol
Date: Wed, 18 Nov 2026 15:48:07 +0100
Message-ID: <20261118150204.148359744@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 31dbd8888aaa9..4ee81b944be25 100644
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
index 2433aa5f44a86..72e9700e2f6c9 100644
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
index 52e7a42d66c72..56b724520c55f 100644
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



