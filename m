Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D9A3B4E8E;
	Mon, 23 Mar 2026 14:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274452; cv=none; b=lGJwd83FiAXVcvbhEM/i8Nb+kjTdSqLbKgney/rtzDTPVoj0tHjyzlChOT1oGxBQc4T+iIWbdRrfefxoMKp+W7eoewbtJv+RduF2WBMMQ8I+RtCFL+SNstcrf4ODcTjpad0UBkBCanmXzsgACOcRP3fB2zIAcDPu5KgcEnCmlv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274452; c=relaxed/simple;
	bh=VAkMWUy3JpVFoEPlIH1NKWTIeKHf2DODQufqHk1gtS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PYprb29Au+8ANJwJUxC+wahZz1BT/K8rS0xju0y9vXU6iNGvh3BcMGZdEB46r0Y+BYj+1Qx0GRxK6togvYN0KJ/4uqTCSp7LgvZwh2FA6n+KtvzTWl/iAw2lmIQJ3TGPZFth4yG4ROp67t8qAz38wMUHP7CXGliA/gc0t/6seX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P5Q8tFUE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P5Q8tFUE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21A0C2BC9E;
	Mon, 23 Mar 2026 14:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274452;
	bh=VAkMWUy3JpVFoEPlIH1NKWTIeKHf2DODQufqHk1gtS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P5Q8tFUEtF6FVtqD59V3uE/cgdtbqWu8U3Ocwb7BflFxjq5x0v7PWJ3znDFPuUIhT
	 9+CDR2sEYHKDVMWY7CyNOkz0toEVK72IT5HTGXzdq0zefxK2Glj/iFxIDc6UaCFN6b
	 2kq6rSYpjEEO4O0hDdQnrkDa251vwNozy+AE83Mc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 215/220] fs/tests: exec: Remove bad test vector
Date: Mon, 23 Mar 2026 14:46:32 +0100
Message-ID: <20260323134511.314581639@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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



