Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29EEA29A301;
	Mon, 13 Oct 2025 15:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369348; cv=none; b=RoTptQWJsVdgbcFeAqRGMZRPQm+aWXHTyf/7pBPsUndF8v1PSswMNNyXjpgMJxgX9Rf/VicONt7nd6yVsrv2mvGnKKSvcRzsSx5vs9QqiQDgV7Oj5uH6vU7v7K+M8FOn0qTnGnHTBD7ZuYmPg2qGZV9eh9M4VViHePdmvEiwMzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369348; c=relaxed/simple;
	bh=zHlbfeGax2Aal3ODVM6GGp2jDrzjduEzuUxXx+jXPCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cj9M7xvaR/Ht9bfXABWQaFuEuljBQiQel+vFU9Uuzl7YUhsJGKrMqouGX/EQb0Ph68zgFn6v1ODZ5s5m10nz4O7mJG7WCvCZdajwpC2KIybaE4VXe9baK5b4jDlJrKJrwmdwzds5i1H/c3CbdI+vrLSrzM7q3D8HmypJOW6+kgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F8uScBzW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F8uScBzW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE6EC4CEE7;
	Mon, 13 Oct 2025 15:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369347;
	bh=zHlbfeGax2Aal3ODVM6GGp2jDrzjduEzuUxXx+jXPCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F8uScBzW/26D8XJ6YbZyzI8oHMgnvbL03tSZ6L+D+2YVt+p9puafFLsT/8KGmZUFY
	 UZ0SI+9LteURkhRospFQG2h/HfyaTf0jOzHDbqgrjhfTKhurH9f0dQ6IZeGNndbKmx
	 JbobtURqYa1h+KBIkMSlXn+BsK2YKJP28Vmjo/1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 215/563] drm/vmwgfx: fix missing assignment to ts
Date: Mon, 13 Oct 2025 16:41:16 +0200
Message-ID: <20251013144419.072373835@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit 33f8f321e7aa7715ce19560801ee5223ba8b9a7d ]

The assignment to ts is missing on the call to ktime_to_timespec64.
Fix this by adding the missing assignment.

Fixes: db6a94b26354 ("drm/vmwgfx: Implement dma_fence_ops properly")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Reviewed-by: Ian Forbes <ian.forbes@broadcom.com>
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Link: https://lore.kernel.org/r/20250623223526.281398-1-colin.i.king@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
index c2294abbe7534..00be92da55097 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
@@ -538,7 +538,7 @@ static void vmw_event_fence_action_seq_passed(struct dma_fence *f,
 	if (likely(eaction->tv_sec != NULL)) {
 		struct timespec64 ts;
 
-		ktime_to_timespec64(f->timestamp);
+		ts = ktime_to_timespec64(f->timestamp);
 		/* monotonic time, so no y2038 overflow */
 		*eaction->tv_sec = ts.tv_sec;
 		*eaction->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
-- 
2.51.0



