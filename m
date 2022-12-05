Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE3B15C8A
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:41:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F105C433C1;
	Mon,  5 Dec 2022 19:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670269310;
	bh=owwtqy1m5iJqtn+nXCjWThumnG2cH3AQ+BOnJ2WpPBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lnSVACZP9pGW+ZFdI7kHWy2mP4CUFplz7MpnP4ZzqCFOCwyU0HnARieQZcmtVZ//4
	 8O4kOmZ2J6SIZIBjB7ALuKm5GqN97Ev6Ggw0YNT++thQONfXwdyFTrYxDvP6AeHHki
	 UG0iMRHEeeORKMJ2gXX3XVJfBtMkIPqn+zmrNNIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>
Subject: [PATCH 5.4 080/153] drm/amdgpu: always register an MMU notifier for userptr
Date: Mon,  5 Dec 2022 20:10:04 +0100
Message-Id: <20221205190811.020709877@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christian König <christian.koenig@amd.com>

commit b39df63b16b64a3af42695acb9bc567aad144776 upstream.

Since switching to HMM we always need that because we no longer grab
references to the pages.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
CC: stable@vger.kernel.org
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
@@ -329,11 +329,9 @@ int amdgpu_gem_userptr_ioctl(struct drm_
 	if (r)
 		goto release_object;
 
-	if (args->flags & AMDGPU_GEM_USERPTR_REGISTER) {
-		r = amdgpu_mn_register(bo, args->addr);
-		if (r)
-			goto release_object;
-	}
+	r = amdgpu_mn_register(bo, args->addr);
+	if (r)
+		goto release_object;
 
 	if (args->flags & AMDGPU_GEM_USERPTR_VALIDATE) {
 		r = amdgpu_ttm_tt_get_user_pages(bo, bo->tbo.ttm->pages);


