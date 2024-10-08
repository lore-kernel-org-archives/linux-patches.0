Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FEF21DFD1;
	Tue,  8 Oct 2024 13:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392877; cv=none; b=MRELUoFyIFv9pPFyrs/yjtPZieApM4fixkEJ9r0QBSgjXAxu7xd8kiYexdBLleKLjx11xXPo7YPlnVgeK8QH+6bMchhs+253AdhDMRSVfEqcR3R2StTBWO16fsIBrZKmyiK1UkUZvtHBQT9YQUu4zy/zRflgrraHGvjyODZfxKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392877; c=relaxed/simple;
	bh=Mhjo9oBJ7px0vI0RCifWM8B2Er7n0OsPzmjU9pEZgAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BwH3uWtH4pl0WTVktU5cax8CkBVOa/gz0y4gvlIaHfa9HRxnCS8wVXUV+uuo7H4lWFSAheGsmX/uNEr0Rnd9l2bggo0pY8Fwds6AaefWAHo0gNwzYymV3gKETTwIST/izIkWDisZc+CXWIfB7lpMiSmvzklBYhW3szmIQy1gA8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v1Hxj+e6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v1Hxj+e6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F217C4CECD;
	Tue,  8 Oct 2024 13:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392877;
	bh=Mhjo9oBJ7px0vI0RCifWM8B2Er7n0OsPzmjU9pEZgAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v1Hxj+e64i7Z7WikSYdjIk9kplNvf/bUa1NUFxF2epGXAaBJOVDtu9vkktzrlBn87
	 aic/AUYgBAn0Rx0CjYexRjSCDDpI6mwl9K9inw5JEb98RAvCvlbfHcKngkts3vg9m1
	 30BxSXykcqyI5aRbOPQZrAd11KuRRePdUS+MMANo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Helge Deller <deller@gmx.de>,
	Sam Ravnborg <sam@ravnborg.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Alex Deucher <alexander.deucher@amd.com>,
	dri-devel@lists.freedesktop.org,
	"Linux regression tracking (Thorsten Leemhuis)" <regressions@leemhuis.info>
Subject: [PATCH 6.11 514/558] firmware/sysfb: Disable sysfb for firmware buffers with unknown parent
Date: Tue,  8 Oct 2024 14:09:04 +0200
Message-ID: <20241008115722.454183618@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

commit ad604f0a4c040dcb8faf44dc72db25e457c28076 upstream.

The sysfb framebuffer handling only operates on graphics devices
that provide the system's firmware framebuffer. If that device is
not known, assume that any graphics device has been initialized by
firmware.

Fixes a problem on i915 where sysfb does not release the firmware
framebuffer after the native graphics driver loaded.

Reported-by: Borah, Chaitanya Kumar <chaitanya.kumar.borah@intel.com>
Closes: https://lore.kernel.org/dri-devel/SJ1PR11MB6129EFB8CE63D1EF6D932F94B96F2@SJ1PR11MB6129.namprd11.prod.outlook.com/
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/12160
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: b49420d6a1ae ("video/aperture: optionally match the device in sysfb_disable()")
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Helge Deller <deller@gmx.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: dri-devel@lists.freedesktop.org
Cc: Linux regression tracking (Thorsten Leemhuis) <regressions@leemhuis.info>
Cc: <stable@vger.kernel.org> # v6.11+
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240924084227.262271-1-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/sysfb.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/firmware/sysfb.c
+++ b/drivers/firmware/sysfb.c
@@ -67,9 +67,11 @@ static bool sysfb_unregister(void)
 void sysfb_disable(struct device *dev)
 {
 	struct screen_info *si = &screen_info;
+	struct device *parent;
 
 	mutex_lock(&disable_lock);
-	if (!dev || dev == sysfb_parent_dev(si)) {
+	parent = sysfb_parent_dev(si);
+	if (!dev || !parent || dev == parent) {
 		sysfb_unregister();
 		disabled = true;
 	}


