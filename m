Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5BC12FF89;
	Tue, 14 May 2024 10:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684291; cv=none; b=JtbxZjVAcuEYxQKUYoFhU4qXGduMAZlEiQATETfbTyD1RJT4HMfkRDtQd0fyyvQ+MO/Q2xDl5grgxQZZL5A6Bx6nEKjD95if3OpHrrAuHzHqigURmPzOOempo4NfJDYOxxYp08Q/sqN2COjR9I2gWpYH6arvpDkhc9jo+wKazqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684291; c=relaxed/simple;
	bh=kuYHP5LFTAZOGnhFliieZVx8PdM9NLfkXSILOLQptvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k2Ek0mhC5Jor7/hHXleCLJ256GTf+J6IpEPWHBqibE+MpFwGrsO+5NOJaDT8VcN8aVEVmAUR9BdfEy6KaZUyMsYCoO4z+GHC1n5tx3nNO6vddjoyFGbji4CAIzya/OvrCyc8fc3Qql/4FGy2z9VJIMa2Df1fLi88tu43m1+8grY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wKbAFB4q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wKbAFB4q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80646C2BD10;
	Tue, 14 May 2024 10:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684291;
	bh=kuYHP5LFTAZOGnhFliieZVx8PdM9NLfkXSILOLQptvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wKbAFB4qfIhWCS9nOPWOXD7kzZDGW4jGAAsS/0lldsrIpO5wKpy4a/J+3t46mxEsq
	 wxHnqwKm4+KXcgd4VjDTsBN90pqoxwL0X0CwJmtmVv9WVO01M6/Vg/BBPoOWVAhlB7
	 ixFNxtd20bt9L7DEs5vciUiJVS0VjDbTdiqgoWOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	karthikeyan <karthikeyan@linumiz.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 002/301] dmaengine: Revert "dmaengine: pl330: issue_pending waits until WFP state"
Date: Tue, 14 May 2024 12:14:33 +0200
Message-ID: <20240514101032.317202614@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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
index c29744bfdf2c2..3cf0b38387ae5 100644
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



