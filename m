Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1CDD2D47ED;
	Mon, 27 Oct 2025 18:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591384; cv=none; b=gIKmRZEITIgOnS0BCa81wnk6UFL21s7MiPmCFzw/RWSNv6N2ol+mtrNlO94seFeHJsGeWNrSnK+A7n5iXv1W7GInAvaT6OiWpYJL9D2N9deDM+Ylfuz/v3/WvKYfR62UjkHhY6E7TLJjPgKNQO363kbCQk5bVRDmea6RSvKdjWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591384; c=relaxed/simple;
	bh=cs0faV2lIDg2zHKxd71QwPbbeAIEvATZuBzV19yu7+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tYtITWRJ738HwIMUOCNuE9iyaX/8wLSfN3y2mTXodg8WZMOWq5aYrdPJ1FKyaLP7uWGaZtBz3QhNDVpw4fWJbYZv2193utlqYW+Lo4eUu+TeV+NHTy5Wp2EeGSKWE4K5tSo9TOGAPJjfCmczcQzyKpVHwQnE+SVgFlufDAgFFO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OmuMV/g3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OmuMV/g3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 563DFC4CEF1;
	Mon, 27 Oct 2025 18:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591384;
	bh=cs0faV2lIDg2zHKxd71QwPbbeAIEvATZuBzV19yu7+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OmuMV/g3ZvqKkLELAF6M7duS+JtF3ybhhp5rUNgiwa6Q+iHxSxg2UAAbraIpuTXqW
	 Fy9011NdWv/Gg/vECSi5I4ejcPTJyi2HeuwqIxKCXwWfSHmgnJF27ddIsclpLVIaxt
	 UIAzO+QJv54bhcbes54GfQpjSLAmOnFfEkMFobWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 176/332] mfd: intel_soc_pmic_chtdc_ti: Drop unneeded assignment for cache_type
Date: Mon, 27 Oct 2025 19:33:49 +0100
Message-ID: <20251027183529.290550621@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


