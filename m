Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7C7441D;
	Thu, 13 Jun 2024 12:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282033; cv=none; b=Zwq9a6lQqZVTPt1+B7nmNJ63iU/tkxerbK+MitGwduf8y9afPb/T16hK6i4C+MYfmOMWeJHtBJ6i5RTTxdx8Uy3FF0RymeJHBh8Yc/ZDvnZWxmGpDJlOf88WSH72R/puf3BCuuwzJphcsuNtug3V7b3P6f+vhbqXgFNCd51zWgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282033; c=relaxed/simple;
	bh=KQybIGgc8eKb8M04mpkTLK3C2ps3hMNvhnzEFnbE6Gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l+aKPp0J2ofjbOSt0dRBMNWRVtC6C5J542Hi/uutbIZXurve5QI8rWIDUimQ/01Kr3kl5q1pCVCxs2DkUiBgX2dn4ehb/MuJRPtaeVTOEGJe6Vg3ghjjmCLXiOkavdOzj6Wpkj0TdE+2/rZi8XUCBYtNab00Ht64iF5tBZ21IPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=luy6DRap; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="luy6DRap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47091C32786;
	Thu, 13 Jun 2024 12:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282032;
	bh=KQybIGgc8eKb8M04mpkTLK3C2ps3hMNvhnzEFnbE6Gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=luy6DRapSNglAs1WMUrf3Gw80SCADqbfXR/tUlRSPexpAIYBDPHYLPx6a0mYbDYud
	 mnFQuA2BD9jgKv9CJdu1BY+hdwp+rDCBbXX9VWSNgap+kziJH6gxQO/0C8io4VKVEe
	 NYRtCgO2F7BR6l5F+MhkuIpee8OMPCee1/RBL278=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sam Ravnborg <sam@ravnborg.org>,
	Helge Deller <deller@gmx.de>,
	linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 139/402] fbdev: sh7760fb: allow modular build
Date: Thu, 13 Jun 2024 13:31:36 +0200
Message-ID: <20240613113307.558810728@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 51084f89d687e14d96278241e5200cde4b0985c7 ]

There is no reason to prohibit sh7760fb from being built as a
loadable module as suggested by Geert, so change the config symbol
from bool to tristate to allow that and change the FB dependency as
needed.

Fixes: f75f71b2c418 ("fbdev/sh7760fb: Depend on FB=y")
Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-fbdev@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Acked-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Acked-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
index 662524574cc33..26dfc4e5b10ce 100644
--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -2016,8 +2016,8 @@ config FB_COBALT
 	depends on FB && MIPS_COBALT
 
 config FB_SH7760
-	bool "SH7760/SH7763/SH7720/SH7721 LCDC support"
-	depends on FB=y && (CPU_SUBTYPE_SH7760 || CPU_SUBTYPE_SH7763 \
+	tristate "SH7760/SH7763/SH7720/SH7721 LCDC support"
+	depends on FB && (CPU_SUBTYPE_SH7760 || CPU_SUBTYPE_SH7763 \
 		|| CPU_SUBTYPE_SH7720 || CPU_SUBTYPE_SH7721)
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
-- 
2.43.0



