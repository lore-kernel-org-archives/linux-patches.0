Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2652745E;
	Fri, 17 Oct 2025 15:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714696; cv=none; b=SS5sXDH7lu59raevuB+aU1TjhnKkFxLKDwo901yxyJZoY+yPkSycaOs0B9lZZD9bcqnqwAeL7a7FvUmffwv2LxrBKn1U07o+Ffb0jAs7kPV6L2hdwXObAM5JJQmCSKRhOnMjGYTjbXbsyQ+ppO53pTDZWxogS5cnZ2JCgW539SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714696; c=relaxed/simple;
	bh=oWO2t0xyUS48mRVDDHKXTeMfg4wRHJQnxvRCrdIyKxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ijuU9c//BvSrDgQm3/l7xAX6ADovH1w4BbeO5PaFvEk2vGbcS33pojFWhtNJV0WZuF4rQruJ9FP39WrvMwHDe0vpXo0dmsIiuDvX3r1JHf4ewY+6yNpfYSlUJilOYn0I9jcknfX8yENpwyPW4lNRRhVhjCE0/8QxieWH7xwBx+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HGGn6vpB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HGGn6vpB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3EA9C4CEE7;
	Fri, 17 Oct 2025 15:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714696;
	bh=oWO2t0xyUS48mRVDDHKXTeMfg4wRHJQnxvRCrdIyKxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HGGn6vpBEcNOReJ6HlC1b35vKL7p171v3KITgvfO8prVcK6I2xpyuYTDIEhgHcQ79
	 mh2EVBNZcmW+Fwk+F8uBn7MfG7uYbhKehz6nf3qBUlNYtLyQthgi+jI0MLZ35ZTrZb
	 Nglzq1p0trZdsbqkoHus5q1dCH3IRZfHCkl0Gp5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 234/277] mfd: intel_soc_pmic_chtdc_ti: Drop unneeded assignment for cache_type
Date: Fri, 17 Oct 2025 16:54:01 +0200
Message-ID: <20251017145155.681348525@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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


