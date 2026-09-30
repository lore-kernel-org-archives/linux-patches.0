Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193F53CAA41;
	Wed, 30 Sep 2026 19:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795786; cv=none; b=XHX+T7qLDi6b1DkHn6z77L33P+BH9tHVxyNZpRVvJFpqpBupk941NcJ8Mu65UXuaOMGt8CeBKAiQntPl5o2HYDtjIa7vGwqOpzScfAWbiHEBW/TrmYlhL4jDCw+lTkifR/ITdfTP7Xk689+9CFuwYBm4gVC/KLNHHjrm+aOO1wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795786; c=relaxed/simple;
	bh=RCT9FxRkyb0BTGxm//Sy45lsGW/VRZyyE/NQX0rACH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UPgqimsHiTaj4rKSfM7a4j+U2UnBCJzZDNZr6rqGr3Yqk/D5jQJgaf3V3fdA12McKmarJYXCypCC6iI/ttv9Kh2hE6JaB18LP9GeI8sXduaWhvaPssvWGDD8FFAYpLLUOqkTvio2kefhZMU/i6qAQJ1mJRr9nCDa9i6CbKqKgfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b7xBR0HN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b7xBR0HN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 722CC1F000FF;
	Wed, 30 Sep 2026 19:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795785;
	bh=Rx14kwlOdl9uymtchnr/6WVqk+GGHfvoZ2STIsx1+nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b7xBR0HNsLOF402Z4xSON3ecHC487OWuESG9nZqr7z92qegui+Kp8P2GD8LIeXbmw
	 1ieLu7/Ck9WxcMkERHkE1xyBxmolVJZYFL9tUjRyPNBlUMAsYuszvf27aMomCU+YD7
	 HLHNc8WyIMg9YVTnwMMOUIh7w9azKAWK/l1vBAes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0683/1193] Revert "nvme-apple: Reset q->sq_tail during queue init"
Date: Wed, 30 Sep 2026 17:22:47 +0200
Message-ID: <20260930152449.421489517@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 85316d624f56573a6e278e1d8c10309f4fb6d2ae.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/apple.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
index 771c03fd850bc..0470941e38988 100644
--- a/drivers/nvme/host/apple.c
+++ b/drivers/nvme/host/apple.c
@@ -1023,7 +1023,6 @@ static void apple_nvme_init_queue(struct apple_nvme_queue *q)
 	unsigned int depth = apple_nvme_queue_depth(q);
 	struct apple_nvme *anv = queue_to_apple_nvme(q);
 
-	q->sq_tail = 0;
 	q->cq_head = 0;
 	q->cq_phase = 1;
 	if (anv->hw->has_lsq_nvmmu)
-- 
2.53.0



