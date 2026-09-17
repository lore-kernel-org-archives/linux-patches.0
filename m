Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296574D179C;
	Thu, 17 Sep 2026 17:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664682; cv=none; b=r1MB5OMeF/uDNvB276JqANHEDIURJ7zD1VtPdF9BfVnjHN2qcUfWkskEqjITq4xHYSiPuW50Utt6LOWy/EMICbmRqpiuC0NKRa0qV3MDPB3Sj/zAXUfeRQ+VC8bkYzcF0UBBwjudNgtjlwfuUgpOSYPbE2N/YDePFMfdFM+Tkhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664682; c=relaxed/simple;
	bh=yZzR2U/uJiH2odu1mAzM3Pu7ZnkjFIRwqwdSaZaDZ68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U79XKqx5nLebSvvAmq16xbEpLoyYnj47ipwJ+3ixDh4lBInBkduSrhgWnhPArT/B7I7YM+JsyZUeSNR2aOW/pORy8UJ3rd2ECub6a/w9ZWLJ3yqKTcLjEdB6XZbmPL4wOGeyoYVj8wan/tjttLgDGxal6MzoEtoFeDyMSWKVLDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NIRLt/sz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NIRLt/sz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D4C91F000FF;
	Thu, 17 Sep 2026 17:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664681;
	bh=7cTrFmLiKOSDkxp4Vu+FwmgZ8gEa+h3l48c3aDQl6RI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NIRLt/szMcOE4OEugCgRYmcvaN6sRqCzhCMDGN3DwxO0qpnhP3sl3l2H2Yqfs04Oe
	 QBSf3LS5peLMQG/Sg3+wRSDM17o0OR2rlXCDYjp8Zt+B8nLBf9gC0gUhwzsd+4AExZ
	 xFPWZGKgL6SRjPVq5VpIB4zzHi9KwAKGcqUNJ3/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tommy Huang <tommy_huang@aspeedtech.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0453/1250] rtc: aspeed: add AST2700 compatible
Date: Thu, 17 Sep 2026 16:04:08 +0100
Message-ID: <20260917151604.268510870@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



