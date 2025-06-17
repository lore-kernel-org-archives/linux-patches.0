Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49C62FA622;
	Tue, 17 Jun 2025 16:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179215; cv=none; b=VmaJEHMbW1qEjEFMcT7VYnAwS7nSdnHzoFBsqBCTqCPV3NcP4LNl90YZsug0OAUVozszzo57KDdGVSREenPK5PYrTXmOPisFcI2qxPhcm1relSFmqJmeZkZrhI/YigNtr9iViZ+JZT7ZOWmGg7WdnmIutuWN7RoZ/Rbq4fATMzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179215; c=relaxed/simple;
	bh=PGCpX6G401g8BpxcJW6+6sm7Ci5ws469GZ+4owbYAyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BWCij0jV7wQP3PmDayuEKzlLc4aqTxhddc9bX+D3RRhP1ADRaXR8aUlWh4d17qrkaV9V4U+XgQGQzQVQee0882UVFCLtwVhxOTqgwo61u2PzSQiUhytjkYHIJU1oJzpygo8XuPiMEBKIzB/+nJt3iSr/5TvvmfEGZNywajvmK0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SvSIJG/W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SvSIJG/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B4D6C4CEF0;
	Tue, 17 Jun 2025 16:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179215;
	bh=PGCpX6G401g8BpxcJW6+6sm7Ci5ws469GZ+4owbYAyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SvSIJG/Woa+oPiASYjG3rPN8dm1SWbTNj8u2rIxamjdgjHtm64plv7dektD5x2Xu8
	 MjJKVAJCX+ngDs9O+U6qCsGkrRUfWj/qIx76TvHxVpZmMyCEuEumySdivXXdujqVcg
	 H01qYDHVn7qtfF2scDvRbYVmMWLh80vDHwgb4RzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 684/780] accel/amdxdna: Fix incorrect PSP firmware size
Date: Tue, 17 Jun 2025 17:26:32 +0200
Message-ID: <20250617152519.335584999@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit 779a0c9e06a91d0007f2a4f4071e3b9a8102b15e ]

The incorrect PSP firmware size is used for initializing. It may
cause error for newer version firmware.

Fixes: 8c9ff1b181ba ("accel/amdxdna: Add a new driver for AMD AI Engine")
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://lore.kernel.org/r/20250604143217.1386272-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/aie2_psp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/accel/amdxdna/aie2_psp.c b/drivers/accel/amdxdna/aie2_psp.c
index dc3a072ce3b6d..f28a060a88109 100644
--- a/drivers/accel/amdxdna/aie2_psp.c
+++ b/drivers/accel/amdxdna/aie2_psp.c
@@ -126,8 +126,8 @@ struct psp_device *aie2m_psp_create(struct drm_device *ddev, struct psp_config *
 	psp->ddev = ddev;
 	memcpy(psp->psp_regs, conf->psp_regs, sizeof(psp->psp_regs));
 
-	psp->fw_buf_sz = ALIGN(conf->fw_size, PSP_FW_ALIGN) + PSP_FW_ALIGN;
-	psp->fw_buffer = drmm_kmalloc(ddev, psp->fw_buf_sz, GFP_KERNEL);
+	psp->fw_buf_sz = ALIGN(conf->fw_size, PSP_FW_ALIGN);
+	psp->fw_buffer = drmm_kmalloc(ddev, psp->fw_buf_sz + PSP_FW_ALIGN, GFP_KERNEL);
 	if (!psp->fw_buffer) {
 		drm_err(ddev, "no memory for fw buffer");
 		return NULL;
-- 
2.39.5



