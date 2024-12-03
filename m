Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884FA1DE8A5;
	Tue,  3 Dec 2024 15:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241421; cv=none; b=edJlJ6XD4hvT55ciByRoSDvqFTYvUHIEYZGObP1rtM7tvhfNMNFqnL2UjShbR/iW7M3JiZrUSSVOEP2i8gQtY5ECmwFrcrVNRE9fA2u/LDVvkO/ihABbpx/v8i9JcI8JnL1yq6CBd/OGNn2zXFyuzb+6PUvYzL8NNRhNSo1T6jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241421; c=relaxed/simple;
	bh=H4FYbATxyIzIaG4z2Qq9+JnBHKDJv+XiA+6fjkIWe4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ExwLzNh2StuAkj4cXtxXdBr/1sBw/SJ9FoFHj5XNteWTzJpv90QseEZJemGGukRyMWpIvNYR1hDNI35rJbFOPMdcgx9S3FQZNE5mHmfixY28Vz/q9Gd80YxdWerhN1uUuLed2e4vh18sq1XcmK0cjWrecLjRX5nlBiVtA2NxQh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e2E/IoKo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e2E/IoKo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B2B4C4CECF;
	Tue,  3 Dec 2024 15:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241421;
	bh=H4FYbATxyIzIaG4z2Qq9+JnBHKDJv+XiA+6fjkIWe4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e2E/IoKo0PqVHK+A/amH/AKxj26Kw3djxHs1Xs8EaV7mxVpq7loMws8GkyiFLhRvN
	 bIUdRRtFfIEZZZGJw0GraCkYEYOFKkgxydaV0cTIdzZbueQ90Sr5eTB6JIcQM6EGsf
	 OA1ckGV/mu9c0KY6PhF/YkXr0O1hTtbnTL8CIv4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 381/826] clk: Allow kunit tests to run without OF_OVERLAY enabled
Date: Tue,  3 Dec 2024 15:41:48 +0100
Message-ID: <20241203144758.628744574@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Boyd <sboyd@kernel.org>

[ Upstream commit 94e6fdd028a12ff2abe7d915f8b6bbdb923cc04d ]

Some configurations want to enable CONFIG_KUNIT without enabling
CONFIG_OF_OVERLAY. The kunit overlay code already skips if
CONFIG_OF_OVERLAY isn't enabled, so these selects here aren't really
doing anything besides making it easier to run the tests without them
skipping. Remove the select and move the config setting to the
drivers/clk/.kunitconfig file so that the clk tests can be run with or
without CONFIG_OF_OVERLAY set to test either behavior.

Fixes: 5776526beb95 ("clk: Add KUnit tests for clk fixed rate basic type")
Fixes: 274aff8711b2 ("clk: Add KUnit tests for clks registered with struct clk_parent_data")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Link: https://lore.kernel.org/r/20241016212738.897691-1-sboyd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/.kunitconfig | 1 +
 drivers/clk/Kconfig      | 2 --
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/clk/.kunitconfig b/drivers/clk/.kunitconfig
index 54ece92070552..08e26137f3d9c 100644
--- a/drivers/clk/.kunitconfig
+++ b/drivers/clk/.kunitconfig
@@ -1,5 +1,6 @@
 CONFIG_KUNIT=y
 CONFIG_OF=y
+CONFIG_OF_OVERLAY=y
 CONFIG_COMMON_CLK=y
 CONFIG_CLK_KUNIT_TEST=y
 CONFIG_CLK_FIXED_RATE_KUNIT_TEST=y
diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 299bc678ed1b9..0fe07a594b4e1 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -517,7 +517,6 @@ config CLK_KUNIT_TEST
 	tristate "Basic Clock Framework Kunit Tests" if !KUNIT_ALL_TESTS
 	depends on KUNIT
 	default KUNIT_ALL_TESTS
-	select OF_OVERLAY if OF
 	select DTC
 	help
 	  Kunit tests for the common clock framework.
@@ -526,7 +525,6 @@ config CLK_FIXED_RATE_KUNIT_TEST
 	tristate "Basic fixed rate clk type KUnit test" if !KUNIT_ALL_TESTS
 	depends on KUNIT
 	default KUNIT_ALL_TESTS
-	select OF_OVERLAY if OF
 	select DTC
 	help
 	  KUnit tests for the basic fixed rate clk type.
-- 
2.43.0



