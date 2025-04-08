Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92EF7269AF5;
	Tue,  8 Apr 2025 12:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116494; cv=none; b=ttDlVt3CJuzwgGXHSPVjwmL/Yt3Ij/l2woRkC5X6vtnZhYjnGq+WT6h02isAjj/i0DIusJ5wk4/8ckuQm+29IrR0cy4P+g5IJiiq55GAJxgRHy7BuovwA1inbvlsTTK32POqT+lVAdtWTO/r+A9rVPaamNFE4fvvNvZSoNgMPqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116494; c=relaxed/simple;
	bh=hgu9JVcXpQr0+Mpz97cHCeKOFAacsD2qR4ZzU8wp7yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=utoGzHpzuOo0aKCRR/n0A9eW4lfdxjwl48z5oE+PpV7l91yXsSNCX9/rZZsyArcsx4bxdlV6cMqfI9mWp/CvL5kw4o8kiSXZCda34GemPy4JLHzCzMj+IW8WUcXykDIZKnx1ojctOnPnMPHCjd+dXOaYsnFRhAW7B6kSOlw3PmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SR6+75P5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SR6+75P5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21CCEC4CEE7;
	Tue,  8 Apr 2025 12:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116494;
	bh=hgu9JVcXpQr0+Mpz97cHCeKOFAacsD2qR4ZzU8wp7yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SR6+75P5+wKflzqUf4bYz8nmVahZgbIwXC2Gs1OzitJn0+Uqx+eqLLDHFTpqrSBGm
	 V3FRqSNJg+mJ9BErh4nJyyUn63fIdtIe9pHX9f8m1zpBd5aWyxnTI1wrY0TEUzRhLT
	 Xuj+be31OpPkzFf/tQHeLZoXIOYC+1mLi/S0umWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexis GUILLEMET <alexis.guillemet@dunasys.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 160/423] pinctrl: intel: Fix wrong bypass assignment in intel_pinctrl_probe_pwm()
Date: Tue,  8 Apr 2025 12:48:06 +0200
Message-ID: <20250408104849.466339392@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit 0eee258cdf172763502f142d85e967f27a573be0 ]

When instantiating PWM, the bypass should be set to false. The field
is used for the selected Intel SoCs that do not have PWM feature enabled
in their pin control IPs.

Fixes: eb78d3604d6b ("pinctrl: intel: Enumerate PWM device when community has a capability")
Reported-by: Alexis GUILLEMET <alexis.guillemet@dunasys.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Tested-by: Alexis GUILLEMET <alexis.guillemet@dunasys.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/intel/pinctrl-intel.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/pinctrl/intel/pinctrl-intel.c b/drivers/pinctrl/intel/pinctrl-intel.c
index 928607a21d36d..f8abc69a39d16 100644
--- a/drivers/pinctrl/intel/pinctrl-intel.c
+++ b/drivers/pinctrl/intel/pinctrl-intel.c
@@ -1531,7 +1531,6 @@ static int intel_pinctrl_probe_pwm(struct intel_pinctrl *pctrl,
 		.clk_rate = 19200000,
 		.npwm = 1,
 		.base_unit_bits = 22,
-		.bypass = true,
 	};
 	struct pwm_chip *chip;
 
-- 
2.39.5



