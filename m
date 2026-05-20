Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF37B3F2115;
	Wed, 20 May 2026 17:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296888; cv=none; b=hPmEXkc8UIVywSFP4+a0fQyiwXyAo2tfcv2wi4Yr5njU1/r8PIekJccDh4/yvBi8iunlhAwe44ADEZot3L1oPTUyoTSmSjzZ64DpgNDNvxXllcMlRJz7642M0J2W2Q1gabc/HvkvYDh9sSq0wk48jg0NwGgiY6E054DDW6EK/jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296888; c=relaxed/simple;
	bh=8Ekt6G39F3J5F8RbgI6t5+Fmf4nBxEbG3pYgonOTeoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Si0I5UxwaJO8DlZjPUi/v7SLdccuziAZb0Ek9CBNb8BRLF2DOk9fNIKQdd0rTOx4GsdG04cwzcNF7NTDmbA7Owc5KLBs3XmugzB6M6W/urrREnUqZ6CgwE2RzWteu59FACziw98oNYvzGeTDEZA18AzdKmPp666vuKSyoMrNP2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u6B1TgYG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u6B1TgYG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27A8B1F000E9;
	Wed, 20 May 2026 17:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296885;
	bh=ZlsMXYpYLX3Q7TbFaSnVGcj1W5pWscBYZ2d3YAagV0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u6B1TgYGAOap9FxKLX1hISvI8VxUf0OyZI3fwTl9RM8TXAXWXDJ7ZkWv5vQKbHSxJ
	 0Izs6tKak6px/Y/xQW+iGZHg7rVP4KaAg+n4UyxsioaOZwRx7ppVX1EEkOIPR9nmXO
	 TFtezk3e9OIK5t0BhV9BLEI3xCWB2wf7nfJ55wWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0970/1146] drm/amdgpu/vcn: set no_user_fence for VCN v5.0.1 enc ring
Date: Wed, 20 May 2026 18:20:20 +0200
Message-ID: <20260520162210.182272162@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinjie Yao <yinjie.yao@amd.com>

[ Upstream commit 8f4954722eab88e10c4ea0c0d3b1269c31421d3a ]

VCN encoder and decoder rings do not support 64-bit user fence writes,
reject CS submissions with user fences.

Fixes: 346492f30ce3 ("drm/amdgpu: Add VCN_5_0_1 support")
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Yinjie Yao <yinjie.yao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit e16be95a2c3ee712b142cb27d2dca0b461181359)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c b/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c
index c28c6aff17aaa..54fbf8d73ca67 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c
@@ -1419,6 +1419,7 @@ static const struct amdgpu_ring_funcs vcn_v5_0_1_unified_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_ENC,
 	.align_mask = 0x3f,
 	.nop = VCN_ENC_CMD_NO_OP,
+	.no_user_fence = true,
 	.get_rptr = vcn_v5_0_1_unified_ring_get_rptr,
 	.get_wptr = vcn_v5_0_1_unified_ring_get_wptr,
 	.set_wptr = vcn_v5_0_1_unified_ring_set_wptr,
-- 
2.53.0



