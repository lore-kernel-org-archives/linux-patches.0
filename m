Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4F521D596;
	Wed, 25 Feb 2026 01:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982952; cv=none; b=RTMoR04veOxSe1pw1yYY4ZWg9B+HZVzLvyS74wrw7I1W6fBRRN7nGAMPrN2n8jWkHs6v/qcoG29OPaHV5QnCdUry/JlJUmrlLvAIDimGNoVEiRiZp9i9rMW54XrrRBZe4qGtPfhdqVJfxbSmB4KXYUWoM8YffK28y51yjFm16ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982952; c=relaxed/simple;
	bh=15uc0oAC7zpXTM5bqN+Nn8ZpBFWbYLgkcPng1DYud/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U6+PEaa9Gs9sm+kLFHKwEmGU9H5uGbpjEmFhRRhXfydobCX6v0HJecLC5OF8KwXMtoPD4Gq1AQQ8KhWEueFuSdg2qgJY01pl2f1f0TMZN39uz20SJy/lzR/QtzgLOVW9WaNY7XybXGeRCpOIMqAiJ0fmkWeyiPiKfFnh8YSbrMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ES2yb7sz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ES2yb7sz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7D68C116D0;
	Wed, 25 Feb 2026 01:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982951;
	bh=15uc0oAC7zpXTM5bqN+Nn8ZpBFWbYLgkcPng1DYud/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ES2yb7sznNFRK9tOn/q/0cb5C4Ifzh6wq9nmu4DFUMFMZwa6c2xbJWT7sTUodIr3v
	 IByuV8z6e1FL7bV6W5EDZBVnkLRxhRbLj4cUbrOYrZV961Oq3D2YDefC8ieqV/24p4
	 F+RnNEskTjPKIWw6snUUCU/o2AxDbtDyiKsJ7lZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Titouan Ameline de Cadeville <titouan.ameline@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 130/781] fs/tests: exec: drop duplicate bprm_stack_limits test vectors
Date: Tue, 24 Feb 2026 17:13:59 -0800
Message-ID: <20260225012402.859126862@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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



