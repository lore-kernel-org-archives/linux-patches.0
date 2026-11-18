Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017157;
	b=sgLd2RtuJzqn5GFw+ZfrzrI9pA42imN0hVtaQALNdF9WsQqUVQfU/odVqX5dVFB95I64
	 pILWeLebOrdMU70GZoiOnyjsRw5mQ0l4fqoUGSA62SwOyE5JRjlL24RUA5ULvw1hvqIyK
	 uwzG4Fh0GuHpuJ+yC5b1qm6PXYIgi5MWDWMc6uQhT1KeLH9qyGVPWETNdVoxLylRYuuPP
	 QCz8D19h7DI6fTN6/IzbyaKGo7yBpDJDMh24d1uJO5Cx0BVOD70TqoGAHKnoHFy4bE94u
	 qizGx9POMqPygOTTiHQKzLsuenTA18GMzL5u2AxL1U/Rbk5GsgoY2qGcBr6qZiQg4/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017157;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PR50j6TU+HF812cO2dlHqFYuHOMuwVv1Bb/sRXndnoA=;
	b=XMkAtheB45DukM6/nqrhzG1yi+UQ0G0vTTKIGDDIW9tcK4Yu+LBvnQomnfDkKXReyfjc
	 ykvQgOHjUUlbTB69nPzax9LUpT0FfdDqIpXfrXElGI5QHm6bWGICOE7Lz6/4wbR3Qw0iY
	 6Av8BDDH5jznx/TLYK9d/8qeoSc7u01B9cD2S2iMWd+UFFxtk2fOemOng8XYxsa2h/vNb
	 OQV/KzIiwkegPJkcftEzVldQ3473URQFxo6S6OdLaTRmDjIrazVdHhWtwB5RlMpjqS463
	 MRfeutZHtmFhuOafStysaARjuF/5VSMYDRga0PQBPHzZY0wjzvpHbsMzUEqFN4wT6yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XgKUjsm4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D07A606A320;
	Wed, 18 Nov 2026 15:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XgKUjsm4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB621F000C4;
	Wed, 18 Nov 2026 15:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017157;
	bh=PR50j6TU+HF812cO2dlHqFYuHOMuwVv1Bb/sRXndnoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XgKUjsm4/RULwJ3WaKjple0PndEqy0LyjB9t7Mykp6f3cKVZURZbEVNQb7O6YCJSW
	 8pj5h8NpRv2Ki+2/uHPbjapHGQTmQIWC35q8aF3r/1UPCjd1yolA6/XOWyUAfoiltL
	 h5dpKiKcKp676cnkPUsXNSbQ5VrHTmYgOogEJuOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Le Ma <le.ma@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0742/2651] drm/amdgpu: disable GFX clockgating for GC 12.1.0
Date: Wed, 18 Nov 2026 15:33:02 +0100
Message-ID: <20261118150314.589688364@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Le Ma <le.ma@amd.com>

[ Upstream commit 7c00e5859b3bd232b2eceaafad4067fbfa46aeca ]

RLC fw disables GFX CGCG and CGLS on GC 12.1.0 by default, so clear the
corresponding CG flags and keep GUI idle interrupts disabled during gfx init.

Signed-off-by: Le Ma <le.ma@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 52a484f3ef5b ("drm/amdgpu: Move GC v12.1 spm vmid init to hw init")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v12_1.c | 5 ++---
 drivers/gpu/drm/amd/amdgpu/soc_v1_0.c  | 3 +--
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v12_1.c b/drivers/gpu/drm/amd/amdgpu/gfx_v12_1.c
index e49d8a79045cc..78d64f2ed31fd 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v12_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v12_1.c
@@ -2817,9 +2817,8 @@ static int gfx_v12_1_xcc_cp_resume(struct amdgpu_device *adev, uint16_t xcc_mask
 				return r;
 		}
 
-		/* GFX CGCG and LS is set by default */
-		if (adev->firmware.load_type == AMDGPU_FW_LOAD_PSP)
-			gfx_v12_1_xcc_enable_gui_idle_interrupt(adev, true, xcc_id);
+		/* GFX CGCG and LS is disabled by rlc fw */
+		gfx_v12_1_xcc_enable_gui_idle_interrupt(adev, false, xcc_id);
 
 		gfx_v12_1_xcc_cp_set_doorbell_range(adev, xcc_id);
 
diff --git a/drivers/gpu/drm/amd/amdgpu/soc_v1_0.c b/drivers/gpu/drm/amd/amdgpu/soc_v1_0.c
index 37e2068b6fda2..1918313d14960 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc_v1_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc_v1_0.c
@@ -293,8 +293,7 @@ static int soc_v1_0_common_early_init(struct amdgpu_ip_block *ip_block)
 
 	switch (amdgpu_ip_version(adev, GC_HWIP, 0)) {
 	case IP_VERSION(12, 1, 0):
-		adev->cg_flags = AMD_CG_SUPPORT_GFX_CGCG |
-			AMD_CG_SUPPORT_GFX_CGLS;
+		adev->cg_flags = 0;
 		adev->pg_flags = AMD_PG_SUPPORT_VCN_DPG;
 		adev->external_rev_id = adev->rev_id + 0x50;
 		break;
-- 
2.53.0



