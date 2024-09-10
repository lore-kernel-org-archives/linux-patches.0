Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4388719580F;
	Tue, 10 Sep 2024 10:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964217; cv=none; b=RorwsIfrdUUlCcVxp+gQUHPT6d+1Q1g2oSZZaoN9J4s6/b5IXVGh+qCcUW6jVO6jkHrgkIFpk5zCItD8lEk6Ks6usdkzqLP38vjr+e81Chv7NzVabHJ425XDt9dAKJEhblVV8I47IhxZTRRFqFWvinBSdsEwQNgCOT9FlRdxvFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964217; c=relaxed/simple;
	bh=vEQ639ZcaQ54CvtMye6ul3tTBQjCretkIYttGr/EBjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oW0zSe5AyVGITi/FDjNqCdiK3oVStFgog4h6Dkf+XfGxLYRLdr+CkQ8bbkh4MlKUQ2QfaT2zGDBYsyWPDxJlngYTXNGLEJjXett0K9XbZNQ1vSA59ifpUOBUawXmJnCvOQDz8Lyq9RnZfTfguJrSAAtxqhM/5QjGnxAD6y3svgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=voIF0un3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="voIF0un3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB432C4CEC6;
	Tue, 10 Sep 2024 10:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964217;
	bh=vEQ639ZcaQ54CvtMye6ul3tTBQjCretkIYttGr/EBjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=voIF0un36Qnjdj1AIBXnRwjq7gt+XFqmFfPkHyi9Un/5I6ESOTzEE0h+IyWqjOl/h
	 YZcDCNMC9/PyCtbE/FkzeRfaZkxn0/mq7k2/lPe29G77Rl7C1OofjWwv98Juk8NllR
	 rmGRbe6FeSFjVNOo0I/Osq/tdG+BzuGI7zkAB8O4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Jocic <martin.jocic@kvaser.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 107/269] can: kvaser_pciefd: Remove unnecessary comment
Date: Tue, 10 Sep 2024 11:31:34 +0200
Message-ID: <20240910092612.017967646@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

From: Martin Jocic <martin.jocic@kvaser.com>

[ Upstream commit 11d186697ceb10b68c6a1fd505635346b1ccd055 ]

The code speaks for itself.

Signed-off-by: Martin Jocic <martin.jocic@kvaser.com>
Link: https://lore.kernel.org/all/20240614151524.2718287-4-martin.jocic@kvaser.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Stable-dep-of: dd885d90c047 ("can: kvaser_pciefd: Use a single write when releasing RX buffers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/kvaser_pciefd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/can/kvaser_pciefd.c b/drivers/net/can/kvaser_pciefd.c
index 076fc2f5b34b..00cfa23a8dcf 100644
--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -1641,7 +1641,6 @@ static irqreturn_t kvaser_pciefd_irq_handler(int irq, void *dev)
 		kvaser_pciefd_receive_irq(pcie);
 
 	for (i = 0; i < pcie->nr_channels; i++) {
-		/* Check that mask matches channel (i) IRQ mask */
 		if (board_irq & irq_mask->kcan_tx[i])
 			kvaser_pciefd_transmit_irq(pcie->can[i]);
 	}
-- 
2.43.0



