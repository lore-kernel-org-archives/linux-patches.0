Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF73B279DC2;
	Wed, 25 Feb 2026 01:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983838; cv=none; b=NT2gu7ljBbxK+Boo1WJGDfMgnrZSrRXvLX0KjuM8ZViiT6kzRRpzwFi+BfANp8i+diN/3uutUS5lt8MNW+3rc8DX7geug8VM6i2xYqSLM1xaVZll4PH22xa0K6AQBqPfkKtgWxCaq7PxTtkqU/a+kfFaz2iYEXVInw3lKxWyA28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983838; c=relaxed/simple;
	bh=3kH7StKXPbmx5yqj9taCqh3r396jRM1vKEOxQHb4bTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VVga7IxDvm0271Wqp2TCF7yMtGRI1M09VggA82Ss9Y+C94nJxlnBmmcVDswBNP56J5P20velgWSQiH+iuKOHl3WxznfXjxiFmkYNqL2eaIrgtSfDx7ep/+CSe4qBate3RtJceYa34pAx3CnABHFZu6kA63gnPUMEomYZ3ltdVQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=THlVDycf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="THlVDycf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F130C116D0;
	Wed, 25 Feb 2026 01:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983838;
	bh=3kH7StKXPbmx5yqj9taCqh3r396jRM1vKEOxQHb4bTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=THlVDycfBfJkPNwu7z8canj26m7lRylq7qkwPdKEgjRP53g+xCv3B4cXRSZmhTkq7
	 X6n1aoH294cKZrXFco3C/PMbuJpPaQsHZE33khAO+R4BhaDK5BoC8bATyz95A6tCsI
	 VqeZouNeVmICAuHtpT2GfRlyimNH84uZFKKevF7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Titouan Ameline de Cadeville <titouan.ameline@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 117/641] fs/tests: exec: drop duplicate bprm_stack_limits test vectors
Date: Tue, 24 Feb 2026 17:17:23 -0800
Message-ID: <20260225012351.966666584@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



