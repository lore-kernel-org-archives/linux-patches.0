Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7290F183CA6;
	Mon, 12 Aug 2024 16:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479716; cv=none; b=KcPC6IqCDmoWFHItngSqgARFY8wV4/lSKHjXI1E2dOXUiUSR59eanaBPD9EyDy2q5sZnVmfM9ouH2E+BcIhEfqe5KKBQy/NtiAt3FUDCt3Wq7fBb4jlNDLv+44yNJZWN/jJ7XCxFbJk+0fyI1N8FCdifehdWdhBiuTctwIyxQYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479716; c=relaxed/simple;
	bh=LtqAZCT64pSaQd6ArD5dUHE5Ew0Osp9NkGCLFZHQzDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RPpwNZCTikafGmxxomzVPNZ86octBXXA3xRxgyCL1JyrIQeNQYH9iOPJMctRyS/fvlq10K7iL0AGRLkZAqiaSiwOaYcUDJ62zv62glaL/q9fbOS94TvDdDr4lrfbi3G2BPlf58mZisw8iXNNt28BL0B597TNgYutc/1cKEgcpms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GyRU8Pli; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GyRU8Pli"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78190C32782;
	Mon, 12 Aug 2024 16:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479716;
	bh=LtqAZCT64pSaQd6ArD5dUHE5Ew0Osp9NkGCLFZHQzDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GyRU8PlikmDjYaiYZwWuvtLbZlkMaZ9vnzIaw02ofn5cu2BsfFcm6uR5Dh+Wih0Vs
	 vPq2mcIqpOGZryvatAi9GdDu7QNcFiNsVKIDDEPzAREj0i4MV755PzhiQ7VAgMbZdE
	 cipUVZfESl9Uce2dwCpZ/HTJRy5Up4TZJwI3rrbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Matthieu Baerts <matttbe@kernel.org>
Subject: [PATCH 6.6 171/189] block: use the right type for stub rq_integrity_vec()
Date: Mon, 12 Aug 2024 18:03:47 +0200
Message-ID: <20240812160138.728379271@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jens Axboe <axboe@kernel.dk>

commit 69b6517687a4b1fb250bd8c9c193a0a304c8ba17 upstream.

For !CONFIG_BLK_DEV_INTEGRITY, rq_integrity_vec() wasn't updated
properly. Fix it up.

Fixes: cf546dd289e0 ("block: change rq_integrity_vec to respect the iterator")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: Matthieu Baerts <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/blk-integrity.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/blk-integrity.h
+++ b/include/linux/blk-integrity.h
@@ -175,7 +175,7 @@ static inline int blk_integrity_rq(struc
 	return 0;
 }
 
-static inline struct bio_vec *rq_integrity_vec(struct request *rq)
+static inline struct bio_vec rq_integrity_vec(struct request *rq)
 {
 	/* the optimizer will remove all calls to this function */
 	return (struct bio_vec){ };


