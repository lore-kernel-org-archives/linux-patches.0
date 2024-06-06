Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C35197550;
	Thu,  6 Jun 2024 14:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682990; cv=none; b=FmLS4zlEsiybMN1RXfePivgMC3o9i46rYJQOPqEf8p6VKdSwLeXd1MgMC6wi3cS7vnlcXMJu4kxBVs8izZnk5/qx310byj2b8lRU8ORRkn7Kknd1NWml/dT7gxIjf0LzcSV4b4Eg1ZcAJmduChgsXAHPHJQmo9YcevJN0s01ZyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682990; c=relaxed/simple;
	bh=rJwXTpL2zM3/6N6/aMgSX8bljOzqKaIRAKYImDBiDTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ayB4hD0y1TA8k7fbITumjSjqrEHQvzS7ULZeh6z4Ioo8VKpj8rttuUOZA4e+ZY+aJMEo0SpF//14+vZX9PEHQuMS6gFb4KOSTl5rxP6H6olXfHIiMUmIVCRUTr23Asm5YwdAdRQFqFsYZSQmQe6kFyNybo360GwzwxO+/VJ1R9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vDamwTA5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vDamwTA5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C24BBC32782;
	Thu,  6 Jun 2024 14:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682989;
	bh=rJwXTpL2zM3/6N6/aMgSX8bljOzqKaIRAKYImDBiDTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vDamwTA5NFC3wx9r+rggxSTaq+7hxhzKNNVM7c+DKrulEX0nt/QujsC/9FHagmNMM
	 kt+cHZgNDHAbiatJrdIMy8LO/DoKdQVp0gherDErCD9W2Yxns3AFqi6NsMfsjPN9bq
	 Ve4DrIvWCRHJtVPBsH3iYC4OPyRb16mSWItWpVE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Ivan Orlov <ivan.orlov0322@gmail.com>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 179/374] string: Prepare to merge strscpy_kunit.c into string_kunit.c
Date: Thu,  6 Jun 2024 16:02:38 +0200
Message-ID: <20240606131657.874109744@linuxfoundation.org>
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

[ Upstream commit b03442f761aae4bbb093a281ad2205bc346188f5 ]

In preparation for moving the strscpy_kunit.c tests into string_kunit.c,
rename "tc" to "strscpy_check" for better readability.

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Tested-by: Ivan Orlov <ivan.orlov0322@gmail.com>
Link: https://lore.kernel.org/r/20240419140155.3028912-1-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Stable-dep-of: 5bb288c4abc2 ("scsi: mptfusion: Avoid possible run-time warning with long manufacturer strings")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/strscpy_kunit.c | 51 +++++++++++++++++++++++----------------------
 1 file changed, 26 insertions(+), 25 deletions(-)

diff --git a/lib/strscpy_kunit.c b/lib/strscpy_kunit.c
index a6b6344354ed5..b6d1d93a88832 100644
--- a/lib/strscpy_kunit.c
+++ b/lib/strscpy_kunit.c
@@ -8,22 +8,23 @@
 #include <kunit/test.h>
 #include <linux/string.h>
 
-/*
- * tc() - Run a specific test case.
+/**
+ * strscpy_check() - Run a specific test case.
+ * @test: KUnit test context pointer
  * @src: Source string, argument to strscpy_pad()
  * @count: Size of destination buffer, argument to strscpy_pad()
  * @expected: Expected return value from call to strscpy_pad()
- * @terminator: 1 if there should be a terminating null byte 0 otherwise.
  * @chars: Number of characters from the src string expected to be
  *         written to the dst buffer.
+ * @terminator: 1 if there should be a terminating null byte 0 otherwise.
  * @pad: Number of pad characters expected (in the tail of dst buffer).
  *       (@pad does not include the null terminator byte.)
  *
  * Calls strscpy_pad() and verifies the return value and state of the
  * destination buffer after the call returns.
  */
-static void tc(struct kunit *test, char *src, int count, int expected,
-	       int chars, int terminator, int pad)
+static void strscpy_check(struct kunit *test, char *src, int count,
+			  int expected, int chars, int terminator, int pad)
 {
 	int nr_bytes_poison;
 	int max_expected;
@@ -79,12 +80,12 @@ static void tc(struct kunit *test, char *src, int count, int expected,
 	}
 }
 
-static void strscpy_test(struct kunit *test)
+static void test_strscpy(struct kunit *test)
 {
 	char dest[8];
 
 	/*
-	 * tc() uses a destination buffer of size 6 and needs at
+	 * strscpy_check() uses a destination buffer of size 6 and needs at
 	 * least 2 characters spare (one for null and one to check for
 	 * overflow).  This means we should only call tc() with
 	 * strings up to a maximum of 4 characters long and 'count'
@@ -92,27 +93,27 @@ static void strscpy_test(struct kunit *test)
 	 * the buffer size in tc().
 	 */
 
-	/* tc(test, src, count, expected, chars, terminator, pad) */
-	tc(test, "a", 0, -E2BIG, 0, 0, 0);
-	tc(test, "",  0, -E2BIG, 0, 0, 0);
+	/* strscpy_check(test, src, count, expected, chars, terminator, pad) */
+	strscpy_check(test, "a", 0, -E2BIG, 0, 0, 0);
+	strscpy_check(test, "",  0, -E2BIG, 0, 0, 0);
 
-	tc(test, "a", 1, -E2BIG, 0, 1, 0);
-	tc(test, "",  1, 0,	 0, 1, 0);
+	strscpy_check(test, "a", 1, -E2BIG, 0, 1, 0);
+	strscpy_check(test, "",  1, 0,	 0, 1, 0);
 
-	tc(test, "ab", 2, -E2BIG, 1, 1, 0);
-	tc(test, "a",  2, 1,	  1, 1, 0);
-	tc(test, "",   2, 0,	  0, 1, 1);
+	strscpy_check(test, "ab", 2, -E2BIG, 1, 1, 0);
+	strscpy_check(test, "a",  2, 1,	  1, 1, 0);
+	strscpy_check(test, "",   2, 0,	  0, 1, 1);
 
-	tc(test, "abc", 3, -E2BIG, 2, 1, 0);
-	tc(test, "ab",  3, 2,	   2, 1, 0);
-	tc(test, "a",   3, 1,	   1, 1, 1);
-	tc(test, "",    3, 0,	   0, 1, 2);
+	strscpy_check(test, "abc", 3, -E2BIG, 2, 1, 0);
+	strscpy_check(test, "ab",  3, 2,	   2, 1, 0);
+	strscpy_check(test, "a",   3, 1,	   1, 1, 1);
+	strscpy_check(test, "",    3, 0,	   0, 1, 2);
 
-	tc(test, "abcd", 4, -E2BIG, 3, 1, 0);
-	tc(test, "abc",  4, 3,	    3, 1, 0);
-	tc(test, "ab",   4, 2,	    2, 1, 1);
-	tc(test, "a",    4, 1,	    1, 1, 2);
-	tc(test, "",     4, 0,	    0, 1, 3);
+	strscpy_check(test, "abcd", 4, -E2BIG, 3, 1, 0);
+	strscpy_check(test, "abc",  4, 3,	    3, 1, 0);
+	strscpy_check(test, "ab",   4, 2,	    2, 1, 1);
+	strscpy_check(test, "a",    4, 1,	    1, 1, 2);
+	strscpy_check(test, "",     4, 0,	    0, 1, 3);
 
 	/* Compile-time-known source strings. */
 	KUNIT_EXPECT_EQ(test, strscpy(dest, "", ARRAY_SIZE(dest)), 0);
@@ -127,7 +128,7 @@ static void strscpy_test(struct kunit *test)
 }
 
 static struct kunit_case strscpy_test_cases[] = {
-	KUNIT_CASE(strscpy_test),
+	KUNIT_CASE(test_strscpy),
 	{}
 };
 
-- 
2.43.0



