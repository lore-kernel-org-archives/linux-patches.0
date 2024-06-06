Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65578197550;
	Thu,  6 Jun 2024 14:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682990; cv=none; b=bBaiEE9iEXrDgHq+Rrr716tRayTl8HH2WhpdywGas0xF1jDotygeLFASU3oXOJ/EnhRejluoTeRtYDzDhpgUbpjPsE1n1fmaXIirntaPSYg2aJ7bg/rmemiZpnl/EGLyFUlu4QYpFkVA1oN+LSOei/d07AfCcH/mGfgQa16VzDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682990; c=relaxed/simple;
	bh=pkJ1Y0hpqLJDw+27ESkFXrhr9FtvbifcpP/U2zUjiwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jvMiXU+1ewMVzR+/c6Iik/DtNA1ITqxaa29jtXYLasaafquWmc/ZUQ5N9cCvw8YbqWj/MU5OungzV+FWOeXQHk2Ff14mZQOf5c+AyjbNGhOcnl9a5vW8LRYyZJ++2GkOyh+eKXnpT6pxKBxPaPpc1MdPZ48r36GMrFr0hJsjlCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EXa5zeX/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EXa5zeX/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4760CC32782;
	Thu,  6 Jun 2024 14:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682990;
	bh=pkJ1Y0hpqLJDw+27ESkFXrhr9FtvbifcpP/U2zUjiwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EXa5zeX/KH+QwFe5GlZ5JCz1meyov9gI4iZ/iUTtGHqa2p2Em/ryXmRFiKaptXoDS
	 VJmkjLiwV5wZC0RY3l/wfmGiFh7lMbppMUU5Un4EpziKmZGnoOfVZ5CM4D7AxdEZK/
	 bxi56JIUnGVFjz+evg65sLMYf9t7XSKiloETcOms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Ivan Orlov <ivan.orlov0322@gmail.com>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 180/374] string: Prepare to merge strcat KUnit tests into string_kunit.c
Date: Thu,  6 Jun 2024 16:02:39 +0200
Message-ID: <20240606131657.902043811@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 6e4ef1429f3be236e145c6115b539acdbd2e299c ]

The test naming convention differs between string_kunit.c and
strcat_kunit.c. Move "test" to the beginning of the function name.

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Tested-by: Ivan Orlov <ivan.orlov0322@gmail.com>
Link: https://lore.kernel.org/r/20240419140155.3028912-3-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Stable-dep-of: 5bb288c4abc2 ("scsi: mptfusion: Avoid possible run-time warning with long manufacturer strings")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/strcat_kunit.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/lib/strcat_kunit.c b/lib/strcat_kunit.c
index e21be95514afa..ca09f7f0e6a26 100644
--- a/lib/strcat_kunit.c
+++ b/lib/strcat_kunit.c
@@ -10,7 +10,7 @@
 
 static volatile int unconst;
 
-static void strcat_test(struct kunit *test)
+static void test_strcat(struct kunit *test)
 {
 	char dest[8];
 
@@ -29,7 +29,7 @@ static void strcat_test(struct kunit *test)
 	KUNIT_EXPECT_STREQ(test, dest, "fourAB");
 }
 
-static void strncat_test(struct kunit *test)
+static void test_strncat(struct kunit *test)
 {
 	char dest[8];
 
@@ -56,7 +56,7 @@ static void strncat_test(struct kunit *test)
 	KUNIT_EXPECT_STREQ(test, dest, "fourAB");
 }
 
-static void strlcat_test(struct kunit *test)
+static void test_strlcat(struct kunit *test)
 {
 	char dest[8] = "";
 	int len = sizeof(dest) + unconst;
@@ -88,9 +88,9 @@ static void strlcat_test(struct kunit *test)
 }
 
 static struct kunit_case strcat_test_cases[] = {
-	KUNIT_CASE(strcat_test),
-	KUNIT_CASE(strncat_test),
-	KUNIT_CASE(strlcat_test),
+	KUNIT_CASE(test_strcat),
+	KUNIT_CASE(test_strncat),
+	KUNIT_CASE(test_strlcat),
 	{}
 };
 
-- 
2.43.0



