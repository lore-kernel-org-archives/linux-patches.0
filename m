Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D61400DEB;
	Wed, 20 May 2026 18:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302808; cv=none; b=B8+GO7HlCtLb/vp/PyskM/gmOo1jVkcwMt65B4tFzwMRYNUi/EjWWgNuiOAvki4j98OPrxq/DP2zmg+m90MN1NzxoDOK3Jz78ypjWuwMCu9X1XctREPiL2AHb4vRzh1pl8vTuCD+B/9D0P/PORnSkfYNJdnHxOuF4d/L9cur7co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302808; c=relaxed/simple;
	bh=0PiJMW7kCEdtkCfPYZrjoprJjo+nGkUVZhtfHGaGLV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RyqJ15S51qqZkttHu+TqIBti49Oj0U/qR0uAuGdTIRJm5mfaREippqB81Pbul+1OhAMu5vttDp7c3/t7R5JsN6UX32o85DB1sQJ3KBOXYOiQujap60Koz28QQ6wzWQQrjZqgVHXanl6/AtMhjC7P/CDLjS8Zj6HiLD+4K+Xo7fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qtdznMBG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qtdznMBG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36C491F000E9;
	Wed, 20 May 2026 18:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302806;
	bh=XaWt4YyohoojfMbH3Cx6Y+wLEP32tsuNwx120v8mp1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qtdznMBG4tIf/G9riNhcV5xfw9DFqJ21fNwImW9ruwsWf3DrFKseDZ04hbnwFRr5R
	 xDj8qLSSNb2IW0wjNBmVeZjjpyxSAYgPYhsiS6MNjmQ462stY23KLYfys7i0B2H+ac
	 opF1AT0AaJ/AFE2+sCbmnj1WlD5DE6qxlm3ULlb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 407/508] drm/amdgpu/jpeg: set no_user_fence for JPEG v4.0.3 ring
Date: Wed, 20 May 2026 18:23:50 +0200
Message-ID: <20260520162107.429498014@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

[ Upstream commit 83e37c0987ca92f9e87789b46dd311dcf5a4a6c8 ]

JPEG rings do not support 64-bit user fence writes, reject CS
submissions with user fences.

Fixes: e684e654eba9 ("drm/amdgpu/jpeg: add jpeg support for VCN4_0_3")
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Yinjie Yao <yinjie.yao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 2f6afc97d259d530f4f86c7743efbc573a8da927)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c
index 78aaaee492e11..210177c738554 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c
@@ -1054,6 +1054,7 @@ static const struct amd_ip_funcs jpeg_v4_0_3_ip_funcs = {
 static const struct amdgpu_ring_funcs jpeg_v4_0_3_dec_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_JPEG,
 	.align_mask = 0xf,
+	.no_user_fence = true,
 	.get_rptr = jpeg_v4_0_3_dec_ring_get_rptr,
 	.get_wptr = jpeg_v4_0_3_dec_ring_get_wptr,
 	.set_wptr = jpeg_v4_0_3_dec_ring_set_wptr,
-- 
2.53.0



