Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50E635DA40;
	Sat, 12 Sep 2026 18:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237973; cv=none; b=iBURh5k+724Cger2Pm6g0SiBkaeTW7W5kHmR767X+XCrboMDd+ISU3IBtq7IaAcke0A9sg+H8Y1a97y772nt9I9kBdQjPMgEMJ155rT9h7vuOXDl34g4tKQP3ygLqd/kVAUTS2B4H6RkbJQ+gtsMBwqW85+meylIpUTDX8E/gQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237973; c=relaxed/simple;
	bh=qyCdLXnPpWRU9NRD+avhP5FUgvt/IRJA9rHXIq24a8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G/icfXNBmFPLZ8r6cEybAIN7HCcVKkzUvh2OxB0SKrlcmR2yeGF/b47hwMQ9qkfnI0otERnQZV566cpw8hqxLqgOcdc3s1/C0MpJKuYjj/ufAKnJlhQGmx9hHXBCcvFfsAqjdtIB5wscT41ec7nw/eOGHbS503si6TCX99shZdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UXEZso8d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UXEZso8d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E23E1F00893;
	Sat, 12 Sep 2026 18:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237972;
	bh=sgQw27fjJiHEWIM6B3Z6FVC0r5GEpViJm9Hn8ZWo3v0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UXEZso8dlsPI7Q79Q0/bgQpXFTs+BeE8vccyIeqNcxeWjtMJCF4S+pKd9XCZSSW8q
	 AfRzBI85tSecvE9txRVs0e84GhKTmgcN1Hm6HaFTMOYMRnSmYp5hMLU1DT/4tzeNpj
	 soS4RnaPuV33N4yZ+v7Z3EGQxudYnNZRoboaRLAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunil Khatri <sunil.khatri@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 368/935] drm/amdgpu: use AMDGPU_GPU_PAGE_SHIFT instead of PAGE_SHIFT
Date: Sat, 12 Sep 2026 08:56:38 +0200
Message-ID: <20260912065535.249190215@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2565,7 +2565,7 @@ int amdgpu_vm_bo_clear_mappings(struct a
 			after->start = eaddr + 1;
 			after->last = tmp->last;
 			after->offset = tmp->offset;
-			after->offset += (after->start - tmp->start) << PAGE_SHIFT;
+			after->offset += (after->start - tmp->start) << AMDGPU_GPU_PAGE_SHIFT;
 			after->flags = tmp->flags;
 			after->bo_va = tmp->bo_va;
 			list_add(&after->list, &tmp->bo_va->invalids);


