Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139B1223DFF;
	Tue, 12 Aug 2025 19:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026025; cv=none; b=Y+da5RKDaghvOGF10ZQHjw2SYw0IUaL9US28jYfApAwOYTpV35uG2umfgyC1/Td4WhR9uWWzyJspv0qrY5ysnsSK6U4SyOh6EK4nIX5MoWJa3mJn9Ci2Yi/8cPdPugD5trZJDza+imJGW3Va0ciQKQN+H1H03gbIWmZRSH5BYio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026025; c=relaxed/simple;
	bh=LCitZxZNq3pBetyvtaj9kXoBJlLBnuxaqXxgGzLXNC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NzgzX/+v25gkeyzksdI8ybaJ5FH7psVLIaxisRvEN+3TrvTb1nA+YuKYI1pUBgrmhW7kWqE4O+Cn4Das2pqyRJgmMnbIByx+jatzBHS+y+wYdh0aHXbGfxeYxhM+K2usm8l7tu7CnwMSVX2egVpwHgi9G9KYwT8NHGTZcfC5EV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BgLotIAB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BgLotIAB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A1DC4CEF0;
	Tue, 12 Aug 2025 19:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026024;
	bh=LCitZxZNq3pBetyvtaj9kXoBJlLBnuxaqXxgGzLXNC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BgLotIABHLSPidzF1QuQ9DW3iZlIKIqv7kwm0GrOofvlmyRdrDBiH5/2WHleVO+4M
	 wg7FhpFF9IkV18jElW3fUypSfHdODlHgHi1RwxmS0PTpMWQr7diASUXfNVyUBAW2Vl
	 djZywq6e/BxatZD2ZJfaIFmu9rSB3yvQkMxvmOwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 187/480] kcsan: test: Initialize dummy variable
Date: Tue, 12 Aug 2025 19:46:35 +0200
Message-ID: <20250812174405.221736127@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Elver <elver@google.com>

[ Upstream commit 9872916ad1a1a5e7d089e05166c85dbd65e5b0e8 ]

Newer compiler versions rightfully point out:

 kernel/kcsan/kcsan_test.c:591:41: error: variable 'dummy' is
 uninitialized when passed as a const pointer argument here
 [-Werror,-Wuninitialized-const-pointer]
   591 |         KCSAN_EXPECT_READ_BARRIER(atomic_read(&dummy), false);
       |                                                ^~~~~
 1 error generated.

Although this particular test does not care about the value stored in
the dummy atomic variable, let's silence the warning.

Link: https://lkml.kernel.org/r/CA+G9fYu8JY=k-r0hnBRSkQQrFJ1Bz+ShdXNwC1TNeMt0eXaxeA@mail.gmail.com
Fixes: 8bc32b348178 ("kcsan: test: Add test cases for memory barrier instrumentation")
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Reviewed-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Marco Elver <elver@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kcsan/kcsan_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/kcsan/kcsan_test.c b/kernel/kcsan/kcsan_test.c
index 6ce73cceaf53..1305bc0e2479 100644
--- a/kernel/kcsan/kcsan_test.c
+++ b/kernel/kcsan/kcsan_test.c
@@ -533,7 +533,7 @@ static void test_barrier_nothreads(struct kunit *test)
 	struct kcsan_scoped_access *reorder_access = NULL;
 #endif
 	arch_spinlock_t arch_spinlock = __ARCH_SPIN_LOCK_UNLOCKED;
-	atomic_t dummy;
+	atomic_t dummy = ATOMIC_INIT(0);
 
 	KCSAN_TEST_REQUIRES(test, reorder_access != NULL);
 	KCSAN_TEST_REQUIRES(test, IS_ENABLED(CONFIG_SMP));
-- 
2.39.5



