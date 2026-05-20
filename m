Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6E03F1AD9;
	Wed, 20 May 2026 17:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299630; cv=none; b=MassGFNtKq0N+IWaqM6wLlhiDg58hy2SQFZBs07v1nKFtKpNIIFZISRM+jTKDOBn1NF9j/IU1QWnWtHrxEi77d4MF9cree5Jn8KTo1qOlPRVIurbqOOpwmR00p6Pf53v2Y4QCJEr54/Ljs9eUAH9Z+FOWmmt5HnpG+GEhQBIre0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299630; c=relaxed/simple;
	bh=2lxBXyGNAFhmcnYuQHtXA3An/BelaLuBK0v8NHYHZVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rdzTn5P1pm6vWkbkAC1ezF+sc8CGu14O3ODrOJ2DvqA2NX/cxH5sJIrR9xNisHJGIb/gYHlxC1rWFt5RVSRo8sczWvKxarcazDkbltAzqXg6FVSLKwMaA6qYyzwMTGfYxDYrrbLQaLQpzeH25dV1m2MawrsvpWUZ+0KTSFU8uHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JPyABXew; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JPyABXew"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6321F000E9;
	Wed, 20 May 2026 17:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299629;
	bh=QVLXNUkAcRPm6dmDoiqS6tcu8KtQKDVNYinbyrJtpVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JPyABXewiNLM+/KwSAI2yE5hFuecGd/1U6xKLYCFCFPC9aeI9rX5UYJEaWR+yKl2g
	 eeQG3tqAAN/H+CdqizkdFVX/lCmK9AO9d2J/sCnEJrjVBAINqQRRaoopG+kM6LjSUD
	 nrXXp+IY2OtNT1ol+zVFVGaioVsqpUntjB4ySxBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 804/957] drm/amdgpu/vcn: set no_user_fence for VCN v5.0.0 enc ring
Date: Wed, 20 May 2026 18:21:27 +0200
Message-ID: <20260520162152.004580026@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinjie Yao <yinjie.yao@amd.com>

[ Upstream commit 8cae0ce77de492d7c31c1532a2e80c0c6e7e58cb ]

VCN encoder and decoder rings do not support 64-bit user fence writes,
reject CS submissions with user fences.

Fixes: b6d1a0632051 ("drm/amdgpu: add VCN_5_0_0 IP block support")
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Yinjie Yao <yinjie.yao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 49b1fbbb5a071197ee71e2d70959b1cb29bdc317)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c
index 6109124f852e5..d5f49fa33bee4 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c
@@ -1207,6 +1207,7 @@ static const struct amdgpu_ring_funcs vcn_v5_0_0_unified_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_ENC,
 	.align_mask = 0x3f,
 	.nop = VCN_ENC_CMD_NO_OP,
+	.no_user_fence = true,
 	.get_rptr = vcn_v5_0_0_unified_ring_get_rptr,
 	.get_wptr = vcn_v5_0_0_unified_ring_get_wptr,
 	.set_wptr = vcn_v5_0_0_unified_ring_set_wptr,
-- 
2.53.0



