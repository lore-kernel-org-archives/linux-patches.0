Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038498;
	b=V0QIwvCvulz9CDWE2oPZ87ZxwwzCUnGqaGjM9vqxU4B1XzfuA27V7yHSM/yg85sjxcgJ
	 /Z2Pq20XNfo87mFkwXv4eedy/I/v26lFbAcj9aWGFzYnZhNXK+/vYTUV2Sim1ffkVOXK8
	 52DpyJQugirMvbLCidZ6+m7AZUpz1C6+47ajLZxaMLdqwS2JK+vvEa/rbmaN8CVDs+drF
	 Pf+ONpIR+nxBqsE1yEnxu1Ud1QmKFH4u7Qm3NaLA7CiqxEn39/MlMlJ+dE151TG39HpP3
	 Vces4eTmrywBMq2AtaXBuRkwe37vfqXRxuAj7n1TjKLNXQwhTf5E3ELsX5dGgujfvUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038498;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=rC+YGn5XKqt1qlBNVz5cHtRT6m+tdlOs00R8Nu8TpqI=;
	b=BFY27A9wbF87YutXlzBvCUO+OQ8XY513hcT1orAMFd9eoyb005kjRBc96NOkEwMl8t56
	 79dY6D1aUnB1Bc6mGukDfZ3bzIzYrSH8sxTTnnaksrgHz3V1TguWT3oqp23Zye+yt8pYS
	 BhLEbocZr2qhkZ0AOBKgCuRPHLYhuLcDHO+r/Eso/EEwuJ9tXU/MIhPin2rR8uBqF7+NK
	 2lYgtyvIp/wwn+OD26TYv35MLs44cXeip8erO7+29uLztK8jpGsEHbY/P3iSL4Wf1cnQA
	 2qcFImwYHjqJelK/SDRMhr2qz7rqPo+vUXe6xqtFb1KhqLkp5UXa4jpnpxXKC/q6yIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sh6pm9Ks;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E5D606A333;
	Wed, 18 Nov 2026 21:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sh6pm9Ks
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 702A11F000C9;
	Wed, 18 Nov 2026 21:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038498;
	bh=rC+YGn5XKqt1qlBNVz5cHtRT6m+tdlOs00R8Nu8TpqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sh6pm9KsISHqLm0cXcHYYAH02++eVv07t8TkT1brEyGbHVV0J7XCQZV+A5ZShs2Zf
	 AjGIK+sZrA/Q94JwuvYE97xrUjcFrJc0RIF15VSyi0g8v+vs/fViEoCaiICsTZMOFa
	 RuzuLBgn2Hj1aeudkcKQ9y0JEoFtB6Kc0TQJzjZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1764/3318] drm/amdgpu: reject CS chunks too large for kvmalloc()
Date: Wed, 18 Nov 2026 15:39:46 +0100
Message-ID: <20261118150414.773759193@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d43bdd14ed4da..99de46eda59be 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -238,6 +238,12 @@ static int amdgpu_cs_pass1(struct amdgpu_cs_parser *p,
 
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



