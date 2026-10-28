Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215193;
	b=INZwMyhNDV6d8o7qGBV9tA7f+IjcVRHA38I0nASspQnDfPx5r3FHGALSMeD7cuXcbBCT
	 q9MO4fS+MocM9Bx7EJsiH4MQPcl043C6/Vn6OkTTE5q/FwuHhmWB0/SbOqwefnBWKPRX4
	 wJchoqED3AQoPd4EGXAO6PtxxSViJwPp1VOBO4yebe4RkFCz+PHv3Nj1Z/Z/1OEgyFgL+
	 9LNL4uQxTKzU0Bs/bdnccTIyKWG+YaDXz7iztls9AM2b3rqU7aDrPTMhdI4nRZuCr5PsV
	 guHUW7tLUAtAZKQKEm9DVGzgUStGHdcCq0hwx6gVA3SXtwEqd8A+srJRBFYsEqBgrlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215193;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=viDgg+eV6grt0JlIkIfYnFjnvUrYnukL5w8QnYXCnH8=;
	b=OYOBnMrTxf6GdDTiP2KVIIDlRvLGFDtSIyR5qeN05uIoEVAT/nEysy2+AqXY6gCpFL07
	 xEIr0S/qkqWEzIIg1cvK4XKG9cLcrPMCSjW1dat0aAMUNw0GAF4yhg5ohd/XGnOZOmYzs
	 pFbPdU3gbIZ6KV/87+YnTtm64gMObzB0pz1CIqB08FblxfT8GkAtYmGOd2prF2wrtgApw
	 81uQGitlPTScizijnDn85NnOkOBjTLnzl4mYPmLyG9cof8HdoPozrPAKmW9qymiCrP7Ew
	 5vZDvtFQRX9eF63va/qOl5kilxuPFIYErJq1Upc1DX++sCS3GHqk4D6wAKxB1VJ8Z5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="KC/VQZga";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE1C0606A31A;
	Wed, 28 Oct 2026 19:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KC/VQZga
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A3E51F01825;
	Wed, 28 Oct 2026 19:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215192;
	bh=viDgg+eV6grt0JlIkIfYnFjnvUrYnukL5w8QnYXCnH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KC/VQZgaKk7VWdpKjfhZqfJdQjAFcHHcEnl/J9v6u05UvSmZyPejEZPeAzmc18riD
	 z1PExD/Gxo/m0NuUxmfTI4uwDFWbIF/sjQn+wufA1HsqH32iGxNll/1WZ4VcCBus0J
	 eZrTRcbOcEQs6A4bSPsyKrsm9aSTcQ3at9h3nH9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1124/1887] drm/amdgpu/vcn: set no_user_fence for VCN v2.0 enc/dec rings
Date: Wed, 28 Oct 2026 17:53:40 +0100
Message-ID: <20261028170524.978349390@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 08bdacf8690bc..c271f3f0c70a1 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c
@@ -2013,6 +2013,7 @@ static const struct amd_ip_funcs vcn_v2_0_ip_funcs = {
 static const struct amdgpu_ring_funcs vcn_v2_0_dec_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_DEC,
 	.align_mask = 0xf,
+	.no_user_fence = true,
 	.secure_submission_supported = true,
 	.vmhub = AMDGPU_MMHUB_0,
 	.get_rptr = vcn_v2_0_dec_ring_get_rptr,
@@ -2045,6 +2046,7 @@ static const struct amdgpu_ring_funcs vcn_v2_0_enc_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_ENC,
 	.align_mask = 0x3f,
 	.nop = VCN_ENC_CMD_NO_OP,
+	.no_user_fence = true,
 	.vmhub = AMDGPU_MMHUB_0,
 	.get_rptr = vcn_v2_0_enc_ring_get_rptr,
 	.get_wptr = vcn_v2_0_enc_ring_get_wptr,
-- 
2.53.0



