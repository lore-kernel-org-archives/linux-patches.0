Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5088547043;
	Thu, 17 Sep 2026 18:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668206; cv=none; b=pub7KQh66MRotnJaQNuSG+4ArIJmGBFdLslATe84pLMhMvWv402zIESRbHoR3Ce89EzNWeyCQdWT970IM2/G1exPQK2pMMtsO6Bt1Zimh1Gw1F7MPSucV64Ap/oJayHmModrF4hQCjEfKdmFFgNHJM0a3cWH/Sj48as7Oi0ZC6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668206; c=relaxed/simple;
	bh=cbztmoKRY3zS6ak8nZnnNs3UkLWjx5FOzQbQ7+8tZAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jq0ygmbZatMVYuyHBBL0h0ydm7KVlNq5U880lnzYYuRKDPTcaEXMFDpOuxdfPx4vKX7LNbSurPNK1j/5DeRZU1k/vMN37x/eFZFkIerNdrShy5WCXiLF/QO8JU0rjWztwk7ZHkCIA5UQ49ekVqnoAYeYakYEbOJbb8YnbgRbvIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M5YZ6Lal; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M5YZ6Lal"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A8111F000FF;
	Thu, 17 Sep 2026 18:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668204;
	bh=EG9mJYBMC+A8Ei7Hn0ua1iNiGrWlvPjCYE/cZDPFRkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M5YZ6LalRk6yMV/LUGMFC8p54BiUttzyo2pCSqtKrPSIQBOtw/zoojKpe7n5UPLMA
	 Mjz4FawNpUhzdY0ofrhjqY7npiRV3f/Z4Tzn7I8GrR2Pt57bnfyLpTWkiHxT6CU+tk
	 XSACHCYYKl5sxUNPdl/gbFpIXyGIh/USk79OS37E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tommy Huang <tommy_huang@aspeedtech.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0348/1102] rtc: aspeed: add AST2700 compatible
Date: Thu, 17 Sep 2026 16:04:51 +0100
Message-ID: <20260917151548.377716249@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 880b015eebaf7..361bf972a18d4 100644
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



