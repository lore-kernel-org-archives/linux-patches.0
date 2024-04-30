Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475F312C491;
	Tue, 30 Apr 2024 10:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474485; cv=none; b=QaOw6sT9VPIoVq53P5o5JrLb0lC5uAVXPy5gEh4OZoBrs6HcSRKQdQOPwQogbcnR0FWar1R1OcMlx217Teu7Dauy1ZM42T2iVD14UzLjKVITlJtVjhZr8y/WmjAKDHC59kRC+yvgu1Q1MRbWhuJ2Lfre2GR/7vlxuJDhA6+Egpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474485; c=relaxed/simple;
	bh=T2Wx+DhR0ZcqGJ+CotM70F0eV4N533MPxBANF+u3UWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K6m/P2HcktRTil9IiiJ2Q/dRx+JEZk57x7FwFMt+sQQWg2jl1O5lrM8NzBfSc+yHl1bdDO540+hHDzNG1DCaGhv7fcsvY+aaIHwkPojShAPgINegte9BhNvl/UXItz3EdHax6Z6K4lFe5og+EmP5iesfvXuVgrydPdnm2Mc391s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pRJgSE5d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pRJgSE5d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DCCAC2BBFC;
	Tue, 30 Apr 2024 10:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474484;
	bh=T2Wx+DhR0ZcqGJ+CotM70F0eV4N533MPxBANF+u3UWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pRJgSE5dacmG7A1fZpHyDdXxKnSVt3GBHDNDDOu+NCmaeFGhWeFpAyTex2BPtbYXv
	 PlKmfe0OpIIUXHc5r34VxjfDloUhu9HSO7HBrHO+yV9YU+6keptj1xJkZzdMHJO9pI
	 S8FWDXGh+m3d5/6xo5kXvUtKig08+8Da/YhsJ8kA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	karthikeyan <karthikeyan@linumiz.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.8 170/228] dmaengine: Revert "dmaengine: pl330: issue_pending waits until WFP state"
Date: Tue, 30 Apr 2024 12:39:08 +0200
Message-ID: <20240430103108.710408354@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinod Koul <vkoul@kernel.org>

commit afc89870ea677bd5a44516eb981f7a259b74280c upstream.

This reverts commit 22a9d9585812 ("dmaengine: pl330: issue_pending waits
until WFP state") as it seems to cause regression in pl330 driver.
Note the issue now exists in mainline so a fix to be done.

Cc: stable@vger.kernel.org
Reported-by: karthikeyan <karthikeyan@linumiz.com>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/pl330.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -1053,9 +1053,6 @@ static bool _trigger(struct pl330_thread
 
 	thrd->req_running = idx;
 
-	if (desc->rqtype == DMA_MEM_TO_DEV || desc->rqtype == DMA_DEV_TO_MEM)
-		UNTIL(thrd, PL330_STATE_WFP);
-
 	return true;
 }
 


