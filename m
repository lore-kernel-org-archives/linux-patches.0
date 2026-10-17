Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112F23B9616;
	Sat, 17 Oct 2026 17:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258898; cv=none; b=jP83RG9GHFZzkMIcFJFytPxMp7DVS8pbHUT/d09zIXSWeai4E6ig/cWpjszm6+sWgjiPIAz7WPlW+wUoxqx4ZVydC8mfPJhWh84o2WGDvIb/Uuy8oD3f0pMN+bUPdmHy6uwfUDdx1n8cRjDYtUZeqUFC1NiPfFcObw7WxUOad58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258898; c=relaxed/simple;
	bh=TKP1wCp1O6gtlsSj1+sYnvkRrh49taI2qEQzk4arILA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QQtWDaEeoSSBPOxn4s1ZqyWH8S7JsTghx++KUPZ3pZM26WVOguyvbxXiRdYg6KTPm7OujJQHKDDYbri32Q7e6JviYRv40lNo2clCaNvYOveF7U6YBDQY23qiT/iHsEeu09ytKiyk/B16Xo5wpMfK/63Mlx+m0LBxhrbj9Eys874=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gbcA3akT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gbcA3akT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6575D1F000C4;
	Sat, 17 Oct 2026 17:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258896;
	bh=RLj2Ivb+uOjnYotDtnzLqr6TtQKKuN4XCvVX/GgAdHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gbcA3akTNu0ZXMZLbs1pDI0tmQpg0O6JLofli+ziQyBihw2V1GJc1EfRyk2RXPcZW
	 iAnVnEbJe5EgTAFI8QpCLGblZxTetUKrnDZ5U62VvQPj8cyKsUz3oRUN0uNJuxRGrH
	 unnujmi78WiUweZWA8D4xDHJYZfXGsZE8h0DX33g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1035/1674] drm/amdgpu/vcn: set no_user_fence for VCN v4.0 enc ring
Date: Sat, 17 Oct 2026 17:55:07 +0200
Message-ID: <20261017160457.697840017@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinjie Yao <yinjie.yao@amd.com>

[ Upstream commit 51f694221047c84fa185be98210eb2c354ffb8c6 ]

VCN encoder and decoder rings do not support 64-bit user fence writes,
reject CS submissions with user fences.

Fixes: 8da1170a16e4 ("drm/amdgpu: add VCN4 ip block support")
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Yinjie Yao <yinjie.yao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit fd852c048b46f9825e904a4f3f4538fe9d8827d9)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
index 9d3368fa9cb07..5f8d6fd50b92d 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
@@ -1827,6 +1827,7 @@ static struct amdgpu_ring_funcs vcn_v4_0_unified_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_ENC,
 	.align_mask = 0x3f,
 	.nop = VCN_ENC_CMD_NO_OP,
+	.no_user_fence = true,
 	.get_rptr = vcn_v4_0_unified_ring_get_rptr,
 	.get_wptr = vcn_v4_0_unified_ring_get_wptr,
 	.set_wptr = vcn_v4_0_unified_ring_set_wptr,
-- 
2.53.0



