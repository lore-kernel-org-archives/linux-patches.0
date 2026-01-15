Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432D825228D;
	Thu, 15 Jan 2026 16:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768495955; cv=none; b=VG4xQ7QVs+zYagMNRdr2Y+LR+mFMvnpuZwzzHrShikcIs77XDrL/KCqZyii0OXcxRljsCoRAXxDj/PStsBVucEsMcxgVhSLYWLoJzoXJsaxi08jGFpyVprp76SrpdHQgD1WNLaGPR0DasL0mcStJihZe83sXZvwkRfw2TqWilhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768495955; c=relaxed/simple;
	bh=thkEQJSUMA08oh1G4QNJEhFJQ87h/VWfyOP2P3omfZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gplhJoigXqiFa+sFp//2jnp/8s71Izjo6K43a7dbA/I2LEpMuwzqX1LgUEOsb1LPn+DE17yLTNW1mcGwoby7wkOsNaqlSEpKdZIdc0TJMhifBaJsTgHqaLGfE1tTBJ+MTcUm2dm8Nmo0a8FEhpNzURkYfg7PP5wS21GylRXDeDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qG+Cs+jT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qG+Cs+jT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7475EC2BC86;
	Thu, 15 Jan 2026 16:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768495954;
	bh=thkEQJSUMA08oh1G4QNJEhFJQ87h/VWfyOP2P3omfZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qG+Cs+jTly1Rnssd7+LHs9Mbe6sJTQcaKv5bLF5XznIP4QkK+HWwjXBeT7tzr2ioa
	 heN6FMewovGt6IYMXHxrKoEgItQ6KNOYCLxtE9NW9V/gwhQ6wGNex9UAvosV+EGFBC
	 LL/Ro0Bz9/OPglybFG3BbKjhgs09aqNKfa1Jh7LY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lang Yu <lang.yu@amd.com>,
	Alan Liu <haoping.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 026/181] drm/amdgpu: Fix query for VPE block_type and ip_count
Date: Thu, 15 Jan 2026 17:46:03 +0100
Message-ID: <20260115164203.270833896@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Alan Liu <haoping.liu@amd.com>

commit 72d7f4573660287f1b66c30319efecd6fcde92ee upstream.

[Why]
Query for VPE block_type and ip_count is missing.

[How]
Add VPE case in ip_block_type and hw_ip_count query.

Reviewed-by: Lang Yu <lang.yu@amd.com>
Signed-off-by: Alan Liu <haoping.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit a6ea0a430aca5932b9c75d8e38deeb45665dd2ae)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
@@ -201,6 +201,9 @@ static enum amd_ip_block_type
 		type = (amdgpu_device_ip_get_ip_block(adev, AMD_IP_BLOCK_TYPE_JPEG)) ?
 				   AMD_IP_BLOCK_TYPE_JPEG : AMD_IP_BLOCK_TYPE_VCN;
 		break;
+	case AMDGPU_HW_IP_VPE:
+		type = AMD_IP_BLOCK_TYPE_VPE;
+		break;
 	default:
 		type = AMD_IP_BLOCK_TYPE_NUM;
 		break;
@@ -721,6 +724,9 @@ int amdgpu_info_ioctl(struct drm_device
 		case AMD_IP_BLOCK_TYPE_UVD:
 			count = adev->uvd.num_uvd_inst;
 			break;
+		case AMD_IP_BLOCK_TYPE_VPE:
+			count = adev->vpe.num_instances;
+			break;
 		/* For all other IP block types not listed in the switch statement
 		 * the ip status is valid here and the instance count is one.
 		 */


