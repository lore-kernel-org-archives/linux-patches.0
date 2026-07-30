Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 877FA1AF0BB;
	Thu, 30 Jul 2026 14:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421558; cv=none; b=YYo9PcVk4hHwfgv5ZfnQvcaapamkWrl5rORE0ubaFjYw+rP81xHhZQltiBZWhfIvjM45QwQs2ea751QMQFn003gYewSleZ16d+b6eAsB9DUKo9MNGf3ycsWofq5VkOL1z41POgQmGGUl9LbRti6fmhAmhUrmbYLsaDqEgGLR5ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421558; c=relaxed/simple;
	bh=Qvvh0pKt8+89eQj2VgWH308+wrLal+Qwj5mKA8rM8nE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=neoyHLWFyjoApon+/ARaMPDJIO3WyHUVbbAlZHh5ZKODjVezKDVvpADKVVcCA4TVhXnvfxYLVhbZgDTPzEVssio64UbzGB2awNiiMfCl4y8PMGcn/caU9x0xs4fYG5wn3AnsScU1d5fXdGX32ANL7Z9/4e+q7UqPVyernILdFhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HVj0bgQF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HVj0bgQF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D25151F00A3A;
	Thu, 30 Jul 2026 14:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421557;
	bh=vES3OoRUxc3GUeQaZbnQizFP3I86WZmqejwt1LkYZgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HVj0bgQF+b1mo5JG4IXq6e7Hlow66uQ1wzDBkN337ItWvxGOQE3Fi2qbrt0ZGHeR3
	 RoFY1+PELX57umqfqxupk8L/P0P/xSAdH8iGIr5Wbwn8bIMT/GLIUD1Ll9v8tI4rl4
	 sLjTUSMwlUQ9tvOqtJoqN4iZ/RDrQKSVi16tuez8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinod Govindapillai <vinod.govindapillai@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 127/744] drm/i915/wm: clear the plane ddb_y entries on plane disable
Date: Thu, 30 Jul 2026 16:06:40 +0200
Message-ID: <20260730141446.981777866@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinod Govindapillai <vinod.govindapillai@intel.com>

[ Upstream commit e89978c1cff54e265345c66e1177d19ea5a8bc00 ]

The UV/Y plane DDB entriess are never cleared on
sk_wm_plane_disable_noatomic() and can leave stale DDB state
for NV12 planes on pre-Gen11 devices

Fixes: d34b59d5ba41 ("drm/i915: Add skl_wm_plane_disable_noatomic()")
Assisted-by: Copilot:claude-sonnet-4.6
Signed-off-by: Vinod Govindapillai <vinod.govindapillai@intel.com>
Reviewed-by: Suraj Kandpal <suraj.kandpal@intel.com>
Link: https://patch.msgid.link/20260615203355.218578-2-vinod.govindapillai@intel.com
(cherry picked from commit 60f68a6ba298fd1e971a2d91576304bee89a16fc)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/skl_watermark.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/skl_watermark.c b/drivers/gpu/drm/i915/display/skl_watermark.c
index e0ac4e2ce4dcb6..29b7661f88141d 100644
--- a/drivers/gpu/drm/i915/display/skl_watermark.c
+++ b/drivers/gpu/drm/i915/display/skl_watermark.c
@@ -3908,7 +3908,7 @@ void skl_wm_plane_disable_noatomic(struct intel_crtc *crtc,
 		return;
 
 	skl_ddb_entry_init(&crtc_state->wm.skl.plane_ddb[plane->id], 0, 0);
-	skl_ddb_entry_init(&crtc_state->wm.skl.plane_ddb[plane->id], 0, 0);
+	skl_ddb_entry_init(&crtc_state->wm.skl.plane_ddb_y[plane->id], 0, 0);
 
 	crtc_state->wm.skl.plane_min_ddb[plane->id] = 0;
 	crtc_state->wm.skl.plane_interim_ddb[plane->id] = 0;
-- 
2.53.0



