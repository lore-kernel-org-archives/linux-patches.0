Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DE83EC2CA;
	Tue, 17 Mar 2026 16:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765531; cv=none; b=Wkcq6JQ465Wqh8hpuYRrMlTR2EXocxDsKkIYVHT6ZTZbqx1jJ6CXEsgAwfHAJl4dFe7YTsU2OBysMM4W+Qj8eM6e8u9RcomI5DSy3rv0c6h8K5dAnkSmjmlq25itzzQfRgPNlezK8ot9/bwd36a6/gpdu1GmIpYOS0LoHJmLW9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765531; c=relaxed/simple;
	bh=Lzj85STonb89kgdnaLDqkJBzXKn6AMCBuflSsiM5Zks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NT6zWaCpgNxWzbvKsRlAeZbmFCSH7GV5A4IyWsrF5Z4FjGIXBRCNOB2cLRUdInq84u8xD8so/3Lj1hk2Wu2VYhQCmlngpHRCdhCX5xcteKHFzc8WNvNcAbcDnDUV1qXLziOI5mKLQgmSSXKnEMPmBGjOA841yx3re8TAalMbbf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VwSthtid; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VwSthtid"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2137C4CEF7;
	Tue, 17 Mar 2026 16:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765531;
	bh=Lzj85STonb89kgdnaLDqkJBzXKn6AMCBuflSsiM5Zks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VwSthtidndt3l1+1RFZXOIDplVRc99rMEly5unkiwaPj5CFaW+0EYa5/WL4HXjnLO
	 Hdbl3Oh/zrg5s8CDw6MygfNgJzxX9eLchTZWZiC7DU2et5z/5k/A2YvZGWdDuFk330
	 KjHLFKE/QwjmndLptvwpieqiabO+MXZTGUDyouQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sguttula <suresh.guttula@amd.com>,
	Pratik Vishwakarma <Pratik.Vishwakarma@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 024/378] drm/amdgpu/vcn5: Add SMU dpm interface type
Date: Tue, 17 Mar 2026 17:29:41 +0100
Message-ID: <20260317163007.865997034@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: sguttula <suresh.guttula@amd.com>

[ Upstream commit a5fe1a54513196e4bc8f9170006057dc31e7155e ]

This will set AMDGPU_VCN_SMU_DPM_INTERFACE_* smu_type
based on soc type and fixing ring timeout issue seen
for DPM enabled case.

Signed-off-by: sguttula <suresh.guttula@amd.com>
Reviewed-by: Pratik Vishwakarma <Pratik.Vishwakarma@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit f0f23c315b38c55e8ce9484cf59b65811f350630)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c
index 0202df5db1e12..6109124f852e5 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c
@@ -174,6 +174,10 @@ static int vcn_v5_0_0_sw_init(struct amdgpu_ip_block *ip_block)
 		fw_shared->present_flag_0 = cpu_to_le32(AMDGPU_FW_SHARED_FLAG_0_UNIFIED_QUEUE);
 		fw_shared->sq.is_enabled = 1;
 
+		fw_shared->present_flag_0 |= cpu_to_le32(AMDGPU_VCN_SMU_DPM_INTERFACE_FLAG);
+		fw_shared->smu_dpm_interface.smu_interface_type = (adev->flags & AMD_IS_APU) ?
+			AMDGPU_VCN_SMU_DPM_INTERFACE_APU : AMDGPU_VCN_SMU_DPM_INTERFACE_DGPU;
+
 		if (amdgpu_vcnfw_log)
 			amdgpu_vcn_fwlog_init(&adev->vcn.inst[i]);
 
-- 
2.51.0



