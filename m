Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073059448
	for <patches@lists.linux.dev>; Tue, 12 Sep 2023 17:55:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A31C433C8;
	Tue, 12 Sep 2023 17:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1694541335;
	bh=rrwYR3/rqDwXPIcEZV4/pnPLM7oE/aWqYDmNh+JXXaA=;
	h=From:To:Cc:Subject:Date:From;
	b=mboLiXQHP0KBMCCt14sMYW/+pIam/h/U7/xcobZ6lEqrEw993BhQD+cDrERdJRs4R
	 Cz+Opgs5wXVQEPUMxCKIRZYuZ+EzImcwDVA9bhEsz9u9atUquoxR2HEhAmit5Do77P
	 24YFu98YvPZJBvw1q+1LhYX/Le/pLGO/TOmqEBVQe904avvh1nKq17kOi9F2TAYOv6
	 0AM10A9qEStnIGYJldEHDyhR1zqeesqNsYeMRisrJ5gSJX6bYjdkvz/8uaD0si/SF+
	 QKOvPCgr+SbkEq41pqpgohXL1FsDCuQeH54aitsYYStDkOVVxbz0RlpSediS2EB5c2
	 EatiPcArOHtLA==
From: Stephen Boyd <sboyd@kernel.org>
To: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Maxime Ripard <mripard@kernel.org>
Subject: [PATCH 0/2] clk: Fix lockdep warnings in clk_test
Date: Tue, 12 Sep 2023 10:55:29 -0700
Message-ID: <20230912175534.2427862-1-sboyd@kernel.org>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is a replacement for the series from Maxime[1]. I didn't want to
introduce more wrappers, so this series takes the approach of driving
the test from a clk_op instead. The second patch extends the test to
look at more determine_rate variants. We can probably extend the test
further to set or not set the CLK_SET_RATE_PARENT flag as well but I
didn't do that.

Stephen Boyd (2):
  clk: Drive clk_leaf_mux_set_rate_parent test from clk_ops
  clk: Parameterize clk_leaf_mux_set_rate_parent

 drivers/clk/clk_test.c | 130 +++++++++++++++++++++++++++++++++++------
 1 file changed, 113 insertions(+), 17 deletions(-)

Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Maxime Ripard <mripard@kernel.org>

[1] https://lore.kernel.org/r/20230721-clk-fix-kunit-lockdep-v1-0-32cdba4c8fc1@kernel.org

base-commit: 0bb80ecc33a8fb5a682236443c1e740d5c917d1d
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

