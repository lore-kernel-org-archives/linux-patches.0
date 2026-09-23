Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B636553A88A;
	Wed, 23 Sep 2026 14:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174368; cv=none; b=JSG7I4h6xS0Om48kSNLX3LUK3BA/AfQ99HtKAOm131+E81OC2En9We9YntbXqrsrURBztW7yH70RKJs+b9vGho5A/SKfa2JbtTXg8RGCJJU/8lrHKaGvDT1QSJ7WUG79eZA6ej7qODUOW5tm8bWdTRczkJJY1snNq5xInFbfDTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174368; c=relaxed/simple;
	bh=f92Xhp+AdPn0pxhGGJ4KGszb/YVFDCZLr/LQ+/AZkk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mQIc9l+Fv7J00W4OjdbxesQqHzhdCtPA312jYa2hwdPPk1W/Z69ACSjxB4o+5w1lTp/tO62spawFJE8CHFmlZBzihCyr3rBusZbc6SrUp9ry+OywQdWJGFHYl9vpgZqz21Qt1d2qOMPfsm2tUnw7JAlbD1VltV29/8KClIkn59Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r3dGoM15; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r3dGoM15"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 992B31F00893;
	Wed, 23 Sep 2026 14:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174367;
	bh=S5YX1N4ctYzCuuda3yXj23CPNMVUyZj8cmjX/hw99Nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r3dGoM15hRP3e0f7LqRd+NjehNmMLaNEEtj3KmjqrKLiKdmdat7FF82MJWxzDfrrb
	 ktdUZp72kbD2mfBGX0FYXCljPiA2Pem0NqKT+7sVeIORAwtCqzIhjZlFRxQgYyb584
	 msmoSWoco6HOaXMeVlxkRBUDvHxsoR44SW6X4mb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 091/398] drm/msm/adreno: Fix the skip_gpu parameter description
Date: Wed, 23 Sep 2026 16:02:45 +0200
Message-ID: <20260923140645.798836420@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 8061ee61b9426fe38350fa9eead2d9c50b03deb6 ]

The module parameter is skip_gpu, but its MODULE_PARM_DESC() names
no_gpu, so modinfo describes a parameter that does not exist and shows
no description for the real one.

Use the parameter name in the description.

Fixes: 3f17991488af ("drm/msm/adreno: Add a modparam to skip GPU")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Patchwork: https://patchwork.freedesktop.org/patch/751406/
Message-ID: <20260906170301.2393-1-kmehltretter@gmail.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/adreno_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/adreno_device.c b/drivers/gpu/drm/msm/adreno/adreno_device.c
index 28f744f3caf7c..5d598815de45a 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_device.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_device.c
@@ -25,7 +25,7 @@ MODULE_PARM_DESC(disable_acd, "Forcefully disable GPU ACD");
 module_param_unsafe(disable_acd, bool, 0400);
 
 static bool skip_gpu;
-MODULE_PARM_DESC(no_gpu, "Disable GPU driver register (0=enable GPU driver register (default), 1=skip GPU driver register");
+MODULE_PARM_DESC(skip_gpu, "Disable GPU driver register (0=enable GPU driver register (default), 1=skip GPU driver register");
 module_param(skip_gpu, bool, 0400);
 
 extern const struct adreno_gpulist a2xx_gpulist;
-- 
2.53.0



