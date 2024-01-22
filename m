Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2082B5FDAB;
	Tue, 23 Jan 2024 01:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974642; cv=none; b=PFaGBZp0f5J+NrpVlpi5baG8WGMDtU5RRdufRq3G/N9btctAPkSzzBnZG5bRKfvzYZpC61KI6Rmft+GmQqtL8xwPLJwwmDzl4rIghcEw1wKw9GcEAJ8Ak8fZBHYoq1h7cdEUzKsTN+koAAPL0Gv51JVq1ZzCxEhJWcZ/7oUPxvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974642; c=relaxed/simple;
	bh=1TYCCYOnwqU63Zq02rdGoGwhZSeUB8JEd47No2RQ/NQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kggawyh78mBItd8rOWMuCDWmf2SM/x3GdCNRb2WCNg6h6R3clOn85Foao4I6xPf3IGL3ziL2tgW1VIeexuhEC/FFyMBSLYnQrrofppk6wLKgvEFD7QPRngO1qf6mHIkL9TwREA6wS/rQCPOo3xJbjyKsh7qBE3ApUm4RD59qENw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PL5QAwht; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PL5QAwht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D50DC43399;
	Tue, 23 Jan 2024 01:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974641;
	bh=1TYCCYOnwqU63Zq02rdGoGwhZSeUB8JEd47No2RQ/NQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PL5QAwhtY+CimX5XdGU6AzxkLimMEH1D82+Xtkv/oZmrJdfPuUYO/erifyZ+aX2yJ
	 JFLt4sm+wfzefzH5tP7ahPOwth3xXLy5oYC2b0QoJmZFZdc0XHGWrNPyug3/IdLQ8o
	 YHLcycqLcYskm3KynPJg6ve2NYbgVvvyFj01tX0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 226/374] clk: fixed-rate: fix clk_hw_register_fixed_rate_with_accuracy_parent_hw
Date: Mon, 22 Jan 2024 15:58:02 -0800
Message-ID: <20240122235752.558025862@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 43e177b3a4d3..6cace09ba63d 100644
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



