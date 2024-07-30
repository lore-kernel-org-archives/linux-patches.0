Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B3818455D;
	Tue, 30 Jul 2024 16:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356777; cv=none; b=OjkTYkJ3jqMlPcSj6n/7yslKttetSEIcE9Y5hNDBZxP1I6JHqGpgi7n35F7ymkxyjyeelCeG5gg6uubz1FAs9act9dV7yRuURomcRHhEFbTMjuqsor53vRukCF6e7zdVok7p07nnm/BCvq4Qog9P+lgudb/oUU936ExCbIzeb3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356777; c=relaxed/simple;
	bh=5kOMzIWgTv3EG/mcbFKjkqAEBz/LHDxTR65j3Jdwbic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a/xcaBrcZmY3IPfU/MHNUBjIPEiSyecoqyUIQbtRvIz9iZpidiYg7L4cuTuIvu2WPVeDrCc+D6PPxgkhAAMc9u2/ilJXx3KajTZpDbqwv50nPvHREoaTVbmzIDs1LYjuoByTkJvVjEQ0XeD4KB7uGn6D+4SJ6X9rUcBOU4Q3DLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SORCqqzr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SORCqqzr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8680C4AF0C;
	Tue, 30 Jul 2024 16:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356777;
	bh=5kOMzIWgTv3EG/mcbFKjkqAEBz/LHDxTR65j3Jdwbic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SORCqqzrFzlDKBs471SnEdLhlwBpzxFvb3Gmpmq6oeBbQVnw53CxZSr2WvE+1G4DN
	 YqGznqluOxYmU5lrmlNItwIHH14b6E5Ce81KFtgydcWFsfFrbqWtXagsOdgRQiN3ba
	 YZ1YdVb8Vvx2H9pGUDab1gelL/Yt2HWsktH6k5go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Van Patten <timvp@google.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 183/568] drm/amdgpu: Remove GC HW IP 9.3.0 from noretry=1
Date: Tue, 30 Jul 2024 17:44:50 +0200
Message-ID: <20240730151647.030692841@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Tim Van Patten <timvp@google.com>

[ Upstream commit 1446226d32a45bb7c4f63195a59be8c08defe658 ]

The following commit updated gmc->noretry from 0 to 1 for GC HW IP
9.3.0:

    commit 5f3854f1f4e2 ("drm/amdgpu: add more cases to noretry=1")

This causes the device to hang when a page fault occurs, until the
device is rebooted. Instead, revert back to gmc->noretry=0 so the device
is still responsive.

Fixes: 5f3854f1f4e2 ("drm/amdgpu: add more cases to noretry=1")
Signed-off-by: Tim Van Patten <timvp@google.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
index bc0eda1a729c5..0b6a0e149f1c4 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
@@ -650,7 +650,6 @@ void amdgpu_gmc_noretry_set(struct amdgpu_device *adev)
 	struct amdgpu_gmc *gmc = &adev->gmc;
 	uint32_t gc_ver = adev->ip_versions[GC_HWIP][0];
 	bool noretry_default = (gc_ver == IP_VERSION(9, 0, 1) ||
-				gc_ver == IP_VERSION(9, 3, 0) ||
 				gc_ver == IP_VERSION(9, 4, 0) ||
 				gc_ver == IP_VERSION(9, 4, 1) ||
 				gc_ver == IP_VERSION(9, 4, 2) ||
-- 
2.43.0



