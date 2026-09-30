Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8E6528423;
	Wed, 30 Sep 2026 17:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791066; cv=none; b=sZcde1wHpc2itdQ/eVGe5NMsXdcB/LVhOrtkPm8mrJKbDkkNN7TNIlF9Mq+44QwylwiQm5LCjwN5CKb4DGa9KyDvn0OrlyGNzEKN/JCwhsEa27Rg3sxTKfX4xTflIrsOIUphL7obN+wZ2c8+xsywToFRpCEKZu1Y7neJtgTToPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791066; c=relaxed/simple;
	bh=EZ1ZFwKu5KFFPIzAiISgl5DOQ1tRYJtDmMGuu6oA+/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Usl9vkvqGZD4x1L/LABLn0R4VDotA7HbwRjHCNkp1/fHzMdhwN8Ri5T7mm+Oe+RuA8387AYNecTxodAbUX/kgKe7d9I1+VcVXtF0nGwimLAMvMbRwVY8K7fD8AIaOHYsSQYZ2DVFCgeklJW5NsCyLNLkN5BY3uhpZ3lQWohOqvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f4+bimW+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f4+bimW+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 156581F000FF;
	Wed, 30 Sep 2026 17:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791065;
	bh=NNzdaXF76TQ73AD5vJYsLR6o2YALFNeWE4yKhTo6LLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f4+bimW+Yedxe1xjXiv8UbFgQ2J89cn0xsUKPHDPguqBPVDAJHBkyPFjqzVyg+TIR
	 YvSwYJfXvfxIyQyu9GwplkpWavPG0hRmuU9/MYGHU9uvV+TTyX4bfVjFqoMph40O0Q
	 hgviJmIH1XAHEf/eaHf6g47pgYHOENkNL0wurCCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tommy Huang <tommy_huang@aspeedtech.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 170/752] rtc: aspeed: add AST2700 compatible
Date: Wed, 30 Sep 2026 17:20:40 +0200
Message-ID: <20260930152401.881188998@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



