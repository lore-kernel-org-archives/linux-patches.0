Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273A132863D;
	Mon, 13 Apr 2026 16:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099499; cv=none; b=dwGurOKn472gPU4F+ehtQZdY3/ujuQOKwn2jmmjNTbVjqLdrI/UjFFVn5Tpihzb8cpdeMKuKWlrnkm1XCxjhIwL6nKxGGbwoy3otkM7SL0Sa8fe4PKdPshnfGJoFFjjrvExiJPpB3jv5Ix8BNI9vx3NQTvAOQWXAzM66q9VoTWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099499; c=relaxed/simple;
	bh=+fafpj86/NskAqr09C4xq02iIGJqJys+yl+IBRr3lrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a8B3wQcqTMASZc+coPS/IdeG8A77HO04NBsGDn39f8M8Bacy/jb/2G0mwg172qqcQ8npqU9d6VrfSq9mHaM3dm9bQXWA+Y/yOpCA9TzO16nsLsY3ymMQtwxe9aNLVLIBtZ3aDR2rKpqKJWiRYfKWrJEipstiAHxrKzBeXfhkb0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CCH7lIay; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CCH7lIay"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B07D1C2BCAF;
	Mon, 13 Apr 2026 16:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099499;
	bh=+fafpj86/NskAqr09C4xq02iIGJqJys+yl+IBRr3lrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CCH7lIay9+8dst/rsDvAbFpfb/12jeEhPCxtcvOYLijx3d5dCACXvNFFZYWi3TbqP
	 DYE11hVZRB+Kk+jlKRrs118kxvMNAT0fUg7z1aUZL+EE4WEtJJnTUAE3Jy0f9xtKhs
	 zN5N8jSZJgrHmsQDe5c/6QZd1FXOdlivxXTlBWIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	stable <stable@kernel.org>
Subject: [PATCH 5.10 364/491] drm/ioc32: stop speculation on the drm_compat_ioctl path
Date: Mon, 13 Apr 2026 18:00:09 +0200
Message-ID: <20260413155832.663090890@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit f8995c2df519f382525ca4bc90553ad2ec611067 upstream.

The drm compat ioctl path takes a user controlled pointer, and then
dereferences it into a table of function pointers, the signature method
of spectre problems.  Fix this up by calling array_index_nospec() on the
index to the function pointer list.

Fixes: 505b5240329b ("drm/ioctl: Fix Spectre v1 vulnerabilities")
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: stable <stable@kernel.org>
Assisted-by: gkh_clanker_2000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Acked-by: Maxime Ripard <mripard@kernel.org>
Reviewed-by: Simona Vetter <simona@ffwll.ch>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patch.msgid.link/2026032451-playing-rummage-8fa2@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_ioc32.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/drm_ioc32.c
+++ b/drivers/gpu/drm/drm_ioc32.c
@@ -28,6 +28,7 @@
  * IN THE SOFTWARE.
  */
 #include <linux/compat.h>
+#include <linux/nospec.h>
 #include <linux/ratelimit.h>
 #include <linux/export.h>
 
@@ -992,6 +993,7 @@ long drm_compat_ioctl(struct file *filp,
 	if (nr >= ARRAY_SIZE(drm_compat_ioctls))
 		return drm_ioctl(filp, cmd, arg);
 
+	nr = array_index_nospec(nr, ARRAY_SIZE(drm_compat_ioctls));
 	fn = drm_compat_ioctls[nr].fn;
 	if (!fn)
 		return drm_ioctl(filp, cmd, arg);


