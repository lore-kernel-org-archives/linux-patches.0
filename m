Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CCD8563FAC;
	Wed,  9 Sep 2026 14:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964478; cv=none; b=Ji/dI5Jazz1OJjlhPlcg+QakWsmcOg/llPQaLhW883p4Gm9Mi1+rsCi7eUVy+ivYYIIH8Ry8cSjh7e2TpD8c5kzq0sfh6moEC6O33xLVFNJQsAph4DIXR8wAEKAcuABQ5TZ9cXmKFLYFDofRlZZ27nMGmbfc3+HEuHktY5C7Hx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964478; c=relaxed/simple;
	bh=0tMaUD2HdIjfv+OW5rUXrM8pgSLVEmIaDFBxfFljGGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jlyytETd7gCyTH+Cs2jaziZj4E7LWJDxlDpwduBXOjvqxcvFHLGDh442OBtjACKcV8PFNvADrWTMfCCtpThjursizio6yi+oRk8gr4zaHLcfuBRKHEdFRn/sobPhB0picEemBEo85xNENuRXX2/gVAy4Q5xWsur5GAYMvx4g2bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I7v2cG8g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I7v2cG8g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 861111F00A3A;
	Wed,  9 Sep 2026 14:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964477;
	bh=C3MIFOoltEEEcbfj4JZszF14gG7W+2+Zk951uQ+yX/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I7v2cG8g3xpqbbz/aA5Kt8AapPjE2Wc5OHJKGOzlrm54Lru7G4HbDfSNHTdoR9ieC
	 bnGKMrRaIZvZFz2EmDqtjs2SecGX4Dk2K6394IzPzRz7f3g98Vlzi1Pa3FEG0AosaS
	 EHpt0HNpp3QPMepgrUQKNVQvBEig9WNXuocQTdOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunil Khatri <sunil.khatri@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 398/583] drm/amdgpu: use AMDGPU_GPU_PAGE_SHIFT instead of PAGE_SHIFT
Date: Wed,  9 Sep 2026 15:41:23 +0200
Message-ID: <20260909134251.786447099@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2054,7 +2054,7 @@ int amdgpu_vm_bo_clear_mappings(struct a
 			after->start = eaddr + 1;
 			after->last = tmp->last;
 			after->offset = tmp->offset;
-			after->offset += (after->start - tmp->start) << PAGE_SHIFT;
+			after->offset += (after->start - tmp->start) << AMDGPU_GPU_PAGE_SHIFT;
 			after->flags = tmp->flags;
 			after->bo_va = tmp->bo_va;
 			list_add(&after->list, &tmp->bo_va->invalids);


