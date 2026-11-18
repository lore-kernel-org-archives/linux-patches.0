Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047587;
	b=HpJvK1bbLeR2hPleDO1Ei2L8COEIND8/TyNDxJdRYnqDbENwyXvhrNp9H6OVhP4T3IrW
	 ok8SohEG9y2tjJEVFrKCB4qjWpqAFXzRKYMy47zV45mShGOHFtsgBEXHzyGIQcQGd6oSY
	 D0eKuCoYSVA5INTAmPApD/OFX57t1o4tMqNx+atGhQyRjOJSR0vv43B5lIjyfdCGu5vxF
	 EHNVFoGmAlRdPcG942042f2nuYZscZlMxBg671sruWJy+jo8GP5wInnl3BcxuD+NM23EN
	 RXDqE5a/An4+zT61aM+2yQVQS6W2WnduHadQU9cy08iL+WYXD6iqFcF+5XYCPUthwJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047587;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2GZCvZgPKS5UUuuqFmEk5ds8uxMMdNpaBW2WvEB4tjE=;
	b=p4XBJWqRzo+PfwqU3vTVjCoRQDWGlJ5zV8QI3DPrTZZdOHi93lXLT8MzshikkaVrkBqA
	 K4Zb2rU2XHwcRMqjWzKlOvXUa6wPdE70ufyL65cYG9CXrlf6cWWmHtunRTWc+a1Iu6Adz
	 2sTcFCHYyGn/W4+O7KD88vsjp3Yood6RGcePC5Bb9QHrJ7IyFm1OsbqZtYSy1msuSIusC
	 tZsWTr5O3z9yQAPvNwDKZeZJpC8cN7xHgA3/eUP/gTHLaFdC3nEdX01nxmtsUuLMLwNly
	 F+gVZR1nyiWz3TaljNZ+WuhjGyOpvD2T4WmFybPk9Km2tsUJQEEHhtQFC16TXUx/szg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=adCIKads;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532DE606A31C;
	Thu, 19 Nov 2026 00:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=adCIKads
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3CCE1F000C4;
	Thu, 19 Nov 2026 00:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047587;
	bh=2GZCvZgPKS5UUuuqFmEk5ds8uxMMdNpaBW2WvEB4tjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=adCIKads9Z0orAnisZfPkZVySHHU/djkC4ZFccniZ+0R9j5NQxhmVjGe3eynG7Qih
	 e+eGdB2clUZy4hOfHYzkjIvKndvW8NVIWTcsFaUw9tJoit+CqJBrpczj0C8zF00D9K
	 hPzjnUOYVy1tywigw6bD7FXlxbJYijJlZWpSjuEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	renpanpan <renpanpan@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1693/2857] drm/amdgpu: Only enable HDMI audio if display supports it
Date: Wed, 18 Nov 2026 15:45:27 +0100
Message-ID: <20261118150302.292618728@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index efc85aa157ddd..95a31e959cca6 100644
--- a/drivers/gpu/drm/amd/amdgpu/dce_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/dce_v10_0.c
@@ -1738,8 +1738,9 @@ static void dce_v10_0_afmt_setmode(struct drm_encoder *encoder,
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
index 6376a252e3f07..736bdeeb2bdcd 100644
--- a/drivers/gpu/drm/amd/amdgpu/dce_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/dce_v6_0.c
@@ -1702,8 +1702,9 @@ static void dce_v6_0_afmt_setmode(struct drm_encoder *encoder,
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
index e93931655243e..ed52451f3b74e 100644
--- a/drivers/gpu/drm/amd/amdgpu/dce_v8_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/dce_v8_0.c
@@ -1667,8 +1667,9 @@ static void dce_v8_0_afmt_setmode(struct drm_encoder *encoder,
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



