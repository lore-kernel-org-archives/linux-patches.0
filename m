Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6832C4E1AD;
	Tue, 23 Jan 2024 01:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971626; cv=none; b=DIk9hdSfQAoLMhQTrzesG+1vFwRDz2toSiRirSJ9ZnsEeuGwiE6DDC3Nw9vUgXz/nPxU6UyvbAI9MLMeH7wUwBkz2osJfW8HGOZ77fpbNKd2nGoKG4zaIpv4q5WYUsOhANNZ042Y4uq9rihHKt5lrP/qgA0yxFsEFGEBNP6y7XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971626; c=relaxed/simple;
	bh=jc7j0ggAkd2cP3evenRSycxGSVMytnEwI/IkUpXO9JE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HKG8xpCrhv7KKfX+EltHMSqphWWUsdFSuGeFoVzfMtw2weP/Z1D0zBcPDNyxshCwSuCAmZwkr+NZ0hI3XCona34frqcF1udYbasFXO3enV3r3jwsg0HsYFQNq0EZS/ypyMBrP04ELqJbBb8XaIAW77dN/omYLwUHGXIb2txLoMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dxOFZn9r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dxOFZn9r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F052CC433C7;
	Tue, 23 Jan 2024 01:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971626;
	bh=jc7j0ggAkd2cP3evenRSycxGSVMytnEwI/IkUpXO9JE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dxOFZn9rEA7XQwnZUP0qo3NS5K5BvE/B9aq7G+NcDNbiKXVU4zlI8ihZ+fhqZjAQY
	 u+zxQJsypcbzatmKTt/wAH3wNhPtZdKh+x80+h1DeMS3VLxwPld2lwbRayFeDpdnfB
	 j2OtcW36zQ0C23cAXllqjz/08c/1Zdmlyfu7JcpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 188/286] clk: fixed-rate: fix clk_hw_register_fixed_rate_with_accuracy_parent_hw
Date: Mon, 22 Jan 2024 15:58:14 -0800
Message-ID: <20240122235739.368847921@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 76f02b214f39..6fa85be64b89 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -434,8 +434,8 @@ struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
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



