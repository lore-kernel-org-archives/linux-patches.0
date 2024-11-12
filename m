Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F29213138;
	Tue, 12 Nov 2024 10:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408259; cv=none; b=L44VszkGMcXoI1OkYtwLbo2UMS80P0zMrX2YYWHBJ3cWfBT/RE/nZMbRH2Iz1lpdNlQ/lBzZDV0m8jRdg0F81LVPAyKF4IpfOM0aBcUfaG0IAS/R3t/0v2yso28ghPFa0jr9ZoIbMWsmFS/hoA/wojcZei1qHCTV4QDk2b9UcBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408259; c=relaxed/simple;
	bh=hanRY4uUf6HxzW0geYcW9BqEwBJAhy59DZU0osxPYPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WQ/vaey0dxcCnTXy6/634SR5xFrZ4QwMgc2Ew0ONAniv8Uq8dRMWi6dqcW/NmWQAWUGYyba70PVOZmZMavLBRtoRHXoWPJzA1lsf8F/9augCbyDazCXScmBk3UxSjbUVD9uMPK+tR84hr74RVsYjp21RvmWDus94ic4SNNVCdpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rLcJ3Htr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rLcJ3Htr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD46C4CECD;
	Tue, 12 Nov 2024 10:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408259;
	bh=hanRY4uUf6HxzW0geYcW9BqEwBJAhy59DZU0osxPYPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rLcJ3HtrpEuisOziTUy/hIRZIJ2haGyhCNbNlluf8GPYPUlj3xkDoMF9LZVXRLda+
	 yLmVieB7RiATbaHG8+7uidAVDHBQKB3PhHswrNrS2CkSoZQ1xGIumiZbmSj81wA5ug
	 ZYdIPUDeiouQJ9zHTIEm0ay0CByvJJKb9nQkDbhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.11 109/184] drm/amdgpu: Adjust debugfs register access permissions
Date: Tue, 12 Nov 2024 11:21:07 +0100
Message-ID: <20241112101905.049301466@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

commit b46dadf7e3cfe26d0b109c9c3d81b278d6c75361 upstream.

Regular users shouldn't have read access.

Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c0cfd2e652553d607b910be47d0cc5a7f3a78641)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
@@ -1648,7 +1648,7 @@ int amdgpu_debugfs_regs_init(struct amdg
 
 	for (i = 0; i < ARRAY_SIZE(debugfs_regs); i++) {
 		ent = debugfs_create_file(debugfs_regs_names[i],
-					  S_IFREG | 0444, root,
+					  S_IFREG | 0400, root,
 					  adev, debugfs_regs[i]);
 		if (!i && !IS_ERR_OR_NULL(ent))
 			i_size_write(ent->d_inode, adev->rmmio_size);


