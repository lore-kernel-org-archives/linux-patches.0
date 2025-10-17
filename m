Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A48D32C944;
	Fri, 17 Oct 2025 15:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715370; cv=none; b=SLiHonstUv4n09/lYTDCdn8jhgftl/XrZueGX6PODhJ8PXCWgpcSuRItcdcABU13jxxO/sPJP3pM/4c4cAOojJnAtVQw/2cugbA+5J7m++lK273pBWnQ8k1Sn9S4o+IeXiYGlA+FZ/fYNDrsx+Na8N1aEdyK1Zi8nkqlvibZPe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715370; c=relaxed/simple;
	bh=/5iHVqXygcYIP8WDWYGlsTR2W2DOav2V1cdKZftV1Yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uarzz0uKXn2XtJoCGHgYkixjjIASCnc2+297IjtGf+GFH0CumZEtr9mIoCgNBLPpMzHWeogueqfyaZOdikyOFSCfec4H8x8LWJcyaIBXPafF5prcktbO82ipS47t+x5GZFEdBpoh1RNQCQQkcetu6rWyYlZG2TPluYsiFomPYqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cU6ynnsn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cU6ynnsn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80652C113D0;
	Fri, 17 Oct 2025 15:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715366;
	bh=/5iHVqXygcYIP8WDWYGlsTR2W2DOav2V1cdKZftV1Yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cU6ynnsnkOJmoBIsICxDeDfCpvU/rGZP5joWAv6L0vuV5GOQaEITywh5qNf7xkgeL
	 swVR/Koq12XgyCznagN5MbEl2wL0YfaOOKW00YnUOmL3sanoxeK3oVxhF0NgorZ1LJ
	 cIOlLOPuwgZ6d3ruqaRucgXo8s2MMhJsdcb9dDz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Vorel <pvorel@suse.cz>,
	Shuhao Fu <sfual@cse.ust.hk>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.17 190/371] drm/nouveau: fix bad ret code in nouveau_bo_move_prep
Date: Fri, 17 Oct 2025 16:52:45 +0200
Message-ID: <20251017145208.799451739@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuhao Fu <sfual@cse.ust.hk>

commit e4bea919584ff292c9156cf7d641a2ab3cbe27b0 upstream.

In `nouveau_bo_move_prep`, if `nouveau_mem_map` fails, an error code
should be returned. Currently, it returns zero even if vmm addr is not
correctly mapped.

Cc: stable@vger.kernel.org
Reviewed-by: Petr Vorel <pvorel@suse.cz>
Signed-off-by: Shuhao Fu <sfual@cse.ust.hk>
Fixes: 9ce523cc3bf2 ("drm/nouveau: separate buffer object backing memory from nvkm structures")
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_bo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -929,7 +929,7 @@ done:
 		nvif_vmm_put(vmm, &old_mem->vma[1]);
 		nvif_vmm_put(vmm, &old_mem->vma[0]);
 	}
-	return 0;
+	return ret;
 }
 
 static int


