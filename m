Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829420;
	b=bOznbu+8AVWv4zvjKeF2kUKbz2pFyu2w5ecC1Kk+By7AkyOPrEQGNQb6dn4rKU8YkqeM
	 Bc/sPvtikb/hi5B9ZzpdtQAZpywx/DT3DExAy79X6xAfv/Gxp3i6eTTyKBQ2LRHRydGNr
	 C6R+9pd65jKNAiMB+HKd/dzZPIuy8D7Ck7LoxgAMkcVlIG5a0xBrECsCkO9E6UFLSykGH
	 EiKNtkq5DqHPwY6FEHOWT++ii4FsZxmfiXmIslUiiwafdwKgn+pg0XegT3fDV/gPSSo9S
	 PKOCHztI0XUjMgeCt2Vggd0pxkp6ryHqLJeIfzpNmfqZvlUSv2LyVjOBoALiSQSvD5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829420;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VTxiSehQsyrTMsVmUUUr3fb3L5qgG7uu/G3HscbPypg=;
	b=U45YP0k+5axnfx07g8ux4oH25Cmc50cm9DRgp0+2JHRzcxgeezmBUqsJNPc3vVH9kXbY
	 ePJY8OKYKm19DiO19HRGhEOtM04a60nDyatpWeWWmAhBHuKIE0CvCTGmkxUP7vTCBkAkI
	 sZ02Q2DWVZRtnbQJ2Zl5xW0bi7HvL1SWORIEvXhDlyvKAFt0Qv7VxoaoMncUoE58BSiG7
	 aAaUbTg/kRNdnDrkXKXZoLu6J8xHVNdd18LISqpE1JhP9umPTfeKHUFq0DOp6okl/ws1d
	 ofhltxGiBEf9qY/Uh3srl2kt1W2BIGUTfxg8ppk93Y7c4fUvcPfuZ8/Bf6+937mhJRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nFuvD5zr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D96F608662C;
	Wed,  4 Nov 2026 21:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nFuvD5zr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41041F000C1;
	Wed,  4 Nov 2026 21:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829420;
	bh=VTxiSehQsyrTMsVmUUUr3fb3L5qgG7uu/G3HscbPypg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nFuvD5zrNqy5gCYDwIi43UEMCizDXKu2WtNbraz5mBNol39xLNaOvL7RqDYrhfooj
	 PdtmbaCPCoIJlERx1ia8vnFthokIB7Sx0F6d7/gcIJAaFmfU8H2UCzKiKKa52xm4DW
	 5/EKGF1mpOATnIZTGnU0S2YDpGkbDmiVYNv3nvag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Russell <kent.russell@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0115/1005] drm/amdgpu/gfx11: WARN() rather than BUG() for invalid SDMA engine
Date: Wed,  4 Nov 2026 15:57:28 -0500
Message-ID: <20261104211046.878523656@linuxfoundation.org>
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
index aaccf0b9947d4..d32ea91eeb343 100644
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



