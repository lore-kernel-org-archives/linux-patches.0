Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26CF3387588;
	Tue, 21 Jul 2026 20:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667075; cv=none; b=tCuRZohzFSLCkThnc6YvcPt8dKxE+O2TPwcY4/k9wmbCHdNlXxn5ZJ66VSRLtCxY8UYs/sDWNOLI+qayTRrCrnwqjTxAfKOpoDCBlzXlI81IKCFe6UbbZOr+YHUCjO29gaWjJ+I1GxWnIzbgY6GiHEkyyuOY5LaUjl7K9PXIPH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667075; c=relaxed/simple;
	bh=dHtaS8ibELokZSZhZsp8IxrxH8kGsEq6IzI4waVYPt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJPlqau7yY1NoMBSAeWdziG0lkU4T6RedrfKtD0p6OiYdjq6XuI28U/6SJWUE3JLjN9Pwe7kTdenLctPT5vFW5Qy9jZ6zGJ1RiUoY2YLaeIg1UJca/jY7y8//5CxTR7DPtwOM3+qLrEBUXS2qLhB9jlUPdUHTJKMEURMYrQ0EHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BP8e5DR4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BP8e5DR4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8622A1F000E9;
	Tue, 21 Jul 2026 20:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667073;
	bh=p9vlz20LP7QxdpjyIN2pfk3Dl7PXDYfISY2T7ymxB58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BP8e5DR4+kAF9QO/Y8hA6EAk/ioChgLhF89WgE7qhOXKlpAEJNrrS7LsI1vAXLWAq
	 TfvRIkd5BYKvH3sPt286ZNUuwp5XdafNNOjf+x2sLFNq8+5eJhxHwQXHjQL41rUwYf
	 1wbN0DZSof473r4qoRobTEVyMS6f9hUlQIoMvrdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rongguang Wei <weirongguang@kylinos.cn>,
	Holger Dengler <dengler@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0879/1266] s390/zcrypt: Remove the empty file
Date: Tue, 21 Jul 2026 17:21:56 +0200
Message-ID: <20260721152501.519240532@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



