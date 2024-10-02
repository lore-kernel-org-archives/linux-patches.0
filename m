Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1381D0499;
	Wed,  2 Oct 2024 14:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879083; cv=none; b=UF90XxUx+qYaoZHpACsSEc6Bo3PcxcFy0R5fjyg+9DR98OLZneL7pTxgofpiveOOiKyswzzUHDbuNFBio5dgj8KsHZ+aHPbiJdo8Ma0IQNMXDu1apu9kfwsMPJ8tvRlNxPl7tUnrbGRAr2BlENz3JvjuQTD299HPD0iMDDcz9as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879083; c=relaxed/simple;
	bh=SZhR+UMNEt8GNQY7TMOqhUck3dwLpIRIc7jp4/iDCIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PhzifgvvLgou5RGFRnlJFAbmanZnQswDIchlyh28uZPQ54Tx3whJlKNHsAZbUSo+5zyC4HQG1BGDaiq3bs90A897rxtNn0Jc7UD0RDZegnrcHct74PTMPtw/ThoIkZaQK4iASZGL2gQxhFuTulq8fm7fxCMzhGC0L097oJuDD2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wSGNRdFa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wSGNRdFa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD768C4CEC2;
	Wed,  2 Oct 2024 14:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879083;
	bh=SZhR+UMNEt8GNQY7TMOqhUck3dwLpIRIc7jp4/iDCIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wSGNRdFa26uekV+FMvcbnoypIP7hHvMslQZpPByClljgrNC9AdTG7RO/cxBGu1OZv
	 cImg4t7t2z6jHbMr7mCbPEgITkcB3KzkyBAy24FQPT6Iey55Lu7ny4evFWNMD15mQa
	 nGONtYAPYsKvUzBDWJn7GrJLGmylLzbfbKtQRxa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.10 632/634] i2c: isch: Add missed else
Date: Wed,  2 Oct 2024 15:02:12 +0200
Message-ID: <20241002125836.071279768@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 1db4da55070d6a2754efeb3743f5312fc32f5961 upstream.

In accordance with the existing comment and code analysis
it is quite likely that there is a missed 'else' when adapter
times out. Add it.

Fixes: 5bc1200852c3 ("i2c: Add Intel SCH SMBus support")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: <stable@vger.kernel.org> # v2.6.27+
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-isch.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/i2c/busses/i2c-isch.c
+++ b/drivers/i2c/busses/i2c-isch.c
@@ -99,8 +99,7 @@ static int sch_transaction(void)
 	if (retries > MAX_RETRIES) {
 		dev_err(&sch_adapter.dev, "SMBus Timeout!\n");
 		result = -ETIMEDOUT;
-	}
-	if (temp & 0x04) {
+	} else if (temp & 0x04) {
 		result = -EIO;
 		dev_dbg(&sch_adapter.dev, "Bus collision! SMBus may be "
 			"locked until next hard reset. (sorry!)\n");


