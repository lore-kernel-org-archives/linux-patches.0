Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BF92E7F1A;
	Thu,  3 Jul 2025 14:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554793; cv=none; b=JUcaIC531JuhwIHTy+T/OitFTxpDVQNEZq64oTwewlrU3U8DNMaH5ZvgBUGXiQH3qo+LUUnkpZACADCAFfT100WZ9ZO0J4uE0vCAPGnoMX0HJhCsu86IIM43MOdFhOTFARvmBPnsO8KmqZYnUdCsbJG8OSZa1jEBY+n6Lco1uM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554793; c=relaxed/simple;
	bh=F9+VP7ENzMkxnUGuDZ1MQEg98U+HovtH6sMdaHSk/uM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rCSrloWiY4nNhUb7Aeq68EvHumZPqKn0AL3fB6zn5J0N2Oe9WFY+/Jdy4vhPVDVba5rdEYcKcQrpgbvilM/XzuJaI5YJHjFhmOcG0xc8tmr1JO5VXn1S1wFZMfXCbJ4sWmMZAdoF8P9hQpf/K9AoVFDjMEE5hsHRK7GLYAYXZ/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FyJYq9eh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FyJYq9eh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69FFFC4CEE3;
	Thu,  3 Jul 2025 14:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554792;
	bh=F9+VP7ENzMkxnUGuDZ1MQEg98U+HovtH6sMdaHSk/uM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FyJYq9ehlThaJmaBQ48lLO4ND7arhTzwA5OVdMRqNXfKdgdgr9AklJEvD316v0G6R
	 5ZKv9LHTnbs24artWpDlQyMbYEqz2ootJlNUJNwWtx0e1YZlw1NdNnsJHoIx0Z92wV
	 y8/CaxGCARn4vCNkzqyiB5qJtkP+5eZ9O0BK+n6w=
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
Subject: [PATCH 6.15 080/263] drm/i915/gem: Allow EXEC_CAPTURE on recoverable contexts on DG1
Date: Thu,  3 Jul 2025 16:40:00 +0200
Message-ID: <20250703144007.506696063@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7796c4119ef5e..1974a300b24a1 100644
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



