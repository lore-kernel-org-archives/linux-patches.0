Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E43379EF7
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301900; cv=none; b=DkJXQMHVHk8L5OKWHiUXDbV6j5s134pVM7JvKGcFFwxEEhduc0iECj91DwqhFZ/0ay1FvjPyZ/dZPdJYcwIoJT4iYfhGJRekPYVa8Ejdw3Rs8CF9aBW3TfspWbRaaEw+/YccIOuFcqIAtpclyj6oPcRjOmPMdlE059WcMSSqIqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301900; c=relaxed/simple;
	bh=ZGTEnqYYJeNtsR/A51neWJQ7VQyXG4DodzsN9qlnQ0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UYC9968hd++j39HAt3iHsK7eTk95iLkmg4GoDP0QLZ2ZEBis1cysEd6+T/sQXPgC1W/MTv10+PDug3ctxH2PP7ERYJi/ADNeaUoccLDUxHADXQWlT8BCNFHpcYOGKp9aFJy25Gq64qv4Goxu1z3ve82tq5/eSCNMrRba1BqfR48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gckd7WWL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gckd7WWL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85DBBC116D0;
	Sat, 28 Feb 2026 18:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301900;
	bh=ZGTEnqYYJeNtsR/A51neWJQ7VQyXG4DodzsN9qlnQ0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gckd7WWLOSjMbdY32cBLkqyo3iS7zFF0zAII5Me1SYPFUl5JiSJAx1pLa+OmSgc7W
	 qHiJxyHNX4Y86Txd22F8nCuhwbriGC2EULwGFa8uK+6SP8siVZY7iUNpd2k1XQ6ESS
	 qDK7GRQhmsfp/RCoHd6k2oQu/nOu65mfECQVH8bX8tkJrnoCY4LrHlx7V1Bx1WArgB
	 0OosV8sTGMJS+8G31Wtd3xrYd0n/muHxlZJNiALa7kmB4kXCeQ+nfdEZHbx7hVDzxv
	 fFf5uRLSWSopkYhK7Pf8MjXHc2KqZB04qB+BYwTfRmZlWKvKVCyMBnHMpqOc7Hq0La
	 WdQcKrFovg2Gg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Petre Rodan <petre.rodan@subdimension.ro>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 329/385] iio: pressure: mprls0025pa: fix interrupt flag
Date: Sat, 28 Feb 2026 12:59:11 -0500
Message-ID: <20260228180011.1568201-329-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Petre Rodan <petre.rodan@subdimension.ro>

[ Upstream commit fff3f1a7d805684e4701a70bfaeba39622b59dbc ]

Interrupt falling/rising flags should only be defined in the device tree.

Fixes: 713337d9143e ("iio: pressure: Honeywell mprls0025pa pressure sensor")
Signed-off-by: Petre Rodan <petre.rodan@subdimension.ro>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/pressure/mprls0025pa.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/pressure/mprls0025pa.c b/drivers/iio/pressure/mprls0025pa.c
index 3b6145348c2e3..7ecb928655421 100644
--- a/drivers/iio/pressure/mprls0025pa.c
+++ b/drivers/iio/pressure/mprls0025pa.c
@@ -418,10 +418,8 @@ int mpr_common_probe(struct device *dev, const struct mpr_ops *ops, int irq)
 	data->offset = div_s64_rem(offset, NANO, &data->offset2);
 
 	if (data->irq > 0) {
-		ret = devm_request_irq(dev, data->irq, mpr_eoc_handler,
-				       IRQF_TRIGGER_RISING,
-				       dev_name(dev),
-				       data);
+		ret = devm_request_irq(dev, data->irq, mpr_eoc_handler, 0,
+				       dev_name(dev), data);
 		if (ret)
 			return dev_err_probe(dev, ret,
 					  "request irq %d failed\n", data->irq);
-- 
2.51.0

