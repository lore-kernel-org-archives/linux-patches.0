Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B390935EE6;
	Fri, 24 Nov 2023 19:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qrgEsKaf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E3FC433C8;
	Fri, 24 Nov 2023 19:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853713;
	bh=BSuZpnWrMHtLO053IOkHUxQsZ10DniIVUIjOQs88NBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qrgEsKafSnuo2rFQ3W0ZGKGEnEImyh4sZUiiHcx9dCsyy5YTPid90NEU2Lp0CxYxe
	 Utv25Yrzj9qXJke3WklA6C1Mr8BstO71jGoj2DVQCUNoBo7Kxnzmbwyt26DTK/oA/t
	 Wp9DqEo7GgfNgw6nIXg4m6xYdIF0QHvcQAYBdH3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 291/297] drm/amdgpu: fix error handling in amdgpu_bo_list_get()
Date: Fri, 24 Nov 2023 17:55:33 +0000
Message-ID: <20231124172010.295938777@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -178,6 +178,7 @@ int amdgpu_bo_list_get(struct amdgpu_fpr
 	}
 
 	rcu_read_unlock();
+	*result = NULL;
 	return -ENOENT;
 }
 


