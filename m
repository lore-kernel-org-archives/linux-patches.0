Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE02E143757;
	Wed, 19 Jun 2024 13:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803483; cv=none; b=ivAkyecwJgEC32YWmd/SZwAypF26vBt0nVbDpo9u0jM9nYyc7Hc0nwFxiJVRQ60Ef9gwMhGC1w6YmziD9qasakb0BmA29iMGlcNs2eS4WD5CqD6/37WC9N3zzZLmtJn0wmxn6i1YDboPzNHaPXy/ijRev79U9ob1F+fZ+elATeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803483; c=relaxed/simple;
	bh=MsLlM5Lat8wJPQ5rNvN5IGUI6LWH3Gk/sgUKLbGs/OE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y1EySt5v8LbHI0GxhuZjydSqB7dWoQXqNLbn6OgucvI+9EJLgAykSe1Hr4yDw7eVl4UAkJ2bda3GoqStqoANQFEpQ+fMRWVwfEWNZKCnkGSrQyO03yF6HABSlvH0D/TjNQLsJwk55Bx/S6dShmPoMl5pLNPoSX1Ej7dAXJ+nayM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VGIkY7r5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VGIkY7r5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51435C2BBFC;
	Wed, 19 Jun 2024 13:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803483;
	bh=MsLlM5Lat8wJPQ5rNvN5IGUI6LWH3Gk/sgUKLbGs/OE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VGIkY7r5Alo/poUP3pgX5oVZPZIH/RKqFW8EAvSvJT9d/nY1+KhvJU7WDZtqUdKYK
	 6kYZVIImWzxt03zd+VhAJtPwRE09EjfoUVGjziVw04JxKe7T8sh7k4RWno5f4R1qeZ
	 Uzz9mFyTR+6AFhE6RCeA8O3UtfkBCQZm2X3Hwpr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Leon=20Wei=C3=9F?= <leon.weiss@ruhr-uni-bochum.de>,
	lyude@redhat.com,
	imre.deak@intel.com,
	regressions@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Wayne Lin <Wayne.Lin@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.9 251/281] drm/mst: Fix NULL pointer dereference at drm_dp_add_payload_part2
Date: Wed, 19 Jun 2024 14:56:50 +0200
Message-ID: <20240619125619.637367093@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wayne Lin <Wayne.Lin@amd.com>

commit 5a507b7d2be15fddb95bf8dee01110b723e2bcd9 upstream.

[Why]
Commit:
- commit 5aa1dfcdf0a4 ("drm/mst: Refactor the flow for payload allocation/removement")
accidently overwrite the commit
- commit 54d217406afe ("drm: use mgr->dev in drm_dbg_kms in drm_dp_add_payload_part2")
which cause regression.

[How]
Recover the original NULL fix and remove the unnecessary input parameter 'state' for
drm_dp_add_payload_part2().

Fixes: 5aa1dfcdf0a4 ("drm/mst: Refactor the flow for payload allocation/removement")
Reported-by: Leon Weiß <leon.weiss@ruhr-uni-bochum.de>
Link: https://lore.kernel.org/r/38c253ea42072cc825dc969ac4e6b9b600371cc8.camel@ruhr-uni-bochum.de/
Cc: lyude@redhat.com
Cc: imre.deak@intel.com
Cc: stable@vger.kernel.org
Cc: regressions@lists.linux.dev
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Acked-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240307062957.2323620-1-Wayne.Lin@amd.com
(cherry picked from commit 4545614c1d8da603e57b60dd66224d81b6ffc305)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c |    2 +-
 drivers/gpu/drm/display/drm_dp_mst_topology.c             |    4 +---
 drivers/gpu/drm/i915/display/intel_dp_mst.c               |    2 +-
 drivers/gpu/drm/nouveau/dispnv50/disp.c                   |    2 +-
 include/drm/display/drm_dp_mst_helper.h                   |    1 -
 5 files changed, 4 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
@@ -363,7 +363,7 @@ void dm_helpers_dp_mst_send_payload_allo
 	mst_state = to_drm_dp_mst_topology_state(mst_mgr->base.state);
 	new_payload = drm_atomic_get_mst_payload_state(mst_state, aconnector->mst_output_port);
 
-	ret = drm_dp_add_payload_part2(mst_mgr, mst_state->base.state, new_payload);
+	ret = drm_dp_add_payload_part2(mst_mgr, new_payload);
 
 	if (ret) {
 		amdgpu_dm_set_mst_status(&aconnector->mst_status,
--- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
@@ -3421,7 +3421,6 @@ EXPORT_SYMBOL(drm_dp_remove_payload_part
 /**
  * drm_dp_add_payload_part2() - Execute payload update part 2
  * @mgr: Manager to use.
- * @state: The global atomic state
  * @payload: The payload to update
  *
  * If @payload was successfully assigned a starting time slot by drm_dp_add_payload_part1(), this
@@ -3430,14 +3429,13 @@ EXPORT_SYMBOL(drm_dp_remove_payload_part
  * Returns: 0 on success, negative error code on failure.
  */
 int drm_dp_add_payload_part2(struct drm_dp_mst_topology_mgr *mgr,
-			     struct drm_atomic_state *state,
 			     struct drm_dp_mst_atomic_payload *payload)
 {
 	int ret = 0;
 
 	/* Skip failed payloads */
 	if (payload->payload_allocation_status != DRM_DP_MST_PAYLOAD_ALLOCATION_DFP) {
-		drm_dbg_kms(state->dev, "Part 1 of payload creation for %s failed, skipping part 2\n",
+		drm_dbg_kms(mgr->dev, "Part 1 of payload creation for %s failed, skipping part 2\n",
 			    payload->port->connector->name);
 		return -EIO;
 	}
--- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
@@ -1160,7 +1160,7 @@ static void intel_mst_enable_dp(struct i
 	if (first_mst_stream)
 		intel_ddi_wait_for_fec_status(encoder, pipe_config, true);
 
-	drm_dp_add_payload_part2(&intel_dp->mst_mgr, &state->base,
+	drm_dp_add_payload_part2(&intel_dp->mst_mgr,
 				 drm_atomic_get_mst_payload_state(mst_state, connector->port));
 
 	if (DISPLAY_VER(dev_priv) >= 12)
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -915,7 +915,7 @@ nv50_msto_cleanup(struct drm_atomic_stat
 		msto->disabled = false;
 		drm_dp_remove_payload_part2(mgr, new_mst_state, old_payload, new_payload);
 	} else if (msto->enabled) {
-		drm_dp_add_payload_part2(mgr, state, new_payload);
+		drm_dp_add_payload_part2(mgr, new_payload);
 		msto->enabled = false;
 	}
 }
--- a/include/drm/display/drm_dp_mst_helper.h
+++ b/include/drm/display/drm_dp_mst_helper.h
@@ -851,7 +851,6 @@ int drm_dp_add_payload_part1(struct drm_
 			     struct drm_dp_mst_topology_state *mst_state,
 			     struct drm_dp_mst_atomic_payload *payload);
 int drm_dp_add_payload_part2(struct drm_dp_mst_topology_mgr *mgr,
-			     struct drm_atomic_state *state,
 			     struct drm_dp_mst_atomic_payload *payload);
 void drm_dp_remove_payload_part1(struct drm_dp_mst_topology_mgr *mgr,
 				 struct drm_dp_mst_topology_state *mst_state,


