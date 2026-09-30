Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6AC47A0DD;
	Wed, 30 Sep 2026 16:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784612; cv=none; b=eStY4/8j1YMmLLo1kNbOCv4U1Obv8oJDOja9onJX1wNWT7VQ99k4mXDYNe4tsuGuOS7rcASyvf04S9XraWNPtU5fokP7LJgMii6DGC2pJzpM/M0UW1LZiivwllz4fttEcxOIPtCy8A+M8jlXzLcd1CrnINNumM4+xGAAl0bwX0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784612; c=relaxed/simple;
	bh=SYLr2BW0VReSk/skWZdYX4xO2WNXmodd+tAWH5uExUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOyvUuRn3gjOkwI/zLHuMucYDASg0dKp473OobPrL3kZRgQQB3VA+MXkv7rsD6EYE1ozQuWVNCTD03Wuu4KGR9EripznzSFwRKhzGXyTtxqO/h7QVOwK4+W40Xb3pjJyo+NZjKn2peJpSksn8xx1jv1cGw5LnZTpeg/bZXGvyjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=waQ3teEq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="waQ3teEq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EBD81F00898;
	Wed, 30 Sep 2026 16:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784606;
	bh=tzYV4vBHOln/grr8Pu7eWrPT6WotPrEzY6cHsPvPhdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=waQ3teEquJQQHpJ4BRKQZXcqup7WaJboc4Xx50nvjwCxZlnKpeYvQ1s8/jlO+vHDz
	 rVWYL50PnYRgUg3JPwot6AhWZYlZFnO7S5X4/MVcnh2lvTklJkfXVNeAfnMyaqxy/f
	 96cjaYXtU55Y0iNp1o7BrbEJcMb4D12bA9QEtn10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tommy Huang <tommy_huang@aspeedtech.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 216/982] rtc: aspeed: add AST2700 compatible
Date: Wed, 30 Sep 2026 17:15:52 +0200
Message-ID: <20260930152421.447167860@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tommy Huang <tommy_huang@aspeedtech.com>

[ Upstream commit 3319cfeeb8c4047026f84df045c438f7bbd338a6 ]

Add support for matching the RTC controller on ASPEED AST2700 SoCs.

The AST2700 RTC controller is compatible with the existing ASPEED
RTC driver implementation.

Signed-off-by: Tommy Huang <tommy_huang@aspeedtech.com>
Link: https://patch.msgid.link/20260601-ast2700-rtc-v1-2-15d4ca46500a@aspeedtech.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-aspeed.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/rtc-aspeed.c b/drivers/rtc/rtc-aspeed.c
index a93352ed3aec9..4f5935b7f4a60 100644
--- a/drivers/rtc/rtc-aspeed.c
+++ b/drivers/rtc/rtc-aspeed.c
@@ -111,6 +111,7 @@ static const struct of_device_id aspeed_rtc_match[] = {
 	{ .compatible = "aspeed,ast2400-rtc", },
 	{ .compatible = "aspeed,ast2500-rtc", },
 	{ .compatible = "aspeed,ast2600-rtc", },
+	{ .compatible = "aspeed,ast2700-rtc", },
 	{}
 };
 MODULE_DEVICE_TABLE(of, aspeed_rtc_match);
-- 
2.53.0



