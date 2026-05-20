Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3BC39B483;
	Wed, 20 May 2026 17:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299628; cv=none; b=NrYCqurvSegWAHyNo/vcdIRoBJBVElOfd7mLs1t/xBAfFlv1LuTzjTw7g4osKGCdctmXpE+675MHUhpUJQXwzrDBA1UHfgr0T38EmIRc+F4dZmnnNoGr2JPZ++vscnBGSVQ4FhnGeTkMrcy/++ofYPZBGtxTyKGU+daRxT3ayBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299628; c=relaxed/simple;
	bh=DNEU0ialWssQ/M/562S/VziO4hoTRdAMMREapdrqKAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HPHXFmXXuCHBV48BitSp1YDRHPl9c232OO8rpW0oTFjykLb0yioBxurle9KSUy4BTiRP/gX2KjRt+kdJ/WHECjlk1mHYV+bYNEZREk03IeUuLJ0CnXI8mdyC8DgvQtSmlrQ+0BC6NhRS5ko8586RrN4I6T15jISgjrtB2IQCHPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ymyXr8fs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ymyXr8fs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 735501F000E9;
	Wed, 20 May 2026 17:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299627;
	bh=eOc85r+QASQuPZNHOPVS4OJwhWlxSGQx/+qlCBzV/tU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ymyXr8fshenzkWgEhCGg5a7mxe2Jo2J+tCm1WCeVrU12am9P/n1v3xBV8pbyhezzL
	 wLSJSyTXCm1DMl8/gCN0GOHA4JAEej9PpMdipyO4mTuzqb1ghinD5EQQq5R0+iK5LS
	 FMidc8eXR3varLD7fpUodR4zEQWPPT3L+gTdrAGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 803/957] drm/amdgpu/vcn: set no_user_fence for VCN v4.0.5 enc ring
Date: Wed, 20 May 2026 18:21:26 +0200
Message-ID: <20260520162151.983079405@linuxfoundation.org>
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

[ Upstream commit 589a254bf3e88204c8402b9cbccd5e23a0af990f ]

VCN encoder and decoder rings do not support 64-bit user fence writes,
reject CS submissions with user fences.

Fixes: 547aad32edac ("drm/amdgpu: add VCN4 ip block support")
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Yinjie Yao <yinjie.yao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 084d94ac93707bdda07efb5cee786f632de4219b)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c
index 1f6a22983c0dd..1571cc5a148c8 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c
@@ -1483,6 +1483,7 @@ static struct amdgpu_ring_funcs vcn_v4_0_5_unified_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_ENC,
 	.align_mask = 0x3f,
 	.nop = VCN_ENC_CMD_NO_OP,
+	.no_user_fence = true,
 	.get_rptr = vcn_v4_0_5_unified_ring_get_rptr,
 	.get_wptr = vcn_v4_0_5_unified_ring_get_wptr,
 	.set_wptr = vcn_v4_0_5_unified_ring_set_wptr,
-- 
2.53.0



