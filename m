Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401502857CD;
	Wed, 23 Apr 2025 15:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421265; cv=none; b=CA80XOJztgpi2tI3OihwYH16vQxp6YsPVL2kBR3lHUo5XuV46NggFN3z/zLT3RiizDOBGrYUzRcoTnd5RsT58cZsscBfgpGqGCIiOZgXaI+eMoGm1LUPsTDuAPJYNBypDiL0b2S22aIL/g4VjP137lzEaNJgsJejiCPbRvIBiJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421265; c=relaxed/simple;
	bh=hw0rKbF/vQbEdGpyYHsoA+rNFiYf9tQ4TTPDBrOmhf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TdoL8YJaMWH6lbikNC98Z0MsJ+IMeaATd94oHJDr8Zrl7SowLVaTLi7M3i1rK0D3Kz0nKHLga+eLdTwWqWCk9CWL5JXS0swMmMwuVs0jHL+GQHMiYNrZgZoP4wsIBzAukmG5yJB5bKRtvzon5c7dzzhUcjZj1T6ieCbVVBtY2Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AqhgRCaC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AqhgRCaC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623D9C4CEE2;
	Wed, 23 Apr 2025 15:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421264;
	bh=hw0rKbF/vQbEdGpyYHsoA+rNFiYf9tQ4TTPDBrOmhf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AqhgRCaC0DNAPM9Ge6DAJN+dtAJ8zvvq/esZI+7tGjNeVNCSiHfJuVKPynOzg3awc
	 y18Ss1MhkpbY5Ei3RY5YBWNJ5KHLMdywKOjgWwJi4X2BhrKYj2j25wGLG8Ev+z2acU
	 kpxnIvU/x88ZvlaErbSK+QY1ilLThwaqfYqeEWu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 6.12 206/223] block: remove rq_list_move
Date: Wed, 23 Apr 2025 16:44:38 +0200
Message-ID: <20250423142625.556877965@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit e8225ab15006fbcdb14cef426a0a54475292fbbc upstream.

Unused now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20241113152050.157179-4-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/blk-mq.h |   17 -----------------
 1 file changed, 17 deletions(-)

--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -270,23 +270,6 @@ static inline unsigned short req_get_iop
 #define rq_list_empty(list)	((list) == (struct request *) NULL)
 
 /**
- * rq_list_move() - move a struct request from one list to another
- * @src: The source list @rq is currently in
- * @dst: The destination list that @rq will be appended to
- * @rq: The request to move
- * @prev: The request preceding @rq in @src (NULL if @rq is the head)
- */
-static inline void rq_list_move(struct request **src, struct request **dst,
-				struct request *rq, struct request *prev)
-{
-	if (prev)
-		prev->rq_next = rq->rq_next;
-	else
-		*src = rq->rq_next;
-	rq_list_add(dst, rq);
-}
-
-/**
  * enum blk_eh_timer_return - How the timeout handler should proceed
  * @BLK_EH_DONE: The block driver completed the command or will complete it at
  *	a later time.


