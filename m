Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704997;
	b=B2Aeo8rCsst+FvdgoVJqhE8yfrIrIda2eRkqUqABNpsWCQHuc80alP6ziotBkdti+uLn
	 ssgXkfcY+b45K5W9y+WzIoNxdfMkuJjPLJoavnzQQXWuaG9p5haX3FCHwoJKEIs9vs1XM
	 FWYs4NOM28sDmuPc8PsJra4dIvK4ONmkWf2lUpESbF0pxfywM9NH/dsVhEaj3fVOlpyCM
	 n+cEZAj+S4vw4oSZ9XPROMZmmvjJ4NsI6mlYNT8W1Y8YfnT4+IbvEuSolKshVCLHvWMcm
	 +uhQPnYpqJManEKQOexuKgP7oO3WzzYOeyYtzTKlvEhDcZXQSN366LB+xrxDjNFQylg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704997;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8odg+u8QnMSU21vjC+NFfIFNOtT5JIdsztV+ghTrCds=;
	b=n82XYBN1d0ODrXsS3Jo+vDd+Lrux6d6XH17QDTaoTORDgdtEbE9sQTUv5LrqnjPevkQc
	 2lF3ta5I8x6Xx1ROqQBkmcntQDUfKovkCneZw9x8+NFHcM286mNriy3ALxBgChoE5qTmp
	 FT4SJlCSMOPC0P+kLeQa1UWafz9aiqPvp46R18obb3/lkXI9kbgfouMAywsE1k1M2Z8B7
	 bJSnzZoqWYvmd1b5VkC6Okva7iyUqdY5WIUY7Q/izdh9/KYhsiGHfnfPrR7Yi7Q08Jqze
	 rPmWWxnu57XOO6s4cbImgfa9MISADNqjIS0w73wnVTy4WGt4PeguxOZaN1HMJiMtoBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=viJMI74H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6B4606A31E;
	Thu, 26 Nov 2026 14:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=viJMI74H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED56A1F000C4;
	Thu, 26 Nov 2026 14:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704997;
	bh=8odg+u8QnMSU21vjC+NFfIFNOtT5JIdsztV+ghTrCds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=viJMI74HoH/7Y8msTkBnlmXgWbfEfPY9aESpeJKTuA1UpuoIO4mTpslgian1P6cbQ
	 n+UcU907hMHUXp8B3KU/VA5Nt6PaGb6YiEWfyukfpbb6LIMmt+3H1F3JpOTK8r+FNz
	 6p76MNkh8agEQ0CHqIzTyL7X6gENvanocgFz7Lyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 047/319] spi: remove duplicate parameters check in acpi_spi_add_resource()
Date: Thu, 26 Nov 2026 15:36:55 +0100
Message-ID: <20261126144007.798230817@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit cdb0cc9379f1b4fa5ea3e0492bacf8008f3f4e5a ]

The acpi_spi_add_resource() is never called with ctrl == NULL and
index == -1. The only caller already performs the check. Hence
remove the duplication from the acpi_spi_add_resource().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20220709000709.35622-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 2d0953ab69d3 ("spi: acpi: only look up the IRQ of confirmed SPI devices")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index f582dc4ac176e..b662a9a3961ab 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -2328,9 +2328,6 @@ static int acpi_spi_add_resource(struct acpi_resource *ares, void *data)
 			if (lookup->index != -1 && lookup->n++ != lookup->index)
 				return 1;
 
-			if (lookup->index == -1 && !ctlr)
-				return -ENODEV;
-
 			status = acpi_get_handle(NULL,
 						 sb->resource_source.string_ptr,
 						 &parent_handle);
-- 
2.53.0



