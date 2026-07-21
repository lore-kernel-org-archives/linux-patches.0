Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C8147010B;
	Tue, 21 Jul 2026 19:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663362; cv=none; b=ONaQhA2at34AqahIR6ErTWLB/D8VNHkj+6ByE6i7bJLUmV8yIWOyti6bMyQC4h4xWAPpBnef6WNDnOfcogCpPzlnBDGNwqNl83jQLsNKgrYGsd9kYwIhmzyYU7xFuyvUV0KzE0CW1+kEraxWkGCxikZgJXm2vQyLXufBe+htQtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663362; c=relaxed/simple;
	bh=Lf0ebW+ttYStJSr7Xe2elIN1+YD2m5g3TqwqzTIgpJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DIyXDgWUmrWsayOqB8Dkl1FOXVCxgAZjA6pWFS2H11kgFo+vjrN+RxTjd6YTjs+2yJ4wyLhIImdOYJoz8J2c+3X2i+OEnd2mBoTzAXpNCaADVExaPBsZEYUAIsPBNedJU8vXLpyN6pRdKPc9jLLlNlb2O7rGFQabNz4LT6wnRm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iw6fd3GC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iw6fd3GC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C4601F000E9;
	Tue, 21 Jul 2026 19:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663361;
	bh=/uvugjIy2eUqOH5Z700uaJVj+/X611l2DyoMpGz0YNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iw6fd3GCiEeQxbrWUxuTygvfBTgb1CkEwsRhmXfotdcteOUoGmc3a/3iWRg2jK4EF
	 SipgRFcQlTJwpOamQxZmMMoFD2YaLbsYf6wUCZEWolL2xrDHDNJeRXOMB5+/uWgPIt
	 FfR/vbsMSKjg7JxOZN88PB0Y4/NLeiHaB3EDpTNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rongguang Wei <weirongguang@kylinos.cn>,
	Holger Dengler <dengler@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0795/1276] s390/zcrypt: Remove the empty file
Date: Tue, 21 Jul 2026 17:20:38 +0200
Message-ID: <20260721152503.864958959@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Rongguang Wei <weirongguang@kylinos.cn>

[ Upstream commit 575f87b9d4882b0d621192fdd754d7e09dbd5789 ]

The files has no real user because CEX2 and CEX3 device drivers
are removed, also remove these empty files.

Fixes: 5ac8c72462cd ("s390/zcrypt: remove CEX2 and CEX3 device drivers")
Signed-off-by: Rongguang Wei <weirongguang@kylinos.cn>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/zcrypt_cex2a.c | 0
 drivers/s390/crypto/zcrypt_cex2a.h | 0
 drivers/s390/crypto/zcrypt_cex2c.c | 0
 drivers/s390/crypto/zcrypt_cex2c.h | 0
 4 files changed, 0 insertions(+), 0 deletions(-)
 delete mode 100644 drivers/s390/crypto/zcrypt_cex2a.c
 delete mode 100644 drivers/s390/crypto/zcrypt_cex2a.h
 delete mode 100644 drivers/s390/crypto/zcrypt_cex2c.c
 delete mode 100644 drivers/s390/crypto/zcrypt_cex2c.h

diff --git a/drivers/s390/crypto/zcrypt_cex2a.c b/drivers/s390/crypto/zcrypt_cex2a.c
deleted file mode 100644
index e69de29bb2d1d6..00000000000000
diff --git a/drivers/s390/crypto/zcrypt_cex2a.h b/drivers/s390/crypto/zcrypt_cex2a.h
deleted file mode 100644
index e69de29bb2d1d6..00000000000000
diff --git a/drivers/s390/crypto/zcrypt_cex2c.c b/drivers/s390/crypto/zcrypt_cex2c.c
deleted file mode 100644
index e69de29bb2d1d6..00000000000000
diff --git a/drivers/s390/crypto/zcrypt_cex2c.h b/drivers/s390/crypto/zcrypt_cex2c.h
deleted file mode 100644
index e69de29bb2d1d6..00000000000000
-- 
2.53.0



