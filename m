Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3AAC79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:55:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61058C433D7;
	Wed, 30 Nov 2022 18:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834557;
	bh=hBl+MQzg+vnQyk7oLpejZTMbi+ab51BURHBW7g1Q3Xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MHGF3HtKLluoVp6DCSfHQjeFytvMId7DM2cGZ1uVXvLvLoiHiuyLUnB8BaTjBTHvy
	 Rje7rqTLq1FKdghL2SdpeJtlg2RoPBazS1ffcVzHwu0aZvkHXxIjwuNxdJMPTEjaBu
	 1nmK9pn+2Nr5KYgeJnxKdB0iu7et5+TV6b68NZ/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>
Subject: [PATCH 6.0 287/289] drm/amdgpu: always register an MMU notifier for userptr
Date: Wed, 30 Nov 2022 19:24:32 +0100
Message-Id: <20221130180550.608594714@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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
@@ -413,11 +413,9 @@ int amdgpu_gem_userptr_ioctl(struct drm_
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


