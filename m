Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0453B7763C;
	Tue, 23 Jan 2024 02:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975518; cv=none; b=blEjgcCnpZIWTEmDYEkobF9GD4FDq4cVKoV8600aJKW75TFyYxM42YjVo8k090qMgPjafj3QWWqXy+uuM7cxoNO0gyT3/w7tdHQeRACVE8MOsuvUxWpxOmdSDhWzZoZIpmU3nz5Slwc8pAeo6BytftV17W3e9s+/iDd7gZt/uS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975518; c=relaxed/simple;
	bh=NumcpoOgHH6Tq+ds25PFRjc2Lmk9VwGE0WpiSNqA27o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W9xKDxA7S7iHVPDC9TxlamT/WZL/MavCZp6Aajl9yEZdnam5io+pVwRkRYrwPylIHHxBYTGV/f4MiPejFK9Tw4I78S5GG1BjinccRTlpW4+FBw798cEiURnnKpWa7fjIJzdVpDZFLGJY/OndIYeeGzF8H6+CfivKJpD3jQ9rsRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RMvnBx1g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RMvnBx1g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD8ECC433C7;
	Tue, 23 Jan 2024 02:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975517;
	bh=NumcpoOgHH6Tq+ds25PFRjc2Lmk9VwGE0WpiSNqA27o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RMvnBx1g+6Nl33RlQQdDfdjzuGYcSd490VLRiBdCtFy8HM6o3LqcdIMP8YT2J5KuB
	 zB6JVkUMJR/KqKwrHXnhpUV/bDtm2QwUkNe0B8ldb5Iorb2kkUBfFmjyURA3gWRPWG
	 +qUAmUhjeb6/s2UIjbqw5o8cq9Lp1nBLqMv3O+HM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Alex Vinarskis <alex.vinarskis@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 444/583] mfd: intel-lpss: Fix the fractional clock divider flags
Date: Mon, 22 Jan 2024 15:58:15 -0800
Message-ID: <20240122235825.565161679@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9591b354072a..00e7b578bb3e 100644
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



