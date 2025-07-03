Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D66F1DB124;
	Thu,  3 Jul 2025 14:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554051; cv=none; b=Xr844fFYDp/z6GS/WPBpLMzdjhZLQwU8GMMT7/sdcDpzSS5He4vr5+2VfDzR+z07nFDs9CEY40UApmelcAC/tLSDNekhs3FcM59s9yUgYidSrZGJ4AQ2sXr32ErTJp/a03mX9iM9A+FUN1g/YjYpIDofDF5hmR04xFSXMcjl7lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554051; c=relaxed/simple;
	bh=zUdKABbyqhMCd8pWMtDBHsqKmkk9P+3gL3+wkRJTx84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UBopUsMT7xfSkMp2DAUZ9XMOR1cS9/mZjy9Wzpmkuhn/MzPQ4WLOnGIkGxZq1fNDYbWWdv2fjzLwDp2t4tIMLGSVhU9pZT7+JHRn5Ix1+rDK4bq3JIILLXBwvqr/astSyBvJXUXLVwOwdUiw/96tqqfk6OpRM/ZtUN4CbReyiwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mNn3P/8W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mNn3P/8W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C2B4C4CEED;
	Thu,  3 Jul 2025 14:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554051;
	bh=zUdKABbyqhMCd8pWMtDBHsqKmkk9P+3gL3+wkRJTx84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mNn3P/8W8CDS3KKH+eWf9CIQ5+szieMv74THZRtMfQx+AbNe71u5Rh//Sw8flDety
	 PA+huEu9q5pIdv9MRrs+6R9NqJa2fuqd00a10cV/B+tK6zRWpoEx5jQ/ZPtu72DgGx
	 YQEUCKXuwxVDxk63cWNeN3WgtN7Vq/aY0ssadPRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 058/218] drm/i915/gem: Allow EXEC_CAPTURE on recoverable contexts on DG1
Date: Thu,  3 Jul 2025 16:40:06 +0200
Message-ID: <20250703143958.264616116@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit 25eeba495b2fc16037647c1a51bcdf6fc157af5c ]

The intel-media-driver is currently broken on DG1 because
it uses EXEC_CAPTURE with recovarable contexts. Relax the
check to allow that.

I've also submitted a fix for the intel-media-driver:
https://github.com/intel/media-driver/pull/1920

Cc: stable@vger.kernel.org # v6.0+
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Testcase: igt/gem_exec_capture/capture-invisible
Fixes: 71b1669ea9bd ("drm/i915/uapi: tweak error capture on recoverable contexts")
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20250411144313.11660-2-ville.syrjala@linux.intel.com
(cherry picked from commit d6e020819612a4a06207af858e0978be4d3e3140)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Stable-dep-of: ed5915cfce2a ("Revert "drm/i915/gem: Allow EXEC_CAPTURE on recoverable contexts on DG1"")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
index a3b83cfe17267..841438301d802 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -2014,7 +2014,7 @@ static int eb_capture_stage(struct i915_execbuffer *eb)
 			continue;
 
 		if (i915_gem_context_is_recoverable(eb->gem_context) &&
-		    (IS_DGFX(eb->i915) || GRAPHICS_VER_FULL(eb->i915) > IP_VER(12, 0)))
+		    GRAPHICS_VER_FULL(eb->i915) > IP_VER(12, 10))
 			return -EINVAL;
 
 		for_each_batch_create_order(eb, j) {
-- 
2.39.5



