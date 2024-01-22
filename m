Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9282412FF73;
	Tue, 23 Jan 2024 01:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971811; cv=none; b=BzK9zqBAGO0MRH+cGbPCOgXJGglxUWtoR5R0ilF2Lp5R/uL8moaFwa+TaMczIumRtEbe97K4afPnN+LrKhziT6sP9KQyV3TpdzssEUQ8jaPEuYuNSKTgTQ8rssfdogvlH67kIsdgz5OBC15CtHTl756oRH00R/6lQBuSb8m4GhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971811; c=relaxed/simple;
	bh=HaZ1XnX2iZJAw/2Y80mPzDiwUu8uiG+NvGB+CHo4CR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fx2IIM2mEJEuyvmugqC2X6S9bh59K0057LfWSUF8v9GfrEDkfSUHq6NKn635nahyzZXUBO8HKzH7G7opBl7l52SGyaNxb+jJvq/8ZDCHGa24RveBfyuz0IsBgMJQOwPvCvz14Op7hnNd+ehggP7NnW0XiGTc71FKHeQtf6wgQng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qu+SXY75; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qu+SXY75"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C42EC433F1;
	Tue, 23 Jan 2024 01:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971811;
	bh=HaZ1XnX2iZJAw/2Y80mPzDiwUu8uiG+NvGB+CHo4CR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qu+SXY7542i090N7xXyKP0mSoami+x7Qg22DAGScKgmKHgOTHJFQssXFT005zAgQq
	 y+mh3akqpDHdbCITqMHZ1GIbUcnL3y6MSjF4Q+fSdw4wWzWtdpERbGUu7x0s4u3nVX
	 m3zAuNyUMulSxdAbRyfRvxVjaWFmMWFwKhM0PbJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Alex Vinarskis <alex.vinarskis@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 326/417] mfd: intel-lpss: Fix the fractional clock divider flags
Date: Mon, 22 Jan 2024 15:58:14 -0800
Message-ID: <20240122235803.094243142@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit 03d790f04fb2507173913cad9c213272ac983a60 ]

The conversion to CLK_FRAC_DIVIDER_POWER_OF_TWO_PS uses wrong flags
in the parameters and hence miscalculates the values in the clock
divider. Fix this by applying the flag to the proper parameter.

Fixes: 82f53f9ee577 ("clk: fractional-divider: Introduce POWER_OF_TWO_PS flag")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reported-by: Alex Vinarskis <alex.vinarskis@gmail.com>
Link: https://lore.kernel.org/r/20231211111441.3910083-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/intel-lpss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/intel-lpss.c b/drivers/mfd/intel-lpss.c
index cfbee2cfba6b..c50387600b81 100644
--- a/drivers/mfd/intel-lpss.c
+++ b/drivers/mfd/intel-lpss.c
@@ -301,8 +301,8 @@ static int intel_lpss_register_clock_divider(struct intel_lpss *lpss,
 
 	snprintf(name, sizeof(name), "%s-div", devname);
 	tmp = clk_register_fractional_divider(NULL, name, __clk_get_name(tmp),
+					      0, lpss->priv, 1, 15, 16, 15,
 					      CLK_FRAC_DIVIDER_POWER_OF_TWO_PS,
-					      lpss->priv, 1, 15, 16, 15, 0,
 					      NULL);
 	if (IS_ERR(tmp))
 		return PTR_ERR(tmp);
-- 
2.43.0



