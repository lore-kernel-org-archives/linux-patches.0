Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E61C12FB00;
	Tue, 14 May 2024 11:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686766; cv=none; b=iOvWrz6bzGFYBPySm9rszf9jvl+g1sLvfD4LdVYMA46yBSuaWTwY8GFaFuunNnT6psiKPD7NG+TlW8QzvtJnpMAM20wLNWJvCHgEmXHPI7E4q8XI/NpJyb27xZ/juy7j96OUlO7EOce6SSo6o9up2HpVnOlhE8cZKZEcGO/6jh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686766; c=relaxed/simple;
	bh=vk/CyTbKmxdlm6O6eLgrTXtLApGY/DkDoDKYBZn+fxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IaXYamgmOViylZ0RVZsbIOyOkA8NwQGhWWO0VP5UoW0p8bi4DfK/hTsE8ut8ZkAenFEtp24YMBMwvK7KCu9QR69suQsYExvJZw1qyms419U40E3UgcyKSFxXG/iFA4xt9HO/83ZkniazJiebnM6FTQ3A1NYDh9QG0AmzWky8i48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ClGuqfl7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ClGuqfl7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA14C2BD10;
	Tue, 14 May 2024 11:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686766;
	bh=vk/CyTbKmxdlm6O6eLgrTXtLApGY/DkDoDKYBZn+fxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ClGuqfl720YKV8EymbKMXnDy4FyPTNz8kMZzAZoE+3N5g1ptoG4Pgzx/oe7wi0m6G
	 iCh+mEXaUvMPFzN9mUkv5AIULoPiPrR5oqHI2tK/q9fTe/zIKBXUrd5W1G+8UyAo/l
	 0kTM9wP/CBVq7R2PfqKnPbocObt/5zZJnS18F6ZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	karthikeyan <karthikeyan@linumiz.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 02/63] dmaengine: Revert "dmaengine: pl330: issue_pending waits until WFP state"
Date: Tue, 14 May 2024 12:19:23 +0200
Message-ID: <20240514100948.105013586@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100948.010148088@linuxfoundation.org>
References: <20240514100948.010148088@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinod Koul <vkoul@kernel.org>

[ Upstream commit afc89870ea677bd5a44516eb981f7a259b74280c ]

This reverts commit 22a9d9585812 ("dmaengine: pl330: issue_pending waits
until WFP state") as it seems to cause regression in pl330 driver.
Note the issue now exists in mainline so a fix to be done.

Cc: stable@vger.kernel.org
Reported-by: karthikeyan <karthikeyan@linumiz.com>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/pl330.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 54bb6e46c1803..1bba1fa3a8096 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -1045,9 +1045,6 @@ static bool _trigger(struct pl330_thread *thrd)
 
 	thrd->req_running = idx;
 
-	if (desc->rqtype == DMA_MEM_TO_DEV || desc->rqtype == DMA_DEV_TO_MEM)
-		UNTIL(thrd, PL330_STATE_WFP);
-
 	return true;
 }
 
-- 
2.43.0



