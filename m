Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829342;
	b=nI+6RcFxMNoBP36x3vaS8rSXkSdcmgEVmPTN+2mRaFYwtkYvsY1gNI9JHRt3iN+uqtdi
	 5u9HxmSYXxLBMRGJTvisWAurVfPPSUwmy6BCFvHqlFZ2iglT5d15WvVqlL01bYzc1LfcV
	 loaEWx8kwi3KvWUPC01u4HygwPG6hT+agCozcDEvif8JweqbF/UsjkuA4E4UlMBqo8B3A
	 +tg4ZiOfKtqCyFRnmCFQnpl4mfiWsRfPDtfGxBlpwXwlQS+FyevP6K0B9Sqv82G6gCpZn
	 KJtSKF+lPSpWjgIgY083SnYkyRRvxg2CxudO/XtW2ClGC7zOGZ8TWPnhaOxGL116Pcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829342;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Urr/8b9lINrMtgx8uTx4akxHKilD6u6X2Mro45QcKfM=;
	b=ChntOaHOdK1/7mI/lLDhGIiN0tlqz7q0nTGLPxDaUKMKNCCMotAKuwWrVX7bMY3kAY8F
	 BonFIMbdJW4KTK1ncrad7Dyey3OPWbryQekdc2Q49epstTdo26SCADQ2jmv3I/twMZX/a
	 L1GwV1z+X04w/Fy8hHA8mhod+0aTWuIgal4sRgXzJWnyvLWyZMjQuRKKMZ11aQLyAfGkc
	 FhrGKAeVw79pBade4sn32mXM2Ya53XxsSA30XrRsKVSF4uqNEsgbDvCSpEovVblS4RQgz
	 DZotTFrrgoxrplppUmPJMK9ZoZsxBy+ONM5rZBIpGz8RyVhiMpjNFXFqToEwX1YlVqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YXuOtA6+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B883607491F;
	Wed,  4 Nov 2026 21:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YXuOtA6+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F1B31F000C1;
	Wed,  4 Nov 2026 21:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829341;
	bh=Urr/8b9lINrMtgx8uTx4akxHKilD6u6X2Mro45QcKfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YXuOtA6+PLQoOsqCwAlPs7NMUAfbMWRVqH0262DE3uJkSIfxo7ZMDkU5sFB8rsnUr
	 xSDZXrf5c8aFo/bZaV9q5cLrnNDj2M2U8jeGLtaeRxLC26ehV4gHMKzlA5GRfls3r/
	 Uxgn9rF/W/qi7PgFyfolOd48kkyrRyy6z5mBKIAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0066/1005] drm/amd/pm: validate vega10 profile mode inputs
Date: Wed,  4 Nov 2026 15:56:39 -0500
Message-ID: <20261104211045.459206550@linuxfoundation.org>
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
index d6aaba0b3613d..84c777fde62f5 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
@@ -5406,6 +5406,11 @@ static int vega10_set_power_profile_mode(struct pp_hwmgr *hwmgr, long *input, ui
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
@@ -5421,6 +5426,10 @@ static int vega10_set_power_profile_mode(struct pp_hwmgr *hwmgr, long *input, ui
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



