Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7491A3BCA;
	Thu, 15 Aug 2024 14:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730794; cv=none; b=Jipmc1cQCZfnMeC7vPoHzJDMyyh/jZ3N8b3/JB7z4b5UWDWLF+FYb0Cz1qQ5tb/7g7rYUgPP+mv2zsMR6W/jYBGXUy62jtY6fsEYRZt0w2PjNdAF/+wDrlcobrhKoKyk7Sl44250FvJV/7wn6XyhYCaw2Wvy5ZYYGL6SbRpXrjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730794; c=relaxed/simple;
	bh=iCYHDXCl7ZiTHJwOra1hJap6rkFncKSRXxB3i0YnQzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dmw7IDwiPGyboDxATUTGhsYzsjK1maSH7FTQK7+682VxIS4tZlK09Wz1aWk4LE8mUai3k0JgoV8yF+vYzV93NNYVTxgHoS89/UYd+N2e6qoja4GFdi7EJsXaazZD3sG5w2v5ge3nT9lPpvJ6crggeIExCyIgUQdcoLvtZS8+AP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S0M8OOSp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S0M8OOSp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE42C32786;
	Thu, 15 Aug 2024 14:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730794;
	bh=iCYHDXCl7ZiTHJwOra1hJap6rkFncKSRXxB3i0YnQzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S0M8OOSps6r4+5epfM0N293529VRBiP9gCa1tYD1c49aKfuaYOieWvYJEGa09tfSs
	 IIL1d3glBXcKAfVV1WtJU2zTbytGtRWfMo2LqJMW6EZK7B536XyYSUQ0gytYqAqqUX
	 7GU4xN41h54bwvTTCtSWeELs0Dy5zeaLzKde2ymo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 33/38] drm/i915: Fix a NULL vs IS_ERR() bug
Date: Thu, 15 Aug 2024 15:26:07 +0200
Message-ID: <20240815131834.230747188@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131832.944273699@linuxfoundation.org>
References: <20240815131832.944273699@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 3a89311387cde27da8e290458b2d037133c1f7b5 ]

The mmap_offset_attach() function returns error pointers, it doesn't
return NULL.

Fixes: eaee1c085863 ("drm/i915: Add a function to mmap framebuffer obj")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/ZH7tHLRZ9oBjedjN@moroto
Stable-dep-of: 1ac5167b3a90 ("drm/i915/gem: Adjust vma offset for framebuffer mmap offset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_mman.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_mman.c b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
index 180b66f6193cb..4a291d29c5af5 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_mman.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
@@ -1118,8 +1118,8 @@ int i915_gem_fb_mmap(struct drm_i915_gem_object *obj, struct vm_area_struct *vma
 		/* handle stolen and smem objects */
 		mmap_type = i915_ggtt_has_aperture(ggtt) ? I915_MMAP_TYPE_GTT : I915_MMAP_TYPE_WC;
 		mmo = mmap_offset_attach(obj, mmap_type, NULL);
-		if (!mmo)
-			return -ENODEV;
+		if (IS_ERR(mmo))
+			return PTR_ERR(mmo);
 	}
 
 	/*
-- 
2.43.0



