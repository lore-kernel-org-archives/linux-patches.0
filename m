Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617713;
	b=i5wb0CA+tV/zbwup2lhxaNJf6IfdGPJuxPGJsSvKFHWF5cIfDwA1/HubFkMrwfafuxqI
	 iAa+aoFH4s9K0wyQGvQShvmPFEuqJj2Ppz1XoZUKveqg/Nf2dTIncb5NXt/yz/WldbwWd
	 GKXeui/2Mb+mPjW/0L/okBeAjuwB1q9aPztetjydYHQKuZ/zaOJiCEeHFjrA1OeVY6Z3t
	 Sq0UIQKzHo6adu5arkVrGDedyqzM1vIoE0ahJVwmnxt81wgB/8YIa+A83XgBxVxaEJisQ
	 Ol61XReBZZo8IXPcsg3tL/jNVFOGLO1Q4+M/4/6INjZ0e/yFuDV6nvoiXbxAeSsi7rQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617713;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=aaCwltWca+LqguxDyACz3fZsWj3ppC4oImyoYr6L9sc=;
	b=iIfWpgo2aMHFJ9vghV6iKQU8HrqmU/r77Oh7oSxhUV5p9D7cZF+8lCYpfPkDKDfiBaFg
	 V0T/e1V9wWulkWd+TccmTdhqQWJ/jdTbOhIZDgBzhZ5ZwLPhaepon0C6BQYNe+kmxsuV0
	 etCRUNKBUcV+3oQr7ZSFpW9nOLBfDUHpKL/FWxNepO39xvu5NliVHDVlp/cYaextgLrDR
	 Wz+kF8He6qe7pYif+OyzTD8CnmXRizefhysNbiQlcc5G/DI1inwN8++2UIACLXO8UDwK2
	 3Te04KILrf9rb9XoCJ7G0fN15B62/z5kNEEuln4qjSeAZZqpF0GVAcNeyvBavY7xL3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W4E3MqNO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A594E606A31E;
	Wed, 25 Nov 2026 14:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W4E3MqNO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96B771F000C4;
	Wed, 25 Nov 2026 14:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617713;
	bh=aaCwltWca+LqguxDyACz3fZsWj3ppC4oImyoYr6L9sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W4E3MqNOVH+v/UtkCXJ4snes4kb/ulvZS9++jaC2D9KZu1W2SJzpoMZDaOw+Q8b4f
	 bJMeNQYqgH/q/yBoU9tFh3ivwqm6FE6RQHZIS1KhkNzG1BtDlNVtLC9jpAsSuyYK8T
	 F/t7GXIkDg9k2d94mMbUZaixhYgXzBy9tRZcrCgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"T.J. Mercier" <tjmercier@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0050/1005] dma-buf: validate the attachment before asserting its reservation lock
Date: Wed, 25 Nov 2026 15:23:08 +0100
Message-ID: <20261125143822.912001820@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Davidlohr Bueso <dave@stgolabs.net>

[ Upstream commit 6ce0c151d52f6741b6c04569e1886bc7837faa5d ]

dma_buf_phys_vec_to_sgt() asserts the reservation lock before its
NULL checks run. Validate first, then assert.

Fixes: 3aa31a8bb11e ("dma-buf: provide phys_vec to scatter-gather mapping routine")
Reviewed-by: T.J. Mercier <tjmercier@google.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Christian König <christian.koenig@amd.com>
Link: https://lore.kernel.org/r/20260928195850.1982569-2-dave@stgolabs.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/dma-buf-mapping.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma-buf/dma-buf-mapping.c b/drivers/dma-buf/dma-buf-mapping.c
index e1e9c93127b51..5167cda7ea216 100644
--- a/drivers/dma-buf/dma-buf-mapping.c
+++ b/drivers/dma-buf/dma-buf-mapping.c
@@ -111,12 +111,12 @@ struct sg_table *dma_buf_phys_vec_to_sgt(struct dma_buf_attachment *attach,
 	size_t i;
 	int ret;
 
-	dma_resv_assert_held(attach->dmabuf->resv);
-
 	if (WARN_ON(!attach || !attach->dmabuf || !provider))
 		/* This function is supposed to work on MMIO memory only */
 		return ERR_PTR(-EINVAL);
 
+	dma_resv_assert_held(attach->dmabuf->resv);
+
 	dma = kzalloc_obj(*dma);
 	if (!dma)
 		return ERR_PTR(-ENOMEM);
-- 
2.53.0



