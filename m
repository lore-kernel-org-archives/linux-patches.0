Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B1E337111;
	Fri, 17 Oct 2025 14:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713156; cv=none; b=mZFIUGuQ3a1w23PEBACZJMaf/HUzvbE98wb3cQirCmmNtE+YnfRAU4+zzyTcJLUTnJxpJr3NvkYe7gxUsGAspj1qPTpVoBMKPaQaawloO8dgaETjDsP0EzJWIzic34fjemRrXC9bLb2Rm7jRQJzRJlTTUbn2posVrei+3HhANT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713156; c=relaxed/simple;
	bh=s6thaIzg5p5A4r3x9uJktkJxbpbMCC8GCdOx86vGtpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IJt2dlpDc7dVXdg3YR82fnVM7QgGeMLzOdaBRClyDABuNVY4A6zPqXs/kLX0aKrZto2UvLHVpmBOXgu9sLJw1GMt0be6uNd1uHl+222NYG1wzozIJtSnWoUxeHCtsnYNzZObeGMeERYGcjKC2LFr+4KQ5DquaXD6eXIeYu7AO90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sfmz/4Dd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sfmz/4Dd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153D9C4CEFE;
	Fri, 17 Oct 2025 14:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713156;
	bh=s6thaIzg5p5A4r3x9uJktkJxbpbMCC8GCdOx86vGtpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sfmz/4DdgUObAIUR4sXtsMn1tuqsQc5Tqg4nr01XKuhc9jd04Ek2QlxTFcfC6d2S7
	 QQ6SGmyaKtq656TPaHIfzWGQ/62BAHlwB7xn8ccmasUWa5S2MsXfmsOKMNO7QEP0Iq
	 W7MfbIDaaU8Bo3yO7TkBlMTlpK0ciIOtIlde0UEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Vorel <pvorel@suse.cz>,
	Shuhao Fu <sfual@cse.ust.hk>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.1 068/168] drm/nouveau: fix bad ret code in nouveau_bo_move_prep
Date: Fri, 17 Oct 2025 16:52:27 +0200
Message-ID: <20251017145131.531405490@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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
@@ -791,7 +791,7 @@ done:
 		nvif_vmm_put(vmm, &old_mem->vma[1]);
 		nvif_vmm_put(vmm, &old_mem->vma[0]);
 	}
-	return 0;
+	return ret;
 }
 
 static int


