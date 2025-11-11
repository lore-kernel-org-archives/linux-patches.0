Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80465305978;
	Tue, 11 Nov 2025 01:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823892; cv=none; b=NofSAvFx4diBesmK7kRwIpuikkS2iCGxTERx2wgGlseMo4hpwUafPacxWmHtlb8tQM4PRC94APzx2Q0D5G/P/IjkvAliU8fjuIWZD0FwNCatWYkvQ+YMgSPGNssC5MB4Zop5Bqen+OV0sqykaVVBh1R2xdEwW7WFv/VxyM40sEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823892; c=relaxed/simple;
	bh=gI1lp6AnT+X9Sqxe0MXYR4GEufgEc3aKL4Fn/ceSwdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SJY2MjlmAXQ3JGaJGMafG7rC3PFnWR0XcPKcKbOz5GjNDvynSzhOWTbo7gqKzZ/mP+6E2l3bkNOQlIek3MskVf95J/P6BlgoNxt8KdTr/XEjE9pGIJ/ZMu7EHe0hvEYFLBMZZjp6Fr4U7OnVL6PbRCeP7pj3qCAQ8I5sf4BcGAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pt5ol8TE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pt5ol8TE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20832C4CEF5;
	Tue, 11 Nov 2025 01:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823892;
	bh=gI1lp6AnT+X9Sqxe0MXYR4GEufgEc3aKL4Fn/ceSwdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pt5ol8TEQTMVWN1tMPRG9l5ku/bYEsSCpXAllHs2woIW0OpTvRt9TAOz6/piY1jxc
	 Z/yVvkRU+EKyEDb3xvLZCPJAj4WSeDiR+qZPfzXLYqyYRNOWxHdmfmMWCymSkKxURi
	 5nuEM+yq62lC1KvihcMgmrwtyQPZIt6GS/42pupg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mangesh Gadre <Mangesh.Gadre@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 392/849] drm/amdgpu: Avoid jpeg v5.0.1 poison irq call trace on sriov guest
Date: Tue, 11 Nov 2025 09:39:22 +0900
Message-ID: <20251111004545.911137309@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mangesh Gadre <Mangesh.Gadre@amd.com>

[ Upstream commit 01152c30eef972c5ca3b3eeb14f2984fa48d18c2 ]

Sriov guest side doesn't init ras feature hence the poison irq shouldn't
be put during hw fini

Signed-off-by: Mangesh Gadre <Mangesh.Gadre@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c
index 8d74455dab1e2..7731ef262d39f 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c
@@ -315,7 +315,7 @@ static int jpeg_v5_0_1_hw_fini(struct amdgpu_ip_block *ip_block)
 			ret = jpeg_v5_0_1_set_powergating_state(ip_block, AMD_PG_STATE_GATE);
 	}
 
-	if (amdgpu_ras_is_supported(adev, AMDGPU_RAS_BLOCK__JPEG))
+	if (amdgpu_ras_is_supported(adev, AMDGPU_RAS_BLOCK__JPEG) && !amdgpu_sriov_vf(adev))
 		amdgpu_irq_put(adev, &adev->jpeg.inst->ras_poison_irq, 0);
 
 	return ret;
-- 
2.51.0



