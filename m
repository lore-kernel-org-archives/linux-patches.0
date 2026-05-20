Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B82F3CAE61;
	Wed, 20 May 2026 17:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296979; cv=none; b=V5khOjZ7zQ189N4IV3zvrjdviAptdOol6HCyM48nRsGPCQwHLXt/CxEaXk95aCoM6jL+cBw03xvZkvOCdIClImeWDAFPnHo3AcvQKfuSYUY9t/vAWgeV8uG97fkLrEf6/R1Rz8Nskehy9+QvD8FGxMGxIAo2BJSP2GyrKXVjlh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296979; c=relaxed/simple;
	bh=itFMrjgmvMXn++Zfwvvliw7vLggmusJ6ryFutm1RyYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g93gqkbU+cqagUAwzQ87aaniZagBsqCiABoOY8IMr9efLC8ZIPCOx+SRCXgHUad1m+ABygb1IzZxfwSRdHRRxP8+Ui6ttXrculu3IdB1+wjr1eN0Qn0ozFDuiUYy/UHCh3e6lx83kD/LW/HAd+VD3fxj6Ud11dLQGYe61KiCGdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FGTHREQp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FGTHREQp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 814C01F000E9;
	Wed, 20 May 2026 17:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296978;
	bh=OF2yvdfP06TiERYazNt2oQtQaH8HsoGAbGPtM9084zE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FGTHREQpp7E5zKldtTJX60ESMp2l/b1vceCk5MOyRgliaxb7Qs7OJs/tmllSj7BfT
	 umJmWpKIpyb0i5YD3Rqfori8bqVaB+pvqrNT7iPHp/6NBIU6Bv0iaF55Swt9Qy1bil
	 Js1OYpmVP8sVVAq96MGnE3hmi0j0zDolWVnpYQGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pratik Vishwakarma <Pratik.Vishwakarma@amd.com>,
	Roman Li <Roman.Li@amd.com>,
	Mario Limonciello <superm1@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0962/1146] drm/amd/display: properly handle family setting for early GC 11.5.4
Date: Wed, 20 May 2026 18:20:12 +0200
Message-ID: <20260520162210.005354878@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 31bc64e87f5f3d9ccbb7e625d570cfd8f52c77fc ]

Early variants need an override.

Fixes: 57d00816c6a9 ("drm/amdgpu: set family for GC 11.5.4")
Cc: Pratik Vishwakarma <Pratik.Vishwakarma@amd.com>
Cc: Roman Li <Roman.Li@amd.com>
Cc: Mario Limonciello <superm1@kernel.org>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Tested-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 922fccc2d3f8186008c19ba08a49ae8a9463cb50)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c     | 4 +---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 6 +++++-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
index af3d2fd61cf3f..3459d356151ef 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -2986,10 +2986,8 @@ int amdgpu_discovery_set_ip_blocks(struct amdgpu_device *adev)
 	case IP_VERSION(11, 5, 1):
 	case IP_VERSION(11, 5, 2):
 	case IP_VERSION(11, 5, 3):
-		adev->family = AMDGPU_FAMILY_GC_11_5_0;
-		break;
 	case IP_VERSION(11, 5, 4):
-		adev->family = AMDGPU_FAMILY_GC_11_5_4;
+		adev->family = AMDGPU_FAMILY_GC_11_5_0;
 		break;
 	case IP_VERSION(12, 0, 0):
 	case IP_VERSION(12, 0, 1):
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 2328c1aa0ead1..0aee65503642d 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1891,7 +1891,11 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 		goto error;
 	}
 
-	init_data.asic_id.chip_family = adev->family;
+	/* special handling for early revisions of GC 11.5.4 */
+	if (amdgpu_ip_version(adev, GC_HWIP, 0) == IP_VERSION(11, 5, 4))
+		init_data.asic_id.chip_family = AMDGPU_FAMILY_GC_11_5_4;
+	else
+		init_data.asic_id.chip_family = adev->family;
 
 	init_data.asic_id.pci_revision_id = adev->pdev->revision;
 	init_data.asic_id.hw_internal_rev = adev->external_rev_id;
-- 
2.53.0



