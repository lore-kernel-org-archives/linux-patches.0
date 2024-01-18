Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0507822F0B;
	Thu, 18 Jan 2024 10:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575316; cv=none; b=PGXsm8pp9SgnzyrvLtEo73S6N4cj0hh6uS0ikBpsTcDfxVadpxseBDbPDFzLfmglvld6I/H3+jkeRn+25o4hNWbJzdFfCnOwevtoxfsB52XJyz6r3dlGeexbX38lppVhk5IFXMFRd7zzl/5qF012lKV/rdcLN7TNMzfSkOz1tvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575316; c=relaxed/simple;
	bh=zwsNY+zle39BfDrCOGr+2+vHjjrHSmOV3hEUM+2W89w=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=DkCZ5EIsT0ID05jANUoAYtZ/nGt9Cz6EKNUhTaUISuGdsuTBVkY9BueHQ/NK+Njw7o124DO1iEZ3Gk7+hmF+DcuJbR8Pudmmo3ieFD8QpechaA+j70aEDPPnWtIehAjLXKPoykdE89ywuTX05azAMraAmjoqHWBbEIVsCEDzoZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kI8W4RWr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kI8W4RWr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74CBDC433C7;
	Thu, 18 Jan 2024 10:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575315;
	bh=zwsNY+zle39BfDrCOGr+2+vHjjrHSmOV3hEUM+2W89w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kI8W4RWr/PopQwhJ3m8MU534sgIc9oN/4kXtvPDzujWekkpq2n9cytqMaZbRI86QD
	 +xEZDptrfrB2q9BPHLmtMvmYK3AHLff72eeQti7PCrpN6jVy9WaNIcZj5uaFOH5WNL
	 zLofwsjZJlJNRynHfb0fp8Z+dto8f7D0qV6J12fU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 061/150] drm/amdgpu: Add NULL checks for function pointers
Date: Thu, 18 Jan 2024 11:48:03 +0100
Message-ID: <20240118104322.803334673@linuxfoundation.org>
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

[ Upstream commit 81577503efb49f4ad76af22f9941d72900ef4aab ]

Check if function is implemented before making the call.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/soc15.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/soc15.c b/drivers/gpu/drm/amd/amdgpu/soc15.c
index 9abfe4c28cea..3667f9a54841 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -1422,9 +1422,11 @@ static void soc15_common_get_clockgating_state(void *handle, u64 *flags)
 	if (amdgpu_sriov_vf(adev))
 		*flags = 0;
 
-	adev->nbio.funcs->get_clockgating_state(adev, flags);
+	if (adev->nbio.funcs && adev->nbio.funcs->get_clockgating_state)
+		adev->nbio.funcs->get_clockgating_state(adev, flags);
 
-	adev->hdp.funcs->get_clock_gating_state(adev, flags);
+	if (adev->hdp.funcs && adev->hdp.funcs->get_clock_gating_state)
+		adev->hdp.funcs->get_clock_gating_state(adev, flags);
 
 	if (adev->ip_versions[MP0_HWIP][0] != IP_VERSION(13, 0, 2)) {
 
@@ -1440,9 +1442,11 @@ static void soc15_common_get_clockgating_state(void *handle, u64 *flags)
 	}
 
 	/* AMD_CG_SUPPORT_ROM_MGCG */
-	adev->smuio.funcs->get_clock_gating_state(adev, flags);
+	if (adev->smuio.funcs && adev->smuio.funcs->get_clock_gating_state)
+		adev->smuio.funcs->get_clock_gating_state(adev, flags);
 
-	adev->df.funcs->get_clockgating_state(adev, flags);
+	if (adev->df.funcs && adev->df.funcs->get_clockgating_state)
+		adev->df.funcs->get_clockgating_state(adev, flags);
 }
 
 static int soc15_common_set_powergating_state(void *handle,
-- 
2.43.0



