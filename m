Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718422F12D2;
	Fri, 17 Oct 2025 15:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713386; cv=none; b=JaJpMf0Q8jiVF6szh2hP0sUwWVyhhp7wTBqZOF6euAT+01Rrs56iVnaX9BfJxu+oTO4DsSFzOidhArPHNNEyT60z/gfQ8Muaq1UW5a21d4aYqs9+t0Lf9hyVu3cPx7m/YhPzyocXZGjB+oAB7KnHe1ewM2Tawg6f7z4P6q2TL3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713386; c=relaxed/simple;
	bh=g/RhqVah9/7xyPd22QjjzwQW0Ysp174ZJxG8S0ftzq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WJ2sy4lkPd/DumzJXwdRmwu18Cw/dkEeWBx6P3TjnK1yppRxJDa+dQvG5I9PiC9l/e5b0US7mbuuzPTqLx3CWdU/NzkPv7SZcph0hR1HrG5k//ibH43NRUf7+wDbZBxxZO92RiwAwiM0xWqB4svaE+NwHEzPwZ5PVr6em5CIClY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RVR/aJrW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RVR/aJrW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5E06C4CEE7;
	Fri, 17 Oct 2025 15:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713386;
	bh=g/RhqVah9/7xyPd22QjjzwQW0Ysp174ZJxG8S0ftzq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RVR/aJrWnVa7rwfnqM8dl8q9CJmIa/7/eOfA9H80ueZ/LQIqepaapz6l9Nm38L9ai
	 ecR7nU44APg4BD55uQ9Z9mDCX/oEMXi3HOTIxznTopcUvPfujZpW2rdcZ9jDZ+Nhir
	 5tohEV2QzSQHbFU2aZkSAZZ0tkbB+Tv5RjqGS+OQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 147/168] mfd: intel_soc_pmic_chtdc_ti: Drop unneeded assignment for cache_type
Date: Fri, 17 Oct 2025 16:53:46 +0200
Message-ID: <20251017145134.452744967@linuxfoundation.org>
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


