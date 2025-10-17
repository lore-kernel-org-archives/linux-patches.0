Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1AA2337113;
	Fri, 17 Oct 2025 15:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713904; cv=none; b=BCnr/VcWEbS7dysi1d9sJ2I0yEDHw6YLyBXkwLYteBWfarz7RAt6lzdw+e/aRnepIRVH3gVq+sZq+0LbFXGoJ3l3YKB7zoc6qZkO4RrEHiJswol4/yQFGtbLuuZ2z9yc5F+rLMjQC24izEgBLJMLZBFrrYuB46u8NIdgpgD7nVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713904; c=relaxed/simple;
	bh=0AeLj3T5IMMzCcwtcNZ7wMs3hEmKmBh8dyKC0vwkvrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YST201LHZedu4j0Y6rU66Wrqg8bxhwVF9aOSXO3JR93wT6Kg07QYLn+QYfck0pj8ValRVdER/g84EgjBdB8uYuzZ2C7VF8nWNv9r5dJ5etLs7QMZX6rA1Lae2tYXSCZSBdoGzjw2Qcd4LqEdbV9QpHb0NgT/dtIwdD6o5igAeXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ExsOPFQi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ExsOPFQi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF04C4CEE7;
	Fri, 17 Oct 2025 15:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713904;
	bh=0AeLj3T5IMMzCcwtcNZ7wMs3hEmKmBh8dyKC0vwkvrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ExsOPFQiUytslHSD16yjpVmSbisvw32U0mFzQ5Z9N+Tejd9Uf7HHp4dJbPVPhcwE2
	 ezcNxBMLfgWAY3nl4xEUN1Fo0AYMTIT6bO1GVXDBmMCM/KFnCJTrkUqdGBrE20afWG
	 qart5BF3mmz1C0xz2xhhv+mIBvlz5ELSDvyn9Vgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 161/201] mfd: intel_soc_pmic_chtdc_ti: Drop unneeded assignment for cache_type
Date: Fri, 17 Oct 2025 16:53:42 +0200
Message-ID: <20251017145140.647499380@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


