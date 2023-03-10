Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D45F8489
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:16:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB76C4339E;
	Fri, 10 Mar 2023 14:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457809;
	bh=PnFPcGnSqGG/kE3uz3cio9R00rJwc4VZbUG+/gwUNss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=clpQRKx0U+gljmlfQUh5OzyD4pHLj+p+9mNMtFDJHX9aAj31eNn5fpE/nlkdR2acW
	 mlOiMMOHBeVizZmalOgozMEAKNDCYDdnewtW4RUiabmzkPbyrJpO7jCIE/BCmTIab9
	 pll+WsxlsfTfHSWWq4ZHWVhpjQBf9ofo29CSx+r8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Marek Vasut <marex@denx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 066/252] drm: mxsfb: DRM_MXSFB should depend on ARCH_MXS || ARCH_MXC
Date: Fri, 10 Mar 2023 14:37:16 +0100
Message-Id: <20230310133720.833027762@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 7783cc67862f9166c901bfa0f80b717aa8d354dd ]

Freescale/NXP i.MX LCDIF and eLCDIF LCD controllers are only present on
Freescale/NXP i.MX SoCs.  Hence add a dependency on ARCH_MXS ||
ARCH_MXC, to prevent asking the user about this driver when configuring
a kernel without Freescale/NXP i.MX support.

Fixes: 45d59d704080cc0c ("drm: Add new driver for MXSFB controller")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Marek Vasut <marex@denx.de>
Signed-off-by: Marek Vasut <marex@denx.de>
Link: https://patchwork.freedesktop.org/patch/msgid/98e74779ca2bc575d91afff03369e86b080c01ac.1669046358.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mxsfb/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/mxsfb/Kconfig b/drivers/gpu/drm/mxsfb/Kconfig
index 3ed6849d63cba..1a2805c7a0eb7 100644
--- a/drivers/gpu/drm/mxsfb/Kconfig
+++ b/drivers/gpu/drm/mxsfb/Kconfig
@@ -7,6 +7,7 @@ config DRM_MXSFB
 	tristate "i.MX23/i.MX28/i.MX6SX MXSFB LCD controller"
 	depends on DRM && OF
 	depends on COMMON_CLK
+	depends on ARCH_MXS || ARCH_MXC || COMPILE_TEST
 	select DRM_MXS
 	select DRM_KMS_HELPER
 	select DRM_KMS_CMA_HELPER
-- 
2.39.2



