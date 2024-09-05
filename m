Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0919514A08E;
	Thu,  5 Sep 2024 09:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529642; cv=none; b=AVpJp+cMklWxOZI3QU52lkqcH01sxPUIyc2EgT2n2mRjHc+HUP96v6bRmyyDE66cWYD0f1Sw/DDz90BLaXhLjVhp5BRFK7OWdp/UVz3wRLte6VXR/2n22jovc5xkYwpbXa/rphpevPaE3nQahkxH6BQm2lO9+89NzI02BET60s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529642; c=relaxed/simple;
	bh=msuYBH4Hnql3TEBN3T+eRXzhtegpGgVV3d/4XpFwnTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bmc5Z6IuTVR329O/FWE6wpZ4gnszQm1tzBdH+u8TdTQxYocmzAMR4bdQqA6GcpXMY10+6VkXdGo3K8QDlHYMkBjs8MGIvCaB0FlsJPta02qFkLS/aab/3boW97mD25poHOihHPPH23hBnnKZp/QuuFe0WDL6VhNENFUYWKeb4Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gcg3ohO/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gcg3ohO/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822BCC4CEC3;
	Thu,  5 Sep 2024 09:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529641;
	bh=msuYBH4Hnql3TEBN3T+eRXzhtegpGgVV3d/4XpFwnTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gcg3ohO/IiE52yO9VZclJJWShu1q6Escp3jOWVJ1RGv76W4L8T9fb+2+ntBivKzOi
	 dOe4rudEe8+5g3vVqvPdSMsudHk8NQfOmW5J1TyniG6drOTRwTyvQ7yiZnPXfZSwLX
	 iYgsTClhvTPKTDEJiPwE99SpsSsrEaoU+Zfh6+Tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhigang Luo <Zhigang.Luo@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 056/184] drm/amdgpu: avoid reading vf2pf info size from FB
Date: Thu,  5 Sep 2024 11:39:29 +0200
Message-ID: <20240905093734.429422369@linuxfoundation.org>
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
index f5fedf1be236..761fff80ec1f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
@@ -585,7 +585,7 @@ static int amdgpu_virt_write_vf2pf_data(struct amdgpu_device *adev)
 	}
 	vf2pf_info->checksum =
 		amd_sriov_msg_checksum(
-		vf2pf_info, vf2pf_info->header.size, 0, 0);
+		vf2pf_info, sizeof(*vf2pf_info), 0, 0);
 
 	return 0;
 }
-- 
2.43.0



