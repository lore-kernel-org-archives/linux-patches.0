Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8445232B125;
	Wed, 23 Sep 2026 14:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172929; cv=none; b=X4QQRkfGcSgPo3DC65LN8iPkLQQTGBmAayFweZVt7sSRmqQ81fYUcaOgAVeIFgrZe1N1gLRNva6kLQINJZVihxG9EEZIIVlvFVOMhzaCWbelyMjKX0SsdOAmyEqliK2qtvbKmdi8LBbs2AB8lT/VkX21nyX3glQGDvTh3jUeXRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172929; c=relaxed/simple;
	bh=Yl+P/1kuUxEZcAsbKv4vPONbtfks0iHaFUguhELLGxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jf635PFob6JARwuk/fxJ0OXIXKD2QDFAVUn9+KjQa2wtwDKY7NjJoxi+XjvdwrNlzXoqSmSHQHlwoX+iy3wUjHkGq8EPYUyFlnN8WGolwbh/TvtOkIHMucSAIK4kpeA2CI20vDLaK3TPUBnHAi4ePQR+DzM3DoHqjbPXRaZdB30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LT/Uap8p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LT/Uap8p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C23E01F00898;
	Wed, 23 Sep 2026 14:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172928;
	bh=tae9UwAKRMK3AoHDJUFwNpNdcXUr7uS9YJyN/K1ZReA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LT/Uap8pxg8LrjFUbXXMQ5cr4T597iBvyRcDaQEgRTQ4jODqE9kk6+xVR21j9bHNi
	 UEPmxSk7tuUcguKafzlHnlKguNy+IXVkBfnuYGiLw3j+vhusgza/4WEfOAcypBddDC
	 pOJnVG/1D1Z7OFzMRR5ExepGCgexZG9Y1pj3Xkmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 102/438] drm/msm: Fix the separate_gpu_kms parameter description
Date: Wed, 23 Sep 2026 16:02:03 +0200
Message-ID: <20260923140647.420986970@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit adf5967331318bcb436fc80069915231ec039352 ]

The module parameter is separate_gpu_kms, but its MODULE_PARM_DESC()
names separate_gpu_drm, so modinfo describes a parameter that does not
exist and shows no description for the real one.

Use the parameter name in the description.

Fixes: 217ed15bd399 ("drm/msm: enable separate binding of GPU and display devices")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Patchwork: https://patchwork.freedesktop.org/patch/751407/
Message-ID: <20260906170347.2427-1-kmehltretter@gmail.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
index 32d5ebea2596f..fa46ab3063e6f 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -55,7 +55,7 @@ MODULE_PARM_DESC(modeset, "Use kernel modesetting [KMS] (1=on (default), 0=disab
 module_param(modeset, bool, 0600);
 
 static bool separate_gpu_kms;
-MODULE_PARM_DESC(separate_gpu_drm, "Use separate DRM device for the GPU (0=single DRM device for both GPU and display (default), 1=two DRM devices)");
+MODULE_PARM_DESC(separate_gpu_kms, "Use separate DRM device for the GPU (0=single DRM device for both GPU and display (default), 1=two DRM devices)");
 module_param(separate_gpu_kms, bool, 0400);
 
 DECLARE_FAULT_ATTR(fail_gem_alloc);
-- 
2.53.0



