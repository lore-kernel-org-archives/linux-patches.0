Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063714;
	b=e2y6kp62v/6qqCuvmnFX4Ve1J5Q7fOT40m8qlw3qoDZI0VHlMc6q1qUVVUhBD4rDCoIu
	 z57pU6/+hp75IggTpnQgyDP1yk3qFmTNG49XzlFZrC5vuxIwzkuuCNZMBgohKmO8tLBz5
	 u/2lNlV+UkJlIzdQhHSq2wVkulOtCjalhThDcDHNlxksEnYc0BRZeXLNIhzio8ClJVcMa
	 aY1FmFAgmJpM0KOuMWtwtHnWMO3jXJidpTRIBkFgXv8qIBOO9hC5ofLTSD6x9pr0uM/er
	 vnDr8LCwQ0/E0WULtQyhosUQb//sX7ykFfCv0yFHLibl/HBWZ5rmx0KIvbJ10Jfe9pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063714;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=YXKG+gIOz3BIUxepUecuNDh5g0lzlcNMdEYtmOUN4Mk=;
	b=BukUg7IxkMxwmYZp0z6kOfGrbY4qEg9/WRpiopb0lb1xq7SDcac/SR5SO6ZDVrkiM7lb
	 GvNo6AySfzO6SE3/OD8uD9ey4ybwqu9oMSsuJPyjtsnevxOUlG0mDDGWqVdkHhiaDB7E9
	 8ioO3TD7pZ+UEciT55N9oNkLGmPLaxRoqX63UEpR4qO/ete2ZaY44xHgg2tXDHjjbMVgo
	 tQ3bvV1xqPp8OFnh5t1LSf/7zclLGkMibBeupYAJAu9fsSU902GxjhfvEritu13oR0Wv9
	 KFHr9aHzGQmJZzFVVpwx7Pc7kkba44bDwXazPtSXqPVZms/uAEgFvHp1QhpieJOvJ/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ql9PsKwy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49CE4606A32E;
	Sat,  7 Nov 2026 15:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ql9PsKwy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDB2D1F0089F;
	Sat,  7 Nov 2026 15:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063714;
	bh=YXKG+gIOz3BIUxepUecuNDh5g0lzlcNMdEYtmOUN4Mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ql9PsKwyaezO8JY0EdUfh9dIdQ3Fe1lyJhLipqj3VCrks9GE7GZoUeZW9f2J7RKo0
	 G+i1dcwxnAitU7BJXwbQ+G8HQ+yQhg1ukABUTOG+DaQrJAjjdLgrijb16Rv6rKTEe9
	 J1LxaAXET9KnJvdlTk9YhWRs6cwsxy87CQimQ/Kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 815/869] drm/amdgpu: reject CS chunks too large for kvmalloc()
Date: Sat,  7 Nov 2026 08:58:17 -0500
Message-ID: <20261107134920.645095208@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f8a2c9e41ca31..efcd2322afa61 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -235,6 +235,12 @@ static int amdgpu_cs_pass1(struct amdgpu_cs_parser *p,
 
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



