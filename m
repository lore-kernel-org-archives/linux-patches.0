Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD6F368D47;
	Sat, 12 Sep 2026 15:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228648; cv=none; b=IB+jsbuURtQ7HDM9+yDv9Z6WnnFs2moSk472HUPd9eKJVvkzgZlSSsTAW6FPbm+r1AnseMhN3JKVbKxQWL9yghjhm3+IFJOvRc5SUhHvZgCdaBZolQNxYvx6wQ0GieFjDzUS1WLbcMR/81vwCAOMNaNf/0Be3PiijBFolQK2t8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228648; c=relaxed/simple;
	bh=hTI3ORAWyjyViYVdO0mK0YwwClzCZxeyKHNIk7TbMCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gY8C/w2TA6yQMW9az+pm1iw2hr1jijxS7+dWRn03VaPJ8AZPF45Xv7Qxs7qDULym3YD81pRBPYXbXFJQqtZ9Q85aBb2qvOTlYjtBWV+gUJiRVum5/j2ZD+qb91iuKqUN3M+D/VYAZwyB+1AtNs/guZ4i+SQ364e7ILP5ST9UmZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gfUQ2RR/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gfUQ2RR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B92701F000FF;
	Sat, 12 Sep 2026 15:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228647;
	bh=OoJekDk0JFKCCXL6/mTiUQ/fNHnM1KK0jv/4RYTJWRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gfUQ2RR/h/x31PoaXCeBNgH7jnD7K2LTblZB8YcycZAN185qarYPa+a3sXbJ/mqV7
	 kO9JKS5Af+vxBQcixFg/+YkDSYuM6f4FhLBvSWxYHH37Dqizf5TX0PcKgVcK1ppHuz
	 GBiuuZNdylvIvGHH4xxUuMzqZDtVr8HLRHnqY65Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunil Khatri <sunil.khatri@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 0429/1191] drm/amdgpu: use AMDGPU_GPU_PAGE_SHIFT instead of PAGE_SHIFT
Date: Sat, 12 Sep 2026 08:52:37 +0200
Message-ID: <20260912065557.871336012@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sunil Khatri <sunil.khatri@amd.com>

commit d6e16df7df4d2c39e2b04b355d0434fb90e2d62c upstream.

For different address types the variable PAGE_SHIFT might
not work well and it's better to use the GPU specific one

Signed-off-by: Sunil Khatri <sunil.khatri@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 3494b77d10375e0f9ab784e9b20763339844b55b)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -1659,7 +1659,7 @@ int amdgpu_vm_bo_clear_mappings(struct a
 			after->start = eaddr + 1;
 			after->last = tmp->last;
 			after->offset = tmp->offset;
-			after->offset += (after->start - tmp->start) << PAGE_SHIFT;
+			after->offset += (after->start - tmp->start) << AMDGPU_GPU_PAGE_SHIFT;
 			after->flags = tmp->flags;
 			after->bo_va = tmp->bo_va;
 			list_add(&after->list, &tmp->bo_va->invalids);


