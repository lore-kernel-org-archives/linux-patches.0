Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7DF348C45;
	Thu, 28 May 2026 19:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998312; cv=none; b=mujUu52vh7t2YYUVgpNcCEYkWjs/nBVZcRyquNio34DDzyDppuBtTR59WJrA6GbW2gdhoYB7DxUZPpKuY46H3rMblwQ2IUkDLFLBhTL9du71d6aDtZdeksrcnTFJ8AcBiEcosV3suaklu4kewi0IyDbyiQKtJqczEg8j6Nbnpaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998312; c=relaxed/simple;
	bh=pmUKQ/J5WGw2YOvwhG9akNR/YqUzIFvHje7pwERnw8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GH6h1nsSEjF0zRIBnOUOfBsSy6hWu40k4UjCezIhrbIk7Q8HnYuLtBdiR0vo8Yr1aMGuzCKSxyKXPGrSXagCcsh7xRHMWDvJ7wQdHgnJiaCTyZvWibjA8wPQ1ESBhk/KRM6tmbL92RktELda1XtqK5LsIsc4KnEsndN5V0O/hYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d8zeFEZw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8zeFEZw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC5E1F000E9;
	Thu, 28 May 2026 19:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998310;
	bh=oN6m6TBfyxgXeu+bWprnViahLUrsEW0BK35ExmbeUpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d8zeFEZwEdiapZWztOi8WW4oeDGyu1mLUmZxSuyMaS9c6i8tcRLSIIXRtuKvpWY4p
	 1QVAUF2O0N5DcWaBqIZA+5hQm1KdZE5YZn2aeOGe7uAos3fGaJX/0bH5SWKrLX0r/S
	 QR6fOoWiJP5QNFahTHFLX2UHc5YO759Ff4wu2aac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidya Srinivas <vidya.srinivas@intel.com>,
	Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>,
	Uma Shankar <uma.shankar@intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>
Subject: [PATCH 7.0 129/461] drm/i915/display: Copy color pipeline from plane in the primary joiner pipe
Date: Thu, 28 May 2026 21:44:18 +0200
Message-ID: <20260528194650.722145700@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>

commit 86ed2d96db1965e9008e919b1936145ae66540e3 upstream.

When copying plane color state in a joiner configuration, use the plane in
the primary joiner pipe since it carries the pipeline number selected by
the user-space.

This assumes that all pipes in the joiner are symmetric in their plane
color capabilities.

Cc: stable@vger.kernel.org # v6.19+
Fixes: a78f1b6baf4d ("drm/i915/color: Add framework to program CSC")
Tested-by: Vidya Srinivas <vidya.srinivas@intel.com>
Signed-off-by: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
Reviewed-by: Uma Shankar <uma.shankar@intel.com>
Signed-off-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Link: https://patch.msgid.link/20260511053213.3122314-2-chaitanya.kumar.borah@intel.com
(cherry picked from commit e8308fb5e05ca08ddfb8b46f6d947a6e3fd80cd7)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_plane.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_plane.c b/drivers/gpu/drm/i915/display/intel_plane.c
index 5390ceb21ca4..82f445c83158 100644
--- a/drivers/gpu/drm/i915/display/intel_plane.c
+++ b/drivers/gpu/drm/i915/display/intel_plane.c
@@ -373,7 +373,7 @@ intel_plane_color_copy_uapi_to_hw_state(struct intel_plane_state *plane_state,
 	bool changed = false;
 	int i = 0;
 
-	iter_colorop = plane_state->uapi.color_pipeline;
+	iter_colorop = from_plane_state->uapi.color_pipeline;
 
 	while (iter_colorop) {
 		for_each_new_colorop_in_state(state, colorop, new_colorop_state, i) {
-- 
2.54.0



