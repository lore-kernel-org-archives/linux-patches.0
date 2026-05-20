Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971FF3F44F7;
	Wed, 20 May 2026 17:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299522; cv=none; b=huAm9h+CEfoYGESdOeDv8KMqgWykxOaX6ATFP6hdmRsSDBbawzc8+NYVJPYXOsoPhg0lpMADSy53cLeGLmNAbPwkFdkorZtoadEVt92C/NYpFfQZhb6NNCJyqjJLTQxqhYOjVad2wmbK5ZI1Uos8HyHmYxF9Vq0fE0AYoQJE91M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299522; c=relaxed/simple;
	bh=FQ5UqUIWF2o013yhl/0hUPB+lKXhcDpn4fE2/i/kDbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ojNTBKEdMCHvpl10iC7Z8aopQNN4ySFZqagNL1dNpqbiDhmt/TjSbAzEpypz2HtI7QpMakJDrAhLBqh+lpGtLRbOxq3wfqB02egDZUO/IBoHDQ0VIJd53tl/A8yAQEUn2bygH/cNvxo3i44Hm1w4kYXtysqSWGEncMLb0K2bzNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QfqjcEDp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QfqjcEDp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0956E1F000E9;
	Wed, 20 May 2026 17:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299521;
	bh=TDpRpkJBeg3DPpAfgUr1DZ5v1wtIdPblHHTuLxmpGHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QfqjcEDpELXVl5I+5pCrXDYD/BBaIs99zIccLOPIh0EnXG6JC0KLg/tWIb2NUIxs8
	 2dXAzx5gCcZYS7qeqtBIlEL4e695j/AxpxEcE79NrbH0Lk/N/xdQvDfbapMBhdyXoo
	 Of30IgpAzcAfBBmIhmhNlQFiQpNy/AwC55gVvh8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 805/957] drm/amdgpu/vcn: set no_user_fence for VCN v5.0.1 enc ring
Date: Wed, 20 May 2026 18:21:28 +0200
Message-ID: <20260520162152.026128939@linuxfoundation.org>
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
index 8bd457dea4cff..972d4a7147a12 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c
@@ -1330,6 +1330,7 @@ static const struct amdgpu_ring_funcs vcn_v5_0_1_unified_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_ENC,
 	.align_mask = 0x3f,
 	.nop = VCN_ENC_CMD_NO_OP,
+	.no_user_fence = true,
 	.get_rptr = vcn_v5_0_1_unified_ring_get_rptr,
 	.get_wptr = vcn_v5_0_1_unified_ring_get_wptr,
 	.set_wptr = vcn_v5_0_1_unified_ring_set_wptr,
-- 
2.53.0



