Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA28A38D018
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302196; cv=none; b=fZUMX/JJdJNg1DMNYUjh7DhK+hmkxh0VM8XKqvvDhK5rlcmYB9V558r17Jx0bcm73RBw0eHt1ltIdbKs3rI54nXFe60LF/QYT4IYTdiuY5xMFJRKpVcMM42qx//xr2rGX1vNut+WktKBGvQQBJd/jlpNT2da+bSsk8smVkfHWpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302196; c=relaxed/simple;
	bh=LtIyv1mwpHCNWGenolrDCo+//vAO3y2yGOhVqvL5oD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tn6ZgAjXV7cohom4NVuxXB7xhKQzSg1cfnS+KkUmQ9VlyVcioiSnOArj01FFZ2o2fbCoxSdytz90eDYtDpNnQDhfIMfJFDoaql6Oy6Mkcdr4zJZIRD3mQyI+6CUpWpR17pdrT1SHGwsqbD+GggJhrBUoyvOvrpKWw5WBbdEKRYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=luJZbZ4z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="luJZbZ4z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BAEEC116D0;
	Sat, 28 Feb 2026 18:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302196;
	bh=LtIyv1mwpHCNWGenolrDCo+//vAO3y2yGOhVqvL5oD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=luJZbZ4zcvghpiQkTxalt8F7DWeN0flzGdDtfM93YGe7GsJqxrmR2PERxY2vUf30o
	 XX5XcKLKarSpJ2nDg0GUYqwZbQmGVNlPDFlyqODhq2wl8iKABRJKK3BoFYDC23hrhn
	 kxRcrhBcjPqqAv/sZs/dXXVUHjmJUwZFoSp/jO9eczythitdf1pORRIQEIy3o56IG3
	 GzpyLjroUfDahxj5E6lihJdTZeHokIPZeNZWB6VCZpRyZYtvkUJDMi6a/hITiCEnIL
	 5uCvD2lVseQs4ONjA4TYxJvfj53YfS0VYzN5x9vrKWiY05QjDEBBZYpVWe/9FotlA2
	 373bbWyvJcfyg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Miquel Raynal <miquel.raynal@bootlin.com>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 200/283] mtd: spinand: Fix kernel doc
Date: Sat, 28 Feb 2026 13:05:42 -0500
Message-ID: <20260228180709.1583486-200-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit a57b1f07d2d35843a7ada30c8cf9a215c0931868 ]

The @data buffer is 5 bytes, not 4, it has been extended for the need of
devices with an extra ID bytes.

Fixes: 34a956739d29 ("mtd: spinand: Add support for 5-byte IDs")
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mtd/spinand.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mtd/spinand.h b/include/linux/mtd/spinand.h
index 5c2ccc6494529..980e1fdf67eda 100644
--- a/include/linux/mtd/spinand.h
+++ b/include/linux/mtd/spinand.h
@@ -195,7 +195,7 @@ struct spinand_device;
 
 /**
  * struct spinand_id - SPI NAND id structure
- * @data: buffer containing the id bytes. Currently 4 bytes large, but can
+ * @data: buffer containing the id bytes. Currently 5 bytes large, but can
  *	  be extended if required
  * @len: ID length
  */
-- 
2.51.0

