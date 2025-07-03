Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107182EFD98;
	Thu,  3 Jul 2025 15:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555978; cv=none; b=C9rCTTPrRvbwoLU6gMsCxqt/HoG81dHZyE9FczHi5P8V6UtSKoy/YyfVm5GzNPKU/TIjqQG2yzdKPsxW9/u68mUX4Frp7IcVvCkj/WjEDlshdPCVY79V47G27YFAhkX8DyU5qdhB24G5A5l8AQeobG7F2SfiiosNakMpyjqrjCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555978; c=relaxed/simple;
	bh=JuWBeY1yX5Opz/pVZRzVBVV+a1l2ahFOjXgT1Zk2iLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f8Ws9NSZICHVwH4NaOIX016cWAx4JxbGwPZAUMKSWdS5yVzKs2XCvklEFjclPkOVOPzzaOK9WH2Fw7V1vCzWJ8e1PAlf0LTLMiJJhhCkGOEw2i/X/favATr1I2XGurqN9R+bxRENiTRDAXp161Xz6jbFSnNK7SwYWQchPbmjoqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jXFIqU0M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jXFIqU0M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D31C4CEE3;
	Thu,  3 Jul 2025 15:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555977;
	bh=JuWBeY1yX5Opz/pVZRzVBVV+a1l2ahFOjXgT1Zk2iLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jXFIqU0MHe3GJoaCkm3nF15fGvXpAFfi5qS8MN6JbKFSM3djVARY9E2VnqZf8Ynu8
	 QyuHFQlCns2alUDvoNH8q4vX8K8iJ3LpCXLzrZCZkZ9XJrh5JKQAdNUwyMcxNfmQP8
	 kBFJ4n9lwXoir0Qe9l47OdRTIgbc25e6KPFzK8XY=
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
Subject: [PATCH 6.1 037/132] drm/i915/gem: Allow EXEC_CAPTURE on recoverable contexts on DG1
Date: Thu,  3 Jul 2025 16:42:06 +0200
Message-ID: <20250703143940.881401104@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0a123bb44c9fb..9424606710a10 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -2001,7 +2001,7 @@ static int eb_capture_stage(struct i915_execbuffer *eb)
 			continue;
 
 		if (i915_gem_context_is_recoverable(eb->gem_context) &&
-		    (IS_DGFX(eb->i915) || GRAPHICS_VER_FULL(eb->i915) > IP_VER(12, 0)))
+		    GRAPHICS_VER_FULL(eb->i915) > IP_VER(12, 10))
 			return -EINVAL;
 
 		for_each_batch_create_order(eb, j) {
-- 
2.39.5



