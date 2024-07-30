Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C972D1A619E;
	Tue, 30 Jul 2024 16:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358370; cv=none; b=Zq00EJvF54HptvYjh3Lvb7syScNLHyjdq10WrclN+XoXzJyHamMU47fjp9NmRLoIvjSXer6W+1ZumZjkVJ9SHqAw0g6C1f8vPMRe4xKO3JSiXwrwI9uk8n9Dn8HQoZRVmUGbnprc88au4BEplj9gUVqvRPHdN6F2KrN4dcIhkpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358370; c=relaxed/simple;
	bh=lqeyQi4DA7Lb9j75hvuSDSKSM94nCWvNA57peRDZvIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ribAhs1LdGWPQbyCRIqfS/dcP3Mps4Wo5XFTsOMIH4PDyBQ8/gCV/HTS6wcrN8kph5tAr9yPkFUip7jvbuDLE7kmAGeaovRhKoktHkPRze9rHyz/qNG98BVvBaKoI5mNxYUP/GY0Fh3LtTVCne41qYNce5EqLo5zucgtz5gvQWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=keKCLADk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="keKCLADk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B87C4AF0E;
	Tue, 30 Jul 2024 16:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358370;
	bh=lqeyQi4DA7Lb9j75hvuSDSKSM94nCWvNA57peRDZvIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=keKCLADkDqOTyTEGB5rg1bODramCc0dE+PVa6PT6YRhZFiCJUANrosnok4mE0g25q
	 VSnvipkpw5WligCAngI2mHwHx05cb/bGVhfgZlBnVtImqI70swvBUD80VXinIsnjbt
	 5rrfYEvT/J+7v2lYUlQConOP3tVfTJXyu17y2yiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 353/809] drm/panic: Do not select DRM_KMS_HELPER
Date: Tue, 30 Jul 2024 17:43:49 +0200
Message-ID: <20240730151738.579129208@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit e044e707fc97dac693691178cdf41fe1a8da928f ]

DRM core code cannot call into DRM helper code, as this would lead to
circular references in the modular case.  Hence drop the selection of
DRM_KMS_HELPER.  It was unused anyway, as v10 switched from using
the DRM format helpers to its own color format conversion, cfr. commit
9544309775c3 ("drm/panic: Add support for color format conversion").

Remove the unneeded include of <drm/drm_format_helper.h>.

Fixes: bf9fb17c6672 ("drm/panic: Add a drm panic handler")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Signed-off-by: Jocelyn Falempe <jfalempe@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/60155f8c939ed286e324a7c12a1daa69fe49fcf6.1719391132.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/Kconfig     | 1 -
 drivers/gpu/drm/drm_panic.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 3e286236aa430..359b68adafc1b 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -107,7 +107,6 @@ config DRM_KMS_HELPER
 config DRM_PANIC
 	bool "Display a user-friendly message when a kernel panic occurs"
 	depends on DRM && !(FRAMEBUFFER_CONSOLE && VT_CONSOLE)
-	select DRM_KMS_HELPER
 	select FONT_SUPPORT
 	help
 	  Enable a drm panic handler, which will display a user-friendly message
diff --git a/drivers/gpu/drm/drm_panic.c b/drivers/gpu/drm/drm_panic.c
index e1c4796685692..831b214975a51 100644
--- a/drivers/gpu/drm/drm_panic.c
+++ b/drivers/gpu/drm/drm_panic.c
@@ -15,7 +15,6 @@
 #include <linux/types.h>
 
 #include <drm/drm_drv.h>
-#include <drm/drm_format_helper.h>
 #include <drm/drm_fourcc.h>
 #include <drm/drm_framebuffer.h>
 #include <drm/drm_modeset_helper_vtables.h>
-- 
2.43.0



