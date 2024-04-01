Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22C21CA8F;
	Mon,  1 Apr 2024 16:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987528; cv=none; b=LI+XPdmusyZz+WAqSpJcVfRCLtMIkTQCSsXOEVmPZ5Po1zIxjr3I8QIh5y7xN1xXzxJQzuBnU/Y5LteYwco7Ng0esoT++8RXi8QCp+eAL1L8ErNMziLvwlVC2NeceYaPKqg9vY9kbt0K7XMVA78u2T2KyjtE5HXmJzWCYLGvjO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987528; c=relaxed/simple;
	bh=BhCmKVonpYxcq1h4TDeTmSIdtAxoP38rpTox40Sm4iI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YixtM4Ac65dRqsO+NU0vzCuhyUC8WEofdenzmQoqaGDLqQffMNhbyjT5JZ2HD7+UXa5Tr0Sr07AxhlYRK1xDBwtmQuD9Bvv/YJnEVHvhVb/wdcfM0jq+KJLXFmNoNN7Y39NJ++d/aZHCHWE49AjnWd1cly3YmbRdSeqd9R1oxFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T/JMxYK3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T/JMxYK3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40DD8C433F1;
	Mon,  1 Apr 2024 16:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987528;
	bh=BhCmKVonpYxcq1h4TDeTmSIdtAxoP38rpTox40Sm4iI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T/JMxYK3yIgE2SYVpkA1bZE0t/mTpJ/Q23iCWJlWrDxyyF0Iw/ZnVxVbr0UJgBz4j
	 Nx7u3pxDtZYSjw/4VOdiWLJfU5+Y1la2JdqxLPyMbmJiPBcyVmVwSOgFlPQi9HzzhL
	 q9HuhICMTbabb/5H5C0OsH8TkgbJoAfAUYXNP8hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Rapeli <mikko.rapeli@linaro.org>,
	Avri Altman <avri.altman@wdc.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.8 314/399] mmc: core: Avoid negative index with array access
Date: Mon,  1 Apr 2024 17:44:40 +0200
Message-ID: <20240401152558.559006674@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikko Rapeli <mikko.rapeli@linaro.org>

commit cf55a7acd1ed38afe43bba1c8a0935b51d1dc014 upstream.

Commit 4d0c8d0aef63 ("mmc: core: Use mrq.sbc in close-ended ffu") assigns
prev_idata = idatas[i - 1], but doesn't check that the iterator i is
greater than zero. Let's fix this by adding a check.

Fixes: 4d0c8d0aef63 ("mmc: core: Use mrq.sbc in close-ended ffu")
Link: https://lore.kernel.org/all/20231129092535.3278-1-avri.altman@wdc.com/
Cc: stable@vger.kernel.org
Signed-off-by: Mikko Rapeli <mikko.rapeli@linaro.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://lore.kernel.org/r/20240313133744.2405325-2-mikko.rapeli@linaro.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/block.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -488,7 +488,7 @@ static int __mmc_blk_ioctl_cmd(struct mm
 	if (idata->flags & MMC_BLK_IOC_DROP)
 		return 0;
 
-	if (idata->flags & MMC_BLK_IOC_SBC)
+	if (idata->flags & MMC_BLK_IOC_SBC && i > 0)
 		prev_idata = idatas[i - 1];
 
 	/*


