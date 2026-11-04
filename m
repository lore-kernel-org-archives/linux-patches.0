Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831289;
	b=kxjU9+Mf4lHF0gTpIHMpJPaI0rqw3u2Vheqm6AGnuPpUzk2cgMejRJqpmRcYrjLKjHIR
	 dADOI4Zjxyrkg55vdY7MSsYkmDnynqwa5nI+7VdMKrHV3Cr81V+BAVXwI5jgwpCkBGyRp
	 ITJpo2UjAbqrp6O6QsvJQlqKH7agPO1gvc+2zwVcXfrvz16I6W38uHNIRisxe7v1zLFDf
	 xxDmpRvaxp9GEetyC1kQsgKv5Siq47NlCnTSMPXNT5U+/wNKqIAkMPYUdETNGHz07a6kn
	 RYtblE7CnzTPQ56xmU7QvrIaVyrosP7lT8urxFxeds+Bt81bx6tQjiDX7g8kygZVnBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831289;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5QDwNASLE7l0iT8oUo7RS72LkTC9IqZ8CNBbxeAzadQ=;
	b=cHa6+q87l+JXXJLlY4ctdnYK2Qx+CS6Gy/u27Vg/Fk+XE2SFnjAf3mCBoXYPRcmvx14a
	 /BXbYIROT/rM8QOyKeIiYx8fKN7zp/g5i9pfDgnB5CA+yHUDV5VyBZk8oJUmsUINZvl70
	 PHaoaKcTyCHVSUEHi4kNNS/mBklubDoSj+gLKmN2QwfHzKsquvf4T0FS3hhbP7XmSpW+s
	 4LBjx1V+nBVxE9l/Iki7eJb2bi0bDkEUYULz3GQ+pHotjYyEJ+80o3XStdR1LW4OaUBKv
	 8jAplc7MpX9+MnNY4DAUOOAlMqvKupTN31DIJBl4qeElqxoxMmhGD7mKA4ciIFBk/qA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K4EZ7aSa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793A9606AC1C;
	Wed,  4 Nov 2026 22:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K4EZ7aSa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66CB1F000C1;
	Wed,  4 Nov 2026 22:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831289;
	bh=5QDwNASLE7l0iT8oUo7RS72LkTC9IqZ8CNBbxeAzadQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K4EZ7aSaH8RgUs97gCooEy2KluKOlh5TIHwRK/eXXBd3DjBnJqC9NvA7BIxSSJH+y
	 kAPD/QEIGOIvf7y6LvDed0ddTC38ipir8RHzlECI+Zh8v89zsZ8FSy4aOZ7T+dTbSa
	 rd53E7xRaBig78Qmu/oEm6AGmJ+CRiM0/D0qumZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Mishal <harimishal1@gmail.com>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0613/1005] drm/amd/display: guard dc_sink dereferences in MST mode validation
Date: Wed,  4 Nov 2026 16:05:46 -0500
Message-ID: <20261104211101.011671296@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Hari Mishal <harimishal1@gmail.com>

[ Upstream commit 217f64f348c90cba62164e7ff38e0ccf78a5ca09 ]

dm_dp_mst_is_port_support_mode() reads
aconnector->dc_sink->dsc_caps... for the DSC branch-throughput check,
and get_conv_frl_bw()'s HDMI-PCON FRL-bandwidth path reads
aconnector->dc_sink->edid_caps.max_frl_rate, both without a NULL
check. dc_sink is cleared asynchronously on MST unplug, and both
functions run from paths that the driver's own comments document as
racing that teardown: the connector probe worker's ->mode_valid
callback and a compositor's atomic check, neither of which holds the
MST manager lock that the teardown path uses. The former does have an
existing dsc_aux NULL check, but dsc_aux isn't reliably cleared in
every path that clears dc_sink, so it doesn't cover this.

Fail the port-support check and skip the FRL conversion path when the
sink is already gone.

Fixes: f04d275d94e1 ("drm/amd/display: add mst port output bw check")
Fixes: 5c9b8b27a883 ("drm/amd/display: Tie FRL support into amdgpu_dm")
Assisted-by: gkh_clanker_t1000
Signed-off-by: Hari Mishal <harimishal1@gmail.com>
Reviewed-by: Fangzhi Zuo <jerry.zuo@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 7c3db8da4e039698ae198c870712428644e965c7)
Cc: stable@vger.kernel.org
[ sashal: Dropped the FRL hunk because the HDMI 2.1 FRL code isn't present, and applied only the dc_sink NULL check in dm_dp_mst_is_port_support_mode(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index 2e0895f4f9b10..642248a251149 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -1867,6 +1867,9 @@ enum dc_status dm_dp_mst_is_port_support_mode(
 	struct dc_dsc_config_options dsc_options = {0};
 	uint32_t stream_kbps;
 
+	if (!aconnector->dc_sink)
+		return DC_FAIL_BANDWIDTH_VALIDATE;
+
 	/* DSC unnecessary case
 	 * Check if timing could be supported within end-to-end BW
 	 */
-- 
2.53.0



