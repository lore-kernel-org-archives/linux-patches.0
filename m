Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829340;
	b=TMyI3XvWf5CMWZ1bahsaDC39WLLg2RI03XVCw2PoHSe2oWrPImixmtzl05AG4ZjhUg2d
	 ya3BTlnT+OkQw6FSPIFz3etg5Gm7QP0j+6XDf77htegQgVROMPuU9abtzEua/Ybyamq9k
	 BrgBQSWW9fZe+jmoLG+kHavUYDbEIaresI5+bEFMDM/mRLZcUeBPg0XulIQSrb0qfuuPD
	 nhJcqF5oM3sS2QrBZz0tTGGaCaGNBvgzgic0Mi3vgMm2nd7KlTteqWOlw7ixWULLS7dHu
	 hiCeTGwuOtLamPhO2h0jAfzhFmExncCgsR1PDP0cqbe+D9OphJwMwo+8Bbe61KxhXfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829340;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ecfn4fX3mUmWpN2aVM/4fDejHex7ZRq5Zi4KlT0+mhQ=;
	b=Jn8W9iKesAuT2C+9N+GNNnPSBIgj9ZHSLkJDGAc2uTlx5W+wShxVEDqjAbGpUlVc5J7L
	 dNQvD1OM24xNSAtxhUY1d5A0OR0MqDg7wZGeYz07StnGPWVg7+63KeX8OUKNGEonyxddz
	 WACtcPCh5VBjKZL3Zh5TaOzsiMLcNGZI0qFXRi7L6aPa/esNBVBpWZsDghzYtYSg7yLvk
	 cdlYKCAWg51GONEEkxc6U0zVO+Kr0oTxrjGkgSEC0Le+kEelNeFb2XbyAlxL1e9WswPHM
	 oXirE0bXrcWJERUXWbNVxokXvUhlYIE2Yw5suLKIlziu2zpZN33h5o5up0nCj4WIXMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uNkiVBPz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AEEC6074932;
	Wed,  4 Nov 2026 21:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uNkiVBPz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1605F1F00A02;
	Wed,  4 Nov 2026 21:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829340;
	bh=Ecfn4fX3mUmWpN2aVM/4fDejHex7ZRq5Zi4KlT0+mhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uNkiVBPz/v6RpLvfUhdodpMBiIAJnMa45U2RddH5Ntd4VJrO1xYOZ49VKpJ1Co3jV
	 GuA7cXIS86KwUg1bsqrrc/TOnZrMmdcsVHZ5/9NL6tNKBzY+XiUf/75YJcNxEbEgrj
	 38JJqNscXKhqRvdEG2efmJFEP9O6yBzQV93k2M4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asad Kamal <asad.kamal@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0065/1005] drm/amdgpu: validate XCP topology counts before division
Date: Wed,  4 Nov 2026 15:56:38 -0500
Message-ID: <20261104211045.427888994@linuxfoundation.org>
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

From: Asad Kamal <asad.kamal@amd.com>

[ Upstream commit 0eda57ee303b4392057b7d4c32e8fda9d14cffad ]

In aqua_vanjaram_get_xcp_res_info(), max_res[i] can be zero.
When res_lt_xcp is true the code divides num_xcp by max_res[i],
causing a divide fault.

Skip the loop body for absent resources.

v2: Remove redundant checks (Lijo)

Signed-off-by: Asad Kamal <asad.kamal@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c b/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c
index f9e2edf5260bc..15e70415c35b4 100644
--- a/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c
+++ b/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c
@@ -295,8 +295,10 @@ static int aqua_vanjaram_get_xcp_res_info(struct amdgpu_xcp_mgr *xcp_mgr,
 	xcp_cfg->num_res = ARRAY_SIZE(max_res);
 
 	for (i = 0; i < xcp_cfg->num_res; i++) {
-		res_lt_xcp = max_res[i] < num_xcp;
 		xcp_cfg->xcp_res[i].id = i;
+		if (!max_res[i])
+			continue;
+		res_lt_xcp = max_res[i] < num_xcp;
 		xcp_cfg->xcp_res[i].num_inst =
 			res_lt_xcp ? 1 : max_res[i] / num_xcp;
 		xcp_cfg->xcp_res[i].num_inst =
-- 
2.53.0



