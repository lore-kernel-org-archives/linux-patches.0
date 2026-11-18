Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057179;
	b=FkNCTjDKEyMKrMTL68HcENQ7KqtZemkekONV45xuUn+08/r1ClnwnL4AQF3LxYtHjLaL
	 StIdjIJUcbdIltnL3UHBXJfUWqeaTD3VmJSHa4klgLjB+DxePk7Npx0ZsxABYM/DQehQb
	 a8k+4zv3ena9hVIY+/ncgAc23j4zG8ozdiZmIvpVVI8KKCT1xWoii4t6u7hhmZ/7Px/5P
	 Ccp+bUr2zDrMz9Er7d43YUy5LZ7kbq7E+mV5dzwjjAxgaHgmltJFj0NdR65l0AEVnLQdH
	 aP+8jTw8bEEP+qtgLBLKDex/+3kkPtiB9J35qM6Y3meSCzSYehmxkgcOOZazHAoc2qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057179;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yLF6rOKfgVtqazmMwtI0zML4xsSDEZSa6nSokYvnd/g=;
	b=VQnoPhqTAOoKQSVeLBPHtVgXmW8tqFbEYkc0aU82JDynn41VcGLRVsKYsEjRUpI1APrX
	 rXBVQ/dv9TxZDY+a4JoOE2fCFYEwyNc6urJvg9vRIiulyhRhj6Wz+Bd3O3fmkV8Z4DCLK
	 1pU5ek0pIOcTnyOtd2/+FkRbbibtxrCkGFjx5dtRrHTEwV3QbSlgWYyxU1o02jWatRYiE
	 F2bAkIlDvlDMpDjXY7A6DOasuZD1XmJPS2x7v9jPVyQItGUcNsnneJ6pdRid1PYHrb1rV
	 a2MV8mDKy+0a2ChZgCN2UTqi/bLOj7aersxRGaRG35g35/gzi3qyhOQpBq5MFgdG4/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t8PgasEo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E2C606A32C;
	Thu, 19 Nov 2026 02:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t8PgasEo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DC71F000C4;
	Thu, 19 Nov 2026 02:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057179;
	bh=yLF6rOKfgVtqazmMwtI0zML4xsSDEZSa6nSokYvnd/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t8PgasEosVNNXuqlFsYvTV9dsDqpsfyOYbYjs1+Gxxs3mTD1sl/qStG/FTEcTLTdI
	 8bhPpXyTV/QWnKa6hRfGS24LHjW47uJmncybR3LKWxX0afUnN9ZknTIYRrus6+XKji
	 ZO9Xu3xBeVZ4LfRIcEeJ63xasBCS4zPKiwg5iqjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0038/1848] drm/amdgpu: Add checks to vbios fetch through ATRM
Date: Wed, 18 Nov 2026 15:34:36 +0100
Message-ID: <20261118145912.713772940@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 8c3fcfc14fc1320a1155acb2dd7656fce7003bc0 ]

Check if a valid buffer object is returned after ATRM call. Also, match
the buffer length against requested size before copying.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
index dee88a7e90ee1..bef70e19d7b1b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
@@ -266,8 +266,14 @@ static int amdgpu_atrm_call(acpi_handle atrm_handle, uint8_t *bios,
 	}
 
 	obj = (union acpi_object *)buffer.pointer;
-	memcpy(bios+offset, obj->buffer.pointer, obj->buffer.length);
-	len = obj->buffer.length;
+	if (!obj || obj->type != ACPI_TYPE_BUFFER) {
+		DRM_ERROR("ATRM returned an invalid object\n");
+		kfree(buffer.pointer);
+		return -EINVAL;
+	}
+
+	len = min_t(size_t, obj->buffer.length, len);
+	memcpy(bios+offset, obj->buffer.pointer, len);
 	kfree(buffer.pointer);
 	return len;
 }
-- 
2.53.0



