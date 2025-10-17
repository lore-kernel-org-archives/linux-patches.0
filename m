Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C4C1A0728;
	Fri, 17 Oct 2025 15:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716555; cv=none; b=clPsSMYY5TtaWXGySdS3XNLWmr5G8LBwJ6w/uzOWw6OP66mZ0x+o+ThMcI0cgnOUYJZtu3eDs6MCFekb+ux8e4azdp+MZAN3b/SLqmj2HZsSMHwMWwpmfyDcK53kkOcQUAEpHWxParfgyG5MMd8ZwGjcQUEwddMOPenK3NYfmLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716555; c=relaxed/simple;
	bh=4/wNS52vxtXHkIOm9MC2ulZISApRgTYVKXhqdZIwKPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tdrdm0lppQbGGpoOzTN94+Xp68lQTa/GcNDD21gXPpGoANABAyh7+0sU4a/YYFQv6eJWiKqMb/G8rqq+N2XEb8BymrrprnnwC1Bk115/qvGz8FQKjv/M82NJxFMgXc4YJRihXQOQKGQ3yRDbDxgfTDnyk7BMryicXA913Q1uzq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BMJAJLa9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BMJAJLa9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66D4C4CEE7;
	Fri, 17 Oct 2025 15:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716555;
	bh=4/wNS52vxtXHkIOm9MC2ulZISApRgTYVKXhqdZIwKPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BMJAJLa9A8YnYhW/ok6FYDb1607Lirl/sR3AG/nkjClpjoj+zx7uHuMcNSrP6ohZd
	 kf6hoSs1OF36MWG6ovmtQ9pbUVrMbnI/c0r/oI6OUqwdSW11iqJy2A14/V4qQQs8PO
	 dI9JFDhxOANb2cnVeevKkTEztpn7sCmkBoQ3CpVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 232/276] mfd: intel_soc_pmic_chtdc_ti: Drop unneeded assignment for cache_type
Date: Fri, 17 Oct 2025 16:55:25 +0200
Message-ID: <20251017145150.936602738@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 9eb99c08508714906db078b5efbe075329a3fb06 ]

REGCACHE_NONE is the default type of the cache when not provided.
Drop unneeded explicit assignment to it.

Note, it's defined to 0, and if ever be redefined, it will break
literally a lot of the drivers, so it very unlikely to happen.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20250129152823.1802273-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Lee Jones <lee@kernel.org>
Stable-dep-of: 64e0d839c589 ("mfd: intel_soc_pmic_chtdc_ti: Set use_single_read regmap_config flag")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/intel_soc_pmic_chtdc_ti.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/mfd/intel_soc_pmic_chtdc_ti.c
+++ b/drivers/mfd/intel_soc_pmic_chtdc_ti.c
@@ -82,7 +82,6 @@ static const struct regmap_config chtdc_
 	.reg_bits = 8,
 	.val_bits = 8,
 	.max_register = 0xff,
-	.cache_type = REGCACHE_NONE,
 };
 
 static const struct regmap_irq chtdc_ti_irqs[] = {


