Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8CF227FB12;
	Tue, 12 Aug 2025 18:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024119; cv=none; b=bXnV68kZ+S+eUDcu1d0fv9iBLJJG0V/l59Zdphs1yxpDJ1dhJVCg/t79R4ZFqluU5ZmcLs8fhwT97R4QFA+SgvIRGY1I+BUiYpR+foSiynWQevdA3N/oBAdnLulti6jZlHIynXEZmbxsvGq2ctINBLGt3WWe7eUmqtjt3+97qTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024119; c=relaxed/simple;
	bh=X8Rw7gJFIuDm6J6BoC5pVL2VCpEx3B+e9P26cqXUqqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ALIDmTG5Qnikam9TY3UE085AJ+IP3gLICg88fapyrJf6B/y5S3ws4ywHCE73K8kHm0tjXLXXr+/CmQcqIqCwYmhnrhpd6l/SeLaYGJ3gsyccpoEb4e2Tjlr04M1q9glg0TL24bCRUu8gbJS/K6SgxB9KF3rUObEwp5hs2mwYmi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a/ez7WuS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a/ez7WuS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5844DC4CEF0;
	Tue, 12 Aug 2025 18:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024118;
	bh=X8Rw7gJFIuDm6J6BoC5pVL2VCpEx3B+e9P26cqXUqqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a/ez7WuS29xbZpZS1nqa8wt0vnmzTGt20F4Ff64X6qDGlc6h2tmj/NTMt7gDV3l2Z
	 +ZE/uTHkZB9EoiY0cIHp10GBUvxrCVPB8VTmO23eanXoJiUsriqCHkfdOhisQfuC7Y
	 mcR8SGlkjiF8UKKBBOEWenMOvCyO5hI4qAm62qYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 247/627] kcsan: test: Initialize dummy variable
Date: Tue, 12 Aug 2025 19:29:02 +0200
Message-ID: <20250812173428.699260211@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index c2871180edcc..49ab81faaed9 100644
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



