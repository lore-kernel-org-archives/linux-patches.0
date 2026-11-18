Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058504;
	b=2TyxjypqOQa1bl9Ytii16QUat6ATy+TiHY7hyYWyixrFTtCv++T30Eleeftq0FrTvRAQ
	 GDk+CU7Nmnujvd2gHYbWa44RtU6DEsxPv49J8JH3E16W0yAnXT59Po21VlRt8sDjvE2m6
	 SbFQTcfA9wjaacy1MjDDSGM/acflBmrBii8iVBoAKknKQENV23RQUmbqEiw6Dt3d+WcPp
	 WVL/9XS67+uJ5WpclM2Fr9vPYkQ9trXDGe0bExZF5tQHqwK7ru0BV/akmIsPfYvbm774q
	 qs0KtGKTU6AETpXcuyD+olaVmeVrdrxnZHtQxwChoYabm+bAQ3g/+w8b1ZT4GR1GjPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058504;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kzyX2gGfnUpEIkSUU8uEBaOZY1WPLJTvWhd+BcxoPE8=;
	b=DCyqxwCEKx2lYbfdGU3z/67lnWYCb04i1MQnF//l9r8pnRyRj208+wVM3j2sLweTEjHy
	 0E3zszahPXSKXUPtCgoSFYHLRrsmjKAamWEiALkNYvipHI9Jg3GKwL2C/A1iKd+N71R8V
	 zgriH4tdTL0TSUj2G44SSYKbV5tK4NxmKL9hnrEDGFZgO5aMSAPcLLHIsdCoWAmazSNeb
	 rilA8c8GmmTkLq7T68ANkoM1b/3H00uZTsqFM6L0AyM38oZaO1SVEoSVAu2AIg8o5TAjQ
	 8x9wPnWkXZTYihMmKaY4gdOg/eqVxz7gHH18XvPGXjNBA1KYsohVvpYnq7tMIT9GjUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zCkDc4uj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662AA606A32C;
	Thu, 19 Nov 2026 03:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zCkDc4uj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806F21F000C4;
	Thu, 19 Nov 2026 03:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058504;
	bh=kzyX2gGfnUpEIkSUU8uEBaOZY1WPLJTvWhd+BcxoPE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zCkDc4ujNM6bTBNGJVQL+30fPm6HfjIaSr4/4SBNNferEdLL0XtfelfMDyI4IjUhf
	 OOV1AviAGxs0GpbpNlRBGOJnFTFR71RbeeONPZkxeZG5oPSQxGNzY25RRnqiFPuSt6
	 sj30AcO37QRxxTeKhvPoLlKuAbRLbn6luUA8KHGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0509/1848] nvme-rdma: dont complete a request after a bogus remote invalidation
Date: Wed, 18 Nov 2026 15:42:27 +0100
Message-ID: <20261118145936.059510384@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

[ Upstream commit 909307cea08aff4e486cdb7491de5c76a2c31341 ]

When a remote invalidation names an rkey that is not the one we handed out
for this request, nvme_rdma_process_nvme_rsp() logs and schedules error
recovery, then falls through to nvme_rdma_end_request().  The request is
completed with req->mr never invalidated, and nvme_rdma_unmap_data() hands
it back with ib_mr_pool_put(), which only puts it on a list.  The rkey
stays valid and still maps the pages the completed read filled, so a
controller that sent the bogus invalidation can write into those pages
after pread() has returned.

Return instead, the way the local invalidation path below already does,
and leave the request for error recovery to cancel.

Fixes: 3ef0279bb0031 ("nvme-rdma: Check remotely invalidated rkey matches our expected rkey")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/rdma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 824d4c088646a..0ea3b6ed9ab9f 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1773,6 +1773,7 @@ static void nvme_rdma_process_nvme_rsp(struct nvme_rdma_queue *queue,
 				"Bogus remote invalidation for rkey %#x\n",
 				req->mr ? req->mr->rkey : 0);
 			nvme_rdma_error_recovery(queue->ctrl);
+			return;
 		}
 	} else if (req->mr) {
 		int ret;
-- 
2.53.0



