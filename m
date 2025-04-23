Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E79B263F54;
	Wed, 23 Apr 2025 14:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419545; cv=none; b=bUffMYYduUim988Pj4Q4MEOZnNA4/zw3fCfzUJDIKwJxY3/eGIHmzzpmEelw8GR7KS0sxsC69jg0Pgp/0Kh8o3qEvIb4BQcdiWlqD83Gdu8jNrgiOw5bU1iIWCBbM0rmjglECjcKJEy2OLt2uWBQN7xX/QIVeBEhN3K6lfnV31g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419545; c=relaxed/simple;
	bh=J8cl/Ws4270xtumwYy/0Z8ABIbsEJqyXu9iltv2p66o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hFDhsN0LFXkPNbqwhJttXyyGqRwDhOCGNoiOOJ68rN4dARIgUMkUqhWpXJ8K2PwPH0M2MVDG/YbtkKIG19/CoRCsGymkHelc6wceZtLo3vb9pceYYxKTjUdunSzBuPUMQSffnWXcJKutCoro2CDoy5oaM6zB/8DPx1F/UNATKvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IM5tbWBM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IM5tbWBM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8F29C4CEE3;
	Wed, 23 Apr 2025 14:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419545;
	bh=J8cl/Ws4270xtumwYy/0Z8ABIbsEJqyXu9iltv2p66o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IM5tbWBMK5XrMUTBtdxwX1bkcz4ILnhJBJJ3mFOvB39UXy5D7hlqXw+1ZVNAr8jEk
	 WtbcBeRP7UgkgQyJDTShnBSFGDMkDdNfm/ZpDQem4guukilzwNfV6VHUbrEXxlSjpA
	 98ml/3eT53kXH0mvGV1WM8R+mp418SFyxd7eBhv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jani Nikula <jani.nikula@intel.com>,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	=?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 002/393] drm/i915/mocs: use to_gt() instead of direct &i915->gt
Date: Wed, 23 Apr 2025 16:38:18 +0200
Message-ID: <20250423142643.349925346@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit 5ed8c7bcf9a58372d3be3d9cd167e45497efaae2 ]

Have to give up the const on i915 pointer, but it's not big of a deal
considering non-const i915 gets passed all over the place.

Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Gustavo Sousa <gustavo.sousa@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Acked-by: Michał Winiarski <michal.winiarski@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/63e644f056c7745eb0e8e165c990c392a38ec85c.1696236329.git.jani.nikula@intel.com
Stable-dep-of: 9d3d9776bd3b ("drm/i915: Disable RPG during live selftest")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_mocs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_mocs.c b/drivers/gpu/drm/i915/gt/intel_mocs.c
index 07269ff3be136..353f93baaca05 100644
--- a/drivers/gpu/drm/i915/gt/intel_mocs.c
+++ b/drivers/gpu/drm/i915/gt/intel_mocs.c
@@ -487,7 +487,7 @@ static bool has_mocs(const struct drm_i915_private *i915)
 	return !IS_DGFX(i915);
 }
 
-static unsigned int get_mocs_settings(const struct drm_i915_private *i915,
+static unsigned int get_mocs_settings(struct drm_i915_private *i915,
 				      struct drm_i915_mocs_table *table)
 {
 	unsigned int flags;
@@ -495,7 +495,7 @@ static unsigned int get_mocs_settings(const struct drm_i915_private *i915,
 	memset(table, 0, sizeof(struct drm_i915_mocs_table));
 
 	table->unused_entries_index = I915_MOCS_PTE;
-	if (IS_GFX_GT_IP_RANGE(&i915->gt0, IP_VER(12, 70), IP_VER(12, 71))) {
+	if (IS_GFX_GT_IP_RANGE(to_gt(i915), IP_VER(12, 70), IP_VER(12, 71))) {
 		table->size = ARRAY_SIZE(mtl_mocs_table);
 		table->table = mtl_mocs_table;
 		table->n_entries = MTL_NUM_MOCS_ENTRIES;
-- 
2.39.5



