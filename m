Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829334;
	b=ViFTgb8MgO3Pm2/iIvS8AbVDq1SyP0/RA3yZZsxRm9MBIVvE4sSUuGr9Et3Ghbkhx7pk
	 pFSs8qDryjm4vDCKpEqn47jjtLqqU4mBMSS7n7VaEqnLLq4RoH3c+0tGt18AXwBwcU5Ko
	 UgHVxkERAWRz56s24aUleGSz045cwpxVQtHLgrMcBBYltsDMHBqyyzF5/mlxD41KrzHoN
	 begdkAUSFg4z/ZunraFiQm/tw21uT4MCjCgCQ9zZ9zsLUF08GAp27LkCExk3XN7jJzXpU
	 FtWG7fDvb2Dsdmp7qjtj7n8s3iRjhYI6xZ/dYO3Rvh0owEo7xAV0KnA+Lc+eMemYp8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829334;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xkK50lvg4RxwiwsNQerxg92agL/0GX5mfoD8w9GVP0g=;
	b=Fe4rAuEQMmvwt9u+dKAlvYimVg/SYL+ZO78n+ikKC9h0e6PhTu2BxXQNNXxg+E7lB01J
	 LcmvsJ8lRxNM5y+gBSWCfrC2K8AP4JFG2LcDuMtiPzGB13SOrfLCD08sIYyky7YleU33m
	 oHkiCZDUQpsl9wj+0QBH2J0r/3XX6Lvdbo6qNCOGQpYmpNaBmgzUYrwOwnWr9Kxukahmd
	 UelMgAqJfHN199zNQLywv5BdgciGlwzEZthaloSybYv3Zr3eby0KALeCJMKBJQThfU9Nk
	 DCOdLtadDG8ROeIcoUbnML2alcCCseQS+oALcTzn5NtqIIZYsa0XpFx23IV6FzruOdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RQsXm+Vu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FA660A3834;
	Wed,  4 Nov 2026 21:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RQsXm+Vu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF15E1F000C1;
	Wed,  4 Nov 2026 21:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829334;
	bh=xkK50lvg4RxwiwsNQerxg92agL/0GX5mfoD8w9GVP0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RQsXm+VuPjV28Eq54q7t6/zUMOuKJLdMeHmp1aACuYUFGhjFJRfFOysV6Y/DWtalb
	 F+JTGoC4Q51H/Tu2T0WnqSIjfxLQSMHcQkezFlMnTEdGU+KrigHkDCCdr9SpQW2G4c
	 TyMmNPevULMO1khT2blGXogpzs72Mtnb+Jw9zed4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0061/1005] drm/amdgpu: Add checks to vbios fetch through ATRM
Date: Wed,  4 Nov 2026 15:56:34 -0500
Message-ID: <20261104211045.306141668@linuxfoundation.org>
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
index dec312b0f3b0a..f28dec3630de5 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
@@ -280,8 +280,14 @@ static int amdgpu_atrm_call(acpi_handle atrm_handle, uint8_t *bios,
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



