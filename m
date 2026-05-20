Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0293F1AA4;
	Wed, 20 May 2026 18:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301450; cv=none; b=mEC+iwCMQCkf+UVJ8/fa6Sthqeu6Hst7Bb0WwtthaSbhnTGzqwS1Vq3NNzkgkYEa2smIZIKsgAkp8aEwRGcHyIpHPOfuG3tduTVJ7PvYnWDYWU0/2VaHFYrEUMXIj9xIguE4XNJ6eM4vNVHwa6uGr0JrtdLgtCnPMD77W3pwE+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301450; c=relaxed/simple;
	bh=JzYCQhAXFUWajmFpz2sBem66PnGrb9AyQj6zcA394d4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YrckSLhEf1dnDkE44RF9CW5w6k5GpEzRxPC5opSv8rk2TuCoskMLIa9EFfliM6gisdvJOVD49uYrS7yWigD76HnaG1JvnL7Y+/pXmX6lqNAbFYgiTxW/d2M1xPXaUQpPV/NF+HYGWiKx4sFSXy9V1n5SbcirkV82u6P+2OAtpNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QIp1uVpg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QIp1uVpg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2A7F1F000E9;
	Wed, 20 May 2026 18:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301449;
	bh=mnjEG8xCInliqA79+Kcva8SmkQW+imOkRZmOjDfxJis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QIp1uVpgaIyOdNA46kx8xBXqIdaVkOgrb+NJQF7AwOZxSCIb0NO93am7je/O/rlOt
	 zF1PJ4Vuwzr2IXMpT1nEi14MRQ9QMdzRKi2/8+Z/ESk6rIEm1bBASzEQN0gps4voT1
	 Avtsk2aRH22ViqtJ1/1TmpKWQoJU1QcBtovMBMsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 558/666] drm/amdgpu/vcn: set no_user_fence for VCN v4.0.3 enc ring
Date: Wed, 20 May 2026 18:22:49 +0200
Message-ID: <20260520162123.360157794@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinjie Yao <yinjie.yao@amd.com>

[ Upstream commit 4532b52b34e4e4310386e6fdf6a643368599f522 ]

VCN encoder and decoder rings do not support 64-bit user fence writes,
reject CS submissions with user fences.

Fixes: b889ef4ac988 ("drm/amdgpu/vcn: add vcn support for VCN4_0_3")
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Yinjie Yao <yinjie.yao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ff1a5a125c5a70c328806b9bc01d7d942cf3f9aa)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
index 1cdf0a381f6b7..7edb6da93fd2e 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
@@ -1520,6 +1520,7 @@ static const struct amdgpu_ring_funcs vcn_v4_0_3_unified_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_ENC,
 	.align_mask = 0x3f,
 	.nop = VCN_ENC_CMD_NO_OP,
+	.no_user_fence = true,
 	.get_rptr = vcn_v4_0_3_unified_ring_get_rptr,
 	.get_wptr = vcn_v4_0_3_unified_ring_get_wptr,
 	.set_wptr = vcn_v4_0_3_unified_ring_set_wptr,
-- 
2.53.0



