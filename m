Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13AE1B96D;
	Thu, 18 Jan 2024 10:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575129; cv=none; b=WRD6PV+wC04U20awsPJKhCxtbTtOwnv8ljn7wWSgGVleo/H/tN3H/Z2VUz1t9nYAEeilBATpvzpKfOlMdtUor+IrhnY8CCdCn/ttkdrKJc7sxdYKtFpxTAvL99glmaQ5uiC4lFyVRUHMKHkOLKFXHOQzjKmIMh7c9qNQhRQiUR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575129; c=relaxed/simple;
	bh=FRpWdSssnTRgZ5mu4BHg2a4fYxPplgir9krcW9CH6aQ=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=h9LUQympS8WLuxWxAif1zWtlmzRBWQV2SJ6rXszlON5q92LSWpX54XNjmaEKooXbcKcH1KIO7irxwLeYiOf2TUvdR7WDNyoU8kcQfR3mIoWdk2OGem4jmWgGanC3zcuIS0GAznOsOXeT5j9Uo6JhbIr+hZugYw6vr+Z3VD6FphQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UGBhkVNd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UGBhkVNd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A2AC433F1;
	Thu, 18 Jan 2024 10:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575129;
	bh=FRpWdSssnTRgZ5mu4BHg2a4fYxPplgir9krcW9CH6aQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UGBhkVNdtJ2qCmqw3urnaNeKbColjp0GzbRZYIHdIznqDaabH2nMGfec6VbDp/6Po
	 Axaa1qlAwuRHUULi1GvcQWECMmjQ5CjfGqVBfSc+81rw1OYlUAefUegBNbCAL2UBOc
	 k6eoaBabwsIafD8s696631BV3zCyLj81/vf+D3LY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 021/150] drm/amdgpu: Use another offset for GC 9.4.3 remap
Date: Thu, 18 Jan 2024 11:47:23 +0100
Message-ID: <20240118104321.036123651@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit ed6e4f0a27ebafffbd12bf3878ab004787685d8a ]

The legacy region at 0x7F000 maps to valid registers in GC 9.4.3 SOCs.
Use 0x1A000 offset instead as MMIO register remap region.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/soc15.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/soc15.c b/drivers/gpu/drm/amd/amdgpu/soc15.c
index 28094cd7d9c2..9abfe4c28cea 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -1160,6 +1160,11 @@ static int soc15_common_early_init(void *handle)
 			AMD_PG_SUPPORT_VCN_DPG |
 			AMD_PG_SUPPORT_JPEG;
 		adev->external_rev_id = adev->rev_id + 0x46;
+		/* GC 9.4.3 uses MMIO register region hole at a different offset */
+		if (!amdgpu_sriov_vf(adev)) {
+			adev->rmmio_remap.reg_offset = 0x1A000;
+			adev->rmmio_remap.bus_addr = adev->rmmio_base + 0x1A000;
+		}
 		break;
 	default:
 		/* FIXME: not supported yet */
-- 
2.43.0



