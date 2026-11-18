Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054527;
	b=xAYhlUSsnIVRmXoSSwdZ5LXwkwc219TuDiV6PlrNSbN9c1f0G+vDG+FCW5yNDTiWiAWs
	 uz7UQzbyCxZxSL/cxC2c+JojKNMYOSr23rGnmZQcIiNP6iizw+YLf8hqhW+PEVpxWy+P1
	 O8OPZ51eQmPD0ynL2951zHBJNRuiOQy11Nak2YmfjKvECAuOkzyDSuDd5LyeBC96CfFFN
	 0PfJ2GVTKJCsJY7wUlEFLOai8h4VwF6WuHeMxThTBqMxe/2Xh/2n2Kz0qBJ/V7MLDVIrC
	 Gx1L0Gq9Mh6BE6OfdoUwwKDZb2Cf2Bg4NkGuzHHBgpMAcxfHZ0ubn85GFBDFb/PgoPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054527;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=38pDBDvNrUXd7sljRx3qjGJGMW5Od3zubaWzltfz73o=;
	b=i0ItgU6iHQt/g/2twj61vFEZYpza3Vs4ymt5f8R4n/HufdLzoajc6nYFVmH5sj4e8BMB
	 GJDKMgTtRfres4YN8bOqFfqt8+Gg4Uad21STZkpyFtfZmkE78C71kasnLM5eubt98YN25
	 pFJFkK6tlzj69rVRkl/9VF2KZGkLEK/PD6M67/shTUZRs66n0qCCxhUGP2TLFWjFpTEBp
	 pXENY/ZbjmWvKL8anf0pRb0URznqh3IFp61VLiyGKQj8K9b0pkF9TmTM5M4lHCvEeF98T
	 2B33Alivd0GoXCyUuAZ2gek/fbGppmwb4Opy9nGN2xWlpxckq+0B6GvZJYcdLTLCxLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pR8MF3bn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD2F606A31C;
	Thu, 19 Nov 2026 02:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pR8MF3bn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC8A1F000C4;
	Thu, 19 Nov 2026 02:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054527;
	bh=38pDBDvNrUXd7sljRx3qjGJGMW5Od3zubaWzltfz73o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pR8MF3bnptIvngvoPgvsJzJDMlPDBsb0mMu08xntCsg+LRpem5ydz1gLjrh5k75eE
	 v6/qPYM7UqMEtlrH+u6kqugRojPKQkmTE7cRrmYu5F7ff22rL8HKXA4v/FcPnlqpbz
	 vvpN5NrfMjxDHKx92sXQGhZIzP3AvJGrdVqJML7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	renpanpan <renpanpan@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1289/2214] drm/amdgpu: Only enable HDMI audio if display supports it
Date: Wed, 18 Nov 2026 15:49:25 +0100
Message-ID: <20261118150103.128986610@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced unavailable connector->display_info.has_audio checks with drm_detect_monitor_audio(amdgpu_connector_edid(connector)). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/dce_v10_0.c | 5 +++--
 drivers/gpu/drm/amd/amdgpu/dce_v6_0.c  | 5 +++--
 drivers/gpu/drm/amd/amdgpu/dce_v8_0.c  | 5 +++--
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/dce_v10_0.c b/drivers/gpu/drm/amd/amdgpu/dce_v10_0.c
index 0b872bc71b70d..d77daf89a9dd9 100644
--- a/drivers/gpu/drm/amd/amdgpu/dce_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/dce_v10_0.c
@@ -1738,8 +1738,9 @@ static void dce_v10_0_afmt_setmode(struct drm_encoder *encoder,
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
index 5e21eb88b2e71..429c97751e5ca 100644
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
index f3b0642f9d9d2..dc72c04d9b7f7 100644
--- a/drivers/gpu/drm/amd/amdgpu/dce_v8_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/dce_v8_0.c
@@ -1667,8 +1667,9 @@ static void dce_v8_0_afmt_setmode(struct drm_encoder *encoder,
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



