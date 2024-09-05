Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F0747796;
	Thu,  5 Sep 2024 09:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529660; cv=none; b=P4mozRF/7BOjMOpB5ASnzRimdOvR/eZO889gqZIwJe1Pnqb7qmp9BCJ3D5Hciotwpy4dhEZEbzjO0n55dNluN7EWKKWQ230DJpsySaW8oPKlojSU5QaFsaK2vhl2DfkUyGl3/nDQsCnFSt5to8bKz68mHSWOqzuI5jBmFVarWDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529660; c=relaxed/simple;
	bh=SaMbYW1rmrbaT5JP1hgZdaoOMj9rMsujPDVRWbpiZO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZwtaHBThB6Z1N/+bYdXouAtVKW7b/Wff977UuOt2WUXo/WGfW7yp6BSiigM8Zkh1DCRZabzUOZ/OS6MTZW27dC3QeiYKU0TePYAn9HnIlOTOBDkYDzZlArj98KdZYSlFcj7xCv684Iggig7NQPuPvcTdsPSDPZmONjnxWtx7Xl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k1U2Vucs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k1U2Vucs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28505C4CEC3;
	Thu,  5 Sep 2024 09:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529660;
	bh=SaMbYW1rmrbaT5JP1hgZdaoOMj9rMsujPDVRWbpiZO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k1U2VucsE4XXqNxl922R+Wq3AdNX4PSFutBaC+YKH6LqT4WyMriyH3kQKaTn9q+lJ
	 gFUoY391m2Ne/X5uj8frt0O1PR+cxh/7WSlyXVyKKeo1m8PVEpj3UDpPf62N1l74hc
	 sNPa31aWb/Wuz9/nFZd+DeTmqJFJvmsl2H5X5Yuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 104/184] drm/amdgpu: fix dereference after null check
Date: Thu,  5 Sep 2024 11:40:17 +0200
Message-ID: <20240905093736.295418025@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <jesse.zhang@amd.com>

[ Upstream commit b1f7810b05d1950350ac2e06992982974343e441 ]

check the pointer hive before use.

Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Reviewed-by: Tim Huang <Tim.Huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 13b54e00a247..d24d7a108624 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -5727,7 +5727,7 @@ int amdgpu_device_gpu_recover(struct amdgpu_device *adev,
 	 * to put adev in the 1st position.
 	 */
 	INIT_LIST_HEAD(&device_list);
-	if (!amdgpu_sriov_vf(adev) && (adev->gmc.xgmi.num_physical_nodes > 1)) {
+	if (!amdgpu_sriov_vf(adev) && (adev->gmc.xgmi.num_physical_nodes > 1) && hive) {
 		list_for_each_entry(tmp_adev, &hive->device_list, gmc.xgmi.head) {
 			list_add_tail(&tmp_adev->reset_list, &device_list);
 			if (adev->shutdown)
-- 
2.43.0



