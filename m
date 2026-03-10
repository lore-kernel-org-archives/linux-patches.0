Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B5638A703;
	Tue, 10 Mar 2026 11:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142221; cv=none; b=FFWOfeWkw2Z8yY5zs9HmJwvC19Hcak/QkTv7DzezafaQyHMk2cTo+R5j0nycLtKKEN5dNf+KkRzbxOCD4SGvJVT8EQbWemdRF2qk5YCCyKzsbVczvN9pkyWtSI0EzbrCcwpEM1/O/epsGSrtxqnGhYnc5tDCWKo5UJvyLsBA1i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142221; c=relaxed/simple;
	bh=rrmlssb7rNi89FLN6SNMBAI+aR0lgjYEd3d+uy9b+Ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ELcVNue6s1kk5fstktmhuXEwv3ucdZbH4lGrwoG1Pa5xu6lb5wYzwnmefr4HMp2HCFa5cth2j5OFAEVG6r/vFJYVk+r7vOf9mejbr74BofL627Q5d4K+/ag8JW6An0ZPp+HKDp+zkN9/KGys6d1JBFvDdNZwq/TrloaETA1D8P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HYYHdgnu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HYYHdgnu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D7E9C19423;
	Tue, 10 Mar 2026 11:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142221;
	bh=rrmlssb7rNi89FLN6SNMBAI+aR0lgjYEd3d+uy9b+Ns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HYYHdgnuXWGxtbgjEQ/H2fjvmOLHuOIFR4QG15mCJSbqm0eTIRgk3Xqy1TMQjT2oK
	 oGK3IFzemlZb+rwCPcKpuTUR0/Eq+VZk+gl7A8ful9uJs8WSKfq2fkkOOeLGizCMSr
	 1uI+3s6EljkaOOiiMnZtOLB8rtW9o946S95dAH1h1uN6wod9PFXdP6GsQAqy5Iejx5
	 DBMUW5SgsJUw3gAOORNQv51ipgismudH7rV/DxHhmZ/m+g4Yfj19d9XPC77D1aiZ5K
	 xLZK+3LLEMt/k+ZesRuuJCzk3GBGHnLHLZb5LMZzY38t/jTp/f/2gT9UaRID7hc5ZT
	 xWNs/8bOuFWGA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yifan Wu <wuyifan50@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 311/314] selftest/arm64: Fix sve2p1_sigill() to hwcap test
Date: Tue, 10 Mar 2026 07:19:30 -0400
Message-ID: <8d186d6e6f08c2c5591cac0b70dc55d3e3185679.1773141556.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Yifan Wu <wuyifan50@huawei.com>

[ Upstream commit d87c828daa7ead9763416f75cc416496969cf1dc ]

The FEAT_SVE2p1 is indicated by ID_AA64ZFR0_EL1.SVEver. However,
the BFADD requires the FEAT_SVE_B16B16, which is indicated by
ID_AA64ZFR0_EL1.B16B16. This could cause the test to incorrectly
fail on a CPU that supports FEAT_SVE2.1 but not FEAT_SVE_B16B16.

LD1Q Gather load quadwords which is decoded from SVE encodings and
implied by FEAT_SVE2p1.

Fixes: c5195b027d29 ("kselftest/arm64: Add SVE 2.1 to hwcap test")
Signed-off-by: Yifan Wu <wuyifan50@huawei.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/abi/hwcap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/arm64/abi/hwcap.c b/tools/testing/selftests/arm64/abi/hwcap.c
index 3b96d090c5ebe..09a326f375e91 100644
--- a/tools/testing/selftests/arm64/abi/hwcap.c
+++ b/tools/testing/selftests/arm64/abi/hwcap.c
@@ -473,8 +473,8 @@ static void sve2_sigill(void)
 
 static void sve2p1_sigill(void)
 {
-	/* BFADD Z0.H, Z0.H, Z0.H */
-	asm volatile(".inst 0x65000000" : : : "z0");
+	/* LD1Q {Z0.Q}, P0/Z, [Z0.D, X0] */
+	asm volatile(".inst 0xC400A000" : : : "z0");
 }
 
 static void sve2p2_sigill(void)
-- 
2.51.0

