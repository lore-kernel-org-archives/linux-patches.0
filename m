Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05CDE1974F4;
	Wed,  2 Oct 2024 14:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880639; cv=none; b=rKpdLkY3SzjBhBDArdzzv/jyTNaPmEai6hc91zJj3w1y7fPynAYO/dDUloCiNl4mDQNcDgTXpFgCa1a1RjDiw3IxhnJooCkMW1VNiUGBolh9/M4CjpTU6fwO10HpL31x8eh2HI31APacQvcdxOFTp43fZaPfcCxcuH/09YW6IjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880639; c=relaxed/simple;
	bh=7Gw/42R4Q3juiE2KAiv40obafpQcycxvXexS0isiYYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nBUIx3oRYSz7IMhdrVOV63QN2TPY+dmm6C6tSsdyX75SNCOE7gxoCqqRO6hkEljVUsnYzFtBheMVS7hNC7INU0QLM7ln4bCu+tc+WXfXgWCdH5fQhicChSjVNPHJh6EPR9xhTx03mBS2A3moQV61CHtQaqAjyJ2vqIIxlCi9d5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z65byMCe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z65byMCe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8256AC4AF0B;
	Wed,  2 Oct 2024 14:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880638;
	bh=7Gw/42R4Q3juiE2KAiv40obafpQcycxvXexS0isiYYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z65byMCeU6J/9HnK9csP2rsQYznc2HGXQGZSYPP2BBpPhOYq63F7dJpoIqPNiDYJW
	 KAIg9woJh6kEhWScjFtjLZDE2RAlM6v+pkzRgNKEvnNLsQTlPZGGYn65NYElrDaRM1
	 pa2O0BPJbnYZqTirPfO26GfZDn8VKEVAyUjovKwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.6 527/538] i2c: isch: Add missed else
Date: Wed,  2 Oct 2024 15:02:46 +0200
Message-ID: <20241002125813.248281125@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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


