Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E141AAA32;
	Tue,  8 Apr 2025 12:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114679; cv=none; b=h1Od5uWqYSOS8HjS6NXcDkk4ZRZwAyakasf/Hr0ezHsQhBPgdlKbtAvdPS4LUVNlXP5fgVV6xuCTiLTP5r9A8j2QsopdUrknjCS24GAEopot0fFWFZ8Al/W1joWxgBgr3v/wZ8apElkuudnC+JREiUEZmKWJY5/v09LIUNpWPEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114679; c=relaxed/simple;
	bh=MTVBqypxOzPu5jVV9T4/E11MS1Mrf75A102UlzBcaVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gzT5h81XjWyRWXxwerrhZW1RMRV6An07i0A9uiyMysKTM1qS/x/tz0uUIrEAKMSTDjkEVdx40HKMcKWuDnhSyObZ/r6mMlq82EkwYccSJHUpOPVp9fGSBYdoOdMprGd23lhCAXamFYnyrhdWd6j5BpMdSUp2mvGKUUXfHETj56Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ovR6+gYO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ovR6+gYO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6005C4CEE7;
	Tue,  8 Apr 2025 12:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114679;
	bh=MTVBqypxOzPu5jVV9T4/E11MS1Mrf75A102UlzBcaVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ovR6+gYOXLuuEUACOvsIzBxdbcjfu3NZW+W9fjBRA3WTp2KTuS+p7jUWFnfDMaUEg
	 9RjJhUPxSuPgXhBqRrf5o5732Uc88vNCBiQq0j3w5dgsBSHCMUrDUMVIlLYvokNj72
	 s2EThWBjFQhJVZU4lrZGbz+wZ+eZ883M1lRy1os8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexis GUILLEMET <alexis.guillemet@dunasys.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 195/499] pinctrl: intel: Fix wrong bypass assignment in intel_pinctrl_probe_pwm()
Date: Tue,  8 Apr 2025 12:46:47 +0200
Message-ID: <20250408104856.051464390@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



