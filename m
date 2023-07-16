Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29FD8F5D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:41:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65CAAC433C8;
	Sun, 16 Jul 2023 20:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540073;
	bh=GF7garfkVz2ofUvqBzFL9Hhc4p1ABazuqJgAzXxmy5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cqbXZk+tYkwHoA6G6qRhlhWy3ZIAoNz7fPMWa2mKcxc/9f9e+hvDMlVCBHPVDRIkU
	 C+DRx4hkxW8pvO39FpXrgD7Yx7SmNUyZvwQ5wneenhtm6nKS9wrbXcFYzOhop3Q8Nv
	 fH88tbvguVXzUsDS8FWZg+M+wpA1b6DINcq/mWDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <maxime@cerno.tech>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 234/591] clk: Export clk_hw_forward_rate_request()
Date: Sun, 16 Jul 2023 21:46:13 +0200
Message-ID: <20230716194929.926804001@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit ed046ac74da0b5602566073023a1519b5ae657b7 ]

Commit 262ca38f4b6e ("clk: Stop forwarding clk_rate_requests to the
parent") introduced the public clk_hw_forward_rate_request() function,
but didn't export the symbol. Make sure it's the case.

Fixes: 262ca38f4b6e ("clk: Stop forwarding clk_rate_requests to the parent")
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20221018-clk-range-checks-fixes-v4-1-971d5077e7d2@cerno.tech
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 57b83665e5c3a..d4a74759fe292 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1525,6 +1525,7 @@ void clk_hw_forward_rate_request(const struct clk_hw *hw,
 				  parent->core, req,
 				  parent_rate);
 }
+EXPORT_SYMBOL_GPL(clk_hw_forward_rate_request);
 
 static bool clk_core_can_round(struct clk_core * const core)
 {
-- 
2.39.2



