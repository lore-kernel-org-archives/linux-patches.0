Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDED111AD
	for <patches@lists.linux.dev>; Thu, 17 Oct 2024 02:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729133297; cv=none; b=vFXZNvFgkf6jn62+zmkPHynWWL5A/6NpSicvqho79F7+tyaxKrwuXCcufV2qxbmJ3yyaLQYqF1p8uC4Luh3vtrepGswKMPHbDl5CZMFxY6izT3AdpGHHNPEXtAaw9Gw78xBla1iaLn3WO31u5YPvbBfgcTpxStZI8KIIhuF4z9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729133297; c=relaxed/simple;
	bh=/4B2dYg6lCh3A2TBvEOq6N8YTHk6ZGEoTCPXkS1BwE0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TQFgUwDOWkmRNny83Cks+EbrxUR23iXirAJzwBdr0DqvuYl5JKIxaV+7kA65QYdgPhLNwWION38k08HfTgtEQNtXbrNj8AfL5MSICZEWobFsX8z/AYUmPGKhiB4iIzH8Q94aKxdQfUy22j74EuvypUR3zX/CHLwen8KE3RHU45A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KqCgD/eP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KqCgD/eP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=ucFuiCRRvpRupTzMst2/fXuORqTG4PkFhkImvRCzP9A=; b=KqCgD/eP6Ku4A8bCEiADaMB7QE
	VqV5gUpwkNb5mUcPFAZFPNVy7ixDzFbb6GLfl8ZhrLDf6oIQ7vJ3sA5mSC8AepdHhncmNjQKUXtz9
	VjDhKx4Qj9nRMCVY08uGSyvaahSmP2Zw77/rOPN8+By/L8keYyM9TINNVDhnAKkSmcMKFfzDP8bX8
	etlqD0AXRkIJ9eY4m2IHmsTNkHl67XB+684SSNB1wPVnwBqd/5iIufwslQggFVtFvK0uTD0CQL5gX
	2tj9pBA5JpCiUxj5rHmJul5dryBIve0J62NIoabGZXg2q9TLYJHj5sOQaynq+mTd9C/S7N5VLAVlG
	0kUBwV5Q==;
Received: from [50.53.2.24] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t1GYf-0000000DaQT-3rjH;
	Thu, 17 Oct 2024 02:48:13 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: dri-devel@lists.freedesktop.org
Cc: patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH v2] drm/fbdev-dma: remove obsolete kernel-doc references
Date: Wed, 16 Oct 2024 19:48:13 -0700
Message-ID: <20241017024813.61908-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kernel-doc comments in these 3 files was removed so remove the
references to these files to prevent kernel-doc warnings.

drivers/gpu/drm/drm_fbdev_dma.c:1: warning: no structured comments found
drivers/gpu/drm/drm_fbdev_shmem.c:1: warning: no structured comments found
drivers/gpu/drm/drm_fbdev_ttm.c:1: warning: no structured comments found

Fixes: 731fddf4302e ("drm/fbdev-dma: Remove obsolete setup function")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/all/20241002142250.07e1c46c@canb.auug.org.au/
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: dri-devel@lists.freedesktop.org
---
Cc: patches@lists.linux.dev

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
 
