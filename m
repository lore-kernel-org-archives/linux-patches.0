Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18476FC9
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:37:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B58C433C8;
	Sun, 17 Sep 2023 19:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979468;
	bh=GhvfnwqZgxmQGO5SHthqHYWfa/jDpgtmChtnhx6NMZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U/1Je/mGCqOVsmuFMBgdj4Ra1uOA9itGBoF/raEdDQfbh4B7clvtO21Go7EOLT4UP
	 38r/23VLzCa9GF4GAUdMQqBqNSY0ZC1tWt2uVZCesCmmuDz9o9IvmqhCL9L3J7juDc
	 RA40axpIFyhnG2k1qsGcy768PIiA9NaOQxlTlOzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 5.10 322/406] fbdev/ep93xx-fb: Do not assign to struct fb_info.dev
Date: Sun, 17 Sep 2023 21:12:56 +0200
Message-ID: <20230917191109.797009149@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


