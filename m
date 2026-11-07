Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061417;
	b=l+hZFQ+PNImOTjQNVpgud/NymOOpw6TtjIf4WIQ6BUlQuN9HOQh1+8//ohSJYM6i8GCG
	 /ZFQhT2hao94v4/V02v5cDjCrBF6WrvwzVkUvoWaYWI8ziG38cRRRV/cXABdEOpACXOld
	 ep/gEJKWQrS4UKBJlOMBev0uSvpsmOWH2ax2VsXh8ocdwit0WhvWIWXlJS5JnNxrOREZt
	 2ZfDObmE3CPW+pzKHqZXDJQibY4iQ0QTv8uODY7X9cYsMafU5kgWxpWymDyAaAe79hkge
	 fuT8JtbIqYEx+RhQN141M5QsRQl8G+1JG8e83ZUGyUAMRk1RQd3Wg7epQd4RPNQNvpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061417;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=98SuR+MI2P0VSaja3VE4Alsq0u0Z9kLI/gxZ/aTPkcA=;
	b=q0S4qYKxmlzTD4RVtg1DZvHmgt7Hp55ahWKKT1mkoELn0yjQKd6Bb72dX3pdJNAzDYzZ
	 81h5Dc27MXD6omxRExATrioxCBgKImmIi5hX9QY9d8UliIIws1IKoUugBV5qGOs2wE3oF
	 2ZTHCJP9HKvkXCNHCozFyFTPkxYx2zClCgGyKY/MoQkAZM1OqcD3AUhy9ppHeLhtJW7Eh
	 /6SiL79Wrt8xWhx0r4okb0JP1txcZhLG36G7JWKA4w1YKAeO5PrevrjoA/ao4U9d2uYfZ
	 /xxndUWeO5cFF7BXW8fF+F9HJ138oTBAz71iQx4DPV4/FlCtT6NKS6IQFfV1dLHfPbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NvaaKX+0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3161C606A32F;
	Sat,  7 Nov 2026 14:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NvaaKX+0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C141F0089F;
	Sat,  7 Nov 2026 14:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061417;
	bh=98SuR+MI2P0VSaja3VE4Alsq0u0Z9kLI/gxZ/aTPkcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NvaaKX+0Qwcnf5RfK0MCw0oTgjuXEwrPiYW7RI0QqmGwZtggCQZQcF/yKlFaBvO6k
	 dtFw8hyF3nyDRqcLLltZOULYKsge3mYfum0hD9BWGrfRr9tYb2ukykE1MbRwhLof0l
	 os4n44Nv2yeB+mPgWEb/0s1JbGj4mdicqLz56KX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Coelho <luciano.coelho@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0529/1536] drm/i915/dp_mst: Fix configuring TUs for a disconnected stream
Date: Sat,  7 Nov 2026 08:42:25 -0500
Message-ID: <20261107135012.471721522@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Imre Deak <imre.deak@intel.com>

[ Upstream commit a443e0b8d647c1401b110d9f919d8c6cb8607260 ]

During an atomic commit after all the MST stream CRTC state is computed
the driver ensures that the sum of TUs of all the streams on a given MST
topology link is within limits (63 for 8b10 and 64 for 128b132b). For a
disconnected stream the DRM MST core's BW verification doesn't ensure
this, because the topology state it uses for this is destroyed as soon
as the stream (i.e. MST connector/port) is disconnected. The driver
should keep the link state valid even for such disconnected streams, as
userspace may disable them one-by-one only in a deferred way. Ensure the
link's sum of TUs stays within limits in this case by simply reusing the
maximum link BPP limit from the stream's (i.e. CRTC's) old state.

The disconnection can happen either via the whole topology getting
disconnected or via only the given stream's port getting disconnected.
Check for both of these conditions separately, as a connector gets
unregistered after a link disconnect event only in a deferred way.

Cc: stable@vger.kernel.org # v6.10+
Link: https://gitlab.freedesktop.org/drm/i915/kernel/-/work_items/16073
Link: https://gitlab.freedesktop.org/drm/i915/kernel/-/work_items/16384
Reviewed-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patch.msgid.link/20260907174413.741851-2-imre.deak@intel.com
(cherry picked from commit ee00f8fbb2b202002ab90834e02e9ba372773a36)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
[ sashal: Replaced the undeclared crtc argument with intel_crtc_for_pipe(display, pipe) in the intel_dp_mst_stream_disconnected() call in intel_link_bw_init_limits(), since this tree has no local crtc variable there. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_dp_mst.c  | 21 ++++++++++++++++++++
 drivers/gpu/drm/i915/display/intel_dp_mst.h  |  2 ++
 drivers/gpu/drm/i915/display/intel_link_bw.c |  4 +++-
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp_mst.c b/drivers/gpu/drm/i915/display/intel_dp_mst.c
index 5d5d8adcfb6af..f74767266da0f 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
@@ -2054,6 +2054,27 @@ bool intel_dp_mst_crtc_needs_modeset(struct intel_atomic_state *state,
 	return false;
 }
 
+bool intel_dp_mst_stream_disconnected(struct intel_atomic_state *state,
+				      const struct intel_crtc *crtc)
+{
+	struct intel_connector *connector;
+
+	connector = get_connector_in_state_for_crtc(state, crtc);
+	if (!connector)
+		return false;
+
+	if (!connector->mst.dp)
+		return false;
+
+	if (!connector->mst.dp->mst.mgr.mst_state)
+		return true;
+
+	if (drm_connector_is_unregistered(&connector->base))
+		return true;
+
+	return false;
+}
+
 /**
  * intel_dp_mst_prepare_probe - Prepare an MST link for topology probing
  * @intel_dp: DP port object
diff --git a/drivers/gpu/drm/i915/display/intel_dp_mst.h b/drivers/gpu/drm/i915/display/intel_dp_mst.h
index 8343804ce3f8d..261a97e24d91e 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_mst.h
+++ b/drivers/gpu/drm/i915/display/intel_dp_mst.h
@@ -27,6 +27,8 @@ int intel_dp_mst_atomic_check_link(struct intel_atomic_state *state,
 				   struct intel_link_bw_limits *limits);
 bool intel_dp_mst_crtc_needs_modeset(struct intel_atomic_state *state,
 				     struct intel_crtc *crtc);
+bool intel_dp_mst_stream_disconnected(struct intel_atomic_state *state,
+				      const struct intel_crtc *crtc);
 void intel_dp_mst_prepare_probe(struct intel_dp *intel_dp);
 bool intel_dp_mst_verify_dpcd_state(struct intel_dp *intel_dp);
 
diff --git a/drivers/gpu/drm/i915/display/intel_link_bw.c b/drivers/gpu/drm/i915/display/intel_link_bw.c
index c87cd1d16d0a2..5aa0db5636078 100644
--- a/drivers/gpu/drm/i915/display/intel_link_bw.c
+++ b/drivers/gpu/drm/i915/display/intel_link_bw.c
@@ -35,7 +35,9 @@ void intel_link_bw_init_limits(struct intel_atomic_state *state,
 			intel_atomic_get_new_crtc_state(state,
 							intel_crtc_for_pipe(display, pipe));
 
-		if (state->base.duplicated && crtc_state) {
+		if ((state->base.duplicated && crtc_state) ||
+		    intel_dp_mst_stream_disconnected(state,
+						 intel_crtc_for_pipe(display, pipe))) {
 			limits->max_bpp_x16[pipe] = crtc_state->max_link_bpp_x16;
 			if (crtc_state->fec_enable)
 				limits->force_fec_pipes |= BIT(pipe);
-- 
2.53.0



