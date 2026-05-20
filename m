Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55B43E7155;
	Wed, 20 May 2026 17:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296907; cv=none; b=pCtwzYs0eMbKcgkQmRfx7mZuTjbKL0EIuQSm6oLor/ahXtyXDW8oN1MANQR9MnqZ+74qIGBDxCMZMn4JmThmKgW0eNr9ApHAVPqMpVpC22svuqyeus3kkzcckKrTfNixtZBGO8BZtE4o96k/yk7sX9NDw9byz0fr15t+rxok6fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296907; c=relaxed/simple;
	bh=09OcRX83sQsCxScDxQFOB5Qu11zKxzrWH4w8yH7MTcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rTYpjUTidrX2UYzhzHXAg51W4kokTtzW5SNotRPeZQDZjpKPTGzryzp/Oyr68m9BtPfFBiNBDBop9ESrjFGycSDRUNqdL7aCNfUYaDm+SmmOsbI39MNYHheokSxAqyJqe2ddw4kzySBAG9oRcL/NgZZ5mz+qaYD4v9CZ3mKWCuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mx1UkWMk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mx1UkWMk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37C6F1F000E9;
	Wed, 20 May 2026 17:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296906;
	bh=Np3wftlBu1g6AnaEamjpYV6NAKeKjwJdtUzJcld2Dw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mx1UkWMkeqUViEWE49kpyVCGJiMXTqq2qTJvZrmWtFfMspD+Yy11FYji3981bks0K
	 B8BmrbsGI/na+Nheubx8UGkGOaA4RpOlJaD29pSG+53NqSAIfC3iw5pW5yoISy561K
	 P0jFdMJSd+Ia4yLSTgIMkZYvcSf3OLvrvK24jq+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0977/1146] drm/amdgpu/jpeg: set no_user_fence for JPEG v5.0.0 ring
Date: Wed, 20 May 2026 18:20:27 +0200
Message-ID: <20260520162210.343591858@linuxfoundation.org>
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

[ Upstream commit ea7c61c5f895e8f9ea0ffffa180498ef9c740152 ]

JPEG rings do not support 64-bit user fence writes, reject CS
submissions with user fences.

Fixes: dfad65c65728 ("drm/amdgpu: Add JPEG5 support")
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Yinjie Yao <yinjie.yao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 0f43893d3cd478fa57836697525b338817c9c23d)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_0.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_0.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_0.c
index 46bf15dce2bd0..72a4b2d0676fa 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_0.c
@@ -680,6 +680,7 @@ static const struct amd_ip_funcs jpeg_v5_0_0_ip_funcs = {
 static const struct amdgpu_ring_funcs jpeg_v5_0_0_dec_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_JPEG,
 	.align_mask = 0xf,
+	.no_user_fence = true,
 	.get_rptr = jpeg_v5_0_0_dec_ring_get_rptr,
 	.get_wptr = jpeg_v5_0_0_dec_ring_get_wptr,
 	.set_wptr = jpeg_v5_0_0_dec_ring_set_wptr,
-- 
2.53.0



