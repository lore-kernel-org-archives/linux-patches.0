Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8910753AB
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:35:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9789C433C7;
	Sun, 17 Sep 2023 20:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982912;
	bh=vxpBZC1wR1R9+WyORlS/zNOyyIfpAjt8cHQVje7YzZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ElGXphWaWeeES+/rxU2GFeZFIOLQe6fe7knjSwGWX2O0PV190s6qKElwzeTU9kB1Y
	 BrEs/+EiCnPS6aCBQsZGlRHWiTa8VrAzRiS/6VMIVpw8S5iE7vOR82QnbfKG/RupNL
	 bSShQ5HOAHu6ER2dq4kdYJd6Ur3+90Ljh9Atz+/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 5.15 390/511] fbdev/ep93xx-fb: Do not assign to struct fb_info.dev
Date: Sun, 17 Sep 2023 21:13:37 +0200
Message-ID: <20230917191123.211295109@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

From: Thomas Zimmermann <tzimmermann@suse.de>

commit f90a0e5265b60cdd3c77990e8105f79aa2fac994 upstream.

Do not assing the Linux device to struct fb_info.dev. The call to
register_framebuffer() initializes the field to the fbdev device.
Drivers should not override its value.

Fixes a bug where the driver incorrectly decreases the hardware
device's reference counter and leaks the fbdev device.

v2:
	* add Fixes tag (Dan)

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 88017bda96a5 ("ep93xx video driver")
Cc: <stable@vger.kernel.org> # v2.6.32+
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230613110953.24176-15-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/ep93xx-fb.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/video/fbdev/ep93xx-fb.c
+++ b/drivers/video/fbdev/ep93xx-fb.c
@@ -474,7 +474,6 @@ static int ep93xxfb_probe(struct platfor
 	if (!info)
 		return -ENOMEM;
 
-	info->dev = &pdev->dev;
 	platform_set_drvdata(pdev, info);
 	fbi = info->par;
 	fbi->mach_info = mach_info;


