Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A97C2C026C;
	Sat, 17 Oct 2026 16:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254248; cv=none; b=CxT4q2znCfXNyYnwsRZAhM/DLwXqgWQ9/Iui9/FnEAECjFJtaNutr+9LPri9Ua/YUhN3sl5+fCVhC5fIA7Wcc029vPcuNKNmQRRszYgSzQ1i0OvLdIdoOjgkLNaUnEIPMzJjMEsioF5mGRRTTNCQN9ZPoPp3ihgBkpdkELzBZ98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254248; c=relaxed/simple;
	bh=kZkA+un8MJxh2QGIJ9ejCrazJsGoNNDWvqSwliH+INg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JReUq3rk5Tpbm/rIVaHRQrENJCRWofovQNZbsTO0MK8qXDZweWcBBgeOuOF4SkWUWTzd22qx3rKNn84kAB7xcttp8ZIjpp9qy7+0I+5lRsnk8X37Y6Szu/facDgBle1MzxvwBx4sNiyM4UnFgJY/2WSg0yXgENA0iHCd3KdZEwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gkMKkI5A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gkMKkI5A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 652A31F000C4;
	Sat, 17 Oct 2026 16:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254247;
	bh=GylX056X7VIr4+YAl/vEcSspitUCtSYlhQ5/brxA3qU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gkMKkI5As276WoBtYUiWqY1TVMcwmESisX5bUldkmEmO8ZTsFzXgeCF7pN+XPODd0
	 MD9g99WjK27PtMVE3+//mFgiaShOwuGZ0kofZ6kgly/lfYsVeplGgZkU3fV0SbWoil
	 gZJY0UapFJ+SW4HX/+AGMp7XP5Q3/5qlbX2AXcus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 343/869] drm/amdgpu/vcn: set no_user_fence for VCN v4.0 enc ring
Date: Sat, 17 Oct 2026 17:53:04 +0200
Message-ID: <20261017160045.886548681@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
index d86de234765d6..e9d43924bcd73 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
@@ -1926,6 +1926,7 @@ static struct amdgpu_ring_funcs vcn_v4_0_unified_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_ENC,
 	.align_mask = 0x3f,
 	.nop = VCN_ENC_CMD_NO_OP,
+	.no_user_fence = true,
 	.extra_dw = sizeof(struct amdgpu_vcn_rb_metadata),
 	.get_rptr = vcn_v4_0_unified_ring_get_rptr,
 	.get_wptr = vcn_v4_0_unified_ring_get_wptr,
-- 
2.53.0



