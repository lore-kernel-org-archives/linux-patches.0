Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028609;
	b=LdjoTvGbYqxZDvrdX8UBHHp2w1pUj5/I6lak9E885tgwmI8g5GgNIVHvUloSCx1+frkg
	 FO+OeQY/HYeUEJ2lGntX3Pmzb7xNFfODRUY54IEXHq5ykYABNbv91QHh4DHiQPZfqwkj3
	 PmbMAUKx+M6uBqAOBNNgHZTjrFBTaWrn0RP/FI5HfLuV62QaB/YD/VLlM0GREi4JPIFnj
	 aL8i5ruFK+xko8rBU9TEXwtN3OY0sKd0yoEME6O2hB5eXxnTYFPi/b7yfpMrCBZjFbHgZ
	 gdC8xScib++rFEAKkXhLJ5trQs2tE65DDfnQMMy4moWq1mkLK9c8MITmDhof+in9VZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028609;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=11o9i6k6M1fI3l87f9rN6HDq/3zExjHRrhOsdsh+TPg=;
	b=lW8SI5gYl4d6ZWVwQ9ox9WFvoEeYiIzCpQcrFTCsFbxVSGsUQWzPuEy6fk0W9GokQQMv
	 SIj8700hskcSy5j6RMkEmkk1BkT3tlNODXOQxi5GKBfqEBG6uEgoXyGU1///KYBILR9tf
	 PrnSS3btWFPxRnpofZ2NZLY/N0viSfxdl/mPf495PP1Qn00eL1p14tnDe3qYfK0BAgL/y
	 Zyz5sey24wcJeZ8Gs2AMz9WOwBdriDEGz5xZ9fYXXQ10jSqRH3q78P80u9NgSlc4p5Ln2
	 O1Dka1XWIcFc0dQOHrgmiZD/KbwPwTrvkJp1IfCWy56v7kE13GY9to0iP6zr8hhaLgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wRZLqk7h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1632606A31C;
	Wed, 18 Nov 2026 19:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wRZLqk7h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC7F1F000C4;
	Wed, 18 Nov 2026 19:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028608;
	bh=11o9i6k6M1fI3l87f9rN6HDq/3zExjHRrhOsdsh+TPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wRZLqk7h01QPRYXbYvsb9Pl6p9Y2UdtwThSAcFxdRfNUmNG/Br3BP1RmSSNDaegae
	 u5XDz/aF8x4/dQXGLmcUegPBVzxGXv3lK/Emqap+Io2yp6XeYY6nI9VPh/jh1VY4wB
	 IIEE3nNd4K+H+mw7XoLQBTR5qP2xH86eiDzngdH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Pierre-Loup A. Griffais" <pgriffais@valvesoftware.com>,
	Melissa Wen <mwen@igalia.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0055/1756] drm/amd/display: Signal PQ EOTF in FreeSync infopacket for DP HDR
Date: Wed, 18 Nov 2026 15:36:22 +0100
Message-ID: <20261118150010.565149036@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
[ sashal: inlined the upstream dm_dp_in_hdr_mode() condition in the existing update_freesync_state_on_stream() function ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 175cf9e1a24e7..0302109de6baa 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -8817,6 +8817,8 @@ static void prepare_flip_isr(struct amdgpu_crtc *acrtc)
 		      acrtc->crtc_id);
 }
 
+#define DP_HDR_SDP_EOTF_IDX 2
+
 static void update_freesync_state_on_stream(
 	struct amdgpu_display_manager *dm,
 	struct dm_crtc_state *new_crtc_state,
@@ -8832,6 +8834,8 @@ static void update_freesync_state_on_stream(
 	bool pack_sdp_v1_3 = false;
 	struct amdgpu_dm_connector *aconn;
 	enum vrr_packet_type packet_type = PACKET_TYPE_VRR;
+	enum color_transfer_func app_tf;
+	const struct dc_info_packet *hdr;
 
 	if (!new_stream)
 		return;
@@ -8883,12 +8887,18 @@ static void update_freesync_state_on_stream(
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



