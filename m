Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0960314B93;
	Mon, 13 Oct 2025 15:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369221; cv=none; b=quhYtaPphjZmVfyIqjt1qWDHVS60U3AtR02JmRrETr7hTTLE7Npbsl5TVL/Rl87BrCdXF7Bd8il23dG0p2ObEIYQKPFR641G06JBfYamI3y2E1fmI7+/Cw8FSd3Al98+FPb7Pdimfn6MZbTuv9nzIiUnkzVmnkYLECEuhqXGQPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369221; c=relaxed/simple;
	bh=Mepr3RKQcyRr1G8P5khqO3JnH2zC6mXf0IeG+GBhc64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KuXTu+lno1ikwU20r8k2jpBcmjOnv7RGD6d+DvguiFVp0agr4gDCT3KG8hp6R8qu3mL2QFItE71OHwuvNIrzbvhndH1QZSlrGytMCxr4wJ+EkE1eu+wXsaHuK58IHm8xK8Ok5Un5slUtLhLiPf02/4U1BYM58vfzjbw5yLR4fjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lGH8qwey; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lGH8qwey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0161C4CEE7;
	Mon, 13 Oct 2025 15:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369221;
	bh=Mepr3RKQcyRr1G8P5khqO3JnH2zC6mXf0IeG+GBhc64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lGH8qweywayrXofofLQaawXrHFYRQ5gMLfzuHypG3zwEJDlVb+0U1a6nvi12Z9r3x
	 nee1ERTWwllMgj8TI1+DFfG1tVxUn7AWueMkx0RJzhvwGv4nixSFpXOnkIxCkeluOd
	 38qy+rvy3MNaRSyi9/oz4oY5SCTEriFwClz63xjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Lai <yi1.lai@intel.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 171/563] selftests/kselftest_harness: Add harness-selftest.expected to TEST_FILES
Date: Mon, 13 Oct 2025 16:40:32 +0200
Message-ID: <20251013144417.483011113@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yi Lai <yi1.lai@intel.com>

[ Upstream commit 3e23a3f688b457288c37899f8898180cc231ff97 ]

The harness-selftest.expected is not installed in INSTALL_PATH.
Attempting to execute harness-selftest.sh shows warning:

diff: ./kselftest_harness/harness-selftest.expected: No such file or
directory

Add harness-selftest.expected to TEST_FILES.

Link: https://lore.kernel.org/r/20250909082619.584470-1-yi1.lai@intel.com
Fixes: df82ffc5a3c1 ("selftests: harness: Add kselftest harness selftest")
Signed-off-by: Yi Lai <yi1.lai@intel.com>
Reviewed-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kselftest_harness/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kselftest_harness/Makefile b/tools/testing/selftests/kselftest_harness/Makefile
index 0617535a6ce42..d2369c01701a0 100644
--- a/tools/testing/selftests/kselftest_harness/Makefile
+++ b/tools/testing/selftests/kselftest_harness/Makefile
@@ -2,6 +2,7 @@
 
 TEST_GEN_PROGS_EXTENDED := harness-selftest
 TEST_PROGS := harness-selftest.sh
+TEST_FILES := harness-selftest.expected
 EXTRA_CLEAN := harness-selftest.seen
 
 include ../lib.mk
-- 
2.51.0



