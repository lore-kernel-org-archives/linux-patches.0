Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1719A379EF8
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301909; cv=none; b=WN9xJ7PYcKUrenNb40NQRMSFcOywWy3HKLJS6vPGHDMytzn9pFK9e+/hRGYnMwCOtqjDLxLs1mz7M0+TEX/YfUCTYpk2C99ebUl26A1L58z9/5Dopn04Oo3VOGHcRWNXUL9TjiyFiSehddHGJgDgYCmHBnnAujmGMbUjo7lzbis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301909; c=relaxed/simple;
	bh=hGXZ59kvmcx95ywRU43kVK6zh7LEe4wodG/c3kPLo9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KYkvZxVq3DFD8zcYemnMYfoh/41TT12efK3NQo9ZCWBkdfTyblAfYKEk/HvkIdqol7oguo3JUh/vzUx1dr+qAt1vfO+y9s7I1aaAW/d8keUhFpoqTOBXuCbQwOjv7uskupPJd0FdKjmuQwtVbBoapYo6bgh8o4c1o3ro43yAdLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=boQ6Q9je; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="boQ6Q9je"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73801C19423;
	Sat, 28 Feb 2026 18:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301908;
	bh=hGXZ59kvmcx95ywRU43kVK6zh7LEe4wodG/c3kPLo9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=boQ6Q9jeu7zmeCqhmuCGZv5ZZKqk7xN6jMnm8q+dAY0710mDKgrSkyuEOCqILySzM
	 DZfkqZssYZt5sIDqya4GQAPQdMRs5D/V8HO+mUOedSgaNvKvZ7JzWDlBb00E+XHuSd
	 1qE9TPm2ZwBRfoPFUTTIF02RHX9eedeK3OE7vef6FPz8RQckNzHaHMJ50CkKP2otqB
	 TCcp8qqx0Si9Xhly+Y9J1Po28qPL9aMFQZacHfo53lm5O2YXyV0BQgwivjFrRTZhPj
	 HIaHMAps23b0ubJMcKtnuJp/jrdFn1xR2HxbC3Hqw+LFFPEu1tN8y5BMjBjLbVijBw
	 mJew/VCOXBqeA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ioana Ciornei <ioana.ciornei@nxp.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 340/385] mfd: simple-mfd-i2c: Keep compatible strings in alphabetical order
Date: Sat, 28 Feb 2026 12:59:22 -0500
Message-ID: <20260228180011.1568201-340-sashal@kernel.org>
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

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit 3ed50d77924ff2e35918739df145dd429cee0ce4 ]

Reorder the of_device_id structures so that they are in alphabetical
order.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Lee Jones <lee@kernel.org>
Stable-dep-of: 8f34c1a64c53 ("mfd: simple-mfd-i2c: Add Delta TN48M CPLD support")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/simple-mfd-i2c.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/simple-mfd-i2c.c b/drivers/mfd/simple-mfd-i2c.c
index 63ac263888606..0cca7a9044cd4 100644
--- a/drivers/mfd/simple-mfd-i2c.c
+++ b/drivers/mfd/simple-mfd-i2c.c
@@ -110,13 +110,13 @@ static const struct simple_mfd_data spacemit_p1 = {
 };
 
 static const struct of_device_id simple_mfd_i2c_of_match[] = {
+	{ .compatible = "fsl,ls1028aqds-fpga" },
+	{ .compatible = "fsl,lx2160aqds-fpga" },
 	{ .compatible = "kontron,sl28cpld" },
-	{ .compatible = "silergy,sy7636a", .data = &silergy_sy7636a},
 	{ .compatible = "maxim,max5970", .data = &maxim_max5970},
 	{ .compatible = "maxim,max5978", .data = &maxim_max5970},
 	{ .compatible = "maxim,max77705-battery", .data = &maxim_mon_max77705},
-	{ .compatible = "fsl,lx2160aqds-fpga" },
-	{ .compatible = "fsl,ls1028aqds-fpga" },
+	{ .compatible = "silergy,sy7636a", .data = &silergy_sy7636a},
 	{ .compatible = "spacemit,p1", .data = &spacemit_p1, },
 	{}
 };
-- 
2.51.0

