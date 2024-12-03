Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F88F1EF08A;
	Tue,  3 Dec 2024 14:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236527; cv=none; b=VQe0jZipqVFjs887ZtGQLUXCBxKOGzP64tXKH/SyeXiaTg1KFKJpfzkmoMFeqpvqsZo8OQBgjg7a2n7X+NkcLhyi0CzGJpSp9JBiS5EhQYGV37VtI+wOpppsJ/Ce4bLoq/F417k7D20FDyIg1FAU1c3I0Vu/f96s4QiMMqp7A2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236527; c=relaxed/simple;
	bh=bVpLsey2WXB2i7f5jnUjJQ0mhz0PBnSJQvomiprsWGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R8ROkP7JnMcIcknwUrpfaAZ1u7rmZJiIeTzGggmwGyL5zIOtdYTjRAVbaAFOIpp6X+pZgBcfDZQjpkg0FAtE86MxYKrbHNqab+41E+4T8q5vWRLxatldWjQkJYuCWW3/g7YTkgqPwM5uYvRNYTLvJ9fg2XOpxEwAkfZS75EZlq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eJm8RKfd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eJm8RKfd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 054F7C4CED8;
	Tue,  3 Dec 2024 14:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236527;
	bh=bVpLsey2WXB2i7f5jnUjJQ0mhz0PBnSJQvomiprsWGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eJm8RKfdSrrhjUmF/6hSES2NwxONJU3hnbJXsdVJ7uclTTdPFHYdoWSAr7OGmoTDm
	 tzZ453NOQVXPo8zMwQFYJmw3cSf17Nv9uLtJe+SD3lx1Iht986pSki/IiUt3Kfvzn2
	 Ro5hzXK7A97tP7fYAuJ0CPpXUhFakvs4d/6JZ8eY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Emil Velikov <emil.velikov@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 046/138] drm/fsl-dcu: Set GEM CMA functions with DRM_GEM_CMA_DRIVER_OPS
Date: Tue,  3 Dec 2024 15:31:15 +0100
Message-ID: <20241203141925.322435712@linuxfoundation.org>
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

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 6a32e55d18b34a787f7beaacc912b30b58022646 ]

DRM_GEM_CMA_DRIVER_OPS sets the functions in struct drm_driver
to their defaults. No functional changes are made.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Emil Velikov <emil.velikov@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200605073247.4057-12-tzimmermann@suse.de
Stable-dep-of: ffcde9e44d3e ("drm: fsl-dcu: enable PIXCLK on LS1021A")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c b/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c
index a21c348f9a5e4..c087ebc0ad4ed 100644
--- a/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c
+++ b/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c
@@ -144,12 +144,7 @@ static struct drm_driver fsl_dcu_drm_driver = {
 	.irq_handler		= fsl_dcu_drm_irq,
 	.irq_preinstall		= fsl_dcu_irq_uninstall,
 	.irq_uninstall		= fsl_dcu_irq_uninstall,
-	.gem_create_object	= drm_gem_cma_create_object_default_funcs,
-	.prime_handle_to_fd	= drm_gem_prime_handle_to_fd,
-	.prime_fd_to_handle	= drm_gem_prime_fd_to_handle,
-	.gem_prime_import_sg_table = drm_gem_cma_prime_import_sg_table,
-	.gem_prime_mmap		= drm_gem_cma_prime_mmap,
-	.dumb_create		= drm_gem_cma_dumb_create,
+	DRM_GEM_CMA_DRIVER_OPS,
 	.fops			= &fsl_dcu_drm_fops,
 	.name			= "fsl-dcu-drm",
 	.desc			= "Freescale DCU DRM",
-- 
2.43.0



