Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829348;
	b=pnt7GMcMMtZIx+L2Tz/9SZ0KMjNoV5oPgd3RY0J1u5xsegpM2FNZo/rqYhDY3zKMV5eU
	 ziVNDkJ21Q+ba3sH+IP0AhWMuX9tmSSLmDDTD0zu+FMYxRNgApIi2IzLlsXulKr6rsKRp
	 Av9aTTa/EfasK2hhuPbNZF70GD+XtnUMnnKUrRYRmdqHBTGPcYWks3GuM9g0nuFa8uumA
	 YHK03a0wsJMzN9ImUNxQosxNLMB9TtKY2tmVXatim7o43rBwz0VI6CcJdzJ4pqmWJr2na
	 C5d8v2j4m8VZDhizmb+FQZNmXQuo0LYEDSasg4zHjreXvcKse17UyIoGaOKBITSfNhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829348;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aOqnJuu3yEHxGEr/BN6z9y9lNkGET+xtjs8R3qPKYBs=;
	b=igrCb73vDBRsd33r2oZ/5YW4hJT/yU/6EChRfruzwtk1jAj1Nx9LfHx534S9xwZleA+v
	 YZmpi9/CrwfsCkfCkTA2ckUtWKHKRG2wOvJ+qjtDhSS0x9dPWblyZSYEKPBe+iVqJD3ZM
	 PD25YK2QbiSBqM2S0gUg8pDJElDgODBumMmeTKFzsVnwqnus5b+/qPuqgyv2xXuvxb8+R
	 zIllgwd+Am6eWwcO5BPuQWi9tI4qeQYpyyYc52sEfVpgWfw+cS/WB55VS7T3rFbYByHOm
	 HP0lC/0Cvjq/X1fVTV6xdtHuQhQ/g/OwiuLqE08+/5jjIszZxKLeUdeIOeQ6r9YwhsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mou8TZjE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314E86074930;
	Wed,  4 Nov 2026 21:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mou8TZjE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A911F00919;
	Wed,  4 Nov 2026 21:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829348;
	bh=aOqnJuu3yEHxGEr/BN6z9y9lNkGET+xtjs8R3qPKYBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mou8TZjEDNPd32ODHgVPwdOLL1xDtMBKo42uccPKRCqUqaBZqTWUgVz6QL1Pv9O9V
	 ddHyh1KL/s5dPALXyRtrfBgj+bvGarMgXOrekXNiRornWfXuvduVAyj58RlP2uPOJ1
	 APBdsIY3qBzA5cUpXoOqA/FK2r0i6Lx5al6QVc9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gangliang Xie <ganglxie@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0069/1005] drm/amdgpu: add check for xcp id
Date: Wed,  4 Nov 2026 15:56:42 -0500
Message-ID: <20261104211045.546507458@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gangliang Xie <ganglxie@amd.com>

[ Upstream commit fa1531170d2c96060478d697fe93f1cafc0e7ddd ]

check sel_xcp_id before its use

Signed-off-by: Gangliang Xie <ganglxie@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c
index 6059227c53150..88de3ecc7f230 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c
@@ -572,6 +572,9 @@ static void amdgpu_xcp_gpu_sched_update(struct amdgpu_device *adev,
 {
 	unsigned int *num_gpu_sched;
 
+	if (sel_xcp_id >= MAX_XCP || sel_xcp_id == AMDGPU_XCP_NO_PARTITION)
+		return;
+
 	num_gpu_sched = &adev->xcp_mgr->xcp[sel_xcp_id]
 			.gpu_sched[ring->funcs->type][ring->hw_prio].num_scheds;
 	adev->xcp_mgr->xcp[sel_xcp_id].gpu_sched[ring->funcs->type][ring->hw_prio]
-- 
2.53.0



