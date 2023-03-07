Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA555BA4F
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 19:05:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 448AAC4339B;
	Tue,  7 Mar 2023 19:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215956;
	bh=FH2nVgYtKe2FUxEeSC+uBqU4W5d8yP806RtSX2KjXiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0SzTtNJgLhFOjgZuP3vK+GbgLcBUF1CbLt9niCplcabpguakqMQxwK8IwYofpCUdW
	 g0Vh0az2yYi4u0fcgwP0wcariFGNlYTVTUougIzlWC753Apl4DrRukLS3Hle8WEw8X
	 9fbHEOX0sLWlKRDNzrZ+ICoXpWyRhhjbK7z6E4x4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Asahi Lina <lina@asahilina.net>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 427/567] drm/shmem-helper: Revert accidental non-GPL export
Date: Tue,  7 Mar 2023 18:02:43 +0100
Message-Id: <20230307165924.393304038@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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
index 1af541c12a45f..d58e8e12d3ae8 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -717,7 +717,7 @@ struct sg_table *drm_gem_shmem_get_pages_sgt(struct drm_gem_shmem_object *shmem)
 
 	return sgt;
 }
-EXPORT_SYMBOL(drm_gem_shmem_get_pages_sgt);
+EXPORT_SYMBOL_GPL(drm_gem_shmem_get_pages_sgt);
 
 /**
  * drm_gem_shmem_prime_import_sg_table - Produce a shmem GEM object from
-- 
2.39.2



