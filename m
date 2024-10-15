Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56FF11C07FF;
	Tue, 15 Oct 2024 13:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997715; cv=none; b=h/JMo14EPn1vvTYYOzkc/MboBX3dF0X6mG5v3GYn+YzieekDGrZhYhxirM0oAmViJ09zAWVXleGDXR/mzJoDHboffctGpBKzd/wZ+/xbTTjq25Z2pSM+A6RqVGS4QC3SbY8CsLMUILdt/3I+COhy7LRwXWtQyFhGeksvdnIAGus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997715; c=relaxed/simple;
	bh=Z7vR9pkxJt+LO/pdMNFZ4vjasWthxb9vLT+cIWzvwL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X5WOSvcbfEa2PIIEVMSxS2RKxBTNRe5i8am+hzulciif1YKbfYiIr6VfOrTfknlIh4hQeQhPha1Kci3EXQhLYfMQp6oTZ0Xa3fBz4g78PMhK2dK7765dqt/a0AcrT9kAA6wQQxrV5n/z3dkvjUIsmpG0XJtMtR968PPyMtTvvoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v85f69rg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v85f69rg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9874C4CEC6;
	Tue, 15 Oct 2024 13:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997715;
	bh=Z7vR9pkxJt+LO/pdMNFZ4vjasWthxb9vLT+cIWzvwL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v85f69rg+1WHm3mClOH+Y2SxFlbtA66iLrLAOmeuHsRCTMVP+CkI6qbIb7d7j7yBS
	 wkv57iOTICtnUeiIAdRGByhXNvow3N0azQ4wVV/XWE3eQaHUbyqzlLkvZrUNyjqIJI
	 20TC4blCNezUjsMbMgDoPKnFb4196pPWwEuZNZgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 5.10 263/518] i2c: isch: Add missed else
Date: Tue, 15 Oct 2024 14:42:47 +0200
Message-ID: <20241015123927.144634135@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


