Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042947;
	b=I6FuUZq6lRjls1B0craoJ3em3zSGto1zt3Q0rdipZFitk2HCh1c8aUj63mnMWfkQHhLN
	 2QYWGpsbv831f6PTS212TvAuwHnW5MsTorcysQZj+59MhGaUBLXzik4C2U9G4G1aiRtHZ
	 h6G2rvjO61IC8ZtYbpHGgtDEb2dlWLnuo7TXXavXIcoAGzbNNCEl5njLzFx6e8tcfrcZb
	 ZSFJHo26jeOzB4qTO1JL50HNeIQ/Y/qz0zQbc3PX8X59MTnDFSq1xlN3V99T1iMZYJ4aA
	 NucMRRwsMTE44S02blTMXf7eWRttAcDwI2odi91fD1UKj4NhTDGCteMJpcfE25WW2Tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042947;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8w9/IPZTwX7U3hNptCyafsCavjy9VJCwunh8KCdIm+A=;
	b=PTH+72BRAnkm5aPjKVTRPdTCtnzg728vb0dDQ/vvXbVPdQ1QR0ED4ZQ1lzwLAhG0XfYp
	 4fVpUOireBu8RLkWimA521NdLGCfJ5ZSil/eM0H9M9m70OVd8X2DwXEe04RrmYFD/UfsB
	 qzMsjHOtHwZKiJwOe4DSwJs/Ci1mkAo3O1MZNjhuZlluFDDCnYnJ3uql7hj5e3EySoKLv
	 Cvv/+OvGR90+1mp1OR8RAEaDc15IIhWeQ40fanVqDPhcWVcSLrhf2J5nEA2mxW6PzGrbs
	 dxPoAxpt8AA1g2hr+rwYpv4Es+nH1y+0EDCJlkVC62XKDno6Kw68FJK04ui3VPkLvYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QPTVf59Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4E8606A31C;
	Wed, 18 Nov 2026 23:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QPTVf59Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1721F000C4;
	Wed, 18 Nov 2026 23:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042947;
	bh=8w9/IPZTwX7U3hNptCyafsCavjy9VJCwunh8KCdIm+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QPTVf59Zs3kEgIe6342OVsz86izJXh5V3zCNi1MjdEF+SdMbGOewmrKJgGSZx3xwi
	 sK7po+lYVm+PNgGtZtGxerU673Ggwt/YOKbgAqcAtvkb4FU04GhwqHbVJrNb2Yl/rx
	 WVeB5yEEwohMP/e+pVSCCE5eWu+J3Y2VuUKkUntA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0036/2857] drm/amd/pm: validate vega10 profile mode inputs
Date: Wed, 18 Nov 2026 15:17:50 +0100
Message-ID: <20261118150202.633577907@linuxfoundation.org>
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

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit bf939f2a1687ef4ab815640096357f8ef5bd5fb6 ]

Check for out of range profile modes and custom params that exceed 8 bits.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
index 22ac8daabb065..990962e81d25f 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
@@ -5405,6 +5405,11 @@ static int vega10_set_power_profile_mode(struct pp_hwmgr *hwmgr, long *input, ui
 	uint8_t min_active_level;
 	uint32_t power_profile_mode = input[size];
 
+	if (power_profile_mode > PP_SMC_POWER_PROFILE_CUSTOM) {
+		pr_err("Invalid power profile mode %u\n", power_profile_mode);
+		return -EINVAL;
+	}
+
 	if (power_profile_mode == PP_SMC_POWER_PROFILE_CUSTOM) {
 		if (size != 0 && size != 4)
 			return -EINVAL;
@@ -5420,6 +5425,10 @@ static int vega10_set_power_profile_mode(struct pp_hwmgr *hwmgr, long *input, ui
 				return -EINVAL;
 		}
 
+		if ((input[0] & ~0xFF) || (input[1] & ~0xFF) ||
+		    (input[2] & ~0xFF) || (input[3] & ~0xFF))
+			return -EINVAL;
+
 		data->custom_profile_mode[0] = busy_set_point = input[0];
 		data->custom_profile_mode[1] = FPS = input[1];
 		data->custom_profile_mode[2] = use_rlc_busy = input[2];
-- 
2.53.0



