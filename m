Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060114;
	b=Qx10xuKDi6EtrYAeHZWNJ+8JPKmAcpsO4+SLOHYWXNBbX5GiFbQOwCs2EOYpztkGZ8CL
	 DzWX/IycmBfl/MFCljOGSErYwIuPB0sq/HsBJysyPYndmIrJ1TMJMxD7er3x2cBfqu1AJ
	 MNacmt5ojvkGlmUdsuY+EKtFt/oUW3ebaWj/OuUQssKuwaYP79DnIYkhL5zTYUOGoopdR
	 3G4bYILXJZLbX5Y+mif391REv/8SUBUcS0rnFqxIc9EsPq95mILZ0TjCCV2axqCR2Sq9m
	 V2ydHCKgyMmjU++MTpPw3BveQXdX6qEBfEA9dYEAb3IUMNoxY52mWOZh8O/0VbV0BnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060114;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=la9ZExeBdQ9mww8rypo1Nonor8BDM9SznLF/nrHSboc=;
	b=votOdHm+wSy+57g6sJifWOfI2lTRe7adr/hUdW5HsdI6THW4PxTUCstzVTrCynAwlQxu
	 9CzKyCsGLfA95hhiqFOJMB+9HVefnVEmCyDvINr3VjpbJQR0TrLajXEFTqHuXEUPV1hcH
	 dLO8ueZ2vulLmjYKS0n2aRzr0cf78qeeahW8fQrLMDLWXOxt6lBedwUubW97mDoOerNB2
	 AbfhAKqdFo5tw0Xcp+1aGfcJAVXn+9O6X4pNhHJnkKlTXYec9rnOdd0XV/dx9HZaz533G
	 NX9zhnVUuW5GEFApB5EzT3b9GLwDDTu4bRyUQiEg+9CQrTvgGjv9VpRy1zNXFnGCDpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UyGkTiK5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4A6606A320;
	Thu, 19 Nov 2026 03:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UyGkTiK5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 715AB1F000C4;
	Thu, 19 Nov 2026 03:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060114;
	bh=la9ZExeBdQ9mww8rypo1Nonor8BDM9SznLF/nrHSboc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UyGkTiK5IYtVKIyQ8ow6UdrX6xM7nQT2VRCdSwdQNSHL1fkPIc9Gyo5BgEJ4kDx6l
	 O2USSRmZtTyYqCl5sjUKGL9QFcRl/R0uSVrnkRKXQ/kwo8AnpG2WcfWSkWTjTDemkD
	 sngDoyOCLX8P6Z9ac8RThz2NqQHSvyVM+tUht9Hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	renpanpan <renpanpan@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1083/1848] drm/amdgpu: Only enable HDMI audio if display supports it
Date: Wed, 18 Nov 2026 15:52:01 +0100
Message-ID: <20261118150003.797675493@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced connector->display_info.has_audio checks with drm_detect_monitor_audio(amdgpu_connector_edid(connector)). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/dce_v10_0.c | 5 +++--
 drivers/gpu/drm/amd/amdgpu/dce_v6_0.c  | 5 +++--
 drivers/gpu/drm/amd/amdgpu/dce_v8_0.c  | 5 +++--
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/dce_v10_0.c b/drivers/gpu/drm/amd/amdgpu/dce_v10_0.c
index 72fc5eaa251fe..48d3bb0ac702a 100644
--- a/drivers/gpu/drm/amd/amdgpu/dce_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/dce_v10_0.c
@@ -1737,8 +1737,9 @@ static void dce_v10_0_afmt_setmode(struct drm_encoder *encoder,
 	WREG32(mmAFMT_RAMP_CONTROL2 + dig->afmt->offset, 0x00000001);
 	WREG32(mmAFMT_RAMP_CONTROL3 + dig->afmt->offset, 0x00000001);
 
-	/* enable audio after to setting up hw */
-	dce_v10_0_audio_enable(adev, dig->afmt->pin, true);
+	/* Only enable audio if the display supports it */
+	if (drm_detect_monitor_audio(amdgpu_connector_edid(connector)))
+		dce_v10_0_audio_enable(adev, dig->afmt->pin, true);
 }
 
 static void dce_v10_0_afmt_enable(struct drm_encoder *encoder, bool enable)
diff --git a/drivers/gpu/drm/amd/amdgpu/dce_v6_0.c b/drivers/gpu/drm/amd/amdgpu/dce_v6_0.c
index f81a10379ed44..9448cf949a497 100644
--- a/drivers/gpu/drm/amd/amdgpu/dce_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/dce_v6_0.c
@@ -1702,8 +1702,9 @@ static void dce_v6_0_afmt_setmode(struct drm_encoder *encoder,
 		dce_v6_0_audio_dp_enable(encoder, 1);
 	}
 
-	/* enable audio after setting up hw */
-	dce_v6_0_audio_enable(adev, dig->afmt->pin, true);
+	/* Only enable audio if the display supports it */
+	if (drm_detect_monitor_audio(amdgpu_connector_edid(connector)))
+		dce_v6_0_audio_enable(adev, dig->afmt->pin, true);
 }
 
 static void dce_v6_0_afmt_enable(struct drm_encoder *encoder, bool enable)
diff --git a/drivers/gpu/drm/amd/amdgpu/dce_v8_0.c b/drivers/gpu/drm/amd/amdgpu/dce_v8_0.c
index aa21354ca122b..5af2bcb746317 100644
--- a/drivers/gpu/drm/amd/amdgpu/dce_v8_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/dce_v8_0.c
@@ -1666,8 +1666,9 @@ static void dce_v8_0_afmt_setmode(struct drm_encoder *encoder,
 	WREG32(mmAFMT_RAMP_CONTROL2 + offset, 0x00000001);
 	WREG32(mmAFMT_RAMP_CONTROL3 + offset, 0x00000001);
 
-	/* enable audio after setting up hw */
-	dce_v8_0_audio_enable(adev, dig->afmt->pin, true);
+	/* Only enable audio if the display supports it */
+	if (drm_detect_monitor_audio(amdgpu_connector_edid(connector)))
+		dce_v8_0_audio_enable(adev, dig->afmt->pin, true);
 }
 
 static void dce_v8_0_afmt_enable(struct drm_encoder *encoder, bool enable)
-- 
2.53.0



