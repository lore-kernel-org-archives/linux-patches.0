Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A87813B5B3;
	Tue, 17 Jun 2025 16:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177806; cv=none; b=YbMMw7PoCEtuQ7BAHDr+1umeA0GV+0/R4xVGVmoGmzh8rDimt0KOB/H0vNQo9nfRlYNYh+dlYCB/tr5QA0+4/bqD83XGg77pOWW1E3cFZsZ8hsyT/yr8z5IzOchcXmmKL8L95Z+MSaaVIxv9AVl7oM60viS1v8RCmI6aZbfAckc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177806; c=relaxed/simple;
	bh=nYZDya2Oct8FDye9iF/4sypy10YuZLFpmzkCmvF02Sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Onbw70b+27ChTBWcPAhvQVePbK/dUasjREnBIsfDWARM7HnjkIZjA+v1kCpdLgMqsty/6lEIAnE6knrW1UY+vgk/WcBEgNh87Zy75JQDLvDo7FdK7chsNtLv4zL91tXj6QzRGh9V3pNbAqc37KA7Pwwshx34UkY8Cb9MMAUa85I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UcWZ9ZRx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UcWZ9ZRx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF2EC4CEE7;
	Tue, 17 Jun 2025 16:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177806;
	bh=nYZDya2Oct8FDye9iF/4sypy10YuZLFpmzkCmvF02Sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UcWZ9ZRxIqJBdrtbTONm1oOnI50UeqGDXdWj+IVoVRL+6RAq1zQTHawFCXY0z/cMK
	 XDg9Ji3bV6zxVlsKYje/TomayFGmeOgbGDWK9z5Vk+NO5v9xHYE4yGA/7FDuiGyJNs
	 IKh38m6dS2snp6EzV1HW9JyNdxOr8pT+GaoDNNaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David (Ming Qiang) Wu" <David.Wu3@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 399/512] drm/amdgpu: read back register after written for VCN v4.0.5
Date: Tue, 17 Jun 2025 17:26:05 +0200
Message-ID: <20250617152435.755793153@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David (Ming Qiang) Wu <David.Wu3@amd.com>

[ Upstream commit 07c9db090b86e5211188e1b351303fbc673378cf ]

On VCN v4.0.5 there is a race condition where the WPTR is not
updated after starting from idle when doorbell is used. Adding
register read-back after written at function end is to ensure
all register writes are done before they can be used.

Closes: https://gitlab.freedesktop.org/mesa/mesa/-/issues/12528
Signed-off-by: David (Ming Qiang) Wu <David.Wu3@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Tested-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Ruijing Dong <ruijing.dong@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: ee7360fc27d6 ("drm/amdgpu: read back register after written for VCN v4.0.5")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c
index e0b02bf1c5639..db33a2b9109aa 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c
@@ -985,6 +985,10 @@ static int vcn_v4_0_5_start_dpg_mode(struct amdgpu_device *adev, int inst_idx, b
 			ring->doorbell_index << VCN_RB1_DB_CTRL__OFFSET__SHIFT |
 			VCN_RB1_DB_CTRL__EN_MASK);
 
+	/* Keeping one read-back to ensure all register writes are done, otherwise
+	 * it may introduce race conditions */
+	RREG32_SOC15(VCN, inst_idx, regVCN_RB1_DB_CTRL);
+
 	return 0;
 }
 
@@ -1169,6 +1173,10 @@ static int vcn_v4_0_5_start(struct amdgpu_device *adev)
 		fw_shared->sq.queue_mode &= ~(FW_QUEUE_RING_RESET | FW_QUEUE_DPG_HOLD_OFF);
 	}
 
+	/* Keeping one read-back to ensure all register writes are done, otherwise
+	 * it may introduce race conditions */
+	RREG32_SOC15(VCN, i, regVCN_RB_ENABLE);
+
 	return 0;
 }
 
-- 
2.39.5



