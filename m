Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115DC3382CB;
	Sat, 12 Sep 2026 19:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242199; cv=none; b=AAAcijL24B6AKD637NWvHucrzBPvT0I598yWFV1QMbBB21xWC1bT2nMK3C+IIlrUmPYbgDUKPs5YuzAYosAFafah4fnzXUtBRQ4JkcUXzADRTh1QAyN9SMEZpNzVmVigNSnTVzRelgYccb4SIe/yQk47mxqFhOi/obp8BEqXJP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242199; c=relaxed/simple;
	bh=P3UMeHDc7l1KMzdZF1S9flo0f/aNnbiS3DPwOrhX26Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t18IjsPRKwTmS2hl2cj1U9Hrc67fZN4xH81w5kxmOYkhQmHJ8FO3ikryBH5WPEGompB/n6JiIoy0zKAYrJYY3HPEo6tOXUwN20ORHqP0QW3dE+Bw5f0CTfKEfIODNHEGmNxRW1vYmCLbNy5lomuRV5d2RNg7R9YqTVMrvkmpBAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U4pFlQ5C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U4pFlQ5C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BDB81F000FF;
	Sat, 12 Sep 2026 19:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242198;
	bh=rdkkgsQS4pK4mpt+AYmFO4HqWx88cNmOAC/3NMdYsN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U4pFlQ5C2qh3qTQixsjBsioO0XCnOmVZ/oD4NE+a6sW0na+d53vI/4aTXDLpODPrY
	 +yKJeSNhatltdL7RU9CgNwsW73jYJcec/OWZotp7KpXS9kPtY5tDB08G1MeL2NJBWY
	 eXOWlbMebedYDO2Q1U5+nimljRLbRWeOfx/Pou2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunil Khatri <sunil.khatri@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 319/798] drm/amdgpu: use AMDGPU_GPU_PAGE_SHIFT instead of PAGE_SHIFT
Date: Sat, 12 Sep 2026 08:59:07 +0200
Message-ID: <20260912065524.473639086@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2461,7 +2461,7 @@ int amdgpu_vm_bo_clear_mappings(struct a
 			after->start = eaddr + 1;
 			after->last = tmp->last;
 			after->offset = tmp->offset;
-			after->offset += (after->start - tmp->start) << PAGE_SHIFT;
+			after->offset += (after->start - tmp->start) << AMDGPU_GPU_PAGE_SHIFT;
 			after->flags = tmp->flags;
 			after->bo_va = tmp->bo_va;
 			list_add(&after->list, &tmp->bo_va->invalids);


