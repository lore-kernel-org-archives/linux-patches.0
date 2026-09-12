Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F0124CEEA;
	Sat, 12 Sep 2026 14:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222127; cv=none; b=ChThSrqVUZ9SytAdAgvMvCXrTfMCPXKnD+ISJdKZah1oHv3pl6Hqs8nReKt9MYE8Cleze6KzMzOd5kcdjOKQGG8WrBRodzKgoRFgkqMsLa8yNL9bClRWLtw212/f19F7PtbwcxNV6HZe2nLj/hNs/n/yQqVajh8AwDEZ5AloCEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222127; c=relaxed/simple;
	bh=Pv/4YQcCBGCqbeujdmePvteJpoTA0gBGFWLGIh4Ggyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eln2LN87oGVOGBaTpcuffwYqnJl+3T/Cum0YSvYLzdGuvrhwOejzLClk2FaksRelHJyGgzQNvwqPWYTWtA/lAMG72rLuVbXTpT5AHo9S11jo/4+IpRmJ8ZQFP31m9GHfshHYByFQdRwphXaKV07YKF7RDTW9DJN1XaIkwAf4HUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RCIsaAXy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RCIsaAXy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A5A1F000FF;
	Sat, 12 Sep 2026 14:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222126;
	bh=LHsGaXiDwWZbgIkIsSguQOgR3sA7W7cR6pGdpfbGQIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RCIsaAXyEE1bw6zo4Fx0uFMN/JyPt5shf33S7EGLZEFkv4IEMG8V5sjW3jgAjpkor
	 GoyPuBu+ofYN3839MrnNrPm7kLE6kLW3ehEhA8V6DNzwo7qf3zIHqPQ7HPeJLcqLAp
	 nfbORPrLFhaWuBMvTLMenzdUOZWg0AbshgZVwy/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunil Khatri <sunil.khatri@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 0523/1424] drm/amdgpu: use AMDGPU_GPU_PAGE_SHIFT instead of PAGE_SHIFT
Date: Sat, 12 Sep 2026 08:49:15 +0200
Message-ID: <20260912065619.005646936@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1760,7 +1760,7 @@ int amdgpu_vm_bo_clear_mappings(struct a
 			after->start = eaddr + 1;
 			after->last = tmp->last;
 			after->offset = tmp->offset;
-			after->offset += (after->start - tmp->start) << PAGE_SHIFT;
+			after->offset += (after->start - tmp->start) << AMDGPU_GPU_PAGE_SHIFT;
 			after->flags = tmp->flags;
 			after->bo_va = tmp->bo_va;
 			list_add(&after->list, &tmp->bo_va->invalids);


