Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023790;
	b=JoOCmUMTT8a1fSHRkn8rNM+xzs0FoQnbMEr0Xy/Jr8OPioPy3CF9hYGMxe9Knu5LJO9P
	 /3M7VLn+9oJN3qgs4P0/hEWou+NEXWWMlAp2MSYsZOIbFMURfUH/vcV75dpF3lxRFF1CN
	 qSkCTy4VXdC3UIl028oss4Xm6NUdzOeSZ9hZ0nPoaI73bpQx1Kn21QtU6huzgPzYwNsEj
	 jZpcm7k/KpLF+LbPnSsv1L+DiUyQjsANiDueN1wesCDgDc23BWb4otal9kG3ExWFh+ceD
	 UYq9Pt4x2/c0/aOO7wE9bHK0ltxZSibaSuPqb+5XzQmZFgmanOTbneASGuhsm5y/lJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023790;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vyB4v1bpbwqq4L7RZYGJEyM6B/6dWrFxU0q3X5UInfs=;
	b=3jYoNrJ6wRAGkIFv4bj8cNADRl8LaxBToi9DOsKn5wdfWC9719rHolSKCnO18qU1+RjI
	 yVfEMoU0PCvkz/lfQE9RaOszMYWYtGHdOiRRKXBCGUjL9alb2f6m5sbj4KVM5HeLeYC9t
	 fLjbFY+Vz2KJaupkMbEuwer40C/sWMXQ4duAcIHZSHBtsDXYr22cWOk9NCwI6ymodoYil
	 Fofg71uhy15i8fzHFG7XwQn4NQdYZJMOGtxUbQeeBR2fc5Gyb3zPr+FZuSb8bskinrmfT
	 7Mt8XN880EFXyLns9P73+s436uvY0zz+OIwcTZnpzHXDak2OjybMys1u8CEm9/jPe3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0wVt030a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10A8606A31C;
	Wed, 18 Nov 2026 17:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0wVt030a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF311F000C4;
	Wed, 18 Nov 2026 17:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023790;
	bh=vyB4v1bpbwqq4L7RZYGJEyM6B/6dWrFxU0q3X5UInfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0wVt030aJ/Crq7QRahYXTt3EGr2I1JwXSSm0R4jG4YeiFwBgDUnFzH0rCNLUfp6pS
	 HyWDLSTFktwkq6OuLe/WbFZPPSsbv/AmFIz3P0Bv36iFLk5KjXeSf8V0dHR9jmfGNH
	 HCi/2XTRDoPhOWGlVwm1YYayGX+j3d6FQYHsNaLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0495/2151] drm/amd: Add correct prefix for VBIOS message
Date: Wed, 18 Nov 2026 15:37:10 +0100
Message-ID: <20261118150140.084735148@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Mario Limonciello (AMD) <superm1@kernel.org>

[ Upstream commit e6c7ebeaba4080562e71a59a788ac90b41e09240 ]

It's not obvious which GPU the ATOM BIOS message goes with. Use
drm_info() to show the correct one.

Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: aee05c455ad3 ("drm/amdgpu/atom: bound the VBIOS date, part number, version and build getters")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/atom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/atom.c b/drivers/gpu/drm/amd/amdgpu/atom.c
index 639649ef6dd03..92ba327f476d6 100644
--- a/drivers/gpu/drm/amd/amdgpu/atom.c
+++ b/drivers/gpu/drm/amd/amdgpu/atom.c
@@ -1474,7 +1474,7 @@ static void atom_get_vbios_pn(struct atom_context *ctx)
 		ctx->vbios_pn[count] = 0;
 	}
 
-	pr_info("ATOM BIOS: %s\n", ctx->vbios_pn);
+	drm_info(ctx->card->dev, "ATOM BIOS: %s\n", ctx->vbios_pn);
 }
 
 static void atom_get_vbios_version(struct atom_context *ctx)
-- 
2.53.0



