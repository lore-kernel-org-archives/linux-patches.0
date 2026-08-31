Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F90A41A91C;
	Mon, 31 Aug 2026 13:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183579; cv=none; b=d+MwBM8ToT0JKDBAP1XgLH0J9Cg1EmD3A3GrxHI6Z7V3d1WFCvWADgO3FnIsQ4Bu05n5xzpuqyINB3AJI0AY9aG37UoqQCJFrYUkI8sp9MMrpncZHwBHpWg7Qp+0gBSvYMIkOuLmmEstUni5kxJxQtReT93IBYffsPy5JC31i/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183579; c=relaxed/simple;
	bh=DPLvSHbjotSuJbK8YHCku3HHyQrTt0DSvWXzMlFxmu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NT9tnTmCIO8+GZyHB9V0GfT3p1u5t5LJleKSiMSrd1ewKujeI4WzSgIRP/e5uIXnLGHUA/C2a9vYHzLvJ9ETS/xDl2LXIFwWTwev6emeVcCjV0ZzKw6TPcB0nDr+t5CVuSQ/q9nx5gH2gf7c2wnG8v7zSVxhcdJKvNLT4jTwLZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YcDWIs45; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YcDWIs45"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B35C11F00ACA;
	Mon, 31 Aug 2026 13:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183577;
	bh=POKu3l4J7SVpxZDF4dEniCQk73PmJkpAFR7IIuhZ9CM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YcDWIs45EMJ+xSjVT1oWgKlQ3Eml2bz7tt5ur3xZ9uQKd2CRI+Gh59b7er1BBQ3dB
	 /6fSRCtW3mDMyZ0gO66avsnGLOttUrEL0mEQ9RNSSDxxQIeHc0uwnBFJm+L6N6XVS/
	 /HylCMU+I/GGL+GxbvIkC5aOwHlzPJwdob4CmOgpnC68Ihk9qugD34snVD2V9jeiSc
	 gaRVZDoPPuAvYZg04vojQMD3uzksV3T2qLoXr0SJH3dmG1ubRWrbKSQ7qP0MCFimUZ
	 TGFqOT/sh9O/fR2gicIa2OSb+CCK4Ue+5eNJUSlBP1CvKAdStjW4GGwdQwHADBG/SF
	 o+5VGCoGZc2DA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tommy Huang <tommy_huang@aspeedtech.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>,
	joel@jms.id.au,
	andrew@codeconstruct.com.au,
	linux-rtc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-aspeed@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] rtc: aspeed: add AST2700 compatible
Date: Mon, 31 Aug 2026 09:23:27 -0400
Message-ID: <20260831133314.4125787-179-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

The background searches finished and match what the earlier analysis
used.

The `b4 dig` lookup on the real commit (`3319cfeeb8c40`) found the lore
thread and confirmed this is patch 2/2 of the AST2700 RTC series, with
`5e7f746bc106a` as the companion DT-binding patch.

The stable-branch history search shows 6.18.y already has substantial
AST2700/G7 bring-up (gpio, mfd, irqchip, reset, mailbox, clock
bindings), but not the RTC compatible or `ast2700-rtc` binding yet.

Verdict unchanged: **YES** for backport to this 6.18.y tree, ideally
together with the binding patch.

 drivers/rtc/rtc-aspeed.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/rtc-aspeed.c b/drivers/rtc/rtc-aspeed.c
index 0d0053b52f9b9..8f5b440f8c0a9 100644
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

