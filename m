Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033527;
	b=lhkt7QftPrbM1UEwE+PdtYlM8254GWCKcYn6R09DZkwMY69F8MqHwb15k60riPPUNXMe
	 qRa7EiWcDMrNAp2MdX7ZuIDsi3lDnHms78SL/TMU7GRy1BSfqsAN5Hu+t/puCD1mwqGpn
	 jOeDACcZ22BlTpNDWTVpTUznyXC5kO9P5d5uYJ9+GO3Z2WEKWdM8AUX0K8i71KX8rlm1H
	 r4vo5ctwaziX066rHHDSYaNpRx96UP0seDQvpWVDZLzKzSaik/qBnBcUjobnLDdCx3sDD
	 vcvAOWM2yXI7+qnrcbogZsOGHDkGa8mzq05w/bGqx5Z6MaSxfd7yTe1LZMudgqjF1tQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033527;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2Flp3sNbmmFgErQG6TzoxQGehW4MSy54NbWnep8S0/Y=;
	b=Zgx0N42bJuWL5qYiaUI8Btjdp2q7hI8rJV4wDVstEeUo2eTJ9ojIkuTiVtKLhaYJkLAH
	 PefMDL0Aim9/j5AK6j1ewsWpTk3f77gBXgCau5ACDFcHlSqcRnxtkzr4k+MqfvrniyoXq
	 HykmkA+OhlkG87EY20LaNg5uZSrY5qbx8Wn0y1jzZhSAY7SbyLZdNcR3OIA+i3bC8+Kfz
	 J9UOAVhSIdjfv+R4X0wQRGi9eR3iKrgh3GuWXRWRZhVWXwYpxW+CxHC2CaiwO2sM5zPfM
	 JnaA6JzShMWzqDinFooEsXQUN0lINWttinuxKZzI7h6+hVT3Iy3Vj+jf5Qk/tEaGBJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aEwYtrbI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF89606A31C;
	Wed, 18 Nov 2026 20:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aEwYtrbI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06ACE1F000C4;
	Wed, 18 Nov 2026 20:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033527;
	bh=2Flp3sNbmmFgErQG6TzoxQGehW4MSy54NbWnep8S0/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aEwYtrbIuvE1uUZf6ZV5FJfGc3aKNBThkQQs/U4QZj28/TzqeURcBgiBvZLqBumd9
	 bINNTobueaaeeQJ3eHc3zam7abWnCquf0/usNPyjckkMIvPru7MXSSPZ2DL2gvV/sH
	 yufAYQoXk8nMDcDBbNnMQknCNWHverkay9NX+E8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0046/3318] drm/amd/pm: validate vega10 profile mode inputs
Date: Wed, 18 Nov 2026 15:11:08 +0100
Message-ID: <20261118150315.270335768@linuxfoundation.org>
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
index 312b18ad78aee..1f7030befbd14 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
@@ -5401,6 +5401,11 @@ static int vega10_set_power_profile_mode(struct pp_hwmgr *hwmgr, long *input, ui
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
@@ -5416,6 +5421,10 @@ static int vega10_set_power_profile_mode(struct pp_hwmgr *hwmgr, long *input, ui
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



