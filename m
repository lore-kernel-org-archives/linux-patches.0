Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50B34D17A6;
	Thu, 17 Sep 2026 18:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671302; cv=none; b=GUyUAFkijkxNvgbKAW1QNIHioGLbMaurKJDk2Fuy9EyLq15Dby4HBrsmkfMsN03WmmHBbKdv6k4P89An8QfnPk8nu4X/TPJrxBtNIgIzWeJIgZzQoF39+c49crj1ARcYlTAm4mewIPY/g0k7dwrKx6pxMbejf+2ciF87cyvdeQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671302; c=relaxed/simple;
	bh=e05Q9sEgSV7vFflbgz4L3Syb+CFkpkn0X6/lrgX2f0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M2aGTqhBUsDWHXZxnMfQafXS25HZsCbFSliVVs0xn29ababBeHDF2Smq2CQV4Y88q24idylMdTNqIPPocQzBzsfBsyV/4nIVyT1Qjmf6IQhhyO013qp4qRpreMtzKiMFAxt6SPMUXA0BZnu/o1NC9eSJDeZzRl/NjJti4GY6aAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bbqsSS79; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bbqsSS79"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 446091F000FF;
	Thu, 17 Sep 2026 18:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671300;
	bh=+/iOPbQGpFnZSBMa0Zn8Xdoe5mioj/PA7rvg5rrf240=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bbqsSS79bTl9ii2b0j6JcWhqdzqZlqgk/9cWH17oWa58L6/yBPOfhLSxsXWRKC561
	 l/NFCRkW13yXvFGl3DrTfUhlop3APOR5PkC408JNBkv8JgIs0PSAACNpoVuS0i9G+r
	 svs4HOd+na1g/ma7OZLw2QuARMYCXSGnbWBjRBsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0932/1102] Revert "nvme-apple: Reset q->sq_tail during queue init"
Date: Thu, 17 Sep 2026 16:14:35 +0100
Message-ID: <20260917151604.037447681@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 7f2047888e37dbe3f185d8104b671959eddb98a3.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/apple.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
index db8c20a60064f..1cc222fdbf22e 100644
--- a/drivers/nvme/host/apple.c
+++ b/drivers/nvme/host/apple.c
@@ -1025,7 +1025,6 @@ static void apple_nvme_init_queue(struct apple_nvme_queue *q)
 	unsigned int depth = apple_nvme_queue_depth(q);
 	struct apple_nvme *anv = queue_to_apple_nvme(q);
 
-	q->sq_tail = 0;
 	q->cq_head = 0;
 	q->cq_phase = 1;
 	if (anv->hw->has_lsq_nvmmu)
-- 
2.53.0



