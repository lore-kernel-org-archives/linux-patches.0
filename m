Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F347419B3CA;
	Thu,  6 Jun 2024 14:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683373; cv=none; b=bqizww2uKNkI+HGLIfR26eISNA8V3xPrV+FSB+vqvgK16jLEAjg3vcfL2v0lMNbgGL3Tw4NAM1i/DyXbaz/QNzW3oGgcurjnq6jSVdUPZOIhYgmhY06tyXepB23UBcNAujW1OuffcBKnq7zCF+YQssnMpEIqUIbCZGK1wGMSYUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683373; c=relaxed/simple;
	bh=MGlEZu/wIakOyF6mxJEhpX6yOkzYEL2Xuh9RPo2dYBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j67ZZd7nEaRN79pzyVXrqK31rdqv6nBig0xDtXdAkHdn+Loan8F2gj4v0W4W387wGRVoObcVua8+wwG1GC1GlZqfGxYIm6tx49C/K7Qi8fcpVanCYMCPIOlH//EUAKkVzm8+E9TfNu2/1e90DY3PaTems0vRgeqLuSR5pufiHqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ba41CdBk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ba41CdBk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4C5C32781;
	Thu,  6 Jun 2024 14:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683372;
	bh=MGlEZu/wIakOyF6mxJEhpX6yOkzYEL2Xuh9RPo2dYBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ba41CdBkutPMxnExgLnRLwz7M5lm8kqsjcHDycHszIqqKLLIBA1ptzodnsDPYyPUS
	 rPs6kSVQAIiDMLK4aC5V4AaCfdQDqCUtiFU/E7Fe4hnLbfVuMOYR6Xkbvs4Rklgreb
	 6BUfc4+g257rBCsX4C/gwkGgqX2dLEWXMN670MfA=
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
Subject: [PATCH 6.6 314/744] fbdev: sh7760fb: allow modular build
Date: Thu,  6 Jun 2024 15:59:46 +0200
Message-ID: <20240606131742.496574844@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c29754b65c0ec..325298573e120 100644
--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -1761,8 +1761,8 @@ config FB_COBALT
 	depends on FB && MIPS_COBALT
 
 config FB_SH7760
-	bool "SH7760/SH7763/SH7720/SH7721 LCDC support"
-	depends on FB=y && (CPU_SUBTYPE_SH7760 || CPU_SUBTYPE_SH7763 \
+	tristate "SH7760/SH7763/SH7720/SH7721 LCDC support"
+	depends on FB && (CPU_SUBTYPE_SH7760 || CPU_SUBTYPE_SH7763 \
 		|| CPU_SUBTYPE_SH7720 || CPU_SUBTYPE_SH7721)
 	select FB_IOMEM_HELPERS
 	help
-- 
2.43.0



