Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1749B3BBA0E;
	Wed, 20 May 2026 17:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296884; cv=none; b=aghhzDutDdLq0e2n/uzLMuCRWBjcgafcCH978Sm+tL3OOwDa5yw73trde93Spa1m6cxUR7XXo6Mb9WYdbyaQwvOBKpZh4Kqk5aU3yuomzRabdK5/ggR53B6IpTrZMAVQmQM+gnFbziH/oldoAr95ASmFMwNGTCQAkM/cBN6b8Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296884; c=relaxed/simple;
	bh=b+hLZTNx5v1ACl9RMe3A6Vgsjg8S62iSv1Azuie+1ig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kqaYLEE+cVwSK1cUFY1pNv4kXdA5y3MgtfyX6lTwepZt8fZS+ks0aeU3ewLmpjYGQ77PYT9oXqqoc/LvFfFeYIFbSfy+fcIs4r19/LkdHbnFd9TTtigvsphN5+0XDQYJnnkijDLDyDmuU/os5ZD0YdtXg4aEDzLt5sABkhjwaoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DFTMHOFl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DFTMHOFl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D4C51F000E9;
	Wed, 20 May 2026 17:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296883;
	bh=tvz68vsM1Q1vSUPtS+m2aITl5Tgo5DXUMp9N23eTjPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DFTMHOFlGFL5/6iEicBMEdJE3Mjy7sULh5ZxJs0AKrBuePYTIHv+MyfHA3pei4FJw
	 Sk4WLbau4m2RSbjPn01VST6SeeQtzNVz6USm9ZPSBInR4KQFkvcVrFObFZO32Hi55L
	 HrbjmUqpQg/UpH3lQ82Y59LqWzOU0uNWfVw7vros=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0969/1146] drm/amdgpu/vcn: set no_user_fence for VCN v5.0.0 enc ring
Date: Wed, 20 May 2026 18:20:19 +0200
Message-ID: <20260520162210.158031627@linuxfoundation.org>
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



