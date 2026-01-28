Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767DB30F548;
	Wed, 28 Jan 2026 15:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615845; cv=none; b=r+xqDzkLjtJ0s532syaQBRhxxsT19PoKxJLMjIdXfyV9ar/7l6SNJ1E0dzkr+TVa/hMNM9hV6jOy6gGR//sCHoaJ97I5oFuuI2P9iyb59sI7S2snv0UeoGaAJ8hZZt1V3YbJXCR0EqzLoeOvQn4ZJBFb1vSMsAsjrP5xd7AzSnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615845; c=relaxed/simple;
	bh=286HZWHnw2KVQvpZ2c4JbZPlK/VmRtO3KFtskuCyI3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H6q9Qg8QMhp9v2ViNlg+cWkw5FDcTHt5Uzv3ijMhvvATvTRggxAwpaPNFfFCWoGDvZBw2Y8cpeB5dnfevFXMcWT//BCFMD24aG5J35BjuoFZp9RsyR7cIBj8YksXJ9CBbemuU1r98DQ2J5c7cuWvYHiAP3zjajdl6i6Yl9qJoCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I3IyOU2I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I3IyOU2I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A773C4CEF1;
	Wed, 28 Jan 2026 15:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615844;
	bh=286HZWHnw2KVQvpZ2c4JbZPlK/VmRtO3KFtskuCyI3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I3IyOU2IT+NE23q6+zvWaBT/L3cdnsdbtdQ4S/kqAvjaKn16XlISSCRgJ6Maw/JQ/
	 P+onAQ2+RvXywO95fFDx+LOCDGU1hCrud/aYcjrV4lGPCqULpFDrWRnA04qSsTniu3
	 dFtq2OMOhOJeOPoi+z5ayFAiK5yn7Ohzot9mypcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 129/227] drm/amd/pm: Fix si_dpm mmCG_THERMAL_INT setting
Date: Wed, 28 Jan 2026 16:22:54 +0100
Message-ID: <20260128145349.104092796@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 4ca284c6d15dda481f714e3687a1d5fb70b3bf5c ]

Use WREG32 to write mmCG_THERMAL_INT.
This is a direct access register.

Fixes: 841686df9f7d ("drm/amdgpu: add SI DPM support (v4)")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 2555f4e4a741d31e0496572a8ab4f55941b4e30e)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
index 3a9522c17fee3..70499bf50ad47 100644
--- a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
+++ b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
@@ -7600,12 +7600,12 @@ static int si_dpm_set_interrupt_state(struct amdgpu_device *adev,
 		case AMDGPU_IRQ_STATE_DISABLE:
 			cg_thermal_int = RREG32_SMC(mmCG_THERMAL_INT);
 			cg_thermal_int |= CG_THERMAL_INT__THERM_INT_MASK_HIGH_MASK;
-			WREG32_SMC(mmCG_THERMAL_INT, cg_thermal_int);
+			WREG32(mmCG_THERMAL_INT, cg_thermal_int);
 			break;
 		case AMDGPU_IRQ_STATE_ENABLE:
 			cg_thermal_int = RREG32_SMC(mmCG_THERMAL_INT);
 			cg_thermal_int &= ~CG_THERMAL_INT__THERM_INT_MASK_HIGH_MASK;
-			WREG32_SMC(mmCG_THERMAL_INT, cg_thermal_int);
+			WREG32(mmCG_THERMAL_INT, cg_thermal_int);
 			break;
 		default:
 			break;
@@ -7617,12 +7617,12 @@ static int si_dpm_set_interrupt_state(struct amdgpu_device *adev,
 		case AMDGPU_IRQ_STATE_DISABLE:
 			cg_thermal_int = RREG32_SMC(mmCG_THERMAL_INT);
 			cg_thermal_int |= CG_THERMAL_INT__THERM_INT_MASK_LOW_MASK;
-			WREG32_SMC(mmCG_THERMAL_INT, cg_thermal_int);
+			WREG32(mmCG_THERMAL_INT, cg_thermal_int);
 			break;
 		case AMDGPU_IRQ_STATE_ENABLE:
 			cg_thermal_int = RREG32_SMC(mmCG_THERMAL_INT);
 			cg_thermal_int &= ~CG_THERMAL_INT__THERM_INT_MASK_LOW_MASK;
-			WREG32_SMC(mmCG_THERMAL_INT, cg_thermal_int);
+			WREG32(mmCG_THERMAL_INT, cg_thermal_int);
 			break;
 		default:
 			break;
-- 
2.51.0



