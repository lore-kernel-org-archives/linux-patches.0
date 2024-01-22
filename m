Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92EDA64CDA;
	Tue, 23 Jan 2024 00:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971346; cv=none; b=N9NAyUZ+Zjveq7R+Zsb7kOyPytbUXwpuaF0x71gEcv9m26cMNAmmv5+wv/Ku/VbjZtzxoWpjEM91OwgNl5avG9u0GnM1p/rjOOV5uLw/usYxcWw0fwFj3j04f2LF2XxpceIE25Z7mfuLnnfw789U76B35aj4dlRZAFdKj8t9bPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971346; c=relaxed/simple;
	bh=hLi7ReKrZ5MEjr6whDLifj+ZVdZx8N1n4YbuLE3RgJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ra6ayueK7AxBQokE59pW74pdYJJ+NyNelvnHzZGLEbSu7slFBA66c1948i5vKP4/rbXsv6WlPvaAfeO9g3R8hBAXebY/Infs+ghn1G66dxYlmJNoayPlNumbkhiihuVqWRWN7VqPIlXmLncqDxiuNPWlQd8Yw7bJB+vaCVjbubE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C9e81c4W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C9e81c4W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB24C43394;
	Tue, 23 Jan 2024 00:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971345;
	bh=hLi7ReKrZ5MEjr6whDLifj+ZVdZx8N1n4YbuLE3RgJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C9e81c4WeEB/8lwARB+ZDg+bjdXtH2XLZk8BPN0mPOYn+15KBwUvRzvUPeRqle0Lx
	 QYa+DfWKsnVY9+ONm5txc5+bbeh3FHqAJaCcdXIwnTzdBnUgT/OMAWYYeNDEcMrD+p
	 W059ENk25THFLUJw54WHmno2gOloEyg5BB/wUfc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 227/417] clk: fixed-rate: fix clk_hw_register_fixed_rate_with_accuracy_parent_hw
Date: Mon, 22 Jan 2024 15:56:35 -0800
Message-ID: <20240122235759.768221617@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Théo Lebrun <theo.lebrun@bootlin.com>

[ Upstream commit ee0cf5e07f44a10fce8f1bfa9db226c0b5ecf880 ]

Add missing comma and remove extraneous NULL argument. The macro is
currently used by no one which explains why the typo slipped by.

Fixes: 2d34f09e79c9 ("clk: fixed-rate: Add support for specifying parents via DT/pointers")
Signed-off-by: Théo Lebrun <theo.lebrun@bootlin.com>
Link: https://lore.kernel.org/r/20231218-mbly-clk-v1-1-44ce54108f06@bootlin.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/clk-provider.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 15e336281d1f..94fcfefb52f3 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -446,8 +446,8 @@ struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
  */
 #define clk_hw_register_fixed_rate_with_accuracy_parent_hw(dev, name,	      \
 		parent_hw, flags, fixed_rate, fixed_accuracy)		      \
-	__clk_hw_register_fixed_rate((dev), NULL, (name), NULL, (parent_hw)   \
-				     NULL, NULL, (flags), (fixed_rate),	      \
+	__clk_hw_register_fixed_rate((dev), NULL, (name), NULL, (parent_hw),  \
+				     NULL, (flags), (fixed_rate),	      \
 				     (fixed_accuracy), 0, false)
 /**
  * clk_hw_register_fixed_rate_with_accuracy_parent_data - register fixed-rate
-- 
2.43.0



