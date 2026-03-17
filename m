Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14A83E3DB1;
	Tue, 17 Mar 2026 17:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767106; cv=none; b=YJ2R9PwJ+4BpyYZIJn5atj3xxnXZN8gvaC4pslpIu+cye5Lzx1nF3zlqy4YVLwRMxmV7tDitYMy1Thfmke0jrUF8AzEPWuBauGiG8DkCo8LzozD45t/UWdEv0Vi1EtToyS9OuVOAV/Jqte6rcghlppFshxEktMwT05Um3wjS2W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767106; c=relaxed/simple;
	bh=YDdJABeX1E5tOS2RUEd3GMgtzFkWj2hlvS2f5wYhtCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y2Sr5eNjwj6Akw5I2kHWo2EnTUh9JfvR/g7o267Vjt7la5dYbL+t7AqxiPV16U23rKmlQFeIs6N1pQ3zB7VVvtaRvTvbnJqH5CRtljzNM8qqovEgRW62JMm2rvMS/sk5l4qSnojRzIt0fxMEun8dBcLMVGlhHMcRQp5g5JJjhBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F3ASgb66; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F3ASgb66"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE84C4CEF7;
	Tue, 17 Mar 2026 17:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767106;
	bh=YDdJABeX1E5tOS2RUEd3GMgtzFkWj2hlvS2f5wYhtCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F3ASgb66afWbd1Q66a+CK/jejPKQjMlxzH8Ps2lQKMZVTFlSfrc+FYZDkTsmbHLVI
	 VJFnUv1a5gC0NCFFMzTungqL8zPchlz1Pn9t2dIXzdxlk3RU8HPGwjdehlaRu3X0W3
	 2Y/PkgOOIRUZQBXKQmJSzb0jEP2rjwulIh+qxRFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sguttula <suresh.guttula@amd.com>,
	Pratik Vishwakarma <Pratik.Vishwakarma@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 016/333] drm/amdgpu/vcn5: Add SMU dpm interface type
Date: Tue, 17 Mar 2026 17:30:45 +0100
Message-ID: <20260317162959.962538128@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



