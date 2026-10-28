Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213708;
	b=X58XRdG3Qdeyv98Wg1+/ceDenyCQW+k1gvxLD3tcjCjE3C69oaeb6B5Z1qYFGUDqcEU3
	 bfvFBNRia+oH4Ak1xsly1osT2sXkd+VVK2/yw37rjv2R60jGx56DNGVRBehX7j3t7N6yi
	 bDCqf0GQGOC2GWSPaWBGoWHF3hJLlzSWo8vr3OcXlFgW0UJZrb8wg7vQRQ8hkREpffP6h
	 QlH7ylWRrL0ld57vpUcPbQSE0IvNWZclQW6lQvGM/tAn4VMtuMxoplFWndr5jxCc2zUgh
	 ewTaMLU/nykeBvx/VqVyIl1yOPct/Etym01kISsh9KPoY/YRlPMx2AXrF6AloTEVPTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213708;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NiICB2epTg00shcnn34LDceK79XF/uYblrD9Ey3fUck=;
	b=c3eQi9uKT7xNKfbrYlxRZU2QL06C0mQyPsE6Fp+/C1XSgZa9S2y9mTZPc+qXob/Ez/rw
	 iM2XpsEnHunPeHfHtAVdD4SfoWad80za/q+63+OMEjlu7A8ONJpxVy8lS0Mksc53EfDjN
	 o4//dGQS/EyDyBK90TDx74IiNxBsP1HnXqAvkPnQQCIScEFVvGlkp9Fi6oZiQgNRG9Kq7
	 tl9RSDKWP/5p1oneHicaBvOzmJzyT/uisAMBz5xS/4K06Anx9NxoNQ3wDeuMBSR3QRT/o
	 dlQHVlPOKffwDFudQQFPo86dmS21cXTVOYydf4MzEWBg/XK3qfRJcU6t51vZ5eMrCwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=peKybH22;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B34606A31D;
	Wed, 28 Oct 2026 18:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=peKybH22
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 210C01F01825;
	Wed, 28 Oct 2026 18:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213707;
	bh=NiICB2epTg00shcnn34LDceK79XF/uYblrD9Ey3fUck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=peKybH22CGGrG/cu9zP2rSKsq6TaR3W3nfJe8CL1bujOJkr+boCjbJJYuh0YgPhvF
	 qsNllMsNTKSrtnuFFcwXsVT86ZXJxJTEp7rujgsrOT40lkXqgHf2Bc+FmVbxSwOGUK
	 2kSHtzAYB+PnldO0YoWO2msGfih85is+ix4bH7Jw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0601/1887] drm/amd/display: fix NULL checks for adev->dm.dc in amdgpu_dm_fini()
Date: Wed, 28 Oct 2026 17:44:57 +0100
Message-ID: <20261028170513.092401853@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

[ Upstream commit 2a3cfb9a24a28da9cc13d2c525a76548865e182c ]

Since 'adev->dm.dc' in amdgpu_dm_fini() might turn out to be NULL
before the call to dc_enable_dmub_notifications(), check
beforehand to ensure there will not be a possible NULL-ptr-deref
there.

Also, since commit 1e88eb1b2c25 ("drm/amd/display: Drop
CONFIG_DRM_AMD_DC_HDCP") there are two separate checks for NULL in
'adev->dm.dc' before dc_deinit_callbacks() and dc_dmub_srv_destroy().
Clean up by combining them all under one 'if'.

Found by Linux Verification Center (linuxtesting.org) with static
analysis tool SVACE.

Fixes: 81927e2808be ("drm/amd/display: Support for DMUB AUX")
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 8c150bf0aa1dd..53ec5f3a8e6f3 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1881,19 +1881,19 @@ static void amdgpu_dm_fini(struct amdgpu_device *adev)
 		hdcp_destroy(&adev->dev->kobj, adev->dm.hdcp_workqueue);
 		adev->dm.hdcp_workqueue = NULL;
 	}
+#endif
 
-	if (adev->dm.dc)
+	if (adev->dm.dc) {
+#ifdef CONFIG_DRM_AMD_DC_HDCP
 		dc_deinit_callbacks(adev->dm.dc);
 #endif
-
-	if (adev->dm.dc)
 		dc_dmub_srv_destroy(&adev->dm.dc->ctx->dmub_srv);
-
-	if (dc_enable_dmub_notifications(adev->dm.dc)) {
-		kfree(adev->dm.dmub_notify);
-		adev->dm.dmub_notify = NULL;
-		destroy_workqueue(adev->dm.delayed_hpd_wq);
-		adev->dm.delayed_hpd_wq = NULL;
+		if (dc_enable_dmub_notifications(adev->dm.dc)) {
+			kfree(adev->dm.dmub_notify);
+			adev->dm.dmub_notify = NULL;
+			destroy_workqueue(adev->dm.delayed_hpd_wq);
+			adev->dm.delayed_hpd_wq = NULL;
+		}
 	}
 
 	if (adev->dm.dmub_bo)
-- 
2.53.0



