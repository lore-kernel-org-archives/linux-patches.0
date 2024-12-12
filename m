Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E244520A5EE;
	Thu, 12 Dec 2024 17:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025140; cv=none; b=RxxhZHeBuw3WZEWXxQKnQkGmAfRKKYbN8IcPjxbIEzTH/1FXVdrMkVvf6Bf+7VtUWcH51vwF1uZcGo+B+fII7ehyC/Vb8pags4cTmf7VaL8gSTZQk2/GtytsBHPPMtqPEUjhaw/LzehTdFIUQVdyD9wfigWbRcxUE9TdmrNzZDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025140; c=relaxed/simple;
	bh=Qu7CplK0vYjgVy4bn0beXxNMMw7DV/5j4POH77mXvds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VjOSC/wf8r4AdXu8zfKsO1FYx1M7gQN6a7MnVN+I6PlpqF2KhfOJLgky9H1v2xYEvnh+5JPCGxv5/zumNeMayEX0hGs+qaa7lLUohveRM2yWahOhMc4Y+bwZ1XDmHEENvi/8yk6J4TpUYHb+SL7bFpSlV/L3XjL9QSCNWfSrOEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EOZeg0XJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EOZeg0XJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C875C4CECE;
	Thu, 12 Dec 2024 17:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025139;
	bh=Qu7CplK0vYjgVy4bn0beXxNMMw7DV/5j4POH77mXvds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EOZeg0XJoNOkuLycUAjHfPukdIAZ21hMd2PNNd7LPTNmMrS3MQhj9LewlQ/R9k1xO
	 aTB0BVXakri8mWasdKMyaCugNQNdwn3+rxYLJ1OVUAzS9XE+1wB1JHjYp5k7o/zMVb
	 ARgk2V/e9manzoZFiav7DzSw9VHPMavsDtkw6p9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Emil Velikov <emil.velikov@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 069/321] drm/fsl-dcu: Set GEM CMA functions with DRM_GEM_CMA_DRIVER_OPS
Date: Thu, 12 Dec 2024 15:59:47 +0100
Message-ID: <20241212144232.715893166@linuxfoundation.org>
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
index 113d2e30cf952..abbc1ddbf27f0 100644
--- a/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c
+++ b/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c
@@ -141,12 +141,7 @@ static struct drm_driver fsl_dcu_drm_driver = {
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



