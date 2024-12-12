Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E142820A5EE;
	Thu, 12 Dec 2024 17:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025137; cv=none; b=M+/Wp1UeG5EXpMSGIFCZNRWybrmFQD8RfWzGjr5bOdf2HhKH+ei8VkuqflocSHvvyXo2Xtlo3y/xygVpLQA6zLKfQzF8XM8krNR7+8AkoNlUilE74fL71ToenC68RYEDlbAbI45SfgnW76DTRNAVrI7LdaRTczPcviWcSZtqEHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025137; c=relaxed/simple;
	bh=nktHyDt0hVA4qDZhgRI2+b0QEmjQOvZPhrDc0wg+TOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X6usztI9spGUz4BqVP58PLeixk9nwG1Cg6FgCZ+vltDxGHFDNGo1l8VzNCnjuv+L9Zf8qAub7WdZIdzJnB/6Vxbul+xOB7TOIOzNKtHRQ5R8/QJDu1StWL5rKwwc+I71YvC+70JRxtbzgzdANEM4bzNdsTFmFiiJ5Vff5PP7fD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LS+ly5wn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LS+ly5wn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68343C4CED3;
	Thu, 12 Dec 2024 17:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025136;
	bh=nktHyDt0hVA4qDZhgRI2+b0QEmjQOvZPhrDc0wg+TOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LS+ly5wnawV9h8Yui6dMTIH9dqDpziZWFzXbXFdKI+DJGYOV3SfvGL/TnXhG6vhD5
	 OtD4IXJIPC+N9lpp+Z/UdcGio7xd6ZwZRS3jHmVsIU2wQyxRnf6/RT2RaChvTYx5WA
	 uE5IL0fhpDp9vDLtPmg1wxJ1hgRuANcoxcGRDwe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Emil Velikov <emil.velikov@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 068/321] drm/fsl-dcu: Use GEM CMA object functions
Date: Thu, 12 Dec 2024 15:59:46 +0100
Message-ID: <20241212144232.677744948@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 929027087f527ef1d9e906e4ebeca7eb3a36042e ]

Create GEM objects with drm_gem_cma_create_object_default_funcs(), which
allocates the object and sets CMA's default object functions. Corresponding
callbacks in struct drm_driver are cleared. No functional changes are made.

Driver and object-function instances use the same callback functions, with
the exception of vunmap. The implementation of vunmap is empty and left out
in CMA's default object functions.

v3:
	* convert to DRIVER_OPS macro in a separate patch

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Emil Velikov <emil.velikov@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200605073247.4057-11-tzimmermann@suse.de
Stable-dep-of: ffcde9e44d3e ("drm: fsl-dcu: enable PIXCLK on LS1021A")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c b/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c
index f15d2e7967a3e..113d2e30cf952 100644
--- a/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c
+++ b/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c
@@ -141,14 +141,10 @@ static struct drm_driver fsl_dcu_drm_driver = {
 	.irq_handler		= fsl_dcu_drm_irq,
 	.irq_preinstall		= fsl_dcu_irq_uninstall,
 	.irq_uninstall		= fsl_dcu_irq_uninstall,
-	.gem_free_object_unlocked = drm_gem_cma_free_object,
-	.gem_vm_ops		= &drm_gem_cma_vm_ops,
+	.gem_create_object	= drm_gem_cma_create_object_default_funcs,
 	.prime_handle_to_fd	= drm_gem_prime_handle_to_fd,
 	.prime_fd_to_handle	= drm_gem_prime_fd_to_handle,
-	.gem_prime_get_sg_table	= drm_gem_cma_prime_get_sg_table,
 	.gem_prime_import_sg_table = drm_gem_cma_prime_import_sg_table,
-	.gem_prime_vmap		= drm_gem_cma_prime_vmap,
-	.gem_prime_vunmap	= drm_gem_cma_prime_vunmap,
 	.gem_prime_mmap		= drm_gem_cma_prime_mmap,
 	.dumb_create		= drm_gem_cma_dumb_create,
 	.fops			= &fsl_dcu_drm_fops,
-- 
2.43.0



