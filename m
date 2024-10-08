Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979341DED79;
	Tue,  8 Oct 2024 12:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391987; cv=none; b=QBrdjZEf/cZPZs9uT8kvwSB9SdOGPEZQkgxeCuY9cyCB1qTwHGpzsrz/L9pAJUuu8GtBZ3bDl8UprlMmDZvpBcaOOt0erIlyv+qlYPRinxDlxBBO5ARkvSRxqTxmi5LeX3bq/GoKRKbkt0gnrNfETSP5wLU+OjZefUFbyhUuHWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391987; c=relaxed/simple;
	bh=aUSR1vvraQnsVbce50ctMHddteCjgqr8ZIGgJlHUiqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sTzSRz9pxQ8pI8GryTmhGArcKX+zsMBK9IrxIh0EeQGHipPg6sOj+Xci61MQzhEsT4BHSG4uSvKIKwV4bPZgN5WbvTej69yNGQxH+pfNbJb0ZZb9kWvckXNH3oUiy5TE7kTHpHNvmzsPDndm3i4ZGXkFGMROUMsmkp1B/fVQ4jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eAN15hns; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eAN15hns"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08BF9C4CEC7;
	Tue,  8 Oct 2024 12:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391987;
	bh=aUSR1vvraQnsVbce50ctMHddteCjgqr8ZIGgJlHUiqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eAN15hnsRaMO9A/rIXwNxMfCLafbr5HteG2UZ2g9C8x6rlCP+cJ/gpB40MvUj2VFF
	 XLQUc+XiX/BqkCOkUsEycjTYvIIaG/JaBOy+VB5pSRXt2jD0WSN3K6CnjrtFlj3ARd
	 xMdebQ52Cc6Mg8+eBEhdvmRQL/OJlUOuqXz9YVfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Sunil Khatri <sunil.khatri@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 283/558] drm/amdgpu: fix ptr check warning in gfx11 ip_dump
Date: Tue,  8 Oct 2024 14:05:13 +0200
Message-ID: <20241008115713.462818378@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sunil Khatri <sunil.khatri@amd.com>

[ Upstream commit bd15f805cdc503ac229a14f5fe21db12e6e7f84a ]

Change condition, if (ptr == NULL) to if (!ptr)
for a better format and fix the warning.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sunil Khatri <sunil.khatri@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index dcef399074492..61e62d846900c 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -1484,7 +1484,7 @@ static void gfx_v11_0_alloc_ip_dump(struct amdgpu_device *adev)
 	uint32_t inst;
 
 	ptr = kcalloc(reg_count, sizeof(uint32_t), GFP_KERNEL);
-	if (ptr == NULL) {
+	if (!ptr) {
 		DRM_ERROR("Failed to allocate memory for GFX IP Dump\n");
 		adev->gfx.ip_dump_core = NULL;
 	} else {
@@ -1497,7 +1497,7 @@ static void gfx_v11_0_alloc_ip_dump(struct amdgpu_device *adev)
 		adev->gfx.mec.num_queue_per_pipe;
 
 	ptr = kcalloc(reg_count * inst, sizeof(uint32_t), GFP_KERNEL);
-	if (ptr == NULL) {
+	if (!ptr) {
 		DRM_ERROR("Failed to allocate memory for Compute Queues IP Dump\n");
 		adev->gfx.ip_dump_compute_queues = NULL;
 	} else {
@@ -1510,7 +1510,7 @@ static void gfx_v11_0_alloc_ip_dump(struct amdgpu_device *adev)
 		adev->gfx.me.num_queue_per_pipe;
 
 	ptr = kcalloc(reg_count * inst, sizeof(uint32_t), GFP_KERNEL);
-	if (ptr == NULL) {
+	if (!ptr) {
 		DRM_ERROR("Failed to allocate memory for GFX Queues IP Dump\n");
 		adev->gfx.ip_dump_gfx_queues = NULL;
 	} else {
-- 
2.43.0



