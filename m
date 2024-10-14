Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F421A76A5;
	Mon, 14 Oct 2024 15:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918602; cv=none; b=ptxjYyn9UGFsEHl7+S41ByDlryVvEGdYDf3iXZHYQ0aNRSSeCwAuUq9hgbhOJLKMYmFsD4FKlJK+EAjxJa1ML0MenBkJJjZiZvKXY328t9Yxo4E62u9DEKA4Sbp0aIAxsP/hgHoSxq+wJ/W49FnfzBVAWuZ71UgBHD359HDGNCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918602; c=relaxed/simple;
	bh=hu305Lmu6rZpYMb4qBrKeDNfg9OE7pDJsbpk+Gmx4oQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q8D0Y5jgW0zU2+odW4/J2h+isa+64LCOh4w4ZNDdRk3xxZocE6RzsI64ty88Ecm40ufIlBp7GswOfq5nNu+WmavcBgEJavyTxhSft7a9y/Rjct4K9depgbQS7yQalzlaKe9kb33CkFSBs6UNfqrAtSVlge+mJqUoRope7Md4Qto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SUeCilhs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SUeCilhs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AEBDC4CEC3;
	Mon, 14 Oct 2024 15:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918602;
	bh=hu305Lmu6rZpYMb4qBrKeDNfg9OE7pDJsbpk+Gmx4oQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SUeCilhsN+ca9597ImeV8yYn+fD3zvRcSCtF0K+okW+0uTytcGbga4vpdmkTaGJ+E
	 s9M+/r8/LlO3svAee7y0qcSCs/2VZytkB+7brMcn4uqwq8dvDnNc/H/V38nVhCtdTq
	 iirgFv4EYeVZCwBFD4H7+K8zPBz+LYfoHAQYLyAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.1 369/798] i2c: isch: Add missed else
Date: Mon, 14 Oct 2024 16:15:23 +0200
Message-ID: <20241014141232.446336415@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


