Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE83958AC4;
	Tue, 14 May 2024 11:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686967; cv=none; b=DiatG3LTbbtz5zdhj4kBQN8nDsTHPaR+WGm6JnHLrbJCwQwCscn3BMWkTo+x+SG084IsrOs7Ps2xXcj4UFQiblBVhkm+YnopV6S8p60bmgdvv4YOfiS1p8g7qScLkB0rDUx9MvlzfC6ybsTcsB1Ty8lFySM4LJClTo2/H47+ED4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686967; c=relaxed/simple;
	bh=byHs1/VNlKrIUvzAvp0j5YOBTcUQ/s3ei8Qm0U/a2Kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C13HA9gfpbChkinK09B6Czjb8ttTW3qbdN/VWFUx19t7seX/90I7ca4UTFECB35aTfkJptHjgRr2XO1L8awOuvNpXFU564+fPPA/7EOq4pqE5NYKHWffZtvp7/nRqXDSyOsclg3QqsAf6u3+69BqJrZxP0Hadc4Z/th/WhBOulU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pHFmuPNY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pHFmuPNY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E3B3C2BD10;
	Tue, 14 May 2024 11:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686966;
	bh=byHs1/VNlKrIUvzAvp0j5YOBTcUQ/s3ei8Qm0U/a2Kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pHFmuPNYq9I6LKGTmR8u+KiRCM2ccPzqCF/wpeNno7n+q5NaHn6VzjtCR+ILjFza/
	 vSw1expnFHcGb2kJFh3eDUCx5DKkwetrPl5n1tPe2swsPT4/JqGewex1N9BqI0pAz/
	 FK9t0XzeAR9KMu+/fbn6CaDhV3ot/DIwNgYMlZ5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	karthikeyan <karthikeyan@linumiz.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 02/84] dmaengine: Revert "dmaengine: pl330: issue_pending waits until WFP state"
Date: Tue, 14 May 2024 12:19:13 +0200
Message-ID: <20240514100951.781540083@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index d12939c25a618..1d7d4b8d810a5 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -1051,9 +1051,6 @@ static bool _trigger(struct pl330_thread *thrd)
 
 	thrd->req_running = idx;
 
-	if (desc->rqtype == DMA_MEM_TO_DEV || desc->rqtype == DMA_DEV_TO_MEM)
-		UNTIL(thrd, PL330_STATE_WFP);
-
 	return true;
 }
 
-- 
2.43.0



