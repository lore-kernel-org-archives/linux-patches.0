Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6ED137918;
	Mon,  8 Apr 2024 13:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583056; cv=none; b=RzLUfM5yzCF2+11cMiL5SIKM7F6cxVaD4PX9jpZcwBrJpTVRrD5TK4aXsoVwYGK26Ro4FnGQH/r2I/38JfhHFxpW37grt9d58g9V12wpvLMqRKOUJqYhY89MMYDPy5D66YknTY4JLcT+bFmlTZBW17No1QNrIdBZvFg8Z2wRiEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583056; c=relaxed/simple;
	bh=U9McpEbZuIUywBWh+wRWg+1Rl6KFi8PqokMu40kaCbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iwlZK0V7/WJ3vBxkKbm2Hp6ceNsDdTJRym1Mtviow5hUaGgTHHXWgDNCLoPJEzgEA4qgeY7EdR06BM5IKdbXx2FXunr0WvtquyPYbbDFQKlo+Y84VaUZYn0rzpjG1hmW6/x1/A8/8lNsfuiSaoBKuF3o+p2i/djTDdvC7V+Xq8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cb+XuRBH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cb+XuRBH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E95E7C43390;
	Mon,  8 Apr 2024 13:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583056;
	bh=U9McpEbZuIUywBWh+wRWg+1Rl6KFi8PqokMu40kaCbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cb+XuRBHQz9RyAke7ISEvv1PTgmdxg4h+VtyfFLh5wIdB64iJcV6G06J4VFKIw5QK
	 X3iQvTysSFLldOqBuWM0trSeydPvUmmxccwlAt1mqoagDYFHU+8imQu7hqf9Iasgo9
	 C5xTvsOZyV3Nqc+5VDvoloio8WrBOYDrn88tJ3PI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 135/273] mean_and_variance: Drop always failing tests
Date: Mon,  8 Apr 2024 14:56:50 +0200
Message-ID: <20240408125313.485220939@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 97ca7c1f93bbac6982717a7055cd727813c45e61 ]

mean_and_variance_test_2 and mean_and_variance_test_4 always fail.
The input parameters to those tests are identical to the input parameters
to tests 1 and 3, yet the expected result for tests 2 and 4 is different
for the mean and stddev tests. That will always fail.

     Expected mean_and_variance_get_mean(mv) == mean[i], but
        mean_and_variance_get_mean(mv) == 22 (0x16)
        mean[i] == 10 (0xa)

Drop the bad tests.

Fixes: 65bc41090720 ("mean and variance: More tests")
Closes: https://lore.kernel.org/lkml/065b94eb-6a24-4248-b7d7-d3212efb4787@roeck-us.net/
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/bcachefs/mean_and_variance_test.c | 28 +---------------------------
 1 file changed, 1 insertion(+), 27 deletions(-)

diff --git a/fs/bcachefs/mean_and_variance_test.c b/fs/bcachefs/mean_and_variance_test.c
index 019583c3ca0ea..51093fa848202 100644
--- a/fs/bcachefs/mean_and_variance_test.c
+++ b/fs/bcachefs/mean_and_variance_test.c
@@ -130,20 +130,8 @@ static void mean_and_variance_test_1(struct kunit *test)
 			d, mean, stddev, weighted_mean, weighted_stddev);
 }
 
-static void mean_and_variance_test_2(struct kunit *test)
-{
-	s64 d[]			= { 100, 10, 10, 10, 10, 10, 10 };
-	s64 mean[]		= {  10, 10, 10, 10, 10, 10, 10 };
-	s64 stddev[]		= {   9,  9,  9,  9,  9,  9,  9 };
-	s64 weighted_mean[]	= {  32, 27, 22, 19, 17, 15, 14 };
-	s64 weighted_stddev[]	= {  38, 35, 31, 27, 24, 21, 18 };
-
-	do_mean_and_variance_test(test, 10, 6, ARRAY_SIZE(d), 2,
-			d, mean, stddev, weighted_mean, weighted_stddev);
-}
-
 /* Test behaviour where we switch from one steady state to another: */
-static void mean_and_variance_test_3(struct kunit *test)
+static void mean_and_variance_test_2(struct kunit *test)
 {
 	s64 d[]			= { 100, 100, 100, 100, 100 };
 	s64 mean[]		= {  22,  32,  40,  46,  50 };
@@ -155,18 +143,6 @@ static void mean_and_variance_test_3(struct kunit *test)
 			d, mean, stddev, weighted_mean, weighted_stddev);
 }
 
-static void mean_and_variance_test_4(struct kunit *test)
-{
-	s64 d[]			= { 100, 100, 100, 100, 100 };
-	s64 mean[]		= {  10,  11,  12,  13,  14 };
-	s64 stddev[]		= {   9,  13,  15,  17,  19 };
-	s64 weighted_mean[]	= {  32,  49,  61,  71,  78 };
-	s64 weighted_stddev[]	= {  38,  44,  44,  41,  38 };
-
-	do_mean_and_variance_test(test, 10, 6, ARRAY_SIZE(d), 2,
-			d, mean, stddev, weighted_mean, weighted_stddev);
-}
-
 static void mean_and_variance_fast_divpow2(struct kunit *test)
 {
 	s64 i;
@@ -224,8 +200,6 @@ static struct kunit_case mean_and_variance_test_cases[] = {
 	KUNIT_CASE(mean_and_variance_weighted_advanced_test),
 	KUNIT_CASE(mean_and_variance_test_1),
 	KUNIT_CASE(mean_and_variance_test_2),
-	KUNIT_CASE(mean_and_variance_test_3),
-	KUNIT_CASE(mean_and_variance_test_4),
 	{}
 };
 
-- 
2.43.0



