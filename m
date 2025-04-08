Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428A626B2A3;
	Tue,  8 Apr 2025 11:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111545; cv=none; b=Awk3YRpyJT/wOADu51psEsgjhiRI9mx8cQWtAS9rgFdDnRFXm8KAvyb0iBLmsWYKuwr2kVTVKFiWzhVtdHGC3fIKGE5WGmmwq2tNnDu0Hu9VgwN++rtSM+IlwNykuspiJzAh3f6VWHSzDLtz0rxgcAbkLGeufrWU9Y9NjssN4hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111545; c=relaxed/simple;
	bh=yqUkNnHO2RZtSwEDhFgOY00D+S7T4yBcLyF1Qb5J/wU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=leUB4lJZpIMMa9KYIhdar21NBhmMkbBERVznjMXXXSL48y11h3+mfh26Ri5qjSr4pCqrBJkyvavXTOW4nrMpl9HAOVOdIB6EsTG15Pc/B4Pb55St8zZNvOmpoWOoJt5m3dMmCoO3QtBt/ADC/Y/btRsJSBosLIZEQ2Q1oYCS5Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J5a8m/om; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J5a8m/om"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EE08C4CEE5;
	Tue,  8 Apr 2025 11:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111543;
	bh=yqUkNnHO2RZtSwEDhFgOY00D+S7T4yBcLyF1Qb5J/wU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J5a8m/omEp778UpZWJ+82J5/l5cq5z6Xspaz3JZSadcFoT2/4ZhJZ7vp4ub3jhltr
	 UfssNad8aktmmbfIpk38Fk3C28gYWZF7H8f8YFlIHsYPipjsLktoszfbmABIaDRsnl
	 /dg3Aba+ne6wtWYBSLr/Q3/JRJ0w2yK9DeBWporc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexis GUILLEMET <alexis.guillemet@dunasys.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 430/731] pinctrl: intel: Fix wrong bypass assignment in intel_pinctrl_probe_pwm()
Date: Tue,  8 Apr 2025 12:45:27 +0200
Message-ID: <20250408104924.277029574@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 527e4b87ae52e..f8b0221055e4a 100644
--- a/drivers/pinctrl/intel/pinctrl-intel.c
+++ b/drivers/pinctrl/intel/pinctrl-intel.c
@@ -1543,7 +1543,6 @@ static int intel_pinctrl_probe_pwm(struct intel_pinctrl *pctrl,
 		.clk_rate = 19200000,
 		.npwm = 1,
 		.base_unit_bits = 22,
-		.bypass = true,
 	};
 	struct pwm_chip *chip;
 
-- 
2.39.5



