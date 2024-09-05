Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2967E1946A2;
	Thu,  5 Sep 2024 10:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530484; cv=none; b=e1w5hprCo8qc3TuDiUwoBjXfQaGlP5HVu1bm3DHMdnIP0K4FXlaokqi5OXydXKNHUZ4DELfvF14jycbKmluP77uET+MUsw/zmgH2r10xyInSmRz3sRvoIee6W9nZ40RGMs08T7HSb9UFcqh33JIqqvkJedz74T6FA3uA2WvJa/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530484; c=relaxed/simple;
	bh=ZVPN6MByTd22jB0HBprcmGP+r3GALgVWzh/U4SCYWtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s3Ix5JvS0APPml0g4RIe7k8WrjgeXkTWQAj4DEtelyYPaqLArUS4wMcEIjlV7aPybl15nz/Fy2NJ+UcIIksz21De782A4LIcdyJ8CA8mv1tjtMRFX2FAMQ5QBcJCkaHck3/a6Wr6BXEmAK6GDNPMdJ7xUr5I2qXym9VK6AQj1GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e+5zxzrC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e+5zxzrC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E784C4CEC3;
	Thu,  5 Sep 2024 10:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530484;
	bh=ZVPN6MByTd22jB0HBprcmGP+r3GALgVWzh/U4SCYWtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e+5zxzrCgWDG06aBqjolohNxzlFepekA0j+uezle2EjQqLi+qYvULK9bBqBXQQBK8
	 mg6tLrnGN6itSKNE24FSDBkY3XDZcWXNEvGr3I5AovY6URgJXDzrbyvrTSC2/Fd4Op
	 7mgQ43ItALi9MNLvJmtvtnFiNJ5Nfyi3bc6IpKNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhigang Luo <Zhigang.Luo@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 039/101] drm/amdgpu: avoid reading vf2pf info size from FB
Date: Thu,  5 Sep 2024 11:41:11 +0200
Message-ID: <20240905093717.661483169@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhigang Luo <Zhigang.Luo@amd.com>

[ Upstream commit 3bcc0ee14768d886cedff65da72d83d375a31a56 ]

VF can't access FB when host is doing mode1 reset. Using sizeof to get
vf2pf info size, instead of reading it from vf2pf header stored in FB.

Signed-off-by: Zhigang Luo <Zhigang.Luo@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
index 5ee9211c503c..af50e6ce39e1 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
@@ -604,7 +604,7 @@ static int amdgpu_virt_write_vf2pf_data(struct amdgpu_device *adev)
 	vf2pf_info->dummy_page_addr = (uint64_t)adev->dummy_page_addr;
 	vf2pf_info->checksum =
 		amd_sriov_msg_checksum(
-		vf2pf_info, vf2pf_info->header.size, 0, 0);
+		vf2pf_info, sizeof(*vf2pf_info), 0, 0);
 
 	return 0;
 }
-- 
2.43.0



