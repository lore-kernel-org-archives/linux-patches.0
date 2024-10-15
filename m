Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FC41D0492;
	Tue, 15 Oct 2024 11:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993298; cv=none; b=TvO4c3LVyO7Ge+vGmFcUfE1NsgC43Hi5qVkrXIc/etnapkA2rZxx/eE20Dft6TFuF+jDnMZZLOr7Pb9rd1PDWJBpkc7IykYVL2hePDK4Y3EgvOtKfb3lGW1NF/r4VhhoFiaKWaTsxO8ma2vD+e3LbDlM5Ux5WShGYhPhHZZpa5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993298; c=relaxed/simple;
	bh=jU6KeMafiCdCpyihqFoIh0t8FYZAw78LqNNgWVp+MRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uigabx7KPwNpTvxQ8UI+pzFjBL9XqDxYfm8wMV8CsSWeV37IH68BVa5HwsbrFWIUkv5hmczfpsFEDo1r18STjS1MRrN1VIVfbmuKvuEVjmyodd3bxY7jBZ9aEkwJpL1fuUeM1JK5L2d93xtr3owgcbohNtsAwtVmSEQELX0gkNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zYMeuRny; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zYMeuRny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 293E2C4CEC6;
	Tue, 15 Oct 2024 11:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993297;
	bh=jU6KeMafiCdCpyihqFoIh0t8FYZAw78LqNNgWVp+MRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zYMeuRnyWqxxFlCaLxb1z9ttCtbkX69b3VRWmhrgKpHY2zT+Fpz3sjK4Tf6CK3JgH
	 xwv1hg9SkKNnekIAA7wUgofccUnsob6XMAlbVHx3BZushZOh0mCa5EFPFAd9IJn2XO
	 hjs3qZaNRggZtM4v6hvl6RYSPuHCn3yjhartjCeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 5.15 369/691] i2c: isch: Add missed else
Date: Tue, 15 Oct 2024 13:25:17 +0200
Message-ID: <20241015112454.992162410@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


