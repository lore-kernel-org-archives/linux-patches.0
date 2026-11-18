Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055962;
	b=FusmvhCJ1W5n5V4GNJBQ8q36l8N9Z7I/1jcHKd9wvsghbxefYzYMjgVerbSJ+lW/OU2E
	 R4M+mULgWI/d1/idUIUSEIJFuVB5GQUlJI3Es3a8QkYjnnzNN08Zl907vAw4RPncRwoAI
	 C53pHp1I3EvOoPuHVmNPLdmxPCCHhQqDShff6aNjnD8VZym9Z3w5hnPLTSIwWmQB4e0gJ
	 6wPQ2UO4yvBemj2eQYMiRpicijl6Wf9qSj7+QSEhbi5EoUJXwn5fsldZ0fiilVaaYOEv6
	 wTWfHyQGc2NLrxpgmIMQP0w8xk6hlbCIR+5s//DsotMHwWdqiylzcpgkwRzpsuQuRrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055962;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UlbtUU71ElCnQp3hV/yk9/H3S1QiVAhemZmxopfQNek=;
	b=owm/BGC/54kFQWi74gpMIAMtNNresTIsI/ByMTRJvrdnHda2twQcBNvX/r5Ofg8FpiQB
	 B0nBb7zNbCYSTfkT+N6bEcrSDIYJ6K9THtAtVimk8j0Er/CgW56hT2ikGaVeWQLlaZu7u
	 7ESEhcE3r4hGfE4SYEMprEuhlC2gmzMADXN/eyGqiGb7//IoSM5UGSxpFjqnF6qZ8gv90
	 tLlFKnKpoxt9FG+gkqh3G3YhrT23wLFOCe78W/CRZ2Nj9dnfWxLbfz5+HkveUjgEmaaPt
	 3CE/LYVvcWjzFIFNFK1Vi0QH5hU9PcbAmFa4tS37SjDaUDSmyvUD7CQcbD+z/p2D+2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SJdcdFQL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F161606A320;
	Thu, 19 Nov 2026 02:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SJdcdFQL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCC151F000C4;
	Thu, 19 Nov 2026 02:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055962;
	bh=UlbtUU71ElCnQp3hV/yk9/H3S1QiVAhemZmxopfQNek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SJdcdFQL5C422UJPhuv42L4oHIGSuVComeC0I40Vmpn78aXHKf/6TShgPdqXapTVg
	 8LpRLAuFXSFAtZOQVl3nre/W9CehvodetoVE4a7ZnSx6xS444VZulRqXhaOnUP1JOV
	 aoQBdQ8Msn48iJhW1tEWvUdzaCTYNWgJs8lC4uMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1778/2214] sh: defconfig: Enable the current M66592 UDC symbol
Date: Wed, 18 Nov 2026 15:57:34 +0100
Message-ID: <20261118150122.623495463@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f776a1d0d2776..37ee66c76efae 100644
--- a/arch/sh/configs/sdk7786_defconfig
+++ b/arch/sh/configs/sdk7786_defconfig
@@ -152,7 +152,7 @@ CONFIG_USB_MON=y
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



