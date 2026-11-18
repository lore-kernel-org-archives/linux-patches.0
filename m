Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036758;
	b=Dq7KJbBtKHkkf5ULFqUfqiqP4fM0kqL43NMUnCwE6VTVg27jqjuo6Ih3JYMUfV1160fv
	 mits+EJiAauMKMInvyuLV/N7aMVKX6rFTD8TV8PM5iWVnF17zXzOOHh2GjUNGeg2qiTVl
	 Bo0a4G7aS+rnaAmea12tcmxQqAz9BBBldrHRN0djKTv0A01wcrSIUDfwBuQQtSYE1+WB+
	 CoVpZ/xRsBFcBo1nqZKptcqSuYMl6XviND6XJzhnSvJ79am4zCkCyxzOapRS2WwRdNSCW
	 7MWJf2tGbi8DshrdXfG/9kz4dBdZyQOb78JzWADGg2MId9BPdAX+wr0zTV1+fkiRfwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036758;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=BjTd2bJvD2Vp2YQCEgyPOdic1I/1QyaivVHnUnhjtPw=;
	b=axuuZw/SnTI9Vxh5Jn60JmseiuaxrinPMG3+xzRL0BAjh526JYwLnTniZROge1zvoIWN
	 HLlfKlW1blgFYgH4SV3LXc0eytG4zqJkuzlMDDlyj28RFuWFPDBsLNU7gfO+pUcCaUx90
	 OVK0ti88a5q0DPXOXS06NeWqRHv0a0EE5LyiX0ouDxt3Nps4Zlrap6h2PKG081Wd951tF
	 6oNveL0BdiTvg4UtU9ssyZ+0IxEzo5oOo6wI00krB+emIb6hB1iN5jY0a8M8eWbj8FQnQ
	 t/PeJSIXVtxHuD/szs7KV35Zy2CmqBX6AXaaQaDrLwhFqAud8+MoSrIatnJfQYFkENw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H9MYFBh8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA193606A333;
	Wed, 18 Nov 2026 21:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H9MYFBh8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FAD61F000C4;
	Wed, 18 Nov 2026 21:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036757;
	bh=BjTd2bJvD2Vp2YQCEgyPOdic1I/1QyaivVHnUnhjtPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H9MYFBh84lekj6w5xbos8ikjs1MXBYafiwsshs/K359Ne4w4rvwvUMnTID+Qh0mY3
	 o4cfakNopfXbv/4rV9Bw2Cijsm/pgLH4HLedR+kpbMn7BLCr3XLnqXwOpmpJTWLa4w
	 2+W50nTcRnSEc5QDLigysTkKysc6G1rv+XW3TNHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Philip Yang <Philip.Yang@amd.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1173/3318] drm/amdgpu: reject ANONONLY userptrs that span multiple VMAs
Date: Wed, 18 Nov 2026 15:29:55 +0100
Message-ID: <20261118150355.319238956@linuxfoundation.org>
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

[ Upstream commit d577b68a854d0f590f480777249b041507d0708c ]

For AMDGPU_GEM_USERPTR_ANONONLY, amdgpu_ttm_tt_get_user_pages() only
checks the VMA at the start of the range for a backing file, and
amdgpu_hmm_range_get_pages() then faults in the whole range, across any
other VMAs. The check used to reject ranges ending beyond the first VMA
(vma->vm_end < end), which got lost when the code moved to HMM.

An ANONONLY userptr over one page of file-backed memory is rejected
with -EPERM, but one over an anonymous page followed by the same
file-backed page is accepted.

Restore the check and reject ANONONLY userptrs that cross more than one
VMA. The second userptr is now rejected too.

v2: reject ranges spanning multiple VMAs instead of walking every VMA
    (Christian)
v3: cast num_pages to u64 to avoid an overflow (Christian)

Fixes: 6826cb3b92a3 ("drm/amdgpu: support userptr cross VMAs case with HMM")
Cc: Christian König <christian.koenig@amd.com>
Cc: Philip Yang <Philip.Yang@amd.com>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Acked-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 75d753ed4704d5efc72164d9e546b2a282e42ae2)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
index 9016ff071d642..371c681edbd93 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -723,7 +723,8 @@ int amdgpu_ttm_tt_get_user_pages(struct amdgpu_bo *bo, struct page **pages,
 		goto out_unlock;
 	}
 	if (unlikely((gtt->userflags & AMDGPU_GEM_USERPTR_ANONONLY) &&
-		vma->vm_file)) {
+		     (vma->vm_file ||
+		      vma->vm_end < start + (u64)ttm->num_pages * PAGE_SIZE))) {
 		r = -EPERM;
 		goto out_unlock;
 	}
-- 
2.53.0



