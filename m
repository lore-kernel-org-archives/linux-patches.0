Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060660;
	b=0TtyRZFzbqbt/v/+HwROthmrTSabFDbg/GosTsEUc1+cq+lSqTFQiGOsI7BeRlWtR/oj
	 OpoEYK2EPJIjlr7iiPKQbby2OQj+wqNWWBmEnQkcI9NfLknit8xT1g3NKGwYieHDPl4YA
	 jZ11cEVwB+pEEaIuAQv+VZ0pAnOJjDv1gmheXFJqDEALuxueWMvGYPbnTOgJ2raEhufBO
	 A9rVhX2FIdGhqUWgUe2tfA4NxEymqTmW5CQpM1/m3+57EBJc1uQ/rtI0r6tPmBPzrphgb
	 B7vyhga60Ou4UC5HmEDw/0tYszJut2Dr7JDIGwgdikoazpJuAqfuLr32ZQkRUAJczgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060660;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a0iD+ty1ig1uw+zpY757DGucHe8omyLs1PxzIxESy9g=;
	b=0U6JYz5neyxdmFk4GW5LtO4GCmlyN0rerfkL66EfmivWBLwjnTi51AFPhHgM8mIHuc9j
	 xgOYFgqK8IKXmQDH1r1t+WrvcLneFo2VshMSdRk6T2BZCyGoJAm5S+ZKIbKAS75w2gKym
	 akPlR66tKpVUIyDDlN8CjXgIVzL7AU7DXIfmegJixGFM2MAZVQ4a4E6DfeE9eSRu2Jszr
	 TMcMbhfxaDWJ/bza45F0oE5ocZACC1vsartOuosUhQQTwyBCnL/ASd0Nfhcy7Ylr6PKuC
	 lon41r02eELNFQA8uesgvAJEK6pfLLn+pZEwHHJeXtmJCKhLhRij/7MkpZRHc6P6k/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VDVlTzkw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21BE7606A326;
	Sat,  7 Nov 2026 14:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VDVlTzkw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA0D11F0089F;
	Sat,  7 Nov 2026 14:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060660;
	bh=a0iD+ty1ig1uw+zpY757DGucHe8omyLs1PxzIxESy9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VDVlTzkwnjunGPmpew7eUCo8MkVSjcxVxl+HK3zKSXUWvPnrS++3tZT31ecTyhUtn
	 Ln/iDWWTnSAIKcNTzcmBxaYhTmn9f+G+3u6TGDfP/szeU2ajwxCnWmkYJYuif8EgLp
	 eC89u/DAIp5jbRTDCdcsprGb6NQMfeVaez9UW974=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Russell <kent.russell@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0098/1536] drm/amdgpu/gfx11: WARN() rather than BUG() for invalid SDMA engine
Date: Sat,  7 Nov 2026 08:35:14 -0500
Message-ID: <20261107135000.419360711@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit c24edbd5ae0e4f24e0179e8c9f22a867016177bb ]

There's no need to crash the kernel for these cases.

Reviewed-by: Kent Russell <kent.russell@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v11.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v11.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v11.c
index a4ba49cb22db4..cc633dbcb94b1 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v11.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v11.c
@@ -139,7 +139,8 @@ static uint32_t get_sdma_rlc_reg_offset(struct amdgpu_device *adev,
 				regSDMA1_QUEUE0_RB_CNTL) - regSDMA0_QUEUE0_RB_CNTL;
 		break;
 	default:
-		BUG();
+		WARN(1, "Invalid SDMA engine id %d\n", engine_id);
+		break;
 	}
 
 	sdma_rlc_reg_offset = sdma_engine_reg_base
-- 
2.53.0



