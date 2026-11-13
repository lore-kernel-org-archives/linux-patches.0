Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590790;
	b=Do8MqYdRMCDWnpPVGKHgp1HlqUuisr7W7Y+jG5IWYDqkLmbb8EAmMEKzkhXymnG6P7h8
	 j8mRDCzIkL1D5Wfpg8PjpU57IBZB097T7krN2N0xkJotDqNtsQC8O2a45FYn+fmCc5iCz
	 SyCROfVqMTqTl/c8IPLSRz2xRiRh2Gxl6MdSHDbmj8BjcOcqIpHEs6WSscZoWLv0Gtnbj
	 ytA3YNrTBe7dYjnhNYnALnanDi+TxFlZP5wrgvPwtnhkdDDxqqOTICRLS9tNAyDNcktyz
	 9F3TepPUVoPLcKi6axaqYdwnvy6OJmC/KkEwOjHRFId6wp8+//Y0ytFY0DPaTVoXMhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590790;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=13FI5hmePlJ8XcabfL/9nCzfXwhCnk0UL00tmHeJNEA=;
	b=p85v7ruTIu91ATvet1LdzB6T4/XhlB8612sdxRI2q+tj9KysPz8HA4HuIVsv1zaXR//O
	 zeLWMdj3+aaD6xCwFkEzuDA4ni4sMkU8A/oCYBreXf/UVuqxP9zOXWgMjwe35sPF8EoQH
	 HUEWr+qQuO2jg/TnAhu7ZYCgHFWAW0HvzLbs4vVAedN2Mj1UoAvwftklv0qoSkFDjrLYn
	 IXZYRvbnHjMiUD3mQVfQQ1JAkFx4+CpU+YyPT8NrKPkneN+ePfI03b1vQ7BQFXu9aVm5z
	 OnbPXg/1nzCM6cucg6FEBOcXF5/k+hafg4OrlCRdPTcCbZecxx0heXbqI8LhJZ3bZZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YGnChTjt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238C1606E20F;
	Fri, 13 Nov 2026 17:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YGnChTjt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA0FC1F000C4;
	Fri, 13 Nov 2026 17:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590790;
	bh=13FI5hmePlJ8XcabfL/9nCzfXwhCnk0UL00tmHeJNEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YGnChTjtBpycPOdZjEflrhudlxSVXsoEoYh4J2NW2cYhcQhipVFCYZ0NndLiUBiE2
	 0AC1o7CQpBMlA7oOInDSzl9d5X3KVrhkILEPXqj7Z+MXoIkxEasC4FA3XSlvxlHd95
	 lWpnogVl025HT6QiPekcO5DYTpxm28dRNtgrQud4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuvam Pandey <shuvampandey1@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Neel Natu <neelnatu@google.com>,
	Dmitry Antipov <dmantipov@yandex.ru>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 682/686] lib/tests: extend cmdline KUnit with next_arg() tests
Date: Fri, 13 Nov 2026 10:53:35 -0500
Message-ID: <20261113153844.746155612@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuvam Pandey <shuvampandey1@gmail.com>

[ Upstream commit dcc8a57815534e3844f342b28ecfb6e626a816a0 ]

The cmdline KUnit suite covers get_option() and get_options(), but it
does not exercise next_arg().

Extend the suite with one test for a quoted value containing spaces and
one regression test for a bare quote token after a normal parameter.

The regression test covers the bare quote token path fixed by commit
9847f21225c4 ("lib/cmdline: avoid page fault in next_arg").

[shuvampandey1@gmail.com: extend cmdline next_arg() coverage with mixed tokens]
  Link: https://lore.kernel.org/20260316211249.88601-1-shuvampandey1@gmail.com
Link: https://lore.kernel.org/20260316101227.15807-1-shuvampandey1@gmail.com
Signed-off-by: Shuvam Pandey <shuvampandey1@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Neel Natu <neelnatu@google.com>
Cc: Dmitry Antipov <dmantipov@yandex.ru>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 5d72266218b1 ("lib/cmdline: fix get_options() count and overflow with large ranges")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/tests/cmdline_kunit.c | 62 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/lib/tests/cmdline_kunit.c b/lib/tests/cmdline_kunit.c
index c1602f797637b..af44ae9e92c3e 100644
--- a/lib/tests/cmdline_kunit.c
+++ b/lib/tests/cmdline_kunit.c
@@ -139,11 +139,73 @@ static void cmdline_test_range(struct kunit *test)
 	} while (++i < ARRAY_SIZE(cmdline_test_range_strings));
 }
 
+static void cmdline_test_next_arg_quoted_value(struct kunit *test)
+{
+	char in[] = "foo=\"bar baz\" qux=1";
+	char *next, *param, *val;
+
+	next = next_arg(in, &param, &val);
+	KUNIT_EXPECT_STREQ(test, param, "foo");
+	KUNIT_ASSERT_NOT_NULL(test, val);
+	KUNIT_EXPECT_STREQ(test, val, "bar baz");
+	KUNIT_EXPECT_STREQ(test, next, "qux=1");
+
+	next = next_arg(next, &param, &val);
+	KUNIT_EXPECT_STREQ(test, param, "qux");
+	KUNIT_ASSERT_NOT_NULL(test, val);
+	KUNIT_EXPECT_STREQ(test, val, "1");
+	KUNIT_EXPECT_STREQ(test, next, "");
+}
+
+static void cmdline_test_next_arg_bare_quote_regression(struct kunit *test)
+{
+	char in[] = "foo=bar \"";
+	char *next, *param, *val;
+
+	next = next_arg(in, &param, &val);
+	KUNIT_EXPECT_STREQ(test, param, "foo");
+	KUNIT_ASSERT_NOT_NULL(test, val);
+	KUNIT_EXPECT_STREQ(test, val, "bar");
+	KUNIT_EXPECT_STREQ(test, next, "\"");
+
+	/* This hits the i == 0 quoted-token case fixed by 9847f21225c4. */
+	next = next_arg(next, &param, &val);
+	KUNIT_EXPECT_STREQ(test, param, "");
+	KUNIT_EXPECT_PTR_EQ(test, val, NULL);
+	KUNIT_EXPECT_STREQ(test, next, "");
+}
+
+static void cmdline_test_next_arg_mixed_tokens(struct kunit *test)
+{
+	char in[] = "bbb= jjj kkk=\"a=b\"";
+	char *next, *param, *val;
+
+	next = next_arg(in, &param, &val);
+	KUNIT_EXPECT_STREQ(test, param, "bbb");
+	KUNIT_ASSERT_NOT_NULL(test, val);
+	KUNIT_EXPECT_STREQ(test, val, "");
+	KUNIT_EXPECT_STREQ(test, next, "jjj kkk=\"a=b\"");
+
+	next = next_arg(next, &param, &val);
+	KUNIT_EXPECT_STREQ(test, param, "jjj");
+	KUNIT_EXPECT_NULL(test, val);
+	KUNIT_EXPECT_STREQ(test, next, "kkk=\"a=b\"");
+
+	next = next_arg(next, &param, &val);
+	KUNIT_EXPECT_STREQ(test, param, "kkk");
+	KUNIT_ASSERT_NOT_NULL(test, val);
+	KUNIT_EXPECT_STREQ(test, val, "a=b");
+	KUNIT_EXPECT_STREQ(test, next, "");
+}
+
 static struct kunit_case cmdline_test_cases[] = {
 	KUNIT_CASE(cmdline_test_noint),
 	KUNIT_CASE(cmdline_test_lead_int),
 	KUNIT_CASE(cmdline_test_tail_int),
 	KUNIT_CASE(cmdline_test_range),
+	KUNIT_CASE(cmdline_test_next_arg_quoted_value),
+	KUNIT_CASE(cmdline_test_next_arg_bare_quote_regression),
+	KUNIT_CASE(cmdline_test_next_arg_mixed_tokens),
 	{}
 };
 
-- 
2.53.0



