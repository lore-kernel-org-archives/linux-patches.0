Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06ED74F1E5;
	Tue, 14 May 2024 11:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686032; cv=none; b=gPSh+K2jpYyPnwWuK5HRlmS62b8y2+9zS9KyUNAz4f7N7hc7mP9vUDXIaZL5w3GXmRqJqhwk+bjn1XRry6wgGBMaspzXpmbGac/L1ZeeskUTHzDoZBWld+JfOlYEQqYDcFKD/XUGmUQRBZ2LYY4NE+v6vKmjBv22a4kk8AdR4Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686032; c=relaxed/simple;
	bh=Gc77fxOEn/Xpcbn66dOazfu4dQEVEQk2kIYjW0dXgtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZOkL9tnYL5H3911fY2uIjoJm0bRD6U6vdY6UK/GRjO4j4qUS90vD/Pni5uuPw5IbjtKAiz9v2k9KNg5HUWI/HqyDb5GiUsQcKNjWT88Zxu+1I3+wmjpcf+wafVD7RtstHN1q4l5zYqAUDSvg9sfSxS23axK0vyLQHDk0c25XcCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xpGz+vCO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xpGz+vCO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66434C2BD10;
	Tue, 14 May 2024 11:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686031;
	bh=Gc77fxOEn/Xpcbn66dOazfu4dQEVEQk2kIYjW0dXgtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xpGz+vCOZfqZ//2bUrTUyoU522hEpF2B/9sxNd5WdWkfNeugiVvtRd0qDySjkx8hj
	 vh4vtLYA9iAbjSKv0cWZnmnofGMuMrID08fgwr9HJosdxM+nsfHzR3PAmhUJx+B37q
	 LInurUF4faSGxz2fTfjmGMqqd9RurIIPVagn2k6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>
Subject: [PATCH 6.6 270/301] drm/vmwgfx: Fix Legacy Display Unit
Date: Tue, 14 May 2024 12:19:01 +0200
Message-ID: <20240514101042.457825780@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Forbes <ian.forbes@broadcom.com>

commit 782e5e7925880f737963444f141a0320a12104a5 upstream.

Legacy DU was broken by the referenced fixes commit because the placement
and the busy_placement no longer pointed to the same object. This was later
fixed indirectly by commit a78a8da51b36c7a0c0c16233f91d60aac03a5a49
("drm/ttm: replace busy placement with flags v6") in v6.9.

Fixes: 39985eea5a6d ("drm/vmwgfx: Abstract placement selection")
Signed-off-by: Ian Forbes <ian.forbes@broadcom.com>
Cc: <stable@vger.kernel.org> # v6.4+
Reviewed-by: Zack Rusin <zack.rusin@broadcom.com>
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240425200700.24403-1-ian.forbes@broadcom.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
index e5eb21a471a6..00144632c600 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
@@ -204,6 +204,7 @@ int vmw_bo_pin_in_start_of_vram(struct vmw_private *dev_priv,
 			     VMW_BO_DOMAIN_VRAM,
 			     VMW_BO_DOMAIN_VRAM);
 	buf->places[0].lpfn = PFN_UP(bo->resource->size);
+	buf->busy_places[0].lpfn = PFN_UP(bo->resource->size);
 	ret = ttm_bo_validate(bo, &buf->placement, &ctx);
 
 	/* For some reason we didn't end up at the start of vram */
-- 
2.45.0



