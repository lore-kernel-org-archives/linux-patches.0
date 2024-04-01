Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8031CA8F;
	Mon,  1 Apr 2024 16:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987499; cv=none; b=eGhVnFSBWdkbPIdmC5PRTHpOChE9PwRMjz2w9DIMINZruFiBoL2x9LykIR5GiCsbVplWfTxokshg9R5YII+ineFEHC5uhBKGuFx9NaLJYxiWQuoZddWyEOrM6wL1lY2Abjx7ZA77X7xbrjcrMVx2koxp2/aDIGFnp+UcjXT/m/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987499; c=relaxed/simple;
	bh=PMSCh7YeYZ43I2lXPNxKk0Z1n/LS5UVy6jt5QNbm+QQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HDXxfC6OSEfaSprpyeNGraMKSpt+LQUluYewWtUXU10DeBm3cWSukArKFJhUfey8OdzjadeEscSrrIgWvFk83sfTOpYfDnuE4IO1hzsyPXoEVHB0xzEGXa8EMm3T+JlDZYOI2I0YIjRVeqr8lCFozkvq5uEny7rGS9P3I8Zbb/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ky8yzTEM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ky8yzTEM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DE2CC433F1;
	Mon,  1 Apr 2024 16:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987499;
	bh=PMSCh7YeYZ43I2lXPNxKk0Z1n/LS5UVy6jt5QNbm+QQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ky8yzTEMM0UmPuWfp4z/xvG5YMhSUuu/VJAqOqv1IoCyHd+gFoOXP+gDH9UZ3YGiO
	 SuZLYOkdRjjpvU676fGPphDXm/XKIaA4PuK4hMjzfg3v9jihRgc44nlBLEgyDfJE73
	 22pgApMMcz8hQCd87gpa49rjFjkjlT11P6mEWLjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Bowler <nbowler@draconx.ca>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Daniel Vetter <daniel@ffwll.ch>,
	Helge Deller <deller@gmx.de>,
	Sam Ravnborg <sam@ravnborg.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org
Subject: [PATCH 6.8 306/399] fbdev: Select I/O-memory framebuffer ops for SBus
Date: Mon,  1 Apr 2024 17:44:32 +0200
Message-ID: <20240401152558.322745905@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

commit a8eb93b42d7e068306ca07f51055cbcde893fea3 upstream.

Framebuffer I/O on the Sparc Sbus requires read/write helpers for
I/O memory. Select FB_IOMEM_FOPS accordingly.

Reported-by: Nick Bowler <nbowler@draconx.ca>
Closes: https://lore.kernel.org/lkml/5bc21364-41da-a339-676e-5bb0f4faebfb@draconx.ca/
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 8813e86f6d82 ("fbdev: Remove default file-I/O implementations")
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: linux-fbdev@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v6.8+
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240322083005.24269-1-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -501,6 +501,7 @@ config FB_SBUS_HELPERS
 	select FB_CFB_COPYAREA
 	select FB_CFB_FILLRECT
 	select FB_CFB_IMAGEBLIT
+	select FB_IOMEM_FOPS
 
 config FB_BW2
 	bool "BWtwo support"
@@ -521,6 +522,7 @@ config FB_CG6
 	depends on (FB = y) && (SPARC && FB_SBUS)
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
+	select FB_IOMEM_FOPS
 	help
 	  This is the frame buffer device driver for the CGsix (GX, TurboGX)
 	  frame buffer.
@@ -530,6 +532,7 @@ config FB_FFB
 	depends on FB_SBUS && SPARC64
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
+	select FB_IOMEM_FOPS
 	help
 	  This is the frame buffer device driver for the Creator, Creator3D,
 	  and Elite3D graphics boards.


