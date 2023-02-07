Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766532C9C
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:07:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDE24C4339C;
	Tue,  7 Feb 2023 13:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775273;
	bh=XCawbP+v4dVHOdk/ZSjwrhu3RVUsOBkys5F1aqwCRuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z3ZOGztUzdypg+QijmbLg4VDl8DDKfkMpPTm8x+eaNj57k8CYhG0g4OkfJNMHc6C/
	 dvPOn1Ob9/glTiCCrP41pXgq8/0owCPJzel+jdCCF+ESKSrKDnUoznfh6tUQ7IZ0lW
	 m13xkGWUp7/Z0SaGUtgcCoXoCGd4iZ2YpcW/Fge0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Danilo Krummrich <dakr@redhat.com>
Subject: [PATCH 6.1 177/208] dma-buf: actually set signaling bit for private stub fences
Date: Tue,  7 Feb 2023 13:57:11 +0100
Message-Id: <20230207125642.469479500@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Danilo Krummrich <dakr@redhat.com>

commit d2ceea0eb6e17bb37d8b85cb4c16797c0d683d1c upstream.

In dma_fence_allocate_private_stub() set the signaling bit of the newly
allocated private stub fence rather than the signaling bit of the
shared dma_fence_stub.

Cc: <stable@vger.kernel.org> # v6.1
Fixes: c85d00d4fd8b ("dma-buf: set signaling bit for the stub fence")
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Danilo Krummrich <dakr@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230126002844.339593-1-dakr@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma-buf/dma-fence.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma-buf/dma-fence.c b/drivers/dma-buf/dma-fence.c
index 406b4e26f538..0de0482cd36e 100644
--- a/drivers/dma-buf/dma-fence.c
+++ b/drivers/dma-buf/dma-fence.c
@@ -167,7 +167,7 @@ struct dma_fence *dma_fence_allocate_private_stub(void)
 		       0, 0);
 
 	set_bit(DMA_FENCE_FLAG_ENABLE_SIGNAL_BIT,
-		&dma_fence_stub.flags);
+		&fence->flags);
 
 	dma_fence_signal(fence);
 
-- 
2.39.1



