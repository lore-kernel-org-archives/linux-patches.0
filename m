Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031023;
	b=P4IyQJXVEhmqsg/36uV4Hzn1VIvbcTk5NbX81o3N/e0xUOaj3aJveQiUaEmy/NOOh/6G
	 bFby1R5q9qGX1ScCGvbLs5aGMPXIfEcv0MgUz0xRWvz9LljpZ3K9ODNCTFpWs7JnbdfEx
	 rMKCVGbhvDYF4H3R6PCFC2LBq7lHlXr6Z1dAqMQB8c/YgjJ1pFsCHtaUyB2+sW3m1zaSV
	 Nm4392u3qpKA7MeasWT1U8Qb/6zWE0CVbDi4R3aELGg6UFIs6OA/wARKmlEDoKAHr38S7
	 RG/P5rPWt7tA8NIAlVjZyz/dxTz+uSa4UXxJ0ApCh0b6WCuFcFmT80DjdbNZomAdX3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031023;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z0TVapuU8sLN8BbA2cSw8JK8S3M6rqmhpwe2fmRISE8=;
	b=kJhzvLxcDFnIim9Pq2BGNh3aAbakMKE67zS8BM7Wz+bopFd8CgqkcpGURmRjXc0b84LU
	 F9jDDl/m81SwiC8ISaCCsVZqWZ2jWdXtXyEpqDJ0AXluUIoskROcbmP4t/igvSfr2qPUV
	 +0qOrH4wPXCcKWCIdekF9Qbmo+S2rA6HOQd2Rsq2xhyYkplqT1xjgs05otJQnsnv4ZkbX
	 qlItMw03g3bXDC6EMh4iKlh6MgGjojAJpy4dy+s5AqbVJcgY1evy8w7vzHY+w8kqyXuiC
	 51E1XusVKJ6Az9yKnQiX76T5KwMxyLnLuLmWbQuyDrGqbwFLU4HH35IKitpgLyEaQhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q6noNxPt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102C3606A31C;
	Wed, 18 Nov 2026 19:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q6noNxPt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A9E1F000C4;
	Wed, 18 Nov 2026 19:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031022;
	bh=Z0TVapuU8sLN8BbA2cSw8JK8S3M6rqmhpwe2fmRISE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q6noNxPtGYVkaKpXhRirhdX8V6998zG4H2Zfi1ex/k2zy2rqb6FpF7+nP6HJlRnWU
	 2rJyV+dEw4DIT9zon3Fljag66tTgWer/YwV9DwvSTbSvFUj9u+rfOTQ6+ApCuPitIU
	 hfR0kLKltg4cnMRtpL3JTplDq+8lEE9LAvlRVfWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0910/1756] sh: defconfig: Enable the current M66592 UDC symbol
Date: Wed, 18 Nov 2026 15:50:37 +0100
Message-ID: <20261118150046.195363980@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 07894f13441ef..919709fdf92b4 100644
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
index 9a0df5ea3866a..d0f642fc2438b 100644
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



