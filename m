Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2773FBEAB;
	Wed, 20 May 2026 18:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301458; cv=none; b=nl2Ku4abM7Vk5mCcKRQOMoQzN0VtwNtg1dbgiBXpw6cNGrod5rdwGR1ZL7JvF3G154NrnEAp3sXyZiKiTLffV4p8F7l1qc4crJBfOkW/xV+7f5W2jSB1eipuz5xyxEOWFj5x4we0lTJZfi+XNbC98MXslz8JUBh+feyYuz96LFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301458; c=relaxed/simple;
	bh=Au8+V6FwyRCUgW3bSy8jkRZPLkjN1k2pAogsh6EUAYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QYDOUc/UArDLJVtZAfyOyMpPva/cUsBAOVRyr3VRFKEN2dQfhXuGRSWaxNnNUqNJkfkB9balPQfzoAiQk1wOcyGInmNNn3EFAeHq5jCb6oX4CBkqH4m5bvK0xFKcW0Ek7x+9aIH/u49wo2Ebuxj6Hh/fpKWLcY3pJ4lMxwa4FyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2HU4JN40; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2HU4JN40"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A59F01F00893;
	Wed, 20 May 2026 18:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301457;
	bh=ljrq2DCF/jW3jNXPjuMwJPeg/z+i9lwMey0BzgVbhcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2HU4JN40gTfydM9sH9wqAhhUHYgjbT03Ngw8bUVPW7sb0DMtXgyOUhhxFfoRmZf6l
	 LSUsXQA4ACM+luDAYUswN276V3sk0ZFfrkzI0nbgQvy7uy5Ih7dOMH+yR4GRlLNJBI
	 y9akiM4vhwVgRPrnFq6aA1BPsKbU0GwMbKlqTxXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 560/666] drm/amdgpu/vcn: set no_user_fence for VCN v5.0.0 enc ring
Date: Wed, 20 May 2026 18:22:51 +0200
Message-ID: <20260520162123.404629133@linuxfoundation.org>
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
index e21193111d4d4..f8994e4bdf4b6 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c
@@ -1137,6 +1137,7 @@ static const struct amdgpu_ring_funcs vcn_v5_0_0_unified_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_ENC,
 	.align_mask = 0x3f,
 	.nop = VCN_ENC_CMD_NO_OP,
+	.no_user_fence = true,
 	.get_rptr = vcn_v5_0_0_unified_ring_get_rptr,
 	.get_wptr = vcn_v5_0_0_unified_ring_get_wptr,
 	.set_wptr = vcn_v5_0_0_unified_ring_set_wptr,
-- 
2.53.0



