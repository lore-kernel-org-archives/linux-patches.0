Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF51B2F8BE7;
	Tue, 12 Aug 2025 17:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021429; cv=none; b=XQgIzWP8rhpzBru8CdZDQL4NacRQlNZpu/GW8jXnHNUMOcyvHH+5fEkcTMGtpxTNidvuaZvSRuvBBpokH2YHh2lai2y3JLvVCBtBGMicmBep94zdKc3cJkoDQALVBHatT/71hITxoUn5EtIogtfM3i1VGmNHUjrW0w5s79yLyqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021429; c=relaxed/simple;
	bh=JG+72NUfh9k8b4PsVfA/4HuIuKYfmi0MmjwDUF23ir8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mq9edRXYg0YSvz4AcwbbLgckPrJrmmwS2OdDCN9GCaoxFDVixvjSVgwe2AcBtDFvkwCohFs7TPuAxJSCg34ou8nUPxmlqgOSBslDY8IvxJxmlNO3x/3aS8cx0V20dF6UFoTZ7V6cvlsbbOeo/IFsK1AKvnFtFqQN56BpChnNPGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SxiuW0hw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SxiuW0hw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15350C4CEF7;
	Tue, 12 Aug 2025 17:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021429;
	bh=JG+72NUfh9k8b4PsVfA/4HuIuKYfmi0MmjwDUF23ir8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SxiuW0hwNSevmY4pb2cVYvZ+2MF34cz4bhAjo9pp/n20euPn+Vxl4ECLPptL940f1
	 +Ig1MLT+aOOLMDgVzGEz3JCtkTCrK88Uz55imI/aYuEr05Bcu0IzuQNwKhNJKCNfEq
	 MJh/EMJ0gRr5U+Jpmom6gc0EU9xYSSRrPiPQu0uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 091/262] kcsan: test: Initialize dummy variable
Date: Tue, 12 Aug 2025 19:27:59 +0200
Message-ID: <20250812172956.942592120@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0ddbdab5903d..9d8c95defdd6 100644
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



