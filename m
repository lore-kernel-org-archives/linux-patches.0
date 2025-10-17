Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B291337118;
	Fri, 17 Oct 2025 15:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713693; cv=none; b=vFN0oy/eojtM52dyH+grFHdR7djprUEBk98qN591Fr1YIy/aRL2Fsez4ilynBZDCSSLNGbBZKqzbesi+9JluGFcrYqh+GJJoJlKFQLKSBLPypaD3159j6w5TXFEHQBO/GaXAnx/FKFKJ+E/kBfGjEC5h3XyHXHUA03GiEwJlKsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713693; c=relaxed/simple;
	bh=vo8j8CiAgiN4LQUui7iHlW+9c3puLJfje3lO+7fY1Kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YUfHqDW7q3Js8TvRGsD+K4M1ckexeKQ7uHI+FKzR3SkFvBELnM8sC8PIU7Giyeg1qY7tA6n5U0SxZad9PpoenKEBrnp/N612NLSyT/H3azh7tHyr8KGb2QI/k3DpJ3eW23dbpu2hhF97c/uPFF3XfEWZ4qXGk78v3wQbQQex0vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dUTby7tY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dUTby7tY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25978C4CEF9;
	Fri, 17 Oct 2025 15:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713692;
	bh=vo8j8CiAgiN4LQUui7iHlW+9c3puLJfje3lO+7fY1Kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dUTby7tYGXMcn8cPEZ2/Pr5/Zdn8V/ClX2js/DrbBW8xo4pnxB1SohvIbhvrbmd6D
	 eh7wzDClUMmI4BKi2B1sTOsHN5begOgifmwq8VAhbGbmhx4fwKnm9p7SyTEGbVSjpT
	 QgEYA4wUw2pomjl+DfXhETszvKs6UkcWaByFfItI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Vorel <pvorel@suse.cz>,
	Shuhao Fu <sfual@cse.ust.hk>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.6 079/201] drm/nouveau: fix bad ret code in nouveau_bo_move_prep
Date: Fri, 17 Oct 2025 16:52:20 +0200
Message-ID: <20251017145137.658408961@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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
@@ -836,7 +836,7 @@ done:
 		nvif_vmm_put(vmm, &old_mem->vma[1]);
 		nvif_vmm_put(vmm, &old_mem->vma[0]);
 	}
-	return 0;
+	return ret;
 }
 
 static int


