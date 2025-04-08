Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57FCD269B08;
	Tue,  8 Apr 2025 11:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113284; cv=none; b=bphlXY9+wgqT00OtyFhYWHceNV6ueE3Dh+oU2aHhuaRfVPcaE4RbJcWKOuItmfCCNmZ9VRZ6ewu4E4Xg6VMJ7K5XEqaUsJCyCUBTblE6oXwddI9SYu51lLYDAycC8xoQpIOOLWZ0ly3Dnu0jh3UMjsiB6+1FGHLA+RGUJ7LAGe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113284; c=relaxed/simple;
	bh=SaMr5vFRYbrzORpLFF1lhAIlZjbP6P9hX6vxRP2PaZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QMrRK894TmcQZtqnkYCuZt51pa0yVttK/+1KgohajHtKrP3BbojcNVz57BZwoxunPDp5OGeOHJtstZN9ayuYP6MaGhnt/uM9xELZJy0k3yoj0BoFjZq0fdBw+517ECYijf4Uc8QXVx/H0Wn/XSY/5dqTCVFrAfpgZxvDRYuAwY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wbtn5/eY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wbtn5/eY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE60C4CEE5;
	Tue,  8 Apr 2025 11:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113284;
	bh=SaMr5vFRYbrzORpLFF1lhAIlZjbP6P9hX6vxRP2PaZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wbtn5/eYGfVvfW4kHn0tMXjXV56Pej4dimpUWxRxUo1l8hQ8+zRs/xIayTUAJ6q2s
	 0LlgtnX4y56ME/hqoHpXxQW9neUEny368BuZofiNqwiCMbNzEOawyUTbytlzRZUjVY
	 IC1fj5iDK794FdlvUrhxxVvd5FEUbNEcMjzpuDpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexis GUILLEMET <alexis.guillemet@dunasys.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 101/268] pinctrl: intel: Fix wrong bypass assignment in intel_pinctrl_probe_pwm()
Date: Tue,  8 Apr 2025 12:48:32 +0200
Message-ID: <20250408104831.219348212@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3be04ab760d3f..9775f6be1c1e6 100644
--- a/drivers/pinctrl/intel/pinctrl-intel.c
+++ b/drivers/pinctrl/intel/pinctrl-intel.c
@@ -1524,7 +1524,6 @@ static int intel_pinctrl_probe_pwm(struct intel_pinctrl *pctrl,
 		.clk_rate = 19200000,
 		.npwm = 1,
 		.base_unit_bits = 22,
-		.bypass = true,
 	};
 	struct pwm_lpss_chip *pwm;
 
-- 
2.39.5



