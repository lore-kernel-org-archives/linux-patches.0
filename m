Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3772EAEA;
	Fri, 24 Nov 2023 18:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K0rUpqf6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A9FDC433C8;
	Fri, 24 Nov 2023 18:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851526;
	bh=JQyKM60vkcLQxwONHXn7zEzSGRptwhmVSqmRcfD44WY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K0rUpqf6XhQtycujPmAsBTPiLBhpr9SUuIyEeAoDKVEmjEO7rvdh/7TSZnsujp92p
	 U6pZSS82oclSp4nIZYpxc6F4pAyeBzmu4nohigm6wOHmmKooAZr2f0civ5jsSgtmed
	 DomkUJbSH8KSP1blYj3woU2qu8cW9jld87zWsFQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.5 482/491] drm/amdgpu: fix error handling in amdgpu_bo_list_get()
Date: Fri, 24 Nov 2023 17:51:58 +0000
Message-ID: <20231124172039.112637337@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

commit 12f76050d8d4d10dab96333656b821bd4620d103 upstream.

We should not leak the pointer where we couldn't grab the reference
on to the caller because it can be that the error handling still
tries to put the reference then.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
@@ -179,6 +179,7 @@ int amdgpu_bo_list_get(struct amdgpu_fpr
 	}
 
 	rcu_read_unlock();
+	*result = NULL;
 	return -ENOENT;
 }
 


