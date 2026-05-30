Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8ACF21ADC7;
	Sat, 30 May 2026 18:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165480; cv=none; b=CJFIeCgSn9LnPwDXfH6VdlpqiHom7+V3Y8jTz3PtuzwWbc6LgpGQhESzmufrRHpODgoZr/rkXK+2BHrSSKzOzRtMXZnr7sLiujs+d11eptrXXy0xUS7DOrWU/vsU8Q3kmxexjhSXXPYYo+mLWwFV8qP5bSH/8kL5E8My18PbWA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165480; c=relaxed/simple;
	bh=wFA9Qi71l+DtOqFZQYE1u5uWxXo2szxOPiQw/go5DE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qhzp2a/WlD2s8TWiv/i6A1WfBfDTF/7OOrtkqrVkxwhDql7Ooof8SLDbjSJ0BNNEkG0VquWz3gkNBor6xseV+7/AGVKVFxCokd4gMgASNf6lgIUyFWh3dxN3zupRoDk36N/ueySZ1tZufm+HTLCaJjQoea7mqnO8D5QEI2LB754=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0D0d6qph; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0D0d6qph"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B1B1F00893;
	Sat, 30 May 2026 18:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165479;
	bh=2fMr5pmn6k8qf5/UBWi2e9nO1D8tlHJtKP0lSqUPQgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0D0d6qphjQbxTI4t6VyzX8q4S4hsmsgNMWI7q/IowFshYcf+mhzTQB6ocOx8fZFOH
	 mv7QcBNQmnBETl72IDfyrcwFBhgc5wDMIKw8rPldhGO642pRg/wvg0dV2ckqISH7gb
	 LOfdAJjtWBXzjJxNL+qbyPp8z/NbsfRcMBp3h0Vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 090/589] drm/amd/display: Add null checker before passing variables
Date: Sat, 30 May 2026 17:59:31 +0200
Message-ID: <20260530160227.055687089@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

From: Alex Hung <alex.hung@amd.com>

commit 8092aa3ab8f7b737a34b71f91492c676a843043a upstream.

Checks null pointer before passing variables to functions.

This fixes 3 NULL_RETURNS issues reported by Coverity.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Acked-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Fixes: cdaae8371aa9 ("drm/amd/display: Handle GPU reset for DC block")
Fixes: dcd5fb82ffb4 ("drm/amd/display: Fix reference counting for struct dc_sink.")
Fixes: 4562236b3bc0 ("drm/amd/dc: Add dc display driver (v2)")
[ kovalev: bp to fix CVE-2024-43902; added Fixes tags ]
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index c22783b882067..bd15de4dee75e 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1778,7 +1778,8 @@ static int dm_suspend(void *handle)
 		mutex_lock(&dm->dc_lock);
 		dm->cached_dc_state = dc_copy_state(dm->dc->current_state);
 
-		dm_gpureset_toggle_interrupts(adev, dm->cached_dc_state, false);
+		if (dm->cached_dc_state)
+			dm_gpureset_toggle_interrupts(adev, dm->cached_dc_state, false);
 
 		amdgpu_dm_commit_zero_streams(dm->dc);
 
@@ -5396,7 +5397,8 @@ static void create_eml_sink(struct amdgpu_dm_connector *aconnector)
 		aconnector->dc_sink = aconnector->dc_link->local_sink ?
 		aconnector->dc_link->local_sink :
 		aconnector->dc_em_sink;
-		dc_sink_retain(aconnector->dc_sink);
+		if (aconnector->dc_sink)
+			dc_sink_retain(aconnector->dc_sink);
 	}
 }
 
@@ -6575,7 +6577,8 @@ static int amdgpu_dm_connector_get_modes(struct drm_connector *connector)
 				drm_add_modes_noedid(connector, 640, 480);
 	} else {
 		amdgpu_dm_connector_ddc_get_modes(connector, edid);
-		amdgpu_dm_connector_add_common_modes(encoder, connector);
+		if (encoder)
+			amdgpu_dm_connector_add_common_modes(encoder, connector);
 	}
 	amdgpu_dm_fbc_init(connector);
 
-- 
2.53.0



