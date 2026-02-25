Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE95018B0A;
	Wed, 25 Feb 2026 01:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983365; cv=none; b=CAedIjEeGG5gH30Krnlmko9sYUKp4Tk/V79tqJigoxB+cN3QF5O+mELXIj74XcSFjRX1LKBX87wMEcch/YE23MF9U0QVMIVlgk7WTXiroNjaEVTqFsv90VpWnknTd5Kmm7sIsWepkjRPJuqaWzg9KGEHhpRDaJHgbTwKkE/2YFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983365; c=relaxed/simple;
	bh=nvXus68tFG/e9Nhtmni0Bbs1iW3k5sfFed6ISdNJ3Fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DKdRfBE6zovjpGKNHtYSvjRMiGzw64iMfRhBpxLqM9krUM095wONlSL+0PdzhSI4wh6aAWuWfZCjbEIoIkG81Y/arilBilpIkNL7xr7MMXZyI7GYv00a6IdTHS7L9CL3W2aMBwmnnzJh+uPlWpKJm6JPrpcnHMSDQxNootr4YxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=drGXvjvR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="drGXvjvR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D2BFC116D0;
	Wed, 25 Feb 2026 01:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983365;
	bh=nvXus68tFG/e9Nhtmni0Bbs1iW3k5sfFed6ISdNJ3Fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=drGXvjvRV6+0jdlvUY/Jrf1Pu/LSeUYGQeGzzG7+pC1kxfYNk7UgEDGnwdLzIzZ/E
	 jalSDmHQftdu1AHi3ZMRPXhehIor/pHbA8ui1xtKZ3pxqDtyroCIst75bM8rTCyMKz
	 dnQAP+Un84Zf9Ar+1tPU8OaC1IqYYqpxaNapNqKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 492/781] mtd: spinand: Fix kernel doc
Date: Tue, 24 Feb 2026 17:20:01 -0800
Message-ID: <20260225012411.874405894@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index ce76f5c632e17..049d55c38d522 100644
--- a/include/linux/mtd/spinand.h
+++ b/include/linux/mtd/spinand.h
@@ -287,7 +287,7 @@ struct spinand_device;
 
 /**
  * struct spinand_id - SPI NAND id structure
- * @data: buffer containing the id bytes. Currently 4 bytes large, but can
+ * @data: buffer containing the id bytes. Currently 5 bytes large, but can
  *	  be extended if required
  * @len: ID length
  */
-- 
2.51.0



