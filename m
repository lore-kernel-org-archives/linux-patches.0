Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591535;
	b=kJdTQouuoglHQ2H+qY8zbnDvoTmxyp2yTEUhXYHh7D24oo+QS5+rOBRHUMp5r/MaqQdD
	 Lal2Do7kVSptSsvJ1qZ/22Ok5axUUSoblAVCsaAqAUYvp96nL5pehQCz2n1NIzIZzEYxr
	 nDlg8YMWTR0lwNlAzawuT1ousYjIuRfJ6xCpz25IfyupcMOBys1SD3BLdmBUY1TncelSR
	 at/c7yu0enUIhX2D4AQbWAuMUQuk48ljqnoszsXRemk2tTuF5ai4J+BR1GRICBfi72G0i
	 hyG5TCm37KwHdfx/QlKkrHMQ+kHeGQ1jI9VHVN9c/A4Q5/ItLjYE/lLWNqWe+3phjdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591535;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=8h2g+s0XDZfdWzUU7c8BFQD9eJ73T9ef3Gu8FH37uTg=;
	b=gIoEZpQGvOaboMGPrvEk142ED/n9ia5IEqDuN3qy41MmMqDlL2S22X4Ie7tTPoEmXnCH
	 u8QBWVSJmrangjP8vReYRF6kX6P1Sa4h0R6wfML3Eh1BS1zGnA4V5JGUM/sYWbBYq87em
	 YV41yve2Vika5izukzLfxA0hwDrWw1CBPCTO+7byg1eXTx0JEioV6iXYqYQ9oIoTEDFQs
	 f83cQhgLTQOC5NzNjfooh/KUXdB8/j8mbr4eL6DV6kQHMAKbe+qE/Ywx6fs1k2CdoygDV
	 LYRN9oTDu4CaKDUJjKWxZtXERB6r9AJbU+qMl3crVJVOv+98oWiCvE7BRZCH4Ktrk2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P3cd5Z1b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C49606D4B0;
	Fri, 13 Nov 2026 17:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P3cd5Z1b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A031F000C4;
	Fri, 13 Nov 2026 17:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591535;
	bh=8h2g+s0XDZfdWzUU7c8BFQD9eJ73T9ef3Gu8FH37uTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P3cd5Z1bfi3eS1e+AHSVCeAYr0GVXQTjGxhb3Mo8x1lYZxNPNTI5Ddxc8R/FtrZ11
	 A+jbj5jGEDXp8iArts/497NcNfezIQcDm3s19/eyh9GJjEDbJazR9JfA+n+e+ABhOr
	 Y1ZcmaZU8SUJWBLcgxNjo+RmzvIpGPfIrmvYB4do=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 590/670] drm/amdgpu: reject CS chunks too large for kvmalloc()
Date: Fri, 13 Nov 2026 10:52:34 -0500
Message-ID: <20261113153831.833436078@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index bb207ba59e752..c49aabb343a72 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -239,6 +239,12 @@ static int amdgpu_cs_pass1(struct amdgpu_cs_parser *p,
 
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



