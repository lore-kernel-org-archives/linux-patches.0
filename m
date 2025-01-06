Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6CDE155C9E;
	Mon,  6 Jan 2025 15:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177532; cv=none; b=u4h09zzEqwN6ekzl8nmJKcPugzBBzRp2986N50yzlWHgcDf78WwDneKxwoxfW6esDYI9+/2hYJXoytLXCldeIcd3f4JCkrN/g/a4jl6kSNR90ob6sENDkHw0X/BwSKm1B+A97nYNVvAZE5EfB2fHXH1VhI3344lGVo6T6knHDr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177532; c=relaxed/simple;
	bh=LIJDMgoGMyBwhW6uKItoZuNuNavaOXvqkYVJDfH949g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GbF/aikJX8KXTBuNaXupaa8CER4o0gKYaC5HASz/BQS3dEcyuZnfILVxSRdi37MPqrYYwOV9wrK1l//T0xyDkv7UGY5zFiKiW367w0SVZ7rtBKAdpcdAhQ+FJo7ZGGS6Jt0AlwXx5Q6f/lgRuhNAp/xHPD0G5BykR6IV9ETysps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lHYVIVEe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lHYVIVEe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59889C4CED2;
	Mon,  6 Jan 2025 15:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177530;
	bh=LIJDMgoGMyBwhW6uKItoZuNuNavaOXvqkYVJDfH949g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lHYVIVEeBDd/4ZGTPpZ2OCNtBQJ5QF/M6v+VLD5vT2hgxnN6IpC4WMyRruuTQrbDc
	 6599NBXYYFbUY3hriJYEJvVDuItJVZXEqTm6zuhcEalXenqTFFEY2jBMOYd3PhR0iC
	 sXWuP6T0Dm8pFYZVcWZRKNSHebLGmzd7HSMznbIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinay Belgaumkar <vinay.belgaumkar@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 162/222] drm/i915/dg1: Fix power gate sequence.
Date: Mon,  6 Jan 2025 16:16:06 +0100
Message-ID: <20250106151156.894919476@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Rodrigo Vivi <rodrigo.vivi@intel.com>

[ Upstream commit 20e7c5313ffbf11c34a46395345677adbe890bee ]

sub-pipe PG is not present on DG1. Setting these bits can disable
other power gates and cause GPU hangs on video playbacks.

VLK: 16314, 4304

Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/13381
Fixes: 85a12d7eb8fe ("drm/i915/tgl: Fix Media power gate sequence.")
Cc: Vinay Belgaumkar <vinay.belgaumkar@intel.com>
Cc: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Reviewed-by: Vinay Belgaumkar <vinay.belgaumkar@intel.com>
Reviewed-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241219210019.70532-1-rodrigo.vivi@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit de7061947b4ed4be857d452c60d5fb795831d79e)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_rc6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_rc6.c b/drivers/gpu/drm/i915/gt/intel_rc6.c
index 9e113e947326..6e8c182b2559 100644
--- a/drivers/gpu/drm/i915/gt/intel_rc6.c
+++ b/drivers/gpu/drm/i915/gt/intel_rc6.c
@@ -133,7 +133,7 @@ static void gen11_rc6_enable(struct intel_rc6 *rc6)
 			GEN9_MEDIA_PG_ENABLE |
 			GEN11_MEDIA_SAMPLER_PG_ENABLE;
 
-	if (GRAPHICS_VER(gt->i915) >= 12) {
+	if (GRAPHICS_VER(gt->i915) >= 12 && !IS_DG1(gt->i915)) {
 		for (i = 0; i < I915_MAX_VCS; i++)
 			if (HAS_ENGINE(gt, _VCS(i)))
 				pg_enable |= (VDN_HCP_POWERGATE_ENABLE(i) |
-- 
2.39.5



