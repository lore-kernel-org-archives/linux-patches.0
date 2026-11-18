Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018202;
	b=b7E+YIE04REGaixF8YZC5kTTDWxTld9czD5T5ViDRb27g340vEVR7mM+YyhDuJgDPL8E
	 y/1f6Tj5h5HuYpFxi/jFu7oTBcIzR+GqLE2QjnAtBKiJAhbyN980lBJ9fB8IlVNzwhHkJ
	 xLlqSfboIhRwuW+FPO8bhYjyrwePKU832Po3cb/Fu080y0cj7WHjKZXzqWoVXIFp5HYIC
	 ap+KOgJK3HOJWTrUt7xOPhITvDOfPuUVUNe9Iv7L+38YSyXBGS/rPHQNS2vurQrezlKfH
	 gU1H7de2GsXHLJ0yNywD2odgzc2mF4qrDzgqEwFeiq6TN6390JxEyjSC6/IUN0v5RWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018202;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D7Prw0RS6V2O00IBPR+r0faJVpP0SquB84yOn6pel6c=;
	b=qeQCIHuFkE0JaOkPDcRINgR5njnrIcgitsuQopSs/TjjG6JO1YybC6d5SWh/9HbYjzUA
	 g9eTW1CEDTcb3Vuan24Edefskut45apBwslwShoNqpx+gpVsL58upRzqBgiSaqls2+J4o
	 WAUC0DpWnWOR812I1j3ldoNPQeIfeAzAdgu+Whl7hOD1ZI5lQwVW25AcfztXa4TzZbd7B
	 4YK2Pz1b0xXILFUPZTvB+jbK9605Uup1B6TpemHBaKvJo2FY/sdGWYf5gypeo//LD5vXm
	 fB1wuiL7AE0ZrLkADyDZuaByymoMR+VIFP3YVFwntKLA82CudSSHwS6kXlIhMs9WMTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ylNA5Use;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A5E606A320;
	Wed, 18 Nov 2026 16:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ylNA5Use
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 828271F000C4;
	Wed, 18 Nov 2026 16:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018201;
	bh=D7Prw0RS6V2O00IBPR+r0faJVpP0SquB84yOn6pel6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ylNA5Use2IQsEu/WEc+vHXUYnR73ky9p/4ABMPOHcd8POIkq3ak2vy3TEzm9HKU1L
	 sEYI1QxiB5O4AF1bgbvL09JP6Rk+XBOa3g94p4LWYqPkP+eYiVtsRZmYQ7MGu8v2qy
	 +3tBKwrEluhkVB3jyMKpiAkWDK+aZZ3kJn1DIN2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1156/2651] drm/panel: fix novatek-nt36536 dependencies
Date: Wed, 18 Nov 2026 15:39:56 +0100
Message-ID: <20261118150329.625519310@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit f11277810402d0e2f3f8e64618cdb5af2ade8d3f ]

The recently added driver requires access to DSC helper code
and fails to link without that:

ld.lld: error: undefined symbol: drm_dsc_pps_payload_pack
>>> referenced by panel-novatek-nt36536.c:109 (/home/arnd/arm-soc/drivers/gpu/drm/panel/panel-novatek-nt36536.c:109)
>>>               drivers/gpu/drm/panel/panel-novatek-nt36536.o:(novatek_prepare) in archive vmlinux.a

Add the usual Kconfig dependency.

Fixes: 75a5dbd1f4f7 ("drm/panel: Add Novatek NT36536 panel driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260925130125.3897046-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/panel/Kconfig b/drivers/gpu/drm/panel/Kconfig
index cbdf7b8f7f7af..67fc671341003 100644
--- a/drivers/gpu/drm/panel/Kconfig
+++ b/drivers/gpu/drm/panel/Kconfig
@@ -669,6 +669,8 @@ config DRM_PANEL_NOVATEK_NT36536
 	depends on OF
 	depends on DRM_MIPI_DSI
 	depends on BACKLIGHT_CLASS_DEVICE
+	select DRM_DISPLAY_DSC_HELPER
+	select DRM_DISPLAY_HELPER
 	select DRM_KMS_HELPER
 	help
 	  Say Y here if you want to enable support for Novatek NT36536-based
-- 
2.53.0



