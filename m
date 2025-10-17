Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7713821C9EA;
	Fri, 17 Oct 2025 15:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716552; cv=none; b=oZhgvrhy1KTtV2S2tbqf1fG6N2QATaT3UCOr7C3K8GDuvp7e/E8K/v64W1FoB6qluGqzm+y/JEjyYba0IMGws4jXsQEfmjp+JC+hLnas6nwYBAC/KX8x5+/EKqsU9pMV+y/SCH6NRArvpIZtnZ0iaK3RSTsWoukdlxcTToE8BKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716552; c=relaxed/simple;
	bh=yeehZaaUJRXmuAPgfkHUI2i9fAMy2V6HZ+lrwl1BdhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZUS1SwV8BpcPKLUUX9J4ArfKYo0d+PhYx0hhFvoSh0CkxrsJiXTFqSjgDYRS3oz0exb0WXkXCG/hDONv313kN7qj9IhjThUBc09eicwroFIC3cbFT+rXMpv+f3GCSU+ehoDxQdmvmw2ZwZj8EneRuCccCqTX160n83D4g404WK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=goZmdCKE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="goZmdCKE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF203C4CEE7;
	Fri, 17 Oct 2025 15:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716552;
	bh=yeehZaaUJRXmuAPgfkHUI2i9fAMy2V6HZ+lrwl1BdhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=goZmdCKE/1c+BvaWrKgE2lrd414XsoltW6I6dPmC7b+k8M1A4YaARFQxHx+LoAsPB
	 UxVfBYgju7E2Ue2HiS79noN1FWFAV3zKc8L4AlO1Jz9kpq/at+oV9xomgW2EXHdiZ6
	 D4j1VMhmK5qc2g8IS/AVmMRO/5uspXd7h4JuK848=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Shevchenko <andy@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 231/276] mfd: intel_soc_pmic_chtdc_ti: Fix invalid regmap-config max_register value
Date: Fri, 17 Oct 2025 16:55:24 +0200
Message-ID: <20251017145150.899417555@linuxfoundation.org>
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
 


