Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3341F7060;
	Tue,  3 Dec 2024 14:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236520; cv=none; b=bmvkYmS4k4BP02PODcaAOfhqU+JljI3wJknPuq3ljfQ2NQ4mXqJM03wEKBzFm5OorlqoKPa9RSPLK5zs/vU4kCOAfz3m1o26oMdoeHuhy+7zCm9PWnYNdEKvUplE0iHcQ+apZUUWZfF+IhXmpEH1o/n+DUVvm/oDiOtjaksc1iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236520; c=relaxed/simple;
	bh=RKJ5FosPv8hGvM30v2uCVur69Ggd2ejj40jlwTZJDdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TplvVRIjW7yF1eS+OHiOokoI/TW9k9gVQw/uSb/RL5O8DRFayju8mTbMEaLgf0oX1aglc7xBkplj6MKgus/siLcb+1xP664onljuAqoDVKARzFXXlYOVf8B1wDzN3IqVaNEqtMmoWWTUMfFKgyrifFt723wQdmKQHqQCKhhIiHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P+s9NlaX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P+s9NlaX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C1B1C4CECF;
	Tue,  3 Dec 2024 14:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236520;
	bh=RKJ5FosPv8hGvM30v2uCVur69Ggd2ejj40jlwTZJDdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P+s9NlaXLgnyTRvBFQUi44qXi4D128TbngBCkDipgseNsAUWGMk2EfyihD4RdpoJr
	 1Xwn7CNUKsnnvsv6CU1CyFIJ1PZTDbmvwAhoGxYhz0ypFiFXbXnxIe2ByHq27kRVgi
	 V+oKnfqQm9MpANkZCr66nOdqFvc+eu5jfusz3y9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Anholt <eric@anholt.net>,
	Emil Velikov <emil.velikov@collabora.com>,
	Stefan Agner <stefan@agner.ch>,
	Daniel Vetter <daniel.vetter@intel.com>,
	Alison Wang <alison.wang@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 044/138] drm/fsl-dcu: Drop drm_gem_prime_export/import
Date: Tue,  3 Dec 2024 15:31:13 +0100
Message-ID: <20241203141925.244798997@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

[ Upstream commit 40e546c5f9ca0054087ce5ee04de96a4f28e9a97 ]

They're the default.

Aside: Would be really nice to switch the others over to
drm_gem_object_funcs.

Reviewed-by: Eric Anholt <eric@anholt.net>
Reviewed-by: Emil Velikov <emil.velikov@collabora.com>
Acked-by: Stefan Agner <stefan@agner.ch>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Cc: Stefan Agner <stefan@agner.ch>
Cc: Alison Wang <alison.wang@nxp.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190614203615.12639-16-daniel.vetter@ffwll.ch
Stable-dep-of: ffcde9e44d3e ("drm: fsl-dcu: enable PIXCLK on LS1021A")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c b/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c
index 15816141e5fbe..3eab7b4c16b2b 100644
--- a/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c
+++ b/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c
@@ -148,8 +148,6 @@ static struct drm_driver fsl_dcu_drm_driver = {
 	.gem_vm_ops		= &drm_gem_cma_vm_ops,
 	.prime_handle_to_fd	= drm_gem_prime_handle_to_fd,
 	.prime_fd_to_handle	= drm_gem_prime_fd_to_handle,
-	.gem_prime_import	= drm_gem_prime_import,
-	.gem_prime_export	= drm_gem_prime_export,
 	.gem_prime_get_sg_table	= drm_gem_cma_prime_get_sg_table,
 	.gem_prime_import_sg_table = drm_gem_cma_prime_import_sg_table,
 	.gem_prime_vmap		= drm_gem_cma_prime_vmap,
-- 
2.43.0



