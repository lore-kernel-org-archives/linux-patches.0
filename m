Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CDD720B20B;
	Tue, 12 Nov 2024 10:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407764; cv=none; b=L3CtVBseFB9uTxwzQto23oUwiCs2lFZZlJX9kiEdGzOTmaPlUzzuF2WqPVOrg/hOwStKNvwHMNa65CpLNUBbkVGwccprR6zsWphUl2W2OTvfi7BgB2a0jqGSVWwiUqVdsqLTcR8Ys/9Wu/JqGiscsA7X1yBqRpADip7nwQi1D3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407764; c=relaxed/simple;
	bh=5JPc/mdJghrfalUFRyppg6Q2LzoD6oPs006fn2W0mjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YSExO1n9xqe0NEym/ry6Axdf5Jn/v5P9H4S3Wn036WKBoUlL7qtWHe30lknNulsbtGYZN9BBMEAxGehLsPDQXhX1AipcgSCKch349a+dAzx4ROoA+Oq5fYRrzdSrjcdfZaUw6rqaeCQOE1qIKleIdVPBoIpndpg6VVhl7P0fW0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yjWe0xLq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yjWe0xLq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71FCEC4CECD;
	Tue, 12 Nov 2024 10:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407763;
	bh=5JPc/mdJghrfalUFRyppg6Q2LzoD6oPs006fn2W0mjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yjWe0xLquVlMekYxkeS0JLF+7QFr1L3sUmvRuVEKGQyK/8rsSZ3WJhdIGU1xK5ie4
	 Ml3nJjlGxeB6WW4SFS9JmZ469SXEqWNZ4dCCNVU93QpzHme6jegHsExMVhLr/Kd2Qa
	 qNl7CbnVR7aOxWL2Bpwsf4opzLFXx0OC7yp3BWCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 076/119] drm/amdgpu: Adjust debugfs eviction and IB access permissions
Date: Tue, 12 Nov 2024 11:21:24 +0100
Message-ID: <20241112101851.626231895@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit f790a2c494c4ef587eeeb9fca20124de76a1646f upstream.

Users should not be able to run these.

Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 7ba9395430f611cfc101b1c2687732baafa239d5)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
@@ -2176,11 +2176,11 @@ int amdgpu_debugfs_init(struct amdgpu_de
 	amdgpu_securedisplay_debugfs_init(adev);
 	amdgpu_fw_attestation_debugfs_init(adev);
 
-	debugfs_create_file("amdgpu_evict_vram", 0444, root, adev,
+	debugfs_create_file("amdgpu_evict_vram", 0400, root, adev,
 			    &amdgpu_evict_vram_fops);
-	debugfs_create_file("amdgpu_evict_gtt", 0444, root, adev,
+	debugfs_create_file("amdgpu_evict_gtt", 0400, root, adev,
 			    &amdgpu_evict_gtt_fops);
-	debugfs_create_file("amdgpu_test_ib", 0444, root, adev,
+	debugfs_create_file("amdgpu_test_ib", 0400, root, adev,
 			    &amdgpu_debugfs_test_ib_fops);
 	debugfs_create_file("amdgpu_vm_info", 0444, root, adev,
 			    &amdgpu_debugfs_vm_info_fops);


