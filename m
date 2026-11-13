Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590513;
	b=jYH9ebYWFFvSWmHHgwizCMKqGpL7rZlkkVMTDn+4VRWVwObq2peX4H3kvSn2tLCy2ylI
	 nsmq8q//+PYD1ABrbt3KUffPdqrXAuZdmjp7N2qf6821XqXDglt+5uDPOhEbfJ16jf/PU
	 m7Bw24HyulWC/1IYc96l8588qu1erly4ze9/1ISaCymo+2PPQVzddyJDReHfwJuzYOfvN
	 SD0SPgy7ND50eOi3Ijq28OCLa0DF7ED0+7/Y8WCUq1d0S+0b3iHdOAUcva47aFQMsK1uG
	 2+sl2Lx5fj/A8Tbxk0kRoIEhPz62txXv8bgY3kI7QFp7LTrwJgXYAZeTei4QNaKtnIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590513;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2aVM+Fel0LIKrOLR2DsA3Q1leDNHIH3D3qQ4WpPGMO8=;
	b=JMmys+x1/AIa+pLMEUvbp/AkH/W95QP6LrMEF3HO6I/oE7fVWITBO/doZLnVeOSIRWFG
	 hm8maau0YlcKP/8pfWvUFu8StQVg57KB2abaREwJI7IGGmhQ7TJDQClGAnKFRPkP1HCQX
	 F42Gxr2wohl6ayZQBPzMIDEfczOcH2k/rWWSfp26hL3KBKY8u0vCqVGmCYzPBGJkwzBic
	 PYEFXszlPq51HSl3Hj7gpeBgcxuxM0rtpSkwGw1velRWLSHtvL5uVjuuiIZ+xFR2knLJO
	 9YkUfyuNxOnFHK0/tsHG6z6xZJj8AdXC5xJfgqM8ZrnK07oWJOA5Kn5LLGSY1JU7EMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nGWMwxAw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B528D606A8A7;
	Fri, 13 Nov 2026 17:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nGWMwxAw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 612071F000C4;
	Fri, 13 Nov 2026 17:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590513;
	bh=2aVM+Fel0LIKrOLR2DsA3Q1leDNHIH3D3qQ4WpPGMO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nGWMwxAwza6yTCxgH/32H8bqLztfZp1yZP2r6fWA/SADqQcg0bJlzrr9SOr4A1f5A
	 0ZGUzeHUtRKoqTA/ykqTHFS/D3ylk30Tbmh/KOPD4k04sXdbHYJPmiFWJx1RtG1vls
	 xFVNz0mxB3ZAmnfEUzFefrgAxhjY3NdG52VtVTeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	renpanpan <renpanpan@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 416/686] drm/amdgpu: Only enable HDMI audio if display supports it
Date: Fri, 13 Nov 2026 10:49:09 -0500
Message-ID: <20261113153835.057132290@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: renpanpan <renpanpan@kylinos.cn>

[ Upstream commit 0de95c96655c8a12df62e47871016f49e5cd8618 ]

The amdgpu legacy DCE audio path (dce_v6/v8/v10) unconditionally calls
audio_enable(pin, true) at the end of afmt_setmode(), regardless of
whether the connected display advertises audio support in its EDID.

This causes a phantom HDMI audio output to appear for displays that
have no audio capability (no basic audio bit, no Audio Data Block in
EDID), because the GPU sets the AUDIO_ENABLED register bit, which
drives the HDA codec's ELDV pin sense, making the codec report the
jack as audio-available.

The radeon, nouveau, and dw-hdmi drivers all gate audio enablement on
display_info.has_audio. Apply the same check to amdgpu's DCE
afmt_setmode functions.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: renpanpan <renpanpan@kylinos.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 842a45c68e0355eea47796551c8761c0c77e8ce0)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/dce_v10_0.c | 5 +++--
 drivers/gpu/drm/amd/amdgpu/dce_v6_0.c  | 5 +++--
 drivers/gpu/drm/amd/amdgpu/dce_v8_0.c  | 5 +++--
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/dce_v10_0.c b/drivers/gpu/drm/amd/amdgpu/dce_v10_0.c
index 72ca6538b2e49..08535245e5fd8 100644
--- a/drivers/gpu/drm/amd/amdgpu/dce_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/dce_v10_0.c
@@ -1735,8 +1735,9 @@ static void dce_v10_0_afmt_setmode(struct drm_encoder *encoder,
 	WREG32(mmAFMT_RAMP_CONTROL2 + dig->afmt->offset, 0x00000001);
 	WREG32(mmAFMT_RAMP_CONTROL3 + dig->afmt->offset, 0x00000001);
 
-	/* enable audio after to setting up hw */
-	dce_v10_0_audio_enable(adev, dig->afmt->pin, true);
+	/* Only enable audio if the display supports it */
+	if (connector->display_info.has_audio)
+		dce_v10_0_audio_enable(adev, dig->afmt->pin, true);
 }
 
 static void dce_v10_0_afmt_enable(struct drm_encoder *encoder, bool enable)
diff --git a/drivers/gpu/drm/amd/amdgpu/dce_v6_0.c b/drivers/gpu/drm/amd/amdgpu/dce_v6_0.c
index acc887a58518d..24462e6f221b0 100644
--- a/drivers/gpu/drm/amd/amdgpu/dce_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/dce_v6_0.c
@@ -1777,8 +1777,9 @@ static void dce_v6_0_afmt_setmode(struct drm_encoder *encoder,
 		dce_v6_0_audio_dp_enable(encoder, 1);
 	}
 
-	/* enable audio after setting up hw */
-	dce_v6_0_audio_enable(adev, dig->afmt->pin, true);
+	/* Only enable audio if the display supports it */
+	if (connector->display_info.has_audio)
+		dce_v6_0_audio_enable(adev, dig->afmt->pin, true);
 }
 
 static void dce_v6_0_afmt_enable(struct drm_encoder *encoder, bool enable)
diff --git a/drivers/gpu/drm/amd/amdgpu/dce_v8_0.c b/drivers/gpu/drm/amd/amdgpu/dce_v8_0.c
index 2ccd6aad8dd65..03d6b6f54c0f1 100644
--- a/drivers/gpu/drm/amd/amdgpu/dce_v8_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/dce_v8_0.c
@@ -1682,8 +1682,9 @@ static void dce_v8_0_afmt_setmode(struct drm_encoder *encoder,
 	WREG32(mmAFMT_RAMP_CONTROL2 + offset, 0x00000001);
 	WREG32(mmAFMT_RAMP_CONTROL3 + offset, 0x00000001);
 
-	/* enable audio after setting up hw */
-	dce_v8_0_audio_enable(adev, dig->afmt->pin, true);
+	/* Only enable audio if the display supports it */
+	if (connector->display_info.has_audio)
+		dce_v8_0_audio_enable(adev, dig->afmt->pin, true);
 }
 
 static void dce_v8_0_afmt_enable(struct drm_encoder *encoder, bool enable)
-- 
2.53.0



