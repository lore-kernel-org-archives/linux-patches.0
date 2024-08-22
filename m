Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0763F6FB9;
	Thu, 22 Aug 2024 00:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724286275; cv=none; b=JhhVsRLlOl+drKpSZZzrTkbhpmMJHsAe9zIVA95O52ZX5BZ5rwKyYgDwJMzcNYApvxB6Fa0XcWGeCvHERyPjo4swnq/hzV08/pkslJlgo93Aw2+ENIcUhiR9cmHqt5J1olJm71rDGQXZszl1WcN/KRko7kdZkGKIEyHcEC2DUuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724286275; c=relaxed/simple;
	bh=8ZtfgYLUKOcsfIJw9GLcrjUrcszWoLOa8hE3abm8uEE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tQS8v0TVkarflJeCNXYv9hUmWRrg9hi48OyXO2Y2GY3cUd8/Av+Cu6KaFv+2qLVrA3U0hIIlUT/SOfQ0hItrRDKaGwCD+upgTDjm4+iqtX2Yf+KiObHeFEZxqJPZyIkoHr3MrqC7uBwZp5VlCXnnVZyY6JO0prFQM2ve9ivirrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RtwlE1mz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RtwlE1mz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 271C1C32781;
	Thu, 22 Aug 2024 00:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724286274;
	bh=8ZtfgYLUKOcsfIJw9GLcrjUrcszWoLOa8hE3abm8uEE=;
	h=From:To:Cc:Subject:Date:From;
	b=RtwlE1mzYPZ+lF43mWERnPpsGlNpwJ4aTHXUbJIR6PkOAOHkxtSvk/YgNXFvIIv4C
	 cLuCzNOp6SkrFxjGxjCbe8cypHzsRDGHm7BxHlFKFSx3HGWcFtMnrg7e7YTap1xNT5
	 J2lsMHTL2r+bpWiVzlrdkbcVcJY/GsA1zoJJ7Hk7yk6osIip5vEdSHVJ18yXBNXby/
	 QHQpVSiA904US7xkyp82nCMkgQGTOqTMS3hnh8dP5QEanoydk0/IAOdeKEB02ZVtZB
	 cDU5RD0GlTpAZqLlN6+L4VOuQ7GLdfStps8MIXhSONdmjWwktWVDlMQJrBbjcZ7HQw
	 +Tbm4xw6jZdzA==
From: Stephen Boyd <sboyd@kernel.org>
To: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org,
	patches@lists.linux.dev,
	kunit-dev@googlegroups.com,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Rae Moar <rmoar@google.com>,
	Peng Fan <peng.fan@nxp.com>
Subject: [PATCH 0/3] clk: test: Test clock-assigned-rates{-u64}
Date: Wed, 21 Aug 2024 17:24:27 -0700
Message-ID: <20240822002433.1163814-1-sboyd@kernel.org>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add some kunit tests for the clock-assigned-rates and
clock-assigned-rates-64 DT properties. I think it may be possible to
crush this down into more carefully chosen DT overlay applications of
properties but this works for now.

This is based on a merge of the clk-assigned-rates and clk-kunit
branches in clk.git

Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Rae Moar <rmoar@google.com>
Cc: Peng Fan <peng.fan@nxp.com>

Stephen Boyd (3):
  clk: test: Add test managed of_clk_add_hw_provider()
  of: kunit: Extract some overlay boiler plate into macros
  clk: test: Add KUnit tests for clock-assigned-rates{-u64} DT
    properties

 drivers/clk/Makefile                          |  14 +
 drivers/clk/clk_kunit_helpers.c               |  30 ++
 drivers/clk/clk_test.c                        | 321 ++++++++++++++++++
 drivers/clk/kunit_clk_assigned_rates.h        |   8 +
 .../kunit_clk_assigned_rates_multiple.dtso    |  16 +
 ..._clk_assigned_rates_multiple_consumer.dtso |  20 ++
 .../clk/kunit_clk_assigned_rates_null.dtso    |  14 +
 ...unit_clk_assigned_rates_null_consumer.dtso |  18 +
 drivers/clk/kunit_clk_assigned_rates_one.dtso |  14 +
 ...kunit_clk_assigned_rates_one_consumer.dtso |  18 +
 ...kunit_clk_assigned_rates_u64_multiple.dtso |  16 +
 ..._assigned_rates_u64_multiple_consumer.dtso |  20 ++
 .../clk/kunit_clk_assigned_rates_u64_one.dtso |  14 +
 ...t_clk_assigned_rates_u64_one_consumer.dtso |  18 +
 .../clk/kunit_clk_assigned_rates_without.dtso |  13 +
 ...t_clk_assigned_rates_without_consumer.dtso |  17 +
 .../clk/kunit_clk_assigned_rates_zero.dtso    |  12 +
 ...unit_clk_assigned_rates_zero_consumer.dtso |  16 +
 include/kunit/clk.h                           |   4 +
 include/kunit/of.h                            |  14 +-
 20 files changed, 613 insertions(+), 4 deletions(-)
 create mode 100644 drivers/clk/kunit_clk_assigned_rates.h
 create mode 100644 drivers/clk/kunit_clk_assigned_rates_multiple.dtso
 create mode 100644 drivers/clk/kunit_clk_assigned_rates_multiple_consumer.dtso
 create mode 100644 drivers/clk/kunit_clk_assigned_rates_null.dtso
 create mode 100644 drivers/clk/kunit_clk_assigned_rates_null_consumer.dtso
 create mode 100644 drivers/clk/kunit_clk_assigned_rates_one.dtso
 create mode 100644 drivers/clk/kunit_clk_assigned_rates_one_consumer.dtso
 create mode 100644 drivers/clk/kunit_clk_assigned_rates_u64_multiple.dtso
 create mode 100644 drivers/clk/kunit_clk_assigned_rates_u64_multiple_consumer.dtso
 create mode 100644 drivers/clk/kunit_clk_assigned_rates_u64_one.dtso
 create mode 100644 drivers/clk/kunit_clk_assigned_rates_u64_one_consumer.dtso
 create mode 100644 drivers/clk/kunit_clk_assigned_rates_without.dtso
 create mode 100644 drivers/clk/kunit_clk_assigned_rates_without_consumer.dtso
 create mode 100644 drivers/clk/kunit_clk_assigned_rates_zero.dtso
 create mode 100644 drivers/clk/kunit_clk_assigned_rates_zero_consumer.dtso


base-commit: 76eb1b6085c2dbae07d584536fe6b1e06245da6a
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

