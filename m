Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997BD50AC30;
	Wed, 30 Sep 2026 15:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782721; cv=none; b=kc2G+iN9TDveurcqQ+S1GWT3nNM3eqg3D111mT40QAkZL//QjK0YrYOA9Q/lPXxClwyDFq15zozAsfqDGH+WC2mWo847/BsV2WqXWDa1NXMc3sKUtOgrYCXwG6OxBR2S7q/2GNrPQWDktFNBMOlnmKvrO8XkN8HNKsEoJg1x1CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782721; c=relaxed/simple;
	bh=4YAUDXMw39n0FTU0eZ04kF3zBev/A9P9AZ3wtYGnEQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iw91W8mSKlj3JUQlD4zuJzDZvVpOUPdyriZD54fxgt9xCnTKXH2qEJ69WCDcG1mDxFpB5RlAL8HrqSxrVc0fSMRT2gbey82aohSQCqzbVrwi9v9jEC8fiuKHf+t/EvL0M+n6AIcVkp0EIzmwK74Xzl3tRUDIH1sujV/dIGnEp5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CkQnHKxd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CkQnHKxd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79F411F00893;
	Wed, 30 Sep 2026 15:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782715;
	bh=j9ngipNkG4RsbUk9E3pBM96L4sQrYK8yp9H4a/jNtCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CkQnHKxdJ4Ckkzl7TMe2SrrunRYgMvs4PnP06INDLm1q4TPY6WwJ7bTnk+hbBM2iy
	 ZBY5zxLUFs7UxCoPLp2ufGHAD6vXspol3ENi91/GA/6c3gX3c3tpm+VpuqYoaE5p4W
	 HtLtdRyB7Nb1pw1MciJU+E8j4rulOMEmETXU3O5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tommy Huang <tommy_huang@aspeedtech.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 143/595] rtc: aspeed: add AST2700 compatible
Date: Wed, 30 Sep 2026 17:20:36 +0200
Message-ID: <20260930152350.809779971@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index eacdd0637cce2..ffa6f964b891c 100644
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



