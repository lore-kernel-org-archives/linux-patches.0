Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74528371048;
	Wed, 20 May 2026 18:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301442; cv=none; b=IzSeGige5s/YqbBV2Kkw+CRqlCM3CmDuQoKl9/t+phwiQkxdRmVn8mshCxx61jO+oL+mbaTYXLsBgNdkWhkkq+Vjdt+jE2FO5AxwrY04UZtXhN53jahtHgRlDD5zQfXk4qRJlzHiF03UoOnfpXYzVd4WzqmCJkMapUhnV+3IEFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301442; c=relaxed/simple;
	bh=lYHqfg+GGMRyR4UU6iiMDyiz1dkxump6patEJ369if4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g5etXV6l0Y65wuy23u4+/Fl8VHXxStXfQD2Pr88Y4QN8JGxsNNOJxy5dB2wW4P1NIY/gH9FvmJrWVtEG04irGszfaLNbfaitGFE+foDfoWD2bCvolKBU340+MQQTXp0udlznVMuXe2/uhQeHfm+BEyoK0BJTsnSy3vbWb/xfPqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NoztNbI9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NoztNbI9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D922D1F000E9;
	Wed, 20 May 2026 18:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301441;
	bh=RsZQoOo5mkW0pQ5v7UGMcaXf3ZEvKkjYz30RGuyHET0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NoztNbI9pq8/sXaR0AlRAuG2LRvADmyK6iUQ7YPgw4JalDGCKi38ppagUYGSIwB5x
	 lXlelkcIHIig579Zm4/2pYJPfk2qEGj0l36TRn4TcSbJNJSLrFPf9g7Hf5Sj7LcN+h
	 DUais0hayJkLsmA0H2/+ehVx7+8w9jwvXg3h9T2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 555/666] drm/amdgpu/vcn: set no_user_fence for VCN v2.0 enc/dec rings
Date: Wed, 20 May 2026 18:22:46 +0200
Message-ID: <20260520162123.295758634@linuxfoundation.org>
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

[ Upstream commit 8d80b293b41fcb5e9396db93e788b0f4ebcbafb7 ]

VCN encoder and decoder rings do not support 64-bit user fence writes,
reject CS submissions with user fences.

Fixes: 1b61de45dfaf ("drm/amdgpu: add initial VCN2.0 support (v2)")
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Yinjie Yao <yinjie.yao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit e2b5499fca55f1a32960a311bbb62e35891eaf73)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c
index 5431b2589ed61..29f5f6b1eb0a4 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c
@@ -2127,6 +2127,7 @@ static const struct amd_ip_funcs vcn_v2_0_ip_funcs = {
 static const struct amdgpu_ring_funcs vcn_v2_0_dec_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_DEC,
 	.align_mask = 0xf,
+	.no_user_fence = true,
 	.secure_submission_supported = true,
 	.get_rptr = vcn_v2_0_dec_ring_get_rptr,
 	.get_wptr = vcn_v2_0_dec_ring_get_wptr,
@@ -2158,6 +2159,7 @@ static const struct amdgpu_ring_funcs vcn_v2_0_enc_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_ENC,
 	.align_mask = 0x3f,
 	.nop = VCN_ENC_CMD_NO_OP,
+	.no_user_fence = true,
 	.get_rptr = vcn_v2_0_enc_ring_get_rptr,
 	.get_wptr = vcn_v2_0_enc_ring_get_wptr,
 	.set_wptr = vcn_v2_0_enc_ring_set_wptr,
-- 
2.53.0



