Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F680242D9D;
	Mon, 23 Mar 2026 14:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277485; cv=none; b=QikthDa1BYFpqbK2GrlUss6SsLQqYjYMMmQu97NH0qMEaq7e+VcZZEQzj4JGOPsqYpEnjwVeXwFoWfns8S2rxkbUPJ2ZU7wq/Pde1VQ4XpEKRxrcqDAKapIRrqqkz8fwvkfP5tsli6O/WU4+Eed+HweQd3ZwQY9ogK2teyRW+oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277485; c=relaxed/simple;
	bh=lvRzHXaThcWxv9PUXkRO0F53dQTFGnEWgfczB09ShpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I/2OChR5dznsFZ9oDU11qUljmHKY4krwO7soDVbnkWXi0D1pvS40t8NreRHFFatvYtNnis6faySnwWjkqolnKuLT7h282XC4gbJffAlSmtp04Zbfd4AKRchKP2MN3KCSjTnLKEMfB39JomEB+NMiJndhE2ocNWenbV1Y7EafrYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N37tnks9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N37tnks9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 038AAC4CEF7;
	Mon, 23 Mar 2026 14:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277485;
	bh=lvRzHXaThcWxv9PUXkRO0F53dQTFGnEWgfczB09ShpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N37tnks98zwwmnTARsDQkyHw96wu9ngyJl2NJcjMOQQV3JqL+gjdIt/joUQtpJRUU
	 2W6LOolHZHQ7OgVkQojsQ0/XEPT5i7Omao6HHHHo5l8Irb6heKQXcZ5YJX01+ntEUQ
	 tFZSG3J26LizGnweTj2gx8a9ud9301Nt5A8gezVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 456/460] fs/tests: exec: Remove bad test vector
Date: Mon, 23 Mar 2026 14:47:32 +0100
Message-ID: <20260323134537.782346806@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

[ Upstream commit c4192754e836e0ffed95833509b6ada975b74418 ]

Drop an unusable test in the bprm stack limits.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Closes: https://lore.kernel.org/all/a3e9b1c2-40c1-45df-9fa2-14ee6a7b3fe2@roeck-us.net
Fixes: 60371f43e56b ("exec: Add KUnit test for bprm_stack_limits()")
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/tests/exec_kunit.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/tests/exec_kunit.c b/fs/tests/exec_kunit.c
index f412d1a0f6bba..1c32cac098cf5 100644
--- a/fs/tests/exec_kunit.c
+++ b/fs/tests/exec_kunit.c
@@ -94,9 +94,6 @@ static const struct bprm_stack_limits_result bprm_stack_limits_results[] = {
 	{ { .p = ULONG_MAX, .rlim_stack.rlim_cur = 4 * (_STK_LIM / 4 * 3 + sizeof(void *)),
 	    .argc = 0, .envc = 0 },
 	  .expected_argmin = ULONG_MAX - (_STK_LIM / 4 * 3) + sizeof(void *) },
-	{ { .p = ULONG_MAX, .rlim_stack.rlim_cur = 4 * (_STK_LIM / 4 *  + sizeof(void *)),
-	    .argc = 0, .envc = 0 },
-	  .expected_argmin = ULONG_MAX - (_STK_LIM / 4 * 3) + sizeof(void *) },
 	{ { .p = ULONG_MAX, .rlim_stack.rlim_cur = 4 * _STK_LIM,
 	    .argc = 0, .envc = 0 },
 	  .expected_argmin = ULONG_MAX - (_STK_LIM / 4 * 3) + sizeof(void *) },
-- 
2.51.0



