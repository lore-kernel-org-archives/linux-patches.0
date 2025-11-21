Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F46B190477;
	Fri, 21 Nov 2025 13:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731703; cv=none; b=urWZQiycXaLALTTvIfbsl/IY3avnfA8okskh69/WiM8p6sMlQeKLYeG/JMY5as0tdZ7qB1o31Txk9DGHZmckCbRBz7mLwUhLfIoRQhyeNN3opNt6xD6l6mzDKppJluGJyp3CVj6JB28um7SpoP9RMoCJxY/0gYn+zu8s+qE+5/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731703; c=relaxed/simple;
	bh=vQMUkrSFkCnFEZamTrK/x7Y8wOCiniAIsJnoqFHLzFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vci76AEh5VjqZtGpw5dYSyWyvjjfoqKKC1tpGaacKF2/mNo6HZLbTujQQ2gv030rx6JAiJP5KdvTWCKY0uELdKLwD6efKh3Io4utbJxLG/F9yC3L+zRQzrZ81Jp6I+iKu7RX2MeV5ThCPeRisaw0k2Tx9GV/PovoY9Z67c5KMjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sQoPaTRS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sQoPaTRS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F01C4CEF1;
	Fri, 21 Nov 2025 13:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731701;
	bh=vQMUkrSFkCnFEZamTrK/x7Y8wOCiniAIsJnoqFHLzFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sQoPaTRS7wmSojOicPROpDjoHZJGFHXnTLz08S1rpLuzW6JD9t6OGLkuappDF27DI
	 KChwO6jlLHrMyIo56MeWRJDVUmlaZlAvP33Dst0bzsePvwTR893pfUQvm/Ee1OqoWL
	 a9PRej0TNXRZdl7UZF28ggG+fHYFEqh4/czjjCPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Mangesh Gadre <Mangesh.Gadre@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 017/185] drm/amdgpu: hide VRAM sysfs attributes on GPUs without VRAM
Date: Fri, 21 Nov 2025 14:10:44 +0100
Message-ID: <20251121130144.497236056@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

From: Christian König <christian.koenig@amd.com>

[ Upstream commit 33cc891b56b93cad1a83263eaf2e417436f70c82 ]

Otherwise accessing them can cause a crash.

Signed-off-by: Christian König <christian.koenig@amd.com>
Tested-by: Mangesh Gadre <Mangesh.Gadre@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
index ea4df412decff..54f2e7b392796 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
@@ -234,6 +234,9 @@ static umode_t amdgpu_vram_attrs_is_visible(struct kobject *kobj,
 	    !adev->gmc.vram_vendor)
 		return 0;
 
+	if (!ttm_resource_manager_used(&adev->mman.vram_mgr.manager))
+		return 0;
+
 	return attr->mode;
 }
 
-- 
2.51.0



