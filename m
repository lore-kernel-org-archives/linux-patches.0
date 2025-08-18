Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D67C27A93D;
	Mon, 18 Aug 2025 13:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523502; cv=none; b=GM6lONhb0NaUKSyzeQOZgKbMU4lcc4XaRlxIfzUiH1mA5zZsk4mgJTZctdmcVBx2lOdctcxDEC07k1sQhSzW6WtgfAJEIP4gedkXsqwGsn+0v6s9mwAXkZ01lblw673/skHZmbEN2Y0YUi0yUGmx+NZfW9nbv3cwv89ScG65c7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523502; c=relaxed/simple;
	bh=G3oU6pC2Dy4y77YsIneY/o/iDclry1Jt93TGzxpSrTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dZaOsgmx2HV5TUzpG9SFUPd1rOkSS9tgW8soxW8/zNjCjpPtM2cPwRKWauOw69icajkcD4dOj7IhDANoW7QFNKZyJErupQ7r4VH3Qh1foKqtI9Bc+guhEAgPbWPtnC4iXT5dh/tdtYmoL7+6AXc7PQDrpnDV6wm34hf1JGyfgBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EkU6Tc2x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EkU6Tc2x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1251BC4CEEB;
	Mon, 18 Aug 2025 13:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523502;
	bh=G3oU6pC2Dy4y77YsIneY/o/iDclry1Jt93TGzxpSrTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EkU6Tc2x/7CD7nvYGC1l0Aihk4Huyjnt7+pDX/eZeMvTq6vk0ih6Y1WcZTBSgxlZ7
	 m96/eSJ6YNp3lsX/TpCLdzOQRHV8VuGk3OOj4EJYUTyhGmooxM56jOg+6/HFrW9hRR
	 icC1/N+bqW41PinkMOJKgf8/Sosxvmmhp3UUyMf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 158/515] selftests: vDSO: vdso_test_getrandom: Always print TAP header
Date: Mon, 18 Aug 2025 14:42:24 +0200
Message-ID: <20250818124504.467869153@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



