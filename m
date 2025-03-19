Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB741DDA36;
	Wed, 19 Mar 2025 14:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394980; cv=none; b=aEWguskkb3HuYwa+ZxomN2HWdNc6RIA9uJB5R42J2eQhd8dJi+obTlvgmURd9pePGiYTNJGC2/d/JO1iuCVRjn8qIsvn1iIvShkOKPfqlmQdP+5AP6I5YXkTIykobmRpmeahn5KDWeTQpFY3dXv2o9XRFv6VV8CmzavepJjXTqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394980; c=relaxed/simple;
	bh=TM9RzQBsv/Cz2xixmjmfE+uAknx1jxYerQAfONB90II=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HALKA2RizsPoONLtyDAPJz9R6mG0lIdcwdX6hXkkM3sdfs3c0bxOxtTuJfJaYR7tB6QY3VMDCqUz+8nCLhQowK4V/iprZCDRXKqUD5CAwinCzLXkL/tWTmC3vXLFX2HZC7LyW+TmPPDvsaOW4O4BhJC2QwjV7kQj5Vkju0O+qtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YafZKPdX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YafZKPdX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF0D1C4CEE4;
	Wed, 19 Mar 2025 14:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394980;
	bh=TM9RzQBsv/Cz2xixmjmfE+uAknx1jxYerQAfONB90II=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YafZKPdXosXo1VVayHMv+U6DYNJMyE2vgr24lLzewMAfcZnF1wn+/R4QsKLsVwmsb
	 eSnf6JyK55SVh8Hlz5Bp+OD5pyIXokhfKj7/miHYPm8hT7NR8ujNXR5ime3+bM7LBc
	 LXYsB9Gajjp3jF6Do6f9//FfICqWzGS8ZvCcPMag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
	=?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 218/241] drm/i915: Increase I915_PARAM_MMAP_GTT_VERSION version to indicate support for partial mmaps
Date: Wed, 19 Mar 2025 07:31:28 -0700
Message-ID: <20250319143033.140880796@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: José Roberto de Souza <jose.souza@intel.com>

[ Upstream commit a8045e46c508b70fe4b30cc020fd0a2b0709b2e5 ]

Commit 255fc1703e42 ("drm/i915/gem: Calculate object page offset for partial memory mapping")
was the last patch of several patches fixing multiple partial mmaps.
But without a bump in I915_PARAM_MMAP_GTT_VERSION there is no clean
way for UMD to know if it can do multiple partial mmaps.

Fixes: 255fc1703e42 ("drm/i915/gem: Calculate object page offset for partial memory mapping")
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Cc: Nirmoy Das <nirmoy.das@intel.com>
Cc: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Signed-off-by: José Roberto de Souza <jose.souza@intel.com>
Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250306210827.171147-1-jose.souza@intel.com
(cherry picked from commit bfef148f3680e6b9d28e7fca46d9520f80c5e50e)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_mman.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_mman.c b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
index 21274aa9bdddc..c3dabb8579605 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_mman.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
@@ -164,6 +164,9 @@ static unsigned int tile_row_pages(const struct drm_i915_gem_object *obj)
  * 4 - Support multiple fault handlers per object depending on object's
  *     backing storage (a.k.a. MMAP_OFFSET).
  *
+ * 5 - Support multiple partial mmaps(mmap part of BO + unmap a offset, multiple
+ *     times with different size and offset).
+ *
  * Restrictions:
  *
  *  * snoopable objects cannot be accessed via the GTT. It can cause machine
@@ -191,7 +194,7 @@ static unsigned int tile_row_pages(const struct drm_i915_gem_object *obj)
  */
 int i915_gem_mmap_gtt_version(void)
 {
-	return 4;
+	return 5;
 }
 
 static inline struct i915_gtt_view
-- 
2.39.5



