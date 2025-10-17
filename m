Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00F4212575;
	Fri, 17 Oct 2025 15:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713383; cv=none; b=n9/kQnZaeNmCnVZDD/ic1rP4yBI5Pt9vRTDx8x6MADRAYI3HtIXlCpDuGML0RXxvnDqS8qgLZ2coqlqaIMdqlqesarOtmzirTiCYe6PXz0iroaJj005onWhjrLeTtUCgN/kqT5BwHz5XrBnkz1Cse+oRyF9pcfQlwPt/PUczBcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713383; c=relaxed/simple;
	bh=d9ruJiFOf0XyLIu5tZHojJpN02Y9u2XZgvHmlQNuL0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ouUdaw6kGHww+KftfjkHTLJb65wzPCojchKV2ercDw6h1B+hpIIqDJdKeWiLH/1j+YHRxrCLYVx4KFUSPK2BmGZJiWdxQ9ek4SDx5q8bmTUquYkqnZ5ggPs6Vx5GgiAv0455OfDesGat5yrsuH70oCWkaA5yVI/MzbZeIdn6l8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rdRu/Z/z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rdRu/Z/z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BABEC4CEE7;
	Fri, 17 Oct 2025 15:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713383;
	bh=d9ruJiFOf0XyLIu5tZHojJpN02Y9u2XZgvHmlQNuL0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rdRu/Z/zJgX7DzciZAGqFa1DBt5yQkU4JPrszhgkkgiobK5V1Yd8Nox16aREs2yEB
	 tngIGFFvuqBSOB9P/GBbn2rew1gQ2YK8rx32QlcMgnj2mFyzjzEWXFM0BDKAVEpxSm
	 UJtrf4hA7lOJwQmOm4IR/47hUffqwHGElHsIXXqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Shevchenko <andy@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 146/168] mfd: intel_soc_pmic_chtdc_ti: Fix invalid regmap-config max_register value
Date: Fri, 17 Oct 2025 16:53:45 +0200
Message-ID: <20251017145134.414754990@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 70e997e0107e5ed85c1a3ef2adfccbe351c29d71 ]

The max_register = 128 setting in the regmap config is not valid.

The Intel Dollar Cove TI PMIC has an eeprom unlock register at address 0x88
and a number of EEPROM registers at 0xF?. Increase max_register to 0xff so
that these registers can be accessed.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Link: https://lore.kernel.org/r/20241208150028.325349-1-hdegoede@redhat.com
Signed-off-by: Lee Jones <lee@kernel.org>
Stable-dep-of: 64e0d839c589 ("mfd: intel_soc_pmic_chtdc_ti: Set use_single_read regmap_config flag")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/intel_soc_pmic_chtdc_ti.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mfd/intel_soc_pmic_chtdc_ti.c
+++ b/drivers/mfd/intel_soc_pmic_chtdc_ti.c
@@ -81,7 +81,7 @@ static struct mfd_cell chtdc_ti_dev[] =
 static const struct regmap_config chtdc_ti_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
-	.max_register = 128,
+	.max_register = 0xff,
 	.cache_type = REGCACHE_NONE,
 };
 


