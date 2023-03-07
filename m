Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC725BA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:44:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CAFEC433EF;
	Tue,  7 Mar 2023 17:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211066;
	bh=yNPdvSlvwnp472yH/0FNF5wu39G6ekhcKcjp2QiyD9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qKw+T1LilWQB9lX/o2q7Gc7Aw2PmmW4eWZU+RMX738JPGiHVqkI8UudFSsdO6o5+x
	 gzAxvwkC4UjHYQK33wAacMzVUrzsLJxpoTrJ9xQ0fCx3yqdrqT3S3YoFIY93xjFfu6
	 rSZAjQ4xRR8L4X+kDJ9Z/7bYj2jRtzJSGUNw1zqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Asahi Lina <lina@asahilina.net>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0742/1001] drm/shmem-helper: Revert accidental non-GPL export
Date: Tue,  7 Mar 2023 17:58:34 +0100
Message-Id: <20230307170053.938697174@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Asahi Lina <lina@asahilina.net>

[ Upstream commit 047a754558d640eaa080fce3b22ca9f3d4e04626 ]

The referenced commit added a wrapper for drm_gem_shmem_get_pages_sgt(),
but in the process it accidentally changed the export type from GPL to
non-GPL. Switch it back to GPL.

Reported-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Fixes: ddddedaa0db9 ("drm/shmem-helper: Fix locking for drm_gem_shmem_get_pages_sgt()")
Signed-off-by: Asahi Lina <lina@asahilina.net>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20230227-shmem-export-fix-v1-1-8880b2c25e81@asahilina.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index 2c559b310cad3..7af9da886d4e5 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -747,7 +747,7 @@ struct sg_table *drm_gem_shmem_get_pages_sgt(struct drm_gem_shmem_object *shmem)
 
 	return sgt;
 }
-EXPORT_SYMBOL(drm_gem_shmem_get_pages_sgt);
+EXPORT_SYMBOL_GPL(drm_gem_shmem_get_pages_sgt);
 
 /**
  * drm_gem_shmem_prime_import_sg_table - Produce a shmem GEM object from
-- 
2.39.2



