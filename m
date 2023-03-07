Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6A1BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:31:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB90C433D2;
	Tue,  7 Mar 2023 18:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213866;
	bh=yNPdvSlvwnp472yH/0FNF5wu39G6ekhcKcjp2QiyD9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ITkjW4+S7faDc31xjTS3M3f7EvtMjj9qs1m0EIE9bojm4lbYSmYHsUtzmObD6mHV3
	 OTViWSv3LrKEW+NxqzWHja4aC8bBtKaq8m9M3H2BaUK//CVCVCHTmNPsR8FQmkHaJX
	 h7x+8K9LMa1qpbM8YD4iejqNQb5+OZD0fegTBzHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Asahi Lina <lina@asahilina.net>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 645/885] drm/shmem-helper: Revert accidental non-GPL export
Date: Tue,  7 Mar 2023 17:59:39 +0100
Message-Id: <20230307170030.181148844@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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



