Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E5B329C55;
	Mon, 27 Oct 2025 18:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591330; cv=none; b=JJcPkghhq+scR2rfPNIl0649i8ExRWqnZZB4TcvVG55T4qZ5vqGT1A5yw9zCOW3zSc4ya2kjcEwEGVsEnu0L3NemldtwaPwVVwiUKr/A5kBZYA74PzOuUb1spaF1eLfEzLZgnPwhwTvDEeN14stRnyTAB2yDTKrqji0WnZA5mf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591330; c=relaxed/simple;
	bh=3nTfQR1KxhGsNq7IBpvkj+pu4YXRkWJZn6H4+JimFNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jWTNG+4wAlEg6jDGuKtCp867HI5FvQyyPqJEcd6qspU0rmrhybeCKe3y9C8a/pwmSR8+TSYDmsHOzUeQnQ4AJ6vbbGY++PiGWzwI+bJl08/y89ukctl8KQ5bk9IPnaP9l9gWWJggd3+654ogTpptb1J+Z9HoGp4sfUCAvL9/Qls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BPhvAQcs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BPhvAQcs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECE05C4CEF1;
	Mon, 27 Oct 2025 18:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591330;
	bh=3nTfQR1KxhGsNq7IBpvkj+pu4YXRkWJZn6H4+JimFNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BPhvAQcs6zkbguvpvO1iQM3dljRkTJHDpag4LWgL0G0lXWJshQnIQoM/yMszLXnvm
	 BoeZppcBAqHllBVA5NCKg1a+T0vgiFBpqUTnx9KkVmI9emL7AZA5LD8nzTdcef1VJD
	 Z/q7YVv2YWa0xj846S6wMrwYgy+5juYMGGuO8mGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 119/332] drm/amdgpu: Add additional DCE6 SCL registers
Date: Mon, 27 Oct 2025 19:32:52 +0100
Message-ID: <20251027183527.756202437@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 507296328b36ffd00ec1f4fde5b8acafb7222ec7 ]

Fixes: 102b2f587ac8 ("drm/amd/display: dce_transform: DCE6 Scaling Horizontal Filter Init (v2)")
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/include/asic_reg/dce/dce_6_0_d.h       | 7 +++++++
 drivers/gpu/drm/amd/include/asic_reg/dce/dce_6_0_sh_mask.h | 2 ++
 2 files changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/amd/include/asic_reg/dce/dce_6_0_d.h b/drivers/gpu/drm/amd/include/asic_reg/dce/dce_6_0_d.h
index 9de01ae574c03..067eddd9c62d8 100644
--- a/drivers/gpu/drm/amd/include/asic_reg/dce/dce_6_0_d.h
+++ b/drivers/gpu/drm/amd/include/asic_reg/dce/dce_6_0_d.h
@@ -4115,6 +4115,7 @@
 #define mmSCL0_SCL_COEF_RAM_CONFLICT_STATUS 0x1B55
 #define mmSCL0_SCL_COEF_RAM_SELECT 0x1B40
 #define mmSCL0_SCL_COEF_RAM_TAP_DATA 0x1B41
+#define mmSCL0_SCL_SCALER_ENABLE 0x1B42
 #define mmSCL0_SCL_CONTROL 0x1B44
 #define mmSCL0_SCL_DEBUG 0x1B6A
 #define mmSCL0_SCL_DEBUG2 0x1B69
@@ -4144,6 +4145,7 @@
 #define mmSCL1_SCL_COEF_RAM_CONFLICT_STATUS 0x1E55
 #define mmSCL1_SCL_COEF_RAM_SELECT 0x1E40
 #define mmSCL1_SCL_COEF_RAM_TAP_DATA 0x1E41
+#define mmSCL1_SCL_SCALER_ENABLE 0x1E42
 #define mmSCL1_SCL_CONTROL 0x1E44
 #define mmSCL1_SCL_DEBUG 0x1E6A
 #define mmSCL1_SCL_DEBUG2 0x1E69
@@ -4173,6 +4175,7 @@
 #define mmSCL2_SCL_COEF_RAM_CONFLICT_STATUS 0x4155
 #define mmSCL2_SCL_COEF_RAM_SELECT 0x4140
 #define mmSCL2_SCL_COEF_RAM_TAP_DATA 0x4141
+#define mmSCL2_SCL_SCALER_ENABLE 0x4142
 #define mmSCL2_SCL_CONTROL 0x4144
 #define mmSCL2_SCL_DEBUG 0x416A
 #define mmSCL2_SCL_DEBUG2 0x4169
@@ -4202,6 +4205,7 @@
 #define mmSCL3_SCL_COEF_RAM_CONFLICT_STATUS 0x4455
 #define mmSCL3_SCL_COEF_RAM_SELECT 0x4440
 #define mmSCL3_SCL_COEF_RAM_TAP_DATA 0x4441
+#define mmSCL3_SCL_SCALER_ENABLE 0x4442
 #define mmSCL3_SCL_CONTROL 0x4444
 #define mmSCL3_SCL_DEBUG 0x446A
 #define mmSCL3_SCL_DEBUG2 0x4469
@@ -4231,6 +4235,7 @@
 #define mmSCL4_SCL_COEF_RAM_CONFLICT_STATUS 0x4755
 #define mmSCL4_SCL_COEF_RAM_SELECT 0x4740
 #define mmSCL4_SCL_COEF_RAM_TAP_DATA 0x4741
+#define mmSCL4_SCL_SCALER_ENABLE 0x4742
 #define mmSCL4_SCL_CONTROL 0x4744
 #define mmSCL4_SCL_DEBUG 0x476A
 #define mmSCL4_SCL_DEBUG2 0x4769
@@ -4260,6 +4265,7 @@
 #define mmSCL5_SCL_COEF_RAM_CONFLICT_STATUS 0x4A55
 #define mmSCL5_SCL_COEF_RAM_SELECT 0x4A40
 #define mmSCL5_SCL_COEF_RAM_TAP_DATA 0x4A41
+#define mmSCL5_SCL_SCALER_ENABLE 0x4A42
 #define mmSCL5_SCL_CONTROL 0x4A44
 #define mmSCL5_SCL_DEBUG 0x4A6A
 #define mmSCL5_SCL_DEBUG2 0x4A69
@@ -4287,6 +4293,7 @@
 #define mmSCL_COEF_RAM_CONFLICT_STATUS 0x1B55
 #define mmSCL_COEF_RAM_SELECT 0x1B40
 #define mmSCL_COEF_RAM_TAP_DATA 0x1B41
+#define mmSCL_SCALER_ENABLE 0x1B42
 #define mmSCL_CONTROL 0x1B44
 #define mmSCL_DEBUG 0x1B6A
 #define mmSCL_DEBUG2 0x1B69
diff --git a/drivers/gpu/drm/amd/include/asic_reg/dce/dce_6_0_sh_mask.h b/drivers/gpu/drm/amd/include/asic_reg/dce/dce_6_0_sh_mask.h
index 41c4a46ce3572..afe7303802c61 100644
--- a/drivers/gpu/drm/amd/include/asic_reg/dce/dce_6_0_sh_mask.h
+++ b/drivers/gpu/drm/amd/include/asic_reg/dce/dce_6_0_sh_mask.h
@@ -8646,6 +8646,8 @@
 #define REGAMMA_LUT_INDEX__REGAMMA_LUT_INDEX__SHIFT 0x00000000
 #define REGAMMA_LUT_WRITE_EN_MASK__REGAMMA_LUT_WRITE_EN_MASK_MASK 0x00000007L
 #define REGAMMA_LUT_WRITE_EN_MASK__REGAMMA_LUT_WRITE_EN_MASK__SHIFT 0x00000000
+#define SCL_SCALER_ENABLE__SCL_SCALE_EN_MASK 0x00000001L
+#define SCL_SCALER_ENABLE__SCL_SCALE_EN__SHIFT 0x00000000
 #define SCL_ALU_CONTROL__SCL_ALU_DISABLE_MASK 0x00000001L
 #define SCL_ALU_CONTROL__SCL_ALU_DISABLE__SHIFT 0x00000000
 #define SCL_BYPASS_CONTROL__SCL_BYPASS_MODE_MASK 0x00000003L
-- 
2.51.0



