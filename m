Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591551;
	b=gdBP7Q8rGu1CX+NsRyi2xz2Mid1YD3wN9t2FXmqmpvA123Z5kFCERzFTvT26nrEVH1dU
	 yge+8N3URtCg/m6YH7KYHZVgGQilEr84NNS0qZmKsQDFRd2Ji7kS0QQgGm/MH/Exs3cPW
	 XofB1ILZRw8rIPMJGG7T/FsIkzwSQAALPjjFI6/6uM+XFMwjE+HdMZJ5WO84UqhXVXjPF
	 jvomW2B1rH1ry13myVu7sE2VRyvWTvmh9m2MVnp2Z/+1c3Wk4x0PecLulwsLQjGDGMCLT
	 NXszgSzjxTnb3oGyeRqdKJnSaV/0uRfpZ0KrpW6ym2jBio4/v4gPBogHFcLaDilRifA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591551;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ClwpNkTXliog/sdhn4eu6qubBs/x4tThUxNePXnmvME=;
	b=0UP1t1L0GaBCEzMLWPk8lylokYwEu8NgFn5mieO8XJRB1UrGskp/dtn6lRZE0AY3I1vt
	 VWNwuFDazWvNGg78cA+zCHMmVT1xO4n82YBzRe9lXboou/+ATBKelT1FZncxynGITKXLA
	 83AZvQ839lsVlwkR54HpPq7BTVaZxjo2EaGu6I6m1+LFWOgmbzgesc+gjn37W2/bsopKD
	 LuhmxJmQCSFIcd5uEX7JQi8sRYme3DNv1sFbe1zq5Am/vsUVqnA1DPy7A7of1MAEcvClp
	 uQ7tkgrj4KxVNPHRQOincsX7S226KlBllU0emXq/j8uZzK7p3vPdiXJ3Khj/kZ5M3rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qx1gHGBU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C807F606D871;
	Fri, 13 Nov 2026 17:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qx1gHGBU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 751C51F000C5;
	Fri, 13 Nov 2026 17:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591551;
	bh=ClwpNkTXliog/sdhn4eu6qubBs/x4tThUxNePXnmvME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qx1gHGBUbK9ZbEG84uX09hwKPmaLv/s7PZa4MYF9OEnv6lezUD9tpt7if1gysteho
	 lTjCGx1TI2p2iKQ0JNE8FW8QzloIG+X3XoyJmPVuGynX2HBl+zd09QHRwczA3ARDv9
	 MqRUfJxoeSJbnF3b9vSiA9LuLISj/RZV8dxaAORo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 602/670] drm/amd/pm: Revert state if force level fails
Date: Fri, 13 Nov 2026 10:52:46 -0500
Message-ID: <20261113153832.234698024@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 58893392989786eefd89aba48823dc3e27d37fd6 ]

Before forcing level, CG/PG is disabled or enabled depending on the new
level. However if the force level operation fails, CG/PG state remains
modified. Revert the state change on failure. Also, move invalid
operation checks to the beginning before any logic that could change SOC
state.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: ad6eb088a508 ("drm/amd/pm: reapply umd profile state after recovery")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_dpm.c | 58 +++++++++++++++++------------
 1 file changed, 35 insertions(+), 23 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/amdgpu_dpm.c b/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
index 0f37d5ccf246f..f57d09b025153 100644
--- a/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
@@ -974,6 +974,24 @@ enum amd_dpm_forced_level amdgpu_dpm_get_performance_level(struct amdgpu_device
 	return level;
 }
 
+static void amdgpu_dpm_enter_umd_state(struct amdgpu_device *adev)
+{
+	/* enter UMD Pstate */
+	amdgpu_device_ip_set_powergating_state(adev, AMD_IP_BLOCK_TYPE_GFX,
+					       AMD_PG_STATE_UNGATE);
+	amdgpu_device_ip_set_clockgating_state(adev, AMD_IP_BLOCK_TYPE_GFX,
+					       AMD_CG_STATE_UNGATE);
+}
+
+static void amdgpu_dpm_exit_umd_state(struct amdgpu_device *adev)
+{
+	/* exit UMD Pstate */
+	amdgpu_device_ip_set_clockgating_state(adev, AMD_IP_BLOCK_TYPE_GFX,
+					       AMD_CG_STATE_GATE);
+	amdgpu_device_ip_set_powergating_state(adev, AMD_IP_BLOCK_TYPE_GFX,
+					       AMD_PG_STATE_GATE);
+}
+
 int amdgpu_dpm_force_performance_level(struct amdgpu_device *adev,
 				       enum amd_dpm_forced_level level)
 {
@@ -994,6 +1012,10 @@ int amdgpu_dpm_force_performance_level(struct amdgpu_device *adev,
 	if (current_level == level)
 		return 0;
 
+	if (!(current_level & profile_mode_mask) &&
+	    (level == AMD_DPM_FORCED_LEVEL_PROFILE_EXIT))
+		return -EINVAL;
+
 	if (adev->asic_type == CHIP_RAVEN) {
 		if (!(adev->apu_flags & AMD_APU_IS_RAVEN2)) {
 			if (current_level != AMD_DPM_FORCED_LEVEL_MANUAL &&
@@ -1005,35 +1027,25 @@ int amdgpu_dpm_force_performance_level(struct amdgpu_device *adev,
 		}
 	}
 
-	if (!(current_level & profile_mode_mask) &&
-	    (level == AMD_DPM_FORCED_LEVEL_PROFILE_EXIT))
-		return -EINVAL;
-
-	if (!(current_level & profile_mode_mask) &&
-	      (level & profile_mode_mask)) {
-		/* enter UMD Pstate */
-		amdgpu_device_ip_set_powergating_state(adev,
-						       AMD_IP_BLOCK_TYPE_GFX,
-						       AMD_PG_STATE_UNGATE);
-		amdgpu_device_ip_set_clockgating_state(adev,
-						       AMD_IP_BLOCK_TYPE_GFX,
-						       AMD_CG_STATE_UNGATE);
-	} else if ((current_level & profile_mode_mask) &&
-		    !(level & profile_mode_mask)) {
-		/* exit UMD Pstate */
-		amdgpu_device_ip_set_clockgating_state(adev,
-						       AMD_IP_BLOCK_TYPE_GFX,
-						       AMD_CG_STATE_GATE);
-		amdgpu_device_ip_set_powergating_state(adev,
-						       AMD_IP_BLOCK_TYPE_GFX,
-						       AMD_PG_STATE_GATE);
-	}
+	if (!(current_level & profile_mode_mask) && (level & profile_mode_mask))
+		amdgpu_dpm_enter_umd_state(adev);
+	else if ((current_level & profile_mode_mask) &&
+		 !(level & profile_mode_mask))
+		amdgpu_dpm_exit_umd_state(adev);
 
 	mutex_lock(&adev->pm.mutex);
 
 	if (pp_funcs->force_performance_level(adev->powerplay.pp_handle,
 					      level)) {
 		mutex_unlock(&adev->pm.mutex);
+		/* If new level failed, retain the umd state as before */
+		if (!(current_level & profile_mode_mask) &&
+		    (level & profile_mode_mask))
+			amdgpu_dpm_exit_umd_state(adev);
+		else if ((current_level & profile_mode_mask) &&
+			 !(level & profile_mode_mask))
+			amdgpu_dpm_enter_umd_state(adev);
+
 		return -EINVAL;
 	}
 
-- 
2.53.0



