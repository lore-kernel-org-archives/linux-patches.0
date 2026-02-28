Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F42834252B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301695; cv=none; b=EeFE4RtEThtSHoOnQzVJIAt0k/KNls6u4SrGJUMcfjyI5OBI720loavuO1g2mEpva6HmC5jUERyIVB7hp7GZWMd3iLipBZ3TSDy18c8bqBzaBZ4QgYQECE2gY75MrfXGtVVbina/9jheNMsf09PcYStaq8CSd1svFfKcM0AQWYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301695; c=relaxed/simple;
	bh=RSl8P1d+iWdlJoDhcQTIXWhPOuhg7YK2eHJIecdQaXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vB+yBC/lQgmGr8uSSBn2vFcZdY9L2XRk48pur923v1f9KFsGYOJv3WgKPrCXdzg8oHZbdUwHF/R+ODSRfKuBUDCYHdRl8qpt3L056ugT3aFDCoMcVw9DaORkV+vg7jCo4qEEGB2L9Q/oD7wPxieqDE1LEANa9RqsRyygSW0lo3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i2UPJSkZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i2UPJSkZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760F9C19423;
	Sat, 28 Feb 2026 18:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301694;
	bh=RSl8P1d+iWdlJoDhcQTIXWhPOuhg7YK2eHJIecdQaXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i2UPJSkZ9/8Y38rqt5VL8hUd1sVgm6loO6izu3H9/hRjKBvrQ5doLSq0LRW3YZilS
	 P6imSfLfjGyO3F8Z+0rHHukTnXRA/o4vOA6SvS/o856ehYaPyCZlv6joOZe65fVy3d
	 Q4F7o+CwnlFaMq5F9KPjFk7TRTBz+5bLT3rqY8vnNAOXCzfZnLld9TjbtusbxQYpRh
	 bCsFu3ey3y+JbjLljfL1n7y+xLuoEPpXDHVp1+n8ZdYyDu4OV4SFn2Dhun9jaaZIRn
	 hEBTNvnClldTxYXWQDD6A8AZdvOBmTLzjb8Uo0ZvCQ4XSE+f6xht+X3kajcvHCkzZQ
	 kD/MCHN/Y4GNg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Titouan Ameline de Cadeville <titouan.ameline@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 086/385] fs/tests: exec: drop duplicate bprm_stack_limits test vectors
Date: Sat, 28 Feb 2026 12:55:08 -0500
Message-ID: <20260228180011.1568201-86-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Titouan Ameline de Cadeville <titouan.ameline@gmail.com>

[ Upstream commit 46a03ea50b5f380bdb99178b8f90b39c6ba1f528 ]

Remove duplicate entries from the bprm_stack_limits KUnit test vector
table. The duplicates do not add coverage and only increase test size.

Signed-off-by: Titouan Ameline de Cadeville <titouan.ameline@gmail.com>
Fixes: 60371f43e56b ("exec: Add KUnit test for bprm_stack_limits()")
Link: https://patch.msgid.link/20260203175950.43710-1-titouan.ameline@gmail.com
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/tests/exec_kunit.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/tests/exec_kunit.c b/fs/tests/exec_kunit.c
index 7c77d039680bb..f412d1a0f6bba 100644
--- a/fs/tests/exec_kunit.c
+++ b/fs/tests/exec_kunit.c
@@ -87,9 +87,6 @@ static const struct bprm_stack_limits_result bprm_stack_limits_results[] = {
 	    .argc = 0, .envc = ARG_MAX / sizeof(void *) - 1 },
 	  .expected_argmin = ULONG_MAX - sizeof(void *) },
 	/* Raising rlim_stack / 4 to _STK_LIM / 4 * 3 will see more space. */
-	{ { .p = ULONG_MAX, .rlim_stack.rlim_cur = 4 * (_STK_LIM / 4 * 3),
-	    .argc = 0, .envc = 0 },
-	  .expected_argmin = ULONG_MAX - (_STK_LIM / 4 * 3) + sizeof(void *) },
 	{ { .p = ULONG_MAX, .rlim_stack.rlim_cur = 4 * (_STK_LIM / 4 * 3),
 	    .argc = 0, .envc = 0 },
 	  .expected_argmin = ULONG_MAX - (_STK_LIM / 4 * 3) + sizeof(void *) },
@@ -103,9 +100,6 @@ static const struct bprm_stack_limits_result bprm_stack_limits_results[] = {
 	{ { .p = ULONG_MAX, .rlim_stack.rlim_cur = 4 * _STK_LIM,
 	    .argc = 0, .envc = 0 },
 	  .expected_argmin = ULONG_MAX - (_STK_LIM / 4 * 3) + sizeof(void *) },
-	{ { .p = ULONG_MAX, .rlim_stack.rlim_cur = 4 * _STK_LIM,
-	    .argc = 0, .envc = 0 },
-	  .expected_argmin = ULONG_MAX - (_STK_LIM / 4 * 3) + sizeof(void *) },
 };
 
 static void exec_test_bprm_stack_limits(struct kunit *test)
-- 
2.51.0

