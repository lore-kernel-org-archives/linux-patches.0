Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C816A352;
	Tue, 23 Jan 2024 02:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975353; cv=none; b=OY2/uZeHjH1+DfFK1Z7R9JNWRKjh6qjmUnecW/7dtg+ZFueKSwrAVbGNpXWRKta+TYbFYo7VDebdWLwaLUWcOnV1wsn0gKMxkLx+Vm9b5MC2gVtonwdEQ0rhSKMNH0EdMOJa09CObxDMMh8oJRwRfW3MinIYw9qLFgFGBvvHUbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975353; c=relaxed/simple;
	bh=BwffI4f7ZNhuqRLHTswFHMPIzj7g/xH28/cG/8ec1EI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X9x0w/L88NlYcD1XMUEx/d5h5QJQB0AsNIMXk3zLqWCihJsnJNlgq2pvNNWKV3g1pXv0UhJMF8dvBJu75C/o/bgZOC6HfhfSBWnYB1cgtuURIeiz3CIMcwt+Te5+n1/PyuV/3imrHdN4rgu9rvJ2LlAtf/MRebKS/RXk8u1DsQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BcNBhvqv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BcNBhvqv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F08FDC43390;
	Tue, 23 Jan 2024 02:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975353;
	bh=BwffI4f7ZNhuqRLHTswFHMPIzj7g/xH28/cG/8ec1EI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BcNBhvqvuGCUF/FjCTYD3kINxT2SoO34NvZw0eKks+bS0M9o/wLQMkE4RgZ7sJBNI
	 Pq8DnPnjFiiyJkk9z73NE1bWJWNxUbmy6DaVDqdos3MbVvgoH0wlKydFTmVsK4Jmt/
	 BlZoGfWzRhwx/wQ1M2DfXn4XfygqTKsaz1aMbuOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 315/583] clk: fixed-rate: fix clk_hw_register_fixed_rate_with_accuracy_parent_hw
Date: Mon, 22 Jan 2024 15:56:06 -0800
Message-ID: <20240122235821.677957225@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ace3a4ce2fc9..1293c38ddb7f 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -448,8 +448,8 @@ struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
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



