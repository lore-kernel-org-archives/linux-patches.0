Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94047745F2;
	Tue, 23 Jan 2024 02:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975459; cv=none; b=X/Ueb4FCcWjheglbZbxcHT/AKTzFpMjbeRNFfExgcEAmN23dS2ixDeoYfb3JV7pkODMcXgPDwMl5J/UHW4eC3Lrh25zmCOSGNYV3T8ENAyxG/9oprXbXp7FxNAtimduF+Vx7nrHj7Avk/b0ikSeR3ig6/6I3ED1v308X2vnjMRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975459; c=relaxed/simple;
	bh=GddwwWqm0IUKPK4DexHPrcYIVr1EnJPaAyeldVgOWEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ukubhXZKlMrp3BekX+NsKe8FMDV7Ck0vyOf8UKhu14yv0T1QluXD9QO2tFimcVWRjbK12ni5ERhygPEiQrwg5qNGptZyoNiyTzkQcbMZcUGtwB2QXNab1iX3iudOzWLT3/FoVBGULELq0BE27xi1nJdgrjJIC2BaLZyiMKwGdvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ethd118l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ethd118l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59736C43390;
	Tue, 23 Jan 2024 02:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975459;
	bh=GddwwWqm0IUKPK4DexHPrcYIVr1EnJPaAyeldVgOWEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ethd118lxDtLdXKaM5TOiKnZREsM90nr/rOypRPJUoa36Aqz5hwx+2ZrTfCcwSXCT
	 9zhYyiOtqiluEWaZjUbaThIhWVs7/GMHXf+NtRrUxaiRL6zPDFXj5NUxXeD0BpXaCL
	 Au45Auz5cePxBEXF8sPHGXwBnS0deXMYxoeSkXx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sam Ravnborg <sam@ravnborg.org>,
	Helge Deller <deller@gmx.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6.6 391/583] fbdev/acornfb: Fix name of fb_ops initializer macro
Date: Mon, 22 Jan 2024 15:57:22 -0800
Message-ID: <20240122235823.948797650@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Thomas Zimmermann <tzimmermann@suse.de>

commit b48807788e7a2bd93044fe84cfe8ff64b85ec15e upstream.

Fix build by using the correct name for the initializer macro
for struct fb_ops.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 9037afde8b9d ("fbdev/acornfb: Use fbdev I/O helpers")
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: <stable@vger.kernel.org> # v6.6+
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231127131655.4020-2-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/acornfb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/fbdev/acornfb.c
+++ b/drivers/video/fbdev/acornfb.c
@@ -605,7 +605,7 @@ acornfb_pan_display(struct fb_var_screen
 
 static const struct fb_ops acornfb_ops = {
 	.owner		= THIS_MODULE,
-	FB_IOMEM_DEFAULT_OPS,
+	FB_DEFAULT_IOMEM_OPS,
 	.fb_check_var	= acornfb_check_var,
 	.fb_set_par	= acornfb_set_par,
 	.fb_setcolreg	= acornfb_setcolreg,


