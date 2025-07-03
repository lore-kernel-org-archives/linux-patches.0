Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA1472610;
	Thu,  3 Jul 2025 14:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554087; cv=none; b=NorZRo8vHAI6+k1LlFbmcOhw6PVzeduvlWo73wPL/6mEN5waRutEkeipqJNaC6z+W0W//i/T/vpvsiaPY3pQh/mhH66ppMqEI5EptkjkvP/nKMZXOIOnCTKsUFGfigHMiEl3dqQ8tuxod6Fmp5kCn2QtLk3+62JbhX+bD4jQHPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554087; c=relaxed/simple;
	bh=eDHxOLUn6KWcpKw5VJbTS0+dj42du5Pmam/1uX89iis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YCGSjXwDJjeOS9cj6Ns7rKd9+hKlCk8p0+mT9DcToRgcDm1fIltKnvXxo0G3L/9N/iVfQlAo4BPzttIoqnivrMY/Z1LXO7xLnZzwtIRxRfKd0DYficA5rr6Dzf/lqSGr4Fa4GW7c2WuwujU1dFI+CS66BkwkoqN5jYI7eKH8Pyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dJDu61Ze; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dJDu61Ze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C10F8C4CEE3;
	Thu,  3 Jul 2025 14:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554087;
	bh=eDHxOLUn6KWcpKw5VJbTS0+dj42du5Pmam/1uX89iis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dJDu61Zevw67ayOkAaVGsv96vsG+h4GQ4jJjJKJnHrkpFGnOjkjnv2PCO3+vYQang
	 dEzAEKVVjDmDDdNJli5yEZP3roZt13+JpGMVuSgFuzBfxBcWyqAs3bGr7nbya51t+h
	 GIRHGw3j84K25XLff5bbkXng6tKPzLJlfwTSetZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 059/218] Revert "drm/i915/gem: Allow EXEC_CAPTURE on recoverable contexts on DG1"
Date: Thu,  3 Jul 2025 16:40:07 +0200
Message-ID: <20250703143958.304605702@linuxfoundation.org>
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

From: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>

[ Upstream commit ed5915cfce2abb9a553c3737badebd4a11d6c9c7 ]

This reverts commit d6e020819612a4a06207af858e0978be4d3e3140.

The IS_DGFX check was put in place because error capture of buffer
objects is expected to be broken on devices with VRAM.

Userspace fix[1] to the impacted media driver has been submitted, merged
and a new driver release is out as 25.2.3 where the capture flag is
dropped on DG1 thus unblocking the usage of media driver on DG1.

[1] https://github.com/intel/media-driver/commit/93c07d9b4b96a78bab21f6acd4eb863f4313ea4a

Cc: stable@vger.kernel.org # v6.0+
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Acked-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://lore.kernel.org/r/20250522064127.24293-1-joonas.lahtinen@linux.intel.com
[Joonas: Update message to point out the merged userspace fix]
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
(cherry picked from commit d2dc30e0aa252830f908c8e793d3139d51321370)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
index 841438301d802..a3b83cfe17267 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -2014,7 +2014,7 @@ static int eb_capture_stage(struct i915_execbuffer *eb)
 			continue;
 
 		if (i915_gem_context_is_recoverable(eb->gem_context) &&
-		    GRAPHICS_VER_FULL(eb->i915) > IP_VER(12, 10))
+		    (IS_DGFX(eb->i915) || GRAPHICS_VER_FULL(eb->i915) > IP_VER(12, 0)))
 			return -EINVAL;
 
 		for_each_batch_create_order(eb, j) {
-- 
2.39.5



