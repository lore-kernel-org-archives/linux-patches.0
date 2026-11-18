Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051042;
	b=X5z8LZGwdTZ368DzFUTqkrFqXp18OaqKcJc3jNOOpo0VWp+xuYnh1OP7KNB9l+hDObcU
	 iHmvfiZWoikobdPx5jhbQDU+4luaaAcT5ZdAfdqsb7AczQPA02zjyVVAKaFOo4p8j84gN
	 iuH3Fuem5D9r8ulTaWOZocod1+L+clMdJZRHg6TeJXBoDqY4cw3Vjof02GDDmRIK6uK4u
	 pQWp6rY879wpUoh2mMobjFUElScmYyjKyCc/VbyC5f6de/7zNZVwahCM6ERHRBPqHYSim
	 NhqIDuKIrezNpwHJ/bbyVXcyQ8yq0seAj/rYPrthymMV652dV6Cqdle7YVwrm0o05OA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051042;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WZ5BEH8m1ZoR84WjSOGJALQTXPNQ3x9h8Hof0xkEr1U=;
	b=FjjOyu3DXPv0qZatlrDNyD72hIjk8j3WXLyRDqZECyF6G/dLYDFRXkp08qAhb5r6uDJ2
	 p5knfTJ90vMWB3jGLMdfCkUNcXx43zwHx3JKUwPEPJzWq232bk2WIpX/0mA6kBQ9jBJQX
	 GE6YrVrpdTkrO10nnk+u5+EUnsMkztZwTSqMak1YsuSUpvZK1jdCKBevfdhoH0KXNYFX6
	 YiSEGM737A0eM7p/RrA0ilQioJHgeWDVBKlrINJfHLq24668tCOmQxVsmxlOqzjzVha6P
	 4IqaaAr6uxXdS6YJV5U6e3jijwh1iF++zYTc1dKkO0iCY3/KStlHOKAnJ6o97T0pxJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EqBbwETv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B51A606A32A;
	Thu, 19 Nov 2026 01:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EqBbwETv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8BF1F000C4;
	Thu, 19 Nov 2026 01:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051042;
	bh=WZ5BEH8m1ZoR84WjSOGJALQTXPNQ3x9h8Hof0xkEr1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EqBbwETvCQJSORZjHDHMTHC+tRFVnorZdm3S7pIfTnII93bV1vqjU/nBj8+4QtKuo
	 ztUD8U8/n8p4Rkx2Xz+i4sklLkAKrl6l403qQuwx7qSmwgzyOhXs7ljZNwwmcVLTfD
	 HVOorJ0dMYGziQ8084/peWclY0CwCsgE7FmFFx1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0041/2214] drm/amd/pm: validate vega10 profile mode inputs
Date: Wed, 18 Nov 2026 15:28:37 +0100
Message-ID: <20261118150011.704850939@linuxfoundation.org>
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
index 7d0cf2a6d2d54..60accc56a1178 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
@@ -5227,6 +5227,11 @@ static int vega10_set_power_profile_mode(struct pp_hwmgr *hwmgr, long *input, ui
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
@@ -5242,6 +5247,10 @@ static int vega10_set_power_profile_mode(struct pp_hwmgr *hwmgr, long *input, ui
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



