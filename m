Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5B6154426;
	Mon,  6 Jan 2025 15:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176803; cv=none; b=TvV5NK2XTlQpja+ZjjWW9N7UVqR8QncVVfX1Mbxdun15j/EqpFQbzC32a7dp9q+KRP9IlBkaACL7iNPdFJ7xucxyWC8rXBraM8rEN3qFwBTXqRJAYXyDSvSalSYDkrc3+CgcElpBaKqWK5Jt4tt4efnbzMT/wmFefAu/XFFb33s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176803; c=relaxed/simple;
	bh=RD/Jlenm/x1oMRS1OtpNdQQuN6ID+fz7YwmNTCFllp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J0b8GKDmzvZ7u3Hr3nXxAejEtf7a7PZ5+muP/zLBcBw49/ljW8/TKPmynoY1iLJ9PNinPACPEY0Txt/xL2sasZWzxP0Vl31et89yvgMFv54HQjVKjqNBmveA3cJLex8z4AvdVLAaxcUtrkDFAm3mDbogI4/RASGS1G1+3aw5rBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wMK3o6wh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wMK3o6wh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF75CC4CED2;
	Mon,  6 Jan 2025 15:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176803;
	bh=RD/Jlenm/x1oMRS1OtpNdQQuN6ID+fz7YwmNTCFllp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wMK3o6whvHDFeoPb7Y2fT3IgYvse+XsegrGMP+VVP6SBgFmnn6WdTv5dUl/1QXUvQ
	 9UirhJ8b30NOmju19x24g4vhfqVaAr4qpg3m3elHtMMfF4dRoQOLY3wiWfab6h5MyN
	 D886kNp9ntltnytHwHDPjjNKdJCvX0ZZeLTjomUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinay Belgaumkar <vinay.belgaumkar@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 37/81] drm/i915/dg1: Fix power gate sequence.
Date: Mon,  6 Jan 2025 16:16:09 +0100
Message-ID: <20250106151130.839042645@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151129.433047073@linuxfoundation.org>
References: <20250106151129.433047073@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f8d0523f4c18..d1dcb018117d 100644
--- a/drivers/gpu/drm/i915/gt/intel_rc6.c
+++ b/drivers/gpu/drm/i915/gt/intel_rc6.c
@@ -134,7 +134,7 @@ static void gen11_rc6_enable(struct intel_rc6 *rc6)
 			GEN9_MEDIA_PG_ENABLE |
 			GEN11_MEDIA_SAMPLER_PG_ENABLE;
 
-	if (GRAPHICS_VER(gt->i915) >= 12) {
+	if (GRAPHICS_VER(gt->i915) >= 12 && !IS_DG1(gt->i915)) {
 		for (i = 0; i < I915_MAX_VCS; i++)
 			if (HAS_ENGINE(gt, _VCS(i)))
 				pg_enable |= (VDN_HCP_POWERGATE_ENABLE(i) |
-- 
2.39.5



