Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969D664A8F
	for <patches@lists.linux.dev>; Thu, 17 Oct 2024 02:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729132989; cv=none; b=QAr7HK1vQDP9n67yJ2TEdqdTIE8pkq/KcMglQChMqfQQiCYFKMgRzPzhIRr7HYvOYXJql8XX2Y/m0biBfurfgxHHSaYx+9JIDF5LBaqOLAKwthrAxWnE8OK6tpSdUaAV0LC1L/i+K99r3TmF6HJ/er7TYIyWLkXavr6kuwTjAqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729132989; c=relaxed/simple;
	bh=sGN07J90cTv5VMhXNO6R6aC98F2vLsoN6Sht+2P4X+o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OQek5e5mx4pj/+9iMiC6m/drbNib0buFpdEekHiMz+jBPH9QLWIfdUscyMk0TfqmjdTQ3ZePgAbOvzqYguy4L9P09dusntbsM76QfxrnsIZu9FUm4s2Xj9l7PVGB1n3BqHVWvwi2Pjgk43UNHf0YB/j7CdwdRI+baXXBG3f6CmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iYAWEXSC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iYAWEXSC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=kegHJLpQz6vdtwsFfnK7vEYWeG6yPEw7RqtmTwSUv7c=; b=iYAWEXSCoRNt6tGqkYRCjxbqp8
	o6c90oEVdp54y+tfoMj9i0GBrOg+f5KIfqeHXknE+ZAtAB9OsyI5ITPBx6ZyxWtEkenRwH0PVowuS
	R1osB3kwRTIp4ZLrUHWH+uSR8J3xQzKe3ouRE8p/JVB0KWJDoMR20QhSAmD+Fo6jAByQxoboz9XSb
	+LlPeMGSbooUhfCH9YWb6yV7dPzuXIaHiCRHLVUD2kkQvK2Zeb7ZU/i9OIkY0umzZbwwuwEDr4Dpy
	2KtGdKYOUq0Sys513id/J8q1RatPK6qgUSC5mWhofZt4ws6Dwm0FakdhtbajiqNrDhHboW4ItSwNQ
	UnaywK9g==;
Received: from [50.53.2.24] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t1GTi-0000000DZmR-092C;
	Thu, 17 Oct 2024 02:43:06 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: dri-devel@lists.freedesktop.org
Cc: patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH] >>>>>>>>>>>>>>>>>>>>>>> FIXME <<<<<<<<<<<<<<<<<<<<<<
Date: Wed, 16 Oct 2024 19:43:05 -0700
Message-ID: <20241017024305.61318-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit


drivers/gpu/drm/drm_fbdev_dma.c:1: warning: no structured comments found
drivers/gpu/drm/drm_fbdev_shmem.c:1: warning: no structured comments found
drivers/gpu/drm/drm_fbdev_ttm.c:1: warning: no structured comments found

Fixes: 731fddf4302e ("drm/fbdev-dma: Remove obsolete setup function")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: dri-devel@lists.freedesktop.org
---
 Documentation/gpu/drm-kms-helpers.rst |    9 ---------
 1 file changed, 9 deletions(-)

--- linux-next-20241016.orig/Documentation/gpu/drm-kms-helpers.rst
+++ linux-next-20241016/Documentation/gpu/drm-kms-helpers.rst
@@ -110,15 +110,6 @@ fbdev Helper Functions Reference
 .. kernel-doc:: drivers/gpu/drm/drm_fb_helper.c
    :doc: fbdev helpers
 
-.. kernel-doc:: drivers/gpu/drm/drm_fbdev_dma.c
-   :export:
-
-.. kernel-doc:: drivers/gpu/drm/drm_fbdev_shmem.c
-   :export:
-
-.. kernel-doc:: drivers/gpu/drm/drm_fbdev_ttm.c
-   :export:
-
 .. kernel-doc:: include/drm/drm_fb_helper.h
    :internal:
 
