Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B1D239573;
	Tue, 26 Aug 2025 11:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207525; cv=none; b=WYlzsnjfSN4lx3OS2T3e0N5abZrDuYOFNwzcwO4HBuefqXyTgnm/eiFmB9LTWn/jekgzJ462WleAewUQ7SxZXtTQEXYuTkTO7U6IcCa4XAnDDpAPeI03nAkvtl1/Htc2tCR3DA/N7/szwmewMbDF8w52ra1vfH2+HcbXUSTwUD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207525; c=relaxed/simple;
	bh=lzMXDcnzhnvnFcAfm2Fv2h+pKdXWAYvJyf4wOpi7//Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gPrOLeH/7pswyzDnnzUVNrq58QLk65CReSrfbc6bVhiiiWPP4Cae2w8Osc/Xvtj8X3ZfShaPMxHhY5vwgMOMwpO95v2sLqO3L2YXyeQqkPgRZJ8LE4awqJRJXbVCrkiLKYLhs9h/WDOo58rdJmLg58wXodvo2NfZCN7EMF1E2s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QTWQOx67; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QTWQOx67"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CBB2C4CEF1;
	Tue, 26 Aug 2025 11:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207525;
	bh=lzMXDcnzhnvnFcAfm2Fv2h+pKdXWAYvJyf4wOpi7//Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QTWQOx67c83f1Te2cGCBKDOMSUXIfu9AwxR8Nj9w8GWLWXUdmS82i/oSfdrv0hOR7
	 YAUZZbw1PP8O2ikZytM0GzF9f/vP3bSfSOs0M4RvNP+lQbA6QylpFlnpaqKp69aOwC
	 fii/v831mNtoVWIeAeBeF+7FF837IPlVLGkDnsgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Mangesh Gadre <Mangesh.Gadre@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.16 184/457] drm/amdgpu: Update supported modes for GC v9.5.0
Date: Tue, 26 Aug 2025 13:07:48 +0200
Message-ID: <20250826110941.919860841@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

commit 389d79a195a9f71a103b39097ee8341a7ca60927 upstream.

For GC v9.5.0 SOCs, both CPX and QPX compute modes are also supported in
NPS2 mode.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Acked-by: Mangesh Gadre <Mangesh.Gadre@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 9d1ac25c7f830e0132aa816393b1e9f140e71148)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c
+++ b/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c
@@ -453,6 +453,7 @@ static int __aqua_vanjaram_get_px_mode_i
 					    uint16_t *nps_modes)
 {
 	struct amdgpu_device *adev = xcp_mgr->adev;
+	uint32_t gc_ver = amdgpu_ip_version(adev, GC_HWIP, 0);
 
 	if (!num_xcp || !nps_modes || !(xcp_mgr->supp_xcp_modes & BIT(px_mode)))
 		return -EINVAL;
@@ -476,12 +477,14 @@ static int __aqua_vanjaram_get_px_mode_i
 		*num_xcp = 4;
 		*nps_modes = BIT(AMDGPU_NPS1_PARTITION_MODE) |
 			     BIT(AMDGPU_NPS4_PARTITION_MODE);
+		if (gc_ver == IP_VERSION(9, 5, 0))
+			*nps_modes |= BIT(AMDGPU_NPS2_PARTITION_MODE);
 		break;
 	case AMDGPU_CPX_PARTITION_MODE:
 		*num_xcp = NUM_XCC(adev->gfx.xcc_mask);
 		*nps_modes = BIT(AMDGPU_NPS1_PARTITION_MODE) |
 			     BIT(AMDGPU_NPS4_PARTITION_MODE);
-		if (amdgpu_sriov_vf(adev))
+		if (gc_ver == IP_VERSION(9, 5, 0))
 			*nps_modes |= BIT(AMDGPU_NPS2_PARTITION_MODE);
 		break;
 	default:


