Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9608E127E0A;
	Tue, 14 May 2024 11:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687216; cv=none; b=mcgDAf8fyP9jUYLdz8xFbMGfeC0Aq0VBsyiYVQWNbHNjYGyEv69B3SYlKg69W1gZVkr2mTS3jvSNG6WOvXaewY0mIX4g4nK/P/jUKynkv0mGK/4zjy8UTPbcXG03bDp0lEaIIcTcQSbe6wIm9TQwznFsO6sJGsJkYx/h3Fn252c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687216; c=relaxed/simple;
	bh=xDfaiYxC16/83zoKmNBxCj8ReiFqWAin6zxqvR28AnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T0yDJ5Qjj3BPiq3e0ucrinXTQ1JlhmLe6mwpvN5WrZR7Xt/YgLJGSBzxbIEAsFcYAOahOjQd/TF87qVi0QnRY447v3H72Gn8oxa2C+eUHyXdbBbD7Igc5Z9dvhJmRREHL1KvUgP8cR8jROPjG6rfS6ic9XfnlnDIvIagU/cUbh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NBFdeEhY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NBFdeEhY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5935C2BD10;
	Tue, 14 May 2024 11:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687216;
	bh=xDfaiYxC16/83zoKmNBxCj8ReiFqWAin6zxqvR28AnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NBFdeEhYq25+sOI0q9+Up1h+q0ZI5enhDmLAWLwmylyKnfubtRBIc4ZFlQ5xaJgTW
	 TXJVW1Sj0sZOhTI+pNl9kB4bBoZJ3/tdSP1V4LeVaIxYlwEY51/E5ODW8LuPauOlWh
	 31wQAQg8MWQ869oARhmXtX1Ysrs9YBIZFvaQcwWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	karthikeyan <karthikeyan@linumiz.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 002/111] dmaengine: Revert "dmaengine: pl330: issue_pending waits until WFP state"
Date: Tue, 14 May 2024 12:19:00 +0200
Message-ID: <20240514100957.213243447@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c71b5c8255217..627aa9e9bc12a 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -1053,9 +1053,6 @@ static bool _trigger(struct pl330_thread *thrd)
 
 	thrd->req_running = idx;
 
-	if (desc->rqtype == DMA_MEM_TO_DEV || desc->rqtype == DMA_DEV_TO_MEM)
-		UNTIL(thrd, PL330_STATE_WFP);
-
 	return true;
 }
 
-- 
2.43.0



