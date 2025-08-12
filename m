Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417782E4248;
	Tue, 12 Aug 2025 17:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020772; cv=none; b=Rmlm6IRU2xEkEAJEFXm7qzF+41GQ7AbBVVoYcEJqCasVjo/OrIuPPXC7DV/c5e/EV6uUGho9tHcdzMLGbR6/YO2npFY8lYJm986dojjfhyBBYj0BuYmxHakAfnfnmJlF6Mh57m51Tmq5GnT3zO1N459L+JW0qxNcb6XcQTErM0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020772; c=relaxed/simple;
	bh=mpzyxzJyis8EUqo1/BjBcqBXUY1qSE4a26+1kXwWCOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QQXCTU3CeQtiMz2AOytXqTAp7rsJ4v3qp1p9LULA3tJK8xJvuvy4At014vvhPN9hUOkMKk+DneTknN9TnuefpZKu/hnWkwitRthA9zlDeLnGdPmDa310YQBU/+7H7UEM5ZG+VXNiiw7oNckxs3fHCv5n/++jYUT7G2AWDWm/VnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kt4EN1s2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kt4EN1s2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3119C4CEF0;
	Tue, 12 Aug 2025 17:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020772;
	bh=mpzyxzJyis8EUqo1/BjBcqBXUY1qSE4a26+1kXwWCOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kt4EN1s2Qci1B5LngP6zbppAjuqrcGW/XLDAA5wEkfau2a9vHlIqP4/cfLXB2V0YC
	 pVCUZ11/qzoWQi/g+QDGGe62QnhtR+ReMRDQz05TmeIirPQjemPC5Y9eolbWTlNlPx
	 /OUWeBg2BeX5VBizCen5u0NRmdSqSlPFljvv3LCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 128/253] kcsan: test: Initialize dummy variable
Date: Tue, 12 Aug 2025 19:28:36 +0200
Message-ID: <20250812172954.142107320@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a60c561724be..fb5e7b65f799 100644
--- a/kernel/kcsan/kcsan_test.c
+++ b/kernel/kcsan/kcsan_test.c
@@ -530,7 +530,7 @@ static void test_barrier_nothreads(struct kunit *test)
 	struct kcsan_scoped_access *reorder_access = NULL;
 #endif
 	arch_spinlock_t arch_spinlock = __ARCH_SPIN_LOCK_UNLOCKED;
-	atomic_t dummy;
+	atomic_t dummy = ATOMIC_INIT(0);
 
 	KCSAN_TEST_REQUIRES(test, reorder_access != NULL);
 	KCSAN_TEST_REQUIRES(test, IS_ENABLED(CONFIG_SMP));
-- 
2.39.5



