Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047090;
	b=pHwBGFxNXqCf0Wij/a+6ZZvEXpp5k8QSf2Hz7qh+gxsitAz5V2a1rUV5+ZJnyHqSMLXh
	 JPGDCP12/WBAHOcoVjjokqkUH86YUw1Wco8zhCNbZBZqTmAubvu6dBnUaG+8yfGzOcgqm
	 YrJ+pVeuRy1DuXCcImUnyKiGJRXIM5sCGdyLNTW/EQH7oOJadvnqNhFgtgxiydv6kHMVj
	 PlZ4n2eYCl4M5rHyeczpQv27RjDf1okyJFKYPcxUrniUtU/NUkqYZ7vSLnZVmKxIrHnzR
	 DHSoWIPHqZrL+W+yZQx5mjHi7sl8AJqQ7QMUC90DILwAHdwrD28lBYb8aL1FwokroFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047090;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=kXXnM1k2UHiLuSPga9h+hw1PSO3Aiyy770SQO+HxHg4=;
	b=lvHRn2bPoTxBpL+OZSTxIqHWcLL09Qpfb0eVt2wI9izZqwbne1/dyOnPvZf53xJ5TI4P
	 3AO/qHdex4iN9Cm1v70bzH46yMD6B4ERfF0w6Ser1LER3Ijor3aam36j5UOnzl8nR+yL7
	 W9kDW+q4MRZnPGWJMnOijBYRQ6vL1e3SH9I6NxejUKJrBjo29MV31QBxCY4xASwtMcn1D
	 ocZLBvxhw69tTh3UhB+lIkxBzW++2u85vXHpMGSWTsUyIO2EDGTPQUz1N0CN/lPH3+14s
	 dqw1x7HarQQAdzhwll/JIBczyCT/BwFQwF3wicTnIKjbpp0r4zsEJjvibT9e4kjWrDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xS2pyzdi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70EB4606A32A;
	Thu, 19 Nov 2026 00:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xS2pyzdi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7150B1F000C4;
	Thu, 19 Nov 2026 00:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047090;
	bh=kXXnM1k2UHiLuSPga9h+hw1PSO3Aiyy770SQO+HxHg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xS2pyzdiWntLmQHkC3o48elr2hOQkwW//A3uo+/NWJIsIRl3dyPbpR0jFwb1RN6i0
	 qBRFFbygEL3vKXxi/U3YuLtknf+Y1oTBs5z6MAG7/JdaPxkORrLVb9MdPE5rTYIdCL
	 83QLXsqMbioZ6AaCpWCy9OUUTWtkMwVxXPq+089E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1507/2857] drm/amdgpu: reject CS chunks too large for kvmalloc()
Date: Wed, 18 Nov 2026 15:42:21 +0100
Message-ID: <20261118150255.595240737@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Jesse Zhang <Jesse.Zhang@amd.com>

[ Upstream commit ba4c3c202919405f461a393e823e4b72c8518494 ]

The CS ioctl copies every chunk with vmemdup_array_user() before it
looks at it, for whatever length_dw userspace gives. kvmalloc() warns
about allocations above INT_MAX when called without __GFP_NOWARN, so any
process with the render node can trigger a warning. On navi31, a CS with
a chunk of length_dw 0x20000000 returns -ENOMEM after:

  WARNING: mm/slub.c:6841 at __kvmalloc_node_noprof+0x5a5/0x7d0

Reject such chunks with -EINVAL before trying to copy them.

Fixes: 2098105ec65c ("drm: drop drm_[cm]alloc* helpers")
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit dab5f5280406088591645f499f048dcfefab8d7d)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index 37782e2b6cf18..894989f453fff 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -227,6 +227,12 @@ static int amdgpu_cs_pass1(struct amdgpu_cs_parser *p,
 
 		size = p->chunks[i].length_dw;
 
+		if (size > INT_MAX / sizeof(uint32_t)) {
+			ret = -EINVAL;
+			i--;
+			goto free_partial_kdata;
+		}
+
 		p->chunks[i].kdata = vmemdup_array_user(u64_to_user_ptr(user_chunk.chunk_data),
 							size,
 							sizeof(uint32_t));
-- 
2.53.0



