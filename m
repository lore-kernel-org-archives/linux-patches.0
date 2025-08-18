Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77F0335BA3;
	Mon, 18 Aug 2025 13:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525245; cv=none; b=gDLa/xDX3QAw50yT7zz8zeS41YsOpJQqJQoh1US3fIasgzeiTfi7w72hRO6Ov5cBe30UOCAjFp88GnLlne7rHU+orn1san1StAj0GNAtLkjVR75+V6Lu7DpkqjM1664wfbyQ+7F/mTnl3z9L7WtA4hr3kAqTboAfM9CXwJyD4iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525245; c=relaxed/simple;
	bh=wtyty3HdF1YFTM45Ws5f2MJy2nhGhXs8BkcIi8QQE2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZKeMEZ2L+FcluuHpEMZK8+6ohCZOBvLXLkNz3lA2Hm788KE+0Wc2lAqOPQ/Qj3zpeZ9vRM1u/DQJxtK346H3UcULXOj6dKBUCKgRgAKo7kUZ9s/l7dvfahgc0YopXEfVQ06dljNP3wLQaJLvkX1uwI8rMkpOy+VI4Px+H8xenLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u/f/q+RH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u/f/q+RH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8164C4CEEB;
	Mon, 18 Aug 2025 13:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525245;
	bh=wtyty3HdF1YFTM45Ws5f2MJy2nhGhXs8BkcIi8QQE2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u/f/q+RH78SOJ8egGrYXDtgsI1Bu5GhvRz2Ac0LugqKaIHcXbTFEsWZN54RsLZnnO
	 ry4Ua7UysqOqj6Ic1QssVv+c5o8z865YS6UtGbb8rCXG3BhSQOrWfrgOJZfBGV0L3M
	 /JEvglLDDbOsrb8KO3NqscIOOfM4guw7tN1wRL+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 171/570] selftests: vDSO: vdso_test_getrandom: Always print TAP header
Date: Mon, 18 Aug 2025 14:42:38 +0200
Message-ID: <20250818124512.385429250@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit 1158220b24674edaf885433153deb4f0e5c7d331 ]

The TAP specification requires that the output begins with a header line.
If vgetrandom_init() fails and skips the test, that header line is missing.

Call vgetrandom_init() after ksft_print_header().

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Link: https://lore.kernel.org/all/20250611-selftests-vdso-fixes-v3-8-e62e37a6bcf5@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vDSO/vdso_test_getrandom.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/vDSO/vdso_test_getrandom.c b/tools/testing/selftests/vDSO/vdso_test_getrandom.c
index 95057f7567db..ff8d5675da2b 100644
--- a/tools/testing/selftests/vDSO/vdso_test_getrandom.c
+++ b/tools/testing/selftests/vDSO/vdso_test_getrandom.c
@@ -242,6 +242,7 @@ static void kselftest(void)
 	pid_t child;
 
 	ksft_print_header();
+	vgetrandom_init();
 	ksft_set_plan(2);
 
 	for (size_t i = 0; i < 1000; ++i) {
@@ -295,8 +296,6 @@ static void usage(const char *argv0)
 
 int main(int argc, char *argv[])
 {
-	vgetrandom_init();
-
 	if (argc == 1) {
 		kselftest();
 		return 0;
@@ -306,6 +305,9 @@ int main(int argc, char *argv[])
 		usage(argv[0]);
 		return 1;
 	}
+
+	vgetrandom_init();
+
 	if (!strcmp(argv[1], "bench-single"))
 		bench_single();
 	else if (!strcmp(argv[1], "bench-multi"))
-- 
2.39.5



