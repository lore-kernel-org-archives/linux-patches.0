Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4581C07C4;
	Tue, 27 May 2025 17:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367838; cv=none; b=YL2+kBf2Vy1ifkDeLSGX1jG/Vkki5R4ozwPTzBTmPO/QU7JvgG8fqYBl7G2eMncO0p+wslmNw9b6xjzLGpnNlVmSnwlehLvyrLdEucRSY9S69KgUDgYhg65YmO4RrVcukVJ5cbrE36VAlWlaSxFanJgSXFIaof3Z/CRR289/w28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367838; c=relaxed/simple;
	bh=bGa1T8Y96Nq6H33GLqPQzaWXbDGCfNoCiOdzDZdd99w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tkLAXCm7EvqUPHiCNVjnEfWIlBtGARYjhZciEHLeDvn4j7Jk3tdmNYm37TwDHtrpA6rb+L/UzdvCb9wJF8hxGaakV1O0N5VZmcsCBlCTPlzlgcIoc3vkOfeTgTuxeviBRbe6ScNgh5qy5PVfOUF3nzRL4v2A8s1Z5OB4h4qlIEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dhhHNE4p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dhhHNE4p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8963C4CEEA;
	Tue, 27 May 2025 17:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367837;
	bh=bGa1T8Y96Nq6H33GLqPQzaWXbDGCfNoCiOdzDZdd99w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dhhHNE4pdEW09KF8OjFJyPuSYSg75VumJgQC9PyKbupGm4YQtNd9NjVOPqHpX1lWK
	 FT8yDQv5u78lyd7Z/HxD7E3sWycj10y1AhA5Em/e5RLYnN/bX7Xj8kx4WhZr+ZmUY3
	 YYjMaQF6LZK3p0VLI5pc5WyOBYYMpVZT3lEVbgno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Jiang Liu <gerry@linux.alibaba.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 484/783] drm/amdgpu: reset psp->cmd to NULL after releasing the buffer
Date: Tue, 27 May 2025 18:24:41 +0200
Message-ID: <20250527162532.839775372@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiang Liu <gerry@linux.alibaba.com>

[ Upstream commit e92f3f94cad24154fd3baae30c6dfb918492278d ]

Reset psp->cmd to NULL after releasing the buffer in function psp_sw_fini().

Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Jiang Liu <gerry@linux.alibaba.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index e5fc80ed06eae..665cc277cdc05 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -533,7 +533,6 @@ static int psp_sw_fini(struct amdgpu_ip_block *ip_block)
 {
 	struct amdgpu_device *adev = ip_block->adev;
 	struct psp_context *psp = &adev->psp;
-	struct psp_gfx_cmd_resp *cmd = psp->cmd;
 
 	psp_memory_training_fini(psp);
 
@@ -543,8 +542,8 @@ static int psp_sw_fini(struct amdgpu_ip_block *ip_block)
 	amdgpu_ucode_release(&psp->cap_fw);
 	amdgpu_ucode_release(&psp->toc_fw);
 
-	kfree(cmd);
-	cmd = NULL;
+	kfree(psp->cmd);
+	psp->cmd = NULL;
 
 	psp_free_shared_bufs(psp);
 
-- 
2.39.5



