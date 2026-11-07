Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065490;
	b=IRAeT0BfpOQRXJX7+1KbRax6thDThqBlze1lGlAEaoumHn9nNptdtQcbv1AilGY9SY38
	 dLzkkNl9sZC0WWhihYsdkjfjro3T38MDiS76Qj/JoyHCMFHy8MPe+VW7/jxkKsTB9laOs
	 +p4w5z6HWovfmW0tpAhHASMxHYLbVy85Tc8RLapwyqd8DoXZXUKTMIsyCV08hvKmIF+Hc
	 LoB4McWXboaOa8VRXoEiY7jTh6h8Jx9t4IicS7IY37LeSEgAKw2SBtyjU9il9xU/s2ymT
	 /Is+Fznmj399aVPsp3vzIYhvrZ9T6FWGjghwvbGQc6PYiykdkcmCMWxrHjK7D6EkCXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065490;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=mlkn+hy4YzHshxjWAHIfKBTKQRM16rgV9oBbVBS+A4U=;
	b=zXHVBwHto8mGzKEQ63C4ov204AEQRYe9Sh7qF2FXcnAVbXtr52v5AAE2uBMIlrteZtAX
	 tmuPne1YkgmZ22EPIZgmv99+R3XoKZSrPnd5RHjAjwd0o5VZDBFpiEAUmiHUP1VRiiyoP
	 ftYN+gaPxMPi3f7vhaxRD86q2XtyoExRHuJOb1gDUyDxx9e/BG9mY+XpCsm36vNVEySZ3
	 m2ru06rZroWx7qCAijekI2l9NP96TP9/36wQVZ81xCbsTz6YLE9VKNG2J6SCJIYmm6Eiv
	 jebsa4IcqrFICKqcuhzI9Cq2IcJEgPZiIiEyi+ZyC8z7a5LJ9eqr1u2XsDHb8fWgMhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kiNOflTN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A8F606D81A;
	Sat,  7 Nov 2026 15:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kiNOflTN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA691F008A5;
	Sat,  7 Nov 2026 15:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065489;
	bh=mlkn+hy4YzHshxjWAHIfKBTKQRM16rgV9oBbVBS+A4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kiNOflTNl0zqySqo5IC+VrdfoiYPVeejow+UWZ0M1xJ+jXwsLwZy+VHNmu33Y569Y
	 N1iLHFNanf8uCh18QIm4dJBrybtNK9tQro2EHjY8xvcDmhj5x85crfu5k5L+mfZv5I
	 TKzInGAWHUwthhJYcAZKJa/JC4zC/RDghWz7PTjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1181/1257] drm/amdgpu: reject CS chunks too large for kvmalloc()
Date: Sat,  7 Nov 2026 08:57:57 -0500
Message-ID: <20261107135011.791553911@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index ef8a61ce4b1d1..86a3dc3655b3c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -217,6 +217,12 @@ static int amdgpu_cs_pass1(struct amdgpu_cs_parser *p,
 
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



