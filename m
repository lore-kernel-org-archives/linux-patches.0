Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FDF5343214;
	Tue, 11 Nov 2025 01:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823546; cv=none; b=hIZBevyKAkUo2dsa6qXK4Ade8UhupetADp9rBbwKiKA6xgPNG5vpTqvXAb9Scx5y2Rz1ew0/QMSO1OHM/Z68d4uX6qv0kPVSqd1LwlnKv5tUPkqv5DGIlW+XNmDEiM7X+DdnsBH5tXngk+I/Io3KOknDFMXCDc7AcxmxEtpwOK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823546; c=relaxed/simple;
	bh=EmL/HGVTUBDdvBcsWNqKGgebFsFYvfJXcuz027NTOo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pbTJR8VwigGOkTTqZV92esM5WXYd7MW4DiDRnuEmEEHnggR+P3JtDjxzBY3CIFAuijXEqRtO7mbZ/uXapXxb5ylRgrI5ZHXY7xR8b8+2ux00Yx3x04+WVKRsVCG1O4M2FwifYYXGSqvn1L+lGd6yAU1J+qsaI/4qGM2cawh2J7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zR88Qf/e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zR88Qf/e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E53F0C4CEFB;
	Tue, 11 Nov 2025 01:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823546;
	bh=EmL/HGVTUBDdvBcsWNqKGgebFsFYvfJXcuz027NTOo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zR88Qf/ei6+dneSJrMn2SDq8ZyF8sc4ePnv4gM6NzIGSaUiBVcUfnAQK4Tg3VuMr7
	 /8YroRaDO3MQVWrSb3N2oBavUZj0BvXG0Sv+o6vKZ+adAK3RHBoP3sHj71gJRcQTt4
	 +sIEsffbhgfRA3qI9/jZ2MdcjR6jSoCs703SUQ5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mangesh Gadre <Mangesh.Gadre@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 267/565] drm/amdgpu: Avoid vcn v5.0.1 poison irq call trace on sriov guest
Date: Tue, 11 Nov 2025 09:42:03 +0900
Message-ID: <20251111004532.896881354@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d8bbb93767318..0034e71283964 100644
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



