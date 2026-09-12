Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3DF37C118;
	Sat, 12 Sep 2026 09:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205309; cv=none; b=q2uKCHCv0v7F3FmCTkE3kZdWfrmfi/I7+PsWDUatUPTpGxbo/r7aGQpO5ITkHEOareD6Z6AhgrMnDKs+GE+0HqCNuQOom9g06Ir6oyldRxC2yXnWqvJF/FXWCiYiE189MsBEGfYYoikvuwYjmuS1+VUHtyPInmDkkGYvyRFQDrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205309; c=relaxed/simple;
	bh=4y3M75QhFPIH0RqcWMwXxlcnq3E8o5P3Dfb/YnC/lmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=juAhprihO8ApjAK4qIgGt4t+96htwVm3WCMyJYWkxMAz9lzToM9UZ3SsCJBDF9bflzDrhg0Y+yWCKIdBWrJ7W8xYO5vgArhNo/BASWTM+VEsjjEMykKxoDYVKJXHk79VEiUj0rNtcpHGywRob92pnerEmoKBesZRVjmRcJlILzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yH2o6v87; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yH2o6v87"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0CC71F000FF;
	Sat, 12 Sep 2026 09:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205307;
	bh=yaD70DGPNBH/gHz8KLFwSxeUpfSdkt6EfSCZxCMymFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yH2o6v87zSMzwkN36LWcl8iQsfdiJ/0apbEwtndVewuIM/GAFeu5UsyaZG7GpEI8I
	 EhmImj90LrPqIMuCXaBIi8zpc/x0LYd+QAyxFovn5z+/t7OEBZcF291ZYgqkpNh63W
	 jVpAwMlpyA8TrXzkkKStDofwTzMNA36aa8+jAQrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1792/1815] selftests/arm64: Fix MTE prctl TAP plan
Date: Sat, 12 Sep 2026 08:59:02 +0200
Message-ID: <20260912065731.104338494@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Usama Anjum <usama.anjum@arm.com>

[ Upstream commit bb52892f9234e4ecd982fa51222aab33ce282f79 ]

The MTE prctl test emits one result from check_basic_read() followed by
one result for each of the seven entries in mte_modes[]. However, the TAP
plan only accounts for the array entries, producing:

  # Planned tests != run tests (7 != 8)

Include the basic read check in the plan so that all eight emitted results
are declared.

Reviewed-by: Mark Brown <broonie@kernel.org>
Fixes: 1f488fb91378 ("kselftest/arm64/mte: Add MTE_STORE_ONLY testcases")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Reviewed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/mte/check_prctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/arm64/mte/check_prctl.c b/tools/testing/selftests/arm64/mte/check_prctl.c
index f7f320defa7b9..d16a91117eef9 100644
--- a/tools/testing/selftests/arm64/mte/check_prctl.c
+++ b/tools/testing/selftests/arm64/mte/check_prctl.c
@@ -119,7 +119,7 @@ int main(void)
 	int i;
 
 	ksft_print_header();
-	ksft_set_plan(ARRAY_SIZE(mte_modes));
+	ksft_set_plan(ARRAY_SIZE(mte_modes) + 1);
 
 	check_basic_read();
 	for (i = 0; i < ARRAY_SIZE(mte_modes); i++)
-- 
2.53.0



