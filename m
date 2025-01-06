Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B173C15C120;
	Mon,  6 Jan 2025 15:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177876; cv=none; b=oAdLlksfiZ2Z6TLi0mbrhMbkmlg17sHYOMOpIKiPiA4h0toqF4EYO9UggWs6xu+EWb568sdoQjq/8xnMHS00vNxRxk1zoWGBaQS5/SNWqqbWJL6Lsq5ommUqrFoc8Hc1C0xpDKeITyTYU/BGf4ucjGqJ1Qy2cYA7nrH9fFxj5io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177876; c=relaxed/simple;
	bh=ZRGya5HBifPt1E4veVLcb+SwKYOYajOlxbFf4ujFgRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ezZojPIC0/RpaXb/xph0rzJDfdXxTw5Gvuc1W1h7Jr1ggtTC768Y4VJxblSDAhGfDw2O8SJ2AlxEzhoVQsskfEQKzkx8wuJ49WT+y6VV4X+ekdO9kW1MCsPwaQE55Xb6/fErVFjuNOs9D59nKntIXliwvmE3vHwXSaVNbfe7GEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YBE1STig; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YBE1STig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C41C4CED2;
	Mon,  6 Jan 2025 15:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177876;
	bh=ZRGya5HBifPt1E4veVLcb+SwKYOYajOlxbFf4ujFgRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YBE1STigOP9a4xGLQ07M2HaWXs6jjNKH+liAagO/rw3tHLhOyejnDwPRGn61DreNy
	 uhXyWuPZ9qtAZBVJPekNS4Gi7YDXixY0BHS702TDwTZe9ogwOmPZ1MoeZguP9voVWP
	 fhgWaDceyD+lA9KhsVtTLOo0YyH1TkeA1lRlU80w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinay Belgaumkar <vinay.belgaumkar@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 055/156] drm/i915/dg1: Fix power gate sequence.
Date: Mon,  6 Jan 2025 16:15:41 +0100
Message-ID: <20250106151143.807239302@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c864d101faf9..9378d5901c49 100644
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



