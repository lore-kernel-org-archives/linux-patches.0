Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038915;
	b=1y2MNwF76N7h8qBUYYGFJgHbqyub760h8c9XmNQIlgtWuC5ea6kQlsxdf3gKZh+mSJxw
	 3TFD852mEOpanZLzZVzF/xhsWOG/+WPM1++3ompkJh7fDMzjqe2OlyIir6TpUytLCmBp1
	 fKzEjD0ONE5D3zQsEDnryqNodLgKPZ7OOhbEKM6Sle+bDDw1//E/R8m2chBfWVejJaVn4
	 CuZxHfd1r9w4v0CRPrhFJ9oj66XLIkL49b7HSQW9aMsMZIl3e3Vagig0jVEPcvaQcTDBb
	 yrAs0bvhd72epnT/7UL3IM1gRK2xdD21vk0XUcBp7Yjn7AX+z18JnZrhWFo4LNS8xIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038915;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3liqg+M482Qe3oKnED691V946y8UOYaztuL3tr/rFEc=;
	b=QVJMiOTPi9oJSgYnJ5M20dSJgdNKIKQVGdkq9FT4Z9TJwatRbN0HxcKJDUZGDmhxipvh
	 BQquOBRH/RdKZ8FfKpOWCNWTBJt9X64axvfk7Hvl0qVD4d6ryR3jUKV6MFEJKBLN/HJme
	 m/jjWaVU+VybSv9AWlmf7gz6igfwvvohVIoj0QYWapu7s+SBk+Rc7xumcgz1nso5TAcf5
	 r3FrFDNqeZ1LCK0aA1Xj6xUZ7i4ZJLiSO276meXxpN3WSm2KZbXl+PrAGpKaZkLRBSOQ7
	 chCYxLNnIGkqC/bsO3NO+bE/OsQSu3ax1/CUTvTE5rCIj2bv7KHWIrJIWdkTuz6meEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=foblt37i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1ED1606A32A;
	Wed, 18 Nov 2026 21:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=foblt37i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366781F000C4;
	Wed, 18 Nov 2026 21:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038915;
	bh=3liqg+M482Qe3oKnED691V946y8UOYaztuL3tr/rFEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=foblt37iewJGYkUwbY3S9B06UM6Uu9Cx4sUN3Wk9mndMeWaTzehgsipCNtxayPZp3
	 E7Yh0JmTGBQwFngk7mNUHIWv9vZBopOLnPP6bdfu89pyIX9s9BA+b83Yn3v1DOXNVm
	 g1uFs8PIHdWFij2iVrs6cxRyvMrl4f8RUBOpyuvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Pierre-Loup A. Griffais" <pgriffais@valvesoftware.com>,
	Melissa Wen <mwen@igalia.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1911/3318] drm/amd/display: Signal PQ EOTF in FreeSync infopacket for DP HDR
Date: Wed, 18 Nov 2026 15:42:13 +0100
Message-ID: <20261118150419.336268276@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Melissa Wen <mwen@igalia.com>

[ Upstream commit 81f923b065801c7d30042bcda31ccb9449b4f58b ]

Commit c2791297013e ("drm/amd/display: Add color bit info to freesync
infoframe") created the app_tf interface for FreeSync HDR and commit
c21a764a98cb ("drm/amd/display: Send PQ bit in AMD VSIF") used it to set
PB9 bit 5 (PQ EOTF) in v2/v3 AMD Freesync infopacket. However, Linux
never made use of this interface: DM ignores what userspace sets
regarding HDR and always passes TRANSFER_FUNC_UNKNOWN as app_tf, so the
PQ bit is never set in the infopacket received by the eDP panel.

Check the EOTF in the HDR static metadata and set the PQ bit in Freesync
infopacket for DP accordingly. This fixes gray-washed HDR on KDE/GNOME
on Framework 13 Pro AI 9 HX 370 (DCN 3.5) and may fix similar issues on
other VRR-capable panels that advertise Replay in its AMD VSDB.

It doesn't affect color/EOTF bits on infopackets for SDR and native
HDMI.

Reported-by: Pierre-Loup A. Griffais <pgriffais@valvesoftware.com>
Closes: https://gitlab.freedesktop.org/drm/amd/-/work_items/3200
Signed-off-by: Melissa Wen <mwen@igalia.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit b318f3e13dd73781404670d3b3c6cf2177e0119c)
Cc: stable@vger.kernel.org
[ sashal: inlined dm_dp_in_hdr_mode() logic in the existing update_freesync_state_on_stream() function ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 900ded67a55ee..de16398e0ca07 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -7893,6 +7893,8 @@ static void prepare_flip_isr(struct amdgpu_crtc *acrtc)
 		      acrtc->crtc_id);
 }
 
+#define DP_HDR_SDP_EOTF_IDX 2
+
 static void update_freesync_state_on_stream(
 	struct amdgpu_display_manager *dm,
 	struct dm_crtc_state *new_crtc_state,
@@ -7908,6 +7910,8 @@ static void update_freesync_state_on_stream(
 	bool pack_sdp_v1_3 = false;
 	struct amdgpu_dm_connector *aconn;
 	enum vrr_packet_type packet_type = PACKET_TYPE_VRR;
+	enum color_transfer_func app_tf;
+	const struct dc_info_packet *hdr;
 
 	if (!new_stream)
 		return;
@@ -7959,12 +7963,18 @@ static void update_freesync_state_on_stream(
 					&new_stream->adaptive_sync_infopacket);
 	}
 
+	hdr = &new_stream->hdr_static_metadata;
+	app_tf = dc_is_dp_signal(new_stream->signal) && hdr->valid &&
+		 hdr->sb[DP_HDR_SDP_EOTF_IDX] == HDMI_EOTF_SMPTE_ST2084 ?
+		 TRANSFER_FUNC_PQ2084 :
+		 TRANSFER_FUNC_UNKNOWN;
+
 	mod_freesync_build_vrr_infopacket(
 		dm->freesync_module,
 		new_stream,
 		&vrr_params,
 		packet_type,
-		TRANSFER_FUNC_UNKNOWN,
+		app_tf,
 		&vrr_infopacket,
 		pack_sdp_v1_3);
 
-- 
2.53.0



