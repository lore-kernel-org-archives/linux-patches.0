Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328C01DFD9D;
	Wed,  6 Nov 2024 13:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898239; cv=none; b=m5XKUDdgc85XUjueqkJpq+EQhxoPBhkSMOvHEV7fDLzLjFgwXW+ZcU5zV/fHvM7Km9DwG+1f/NhWDlXlYi9SUO9G5dWlq1PONfoPTvJZnv1xnODFvsyoRl3kLnBDs7AerOf55k+haux748XcyK70JbnRLRl2Lo7LeZsJtORodbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898239; c=relaxed/simple;
	bh=YrAfItaFt/Zw0uzSLPpY+v9qxQVa9g0mh2UkeC9gRKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pQEzXw5QXdCO8YmdC6UKuEYSXp7r7Or5792ei8m/XNhMl36/GnHtV1Xby/95JFrNuedSI43sacjF7yO53cm7EeY9nwyTmK3xgRLSRN2FqhFs+zLqMZUG9bBxpASFEAAiiKKQO9IdizWMCaXh2M7iGawXRfnOhKG5PxutDNEOPPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TsxJorCr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TsxJorCr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0FEFC4CED3;
	Wed,  6 Nov 2024 13:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898239;
	bh=YrAfItaFt/Zw0uzSLPpY+v9qxQVa9g0mh2UkeC9gRKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TsxJorCr/ODA1U7ifLYzIH+gUEstJ2ieDG8m8ZOQnfSKzqBDTmIzemYjbZXNgvh1F
	 w/Jjg6I1MbvVFeyJuNcfVj2GJSpkbhlPo0AN3uImzLOBmYtSfn5PGq9VtsxwTUKf26
	 YIM7ZXcgJhafrH9zrPrdkx748THqpIZAj14wcANE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 5.4 171/462] i2c: isch: Add missed else
Date: Wed,  6 Nov 2024 13:01:04 +0100
Message-ID: <20241106120335.743774111@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


