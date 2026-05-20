Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6077E42A96;
	Wed, 20 May 2026 18:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300460; cv=none; b=DvDgWcNegKuwa+LsJMwDIO+HooiL2Gwjr5VFaIhZLPLiFw/hTh6n1Zi3pQpvgjmaw1eqn5Ya/U9gKCsnuptKZgsnGnrKiGDzUQhsmH+XC7PbpD7XpW/JRCgQtENSnUirAt/akDBL05+5d6xvURFLLN1sXXA98gZ+fDZMoCrGAw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300460; c=relaxed/simple;
	bh=DSVb3mFLeFiE2Jl7v2e4X7po7lr760gKm5zrHSV8fo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ftDmjpVAiBUHt8vFG0fBgIdhPzwwA3M9A70tA0W1JduoLELuISt/o+rVkxh7GUyOIUzek0IWYuhGYnrrT3Yw57urA7ughRbCX/0U/74pvFzvJNswb4SMOKm37gMFL4x+gKkXUE+ap86P2FTTW7yZBN2P/5NTojk0D0+uMB1Xdp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZPS1J1fs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZPS1J1fs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54D91F00893;
	Wed, 20 May 2026 18:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300459;
	bh=ZUraPjYCF1yt9bkjhMTpDwR3dlg69TDBivt04O4JVzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZPS1J1fsQDdY0q04oVNErJ8burlqdmcBs78n7nKgkxf/a9as/rUi0hTVE5ELgAVn6
	 Q2ki6790RbWFcyG1VwhsaB+ksCJUo2Uxn7pWfwPWpz77OBK2nxzugEWLWvFlDLvBtu
	 +MtpdObki0CkjK6/xpKMFmzXo5GBezcMz1GcjD4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunil Khatri <sunil.khatri@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 183/666] drm/amdgpu: add amdgpu_device reference in ip block
Date: Wed, 20 May 2026 18:16:34 +0200
Message-ID: <20260520162115.167626272@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sunil Khatri <sunil.khatri@amd.com>

[ Upstream commit 37b993225d37744f2a62bf67074a76a6cb7b8b98 ]

To handle amdgpu_device reference for different GPUs
we add it's reference in each ip block which can be
used to differentiate between difference gpu devices.

Signed-off-by: Sunil Khatri <sunil.khatri@amd.com>
Suggested-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 8b3e8fa6d7bd ("drm/amdgpu/uvd4.2: Don't initialize UVD 4.2 when DPM is disabled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu.h        | 1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu.h b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
index 7edf8d67a0fa5..b667da0ec68a3 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -388,6 +388,7 @@ struct amdgpu_ip_block_version {
 struct amdgpu_ip_block {
 	struct amdgpu_ip_block_status status;
 	const struct amdgpu_ip_block_version *version;
+	struct amdgpu_device *adev;
 };
 
 int amdgpu_device_ip_block_version_cmp(struct amdgpu_device *adev,
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 12d7e45a42456..1183d671d0606 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2336,6 +2336,8 @@ int amdgpu_device_ip_block_add(struct amdgpu_device *adev,
 	DRM_INFO("add ip block number %d <%s>\n", adev->num_ip_blocks,
 		  ip_block_version->funcs->name);
 
+	adev->ip_blocks[adev->num_ip_blocks].adev = adev;
+
 	adev->ip_blocks[adev->num_ip_blocks++].version = ip_block_version;
 
 	return 0;
-- 
2.53.0



