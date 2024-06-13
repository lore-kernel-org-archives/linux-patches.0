Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDAAD13DDD8;
	Thu, 13 Jun 2024 11:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278799; cv=none; b=P/goXVyIFsmUEYIZ3aj1AOozJcn5a/Isr9x3E6OmBrNxxgjU42lChEJ0eS+5D6zlJNIrFlKMFv/HPpFU2cgZpRT9qdLEzVuuzLh1ixUrTJb8fHhjN+Kd6Ry4WlXjfyjY/IKn81MrlK63Vf8kdzoB2jX5TdFbK24WhmcEBAUBbuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278799; c=relaxed/simple;
	bh=yBhofhADsMvnMWPHz8AjOvmPTGaBt+PagTG+hbEV/NE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=esN7xgZ+RIxcFyThGKvwjfcaQ1K87DETIcRim0eMu4euTY1z2rnSXi911rFw0UFyoON/3XfmJyQDxbtFsWBklUpRWC7tIiuTnlAFLChHmm+9ZIsatKB8DAGqkkAPZaQRjPvhkz8hkxoT5QDOmxl36neOXzBvm1OjMqt+7jrftuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RWZtVPh+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RWZtVPh+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41B43C2BBFC;
	Thu, 13 Jun 2024 11:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278798;
	bh=yBhofhADsMvnMWPHz8AjOvmPTGaBt+PagTG+hbEV/NE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RWZtVPh+4zwnVj7C5co6QVCTAqhD/lDg1UuxtowEb8m1K3UxoHpSlaTD5Zh6k+AE7
	 3lGY4CnsjPoXiRA4zlSbiL3nNRQ/ZK6/9X28AeLAzKRQVjc+O2cvLEl1Hg4J3MbiFC
	 +tf3QLCb9ku8YHSMIxY3f9UcjPf8HKU50un0i4CI=
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
Subject: [PATCH 4.19 073/213] fbdev: sh7760fb: allow modular build
Date: Thu, 13 Jun 2024 13:32:01 +0200
Message-ID: <20240613113230.824017541@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 8e224ee27ade9..12846837f5de0 100644
--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -2084,8 +2084,8 @@ config FB_COBALT
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



