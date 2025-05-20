Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D88019ABB6;
	Tue, 20 May 2025 14:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750237; cv=none; b=mulKSwpLgkGMcu+A+J4SYeK4DWaKheET3nADaDoIxgEDYIQIiaTa0X9U4be8pXSN7bo2N5C2cC6pz2CQ2YkaMIb5ru47gmUQzx5GFYOjG3pZvdXXXIw5lXTzrP6AX6VJ7YJLyLnp0vh9IKUKHNnfw5w6QrOBLfsmg8biuaHK8DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750237; c=relaxed/simple;
	bh=cExWMK8nPMoA3Tpe0Ib3jcl/ArLqNl3WlSoaax1pOgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=urHOEOB0PnBFgzxRQF7wAUA3i11TCHlizhUB5ImKxFftyjz0z2+d5fB+VcobmdgZOnG7tDKLZ5V6ME1wLsv7bqUnY3aw8b7+N2BjhIK/GrGJVFPYa5lJIov+HPFmaLmBYLRBirfp7YzPfRLTS8c81p+KcJ2UAd5AjGbaU4ubgqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ka1GE/QO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ka1GE/QO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB6FC4CEE9;
	Tue, 20 May 2025 14:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750237;
	bh=cExWMK8nPMoA3Tpe0Ib3jcl/ArLqNl3WlSoaax1pOgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ka1GE/QOHDA5UcOpRAUx/Z99G4tPKM2J+iFUIjdT7k6H1xfNqNnRWYO3h5Nzzh/41
	 atBHJtIsrsGLGAkvi/ee5Uf/ZM96ttziMGv70L2cki/2WhuXnM5q0iWkHqNluTfP2W
	 GqJt+s6HESVopu0ZBtAMoPxUQxSDbsJDvSlXE6z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Wayne Lin <Wayne.Lin@amd.com>
Subject: [PATCH 6.12 087/143] drm/amd/display: Avoid flooding unnecessary info messages
Date: Tue, 20 May 2025 15:50:42 +0200
Message-ID: <20250520125813.481920728@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

From: Wayne Lin <Wayne.Lin@amd.com>

commit d33724ffb743d3d2698bd969e29253ae0cff9739 upstream.

It's expected that we'll encounter temporary exceptions
during aux transactions. Adjust logging from drm_info to
drm_dbg_dp to prevent flooding with unnecessary log messages.

Fixes: 3637e457eb00 ("drm/amd/display: Fix wrong handling for AUX_DEFER case")
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://lore.kernel.org/r/20250513032026.838036-1-Wayne.Lin@amd.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 9a9c3e1fe5256da14a0a307dff0478f90c55fc8c)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -107,7 +107,7 @@ static ssize_t dm_dp_aux_transfer(struct
 	if (payload.write && result >= 0) {
 		if (result) {
 			/*one byte indicating partially written bytes*/
-			drm_info(adev_to_drm(adev), "amdgpu: AUX partially written\n");
+			drm_dbg_dp(adev_to_drm(adev), "amdgpu: AUX partially written\n");
 			result = payload.data[0];
 		} else if (!payload.reply[0])
 			/*I2C_ACK|AUX_ACK*/
@@ -133,11 +133,11 @@ static ssize_t dm_dp_aux_transfer(struct
 			break;
 		}
 
-		drm_info(adev_to_drm(adev), "amdgpu: DP AUX transfer fail:%d\n", operation_result);
+		drm_dbg_dp(adev_to_drm(adev), "amdgpu: DP AUX transfer fail:%d\n", operation_result);
 	}
 
 	if (payload.reply[0])
-		drm_info(adev_to_drm(adev), "amdgpu: AUX reply command not ACK: 0x%02x.",
+		drm_dbg_dp(adev_to_drm(adev), "amdgpu: AUX reply command not ACK: 0x%02x.",
 			payload.reply[0]);
 
 	return result;


