Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59CE52B1C8;
	Mon, 31 Aug 2026 13:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183880; cv=none; b=WqV7VQX2PzQgOJIQHvF0VNdLdakFlcC7SEXwV89yaCLR5fV1G3CuwHUVJiBJmtSuByAXyJU/M5LXyTwx0BsVs/bCOWLAkP1HX7VyM6wbafQWuJm5e+4A0kTF33d9zp/L0R9o1K4Kdm1A94vBSIHh/LthCruWYkuHdNtvwlyQ0v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183880; c=relaxed/simple;
	bh=sb8dpUN2hbrGQSjXREIMP/gjRoH0MDBt+aHPV8RFPc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DNXhOOTK32hAM5qiTD5y180uyVZmQeh9+OCkYbVDpY1u2kNrpZ52HzrYl0WgGepuq43xhx53VP1IH6eQnHchslhayvoG0qkq/GEXm9PMR3LeW+sYnGq3Er5mznkjfOVWS8Hl4lnHKmbZ6EBFT6LVYk1ruKTpACJlOBG29fVDlRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dJjn2BRl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dJjn2BRl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20BBC1F00ACF;
	Mon, 31 Aug 2026 13:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183878;
	bh=QwYnHj3cltivoVTF2AufhtInubvueKHuHYcq4uUZHPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dJjn2BRlBoerXo54P1VtDjfM7pJBgZ+0IkAVjex1YR2CCUPVT+lG/wRgZk633pasy
	 3mYAr94VD4nNCHa31XvsNTotGLD258nJ82gQRvyimZfOCvcQnr90/IO762apecoF6h
	 FJdRYLPPpbNGwdGF1JI/iXJiXT9L/p0GMnTfyOTDEOABC6YpTIEUVew9gGG6EWtu8s
	 6wxI0pJ+bWwyqh7TkI3jo2O08O4xFOYpd6sLK5IEhtwKJRvSDbq1t92Zl6lD7IJcHk
	 JQVs7OPiPGhmDvPVtoKka5bDd3AP14Z8dU3R3JYLdRKE3wObw49o3fRMefyFx32y6K
	 9NvXW/9QgD2oA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Boris Brezillon <boris.brezillon@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] drm/gem: Consider GEM object reclaimable if shrinking fails
Date: Mon, 31 Aug 2026 09:26:25 -0400
Message-ID: <20260831133314.4125787-357-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit 71c8224a18825102ee1e5e70498f96f6c2d2a81d ]

If the object wasn't moved to a different LRU after the shrink callback
returns, it means the buffer is still reclaimable. Update the remaining
counter to reflect that.

v2:
- Collect R-b

v3:
- Collect R-b

v4:
- No changes

v5:
- No changes

v6:
- No changes

v7:
- No changes

Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Link: https://patch.msgid.link/20260401134854.2275433-2-boris.brezillon@collabora.com
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background `b4 dig` on the original `drm_gem_lru_scan` introduction
commit (`a4871e6201c46`) finished successfully. It matched the Thomas
Zimmermann May 2025 thread:
https://patch.msgid.link/20250520094203.30545-5-tzimmermann@suse.de

That lines up with the earlier finding that the helper and the missing
`*remaining` accounting have been in this tree since `drm_gem.c` landed;
the Boris Brezillon patch is a small, standalone fix on top of that.

For **Linux 6.18.43**, the backport recommendation remains **YES**.

 drivers/gpu/drm/drm_gem.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index 5c4a113b08941..224ed96bd0d4a 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -1601,6 +1601,16 @@ drm_gem_lru_scan(struct drm_gem_lru *lru,
 			 */
 			WARN_ON(obj->lru == &still_in_lru);
 			WARN_ON(obj->lru == lru);
+		} else if (obj->lru == &still_in_lru) {
+			/*
+			 * If the object wasn't moved and wasn't shrunk either,
+			 * it's still remaining as reclaimable. Note that
+			 * obj->lru is supposed to be checked with the LRU lock
+			 * held for an accurate result, but we don't care about
+			 * accuracy here. Worst thing that could happen is an
+			 * extra scan.
+			 */
+			*remaining += obj->size >> PAGE_SHIFT;
 		}
 
 		dma_resv_unlock(obj->resv);
-- 
2.53.0

