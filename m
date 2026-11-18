Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037832;
	b=svHRsvAdUDwsUCV+OZiF/Fvh9Bf1SaxYzRsZu8EgqyiHdLCucnQvP+cuaiADzYJSczaE
	 q2uSeN/SSwG3I1kyAyeNvuhASTjNYYv40bCpKoW6h03lJihTO/azNvK00Wtu57fBlogVC
	 P1s5QtniQurzbICSANoikE4n5N7vsQJLGZZHKYtEx40XzDZc+8cOLAbrnpuyAKlZLNbRF
	 m9xDQ/ctQa8Zem5m/5TujLGPz4/7aeTzhcCtAeb65gROYDSWI/6a/CQUmMBF1hBNalNNp
	 ktE5I72m2MAdEJSGQI7YXCJ8nunxXv6+o9g/yXLhucC1hnIwwdg4/zqFJvowsfoCHOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037832;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=55fNOUZc5DRE6fS2XsX+MBPpMfR6EHTTs/QRqcVT3OQ=;
	b=GeP1oGT6pUPHYUQ/AcE5zP+kwzhZSp7zn1vakuv+ngOoaZg4k8DvLcaebZV+/du4Tw30
	 YSf1puLaaatvCRRMYUDc9xhjtc37drbydweOFEXLNoZvFRXF2MK2O4n8zWqLS9Xte3lVX
	 DYXG3WxqviZg/Abwq3+5I2WaG0w5e14JbAXKQXcAQ/g7OhcO6AWL0hHS/m0nzfbnmASfS
	 T9PqC+d6yL31v2inFl66SdTWWwkQJmTjXT78YPRUA9KIY5i3BkTXtvS90N49ntHdFLR4x
	 MsSsHPftzJ7AS7Es9qncdN3Pm1IuwHxmWkbsJHhHJgpjmi/OtlKwJ238KRQjObQbCKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m2rlJZBV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39DB4606A337;
	Wed, 18 Nov 2026 21:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m2rlJZBV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FB131F000C8;
	Wed, 18 Nov 2026 21:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037831;
	bh=55fNOUZc5DRE6fS2XsX+MBPpMfR6EHTTs/QRqcVT3OQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m2rlJZBVk6nCNQOPD5Sfmi4KrHaRHt+zsdIkNBd/2sp9GdqkanzA+ZK/dSKY7+uG0
	 oITzehcNYY6yPozs7EhO64c+btz0Z1SUK2kKnoBSLTwDQX7sMv3tpD8I+xjxKT3+WN
	 DO+UFictNVoIjZmU9SbqPDI8sdpreD2VcbW9ustQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	renpanpan <renpanpan@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1533/3318] drm/amdgpu: Only enable HDMI audio if display supports it
Date: Wed, 18 Nov 2026 15:35:55 +0100
Message-ID: <20261118150406.964312516@linuxfoundation.org>
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
index e2dd7d4361cf3..cddb51565f21d 100644
--- a/drivers/gpu/drm/amd/amdgpu/dce_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/dce_v10_0.c
@@ -1733,8 +1733,9 @@ static void dce_v10_0_afmt_setmode(struct drm_encoder *encoder,
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
index c3d05ab7b12ff..dee25d8746032 100644
--- a/drivers/gpu/drm/amd/amdgpu/dce_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/dce_v6_0.c
@@ -1704,8 +1704,9 @@ static void dce_v6_0_afmt_setmode(struct drm_encoder *encoder,
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
index ce2300c3c36b4..c34af59f1df64 100644
--- a/drivers/gpu/drm/amd/amdgpu/dce_v8_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/dce_v8_0.c
@@ -1666,8 +1666,9 @@ static void dce_v8_0_afmt_setmode(struct drm_encoder *encoder,
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



