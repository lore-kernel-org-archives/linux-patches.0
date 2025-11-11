Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F3B25A64C;
	Tue, 11 Nov 2025 01:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823901; cv=none; b=mL0Nct8Y6phFPVjW8qO8a7lZAmhe+pOqExPf+h4+LiYyZciNg0zQ+8unNjfYVbxF2eoNqGiFILrUv1c6tZwfs/3FYqU00oUc5GICGxlfqhsvVJ7MHpaC0lHxHf2g+Xb/lh3YihFuiGRcHHBMNkcQlEuIS566EQ1yPM8JKQJtFCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823901; c=relaxed/simple;
	bh=YtmJ5HRAXavhIhK9F9N/IhLbSxjaYymmvGhjzj0AlR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tX+cmsB7DZDoaUAjLO/Cwg48BG2XA2k22E5gTC3794+idWENN1tUwCGannvPY2D0wEps3PP4tJT85iyLMBM8PxYqlAvari8diNl4JTmhRX1PNEF6mYkjPWKfJTn371wttZRbNpoQVsJqgKlID8wapyoNcGOuQbq1eNShJbI48zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uWiJDtDT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uWiJDtDT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478C5C16AAE;
	Tue, 11 Nov 2025 01:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823901;
	bh=YtmJ5HRAXavhIhK9F9N/IhLbSxjaYymmvGhjzj0AlR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uWiJDtDTucL1CkHP1sETL9vAc6h7mdwiicZr/jae8poQBvWbZQfvhsb+t2tSkQNjG
	 haRuAz6RjmGpqE7rRmdKAWjFf9AuSTmk3EWWOKJGoZ//s8B0t/1Z1bc54JMjG+kiqS
	 MIixvWLncvoJ8aBjgluNJVn8CitkDdBUVGvGu5jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mangesh Gadre <Mangesh.Gadre@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 394/849] drm/amdgpu: Avoid vcn v5.0.1 poison irq call trace on sriov guest
Date: Tue, 11 Nov 2025 09:39:24 +0900
Message-ID: <20251111004545.962181133@linuxfoundation.org>
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

[ Upstream commit 37551277dfed796b6749e4fa52bdb62403cfdb42 ]

Sriov guest side doesn't init ras feature hence the poison irq shouldn't
be put during hw fini

Signed-off-by: Mangesh Gadre <Mangesh.Gadre@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c b/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c
index cb560d64da08c..8ef4a8b2fae99 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c
@@ -284,7 +284,7 @@ static int vcn_v5_0_1_hw_fini(struct amdgpu_ip_block *ip_block)
 			vinst->set_pg_state(vinst, AMD_PG_STATE_GATE);
 	}
 
-	if (amdgpu_ras_is_supported(adev, AMDGPU_RAS_BLOCK__VCN))
+	if (amdgpu_ras_is_supported(adev, AMDGPU_RAS_BLOCK__VCN) && !amdgpu_sriov_vf(adev))
 		amdgpu_irq_put(adev, &adev->vcn.inst->ras_poison_irq, 0);
 
 	return 0;
-- 
2.51.0



