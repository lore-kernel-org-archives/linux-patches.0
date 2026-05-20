Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6462E3D75A0;
	Wed, 20 May 2026 17:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296889; cv=none; b=RMnBqA3PQf9KeCTBbYj70StZPhPrDi0bXeqFLTLBiFddk3/Rh4ZjuMAoJVc/edXWyhUeDu5kYwaENzuyz7jzr4N7ro3AZC1vQMm5sSEqlkWAaUkEAzFkfhySqLHZLP8injtevu50ziFVLoXvWtfgo3RPzNwHkRiISwI+fW1X6Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296889; c=relaxed/simple;
	bh=KaTlvSJq77jEwMLh7WJY8bSF5JP54dIpHssxXVgHpNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IOaP7KICspIRWf4FF/9f7z3aMA56bFxHWOtZKnA0gE4L1CRry33DY2XtBRsAzIbyGUamnjlUuvlSg+vRhtEn5uU37LBvBPQeoJlWJj+kyQ7RBF/yzNgEhKlKm6pgDTnd9R3OuLdF6OKesz7bx72rTgAOjAixBwYsqJmdTxIkK4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rQ6qCpFU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rQ6qCpFU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D301F00893;
	Wed, 20 May 2026 17:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296888;
	bh=jHjt8hJXfjlZGsNbuoOklGe59wgeIRaL0O3bEP4RalA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rQ6qCpFUPCSP4Gh9/RiwziBFzbCbZumMf90hU6I5GtfuRfuHEUt6lOz4SqVbeOAFg
	 ObIbZvG5Qd5vESUrnmhZNym7xuaEVfuNiXg5dLVQZRhpa3WdjrgPyW4ek53QjTcBtf
	 oIXhoINMBsLnImBvvyUzLRUBJ3BR6howu3KxYb+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0971/1146] drm/amdgpu/jpeg: set no_user_fence for JPEG v2.0 ring
Date: Wed, 20 May 2026 18:20:21 +0200
Message-ID: <20260520162210.205378094@linuxfoundation.org>
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

[ Upstream commit e5f612dc91650561fe2b5b76dd6d2898ec9ad480 ]

JPEG rings do not support 64-bit user fence writes, reject CS
submissions with user fences.

Fixes: 6ac27241106b ("drm/amdgpu: add JPEG v2.0 function supports")
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Yinjie Yao <yinjie.yao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 96179da0c6b059eb31706a0abe8dd6381c533143)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c
index 9fe8d10ab2705..cffb1e6bab353 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c
@@ -802,6 +802,7 @@ static const struct amd_ip_funcs jpeg_v2_0_ip_funcs = {
 static const struct amdgpu_ring_funcs jpeg_v2_0_dec_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_JPEG,
 	.align_mask = 0xf,
+	.no_user_fence = true,
 	.get_rptr = jpeg_v2_0_dec_ring_get_rptr,
 	.get_wptr = jpeg_v2_0_dec_ring_get_wptr,
 	.set_wptr = jpeg_v2_0_dec_ring_set_wptr,
-- 
2.53.0



