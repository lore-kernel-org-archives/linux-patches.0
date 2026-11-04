Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831246;
	b=xnvgoo4pba4LssOg7QyJd/uJSJJMu7w9lNhEEQ/7Sq93V9pmeQGKykF8zGk2McCBDlhQ
	 jPPChn22uy+P8H+5r4TDXl4qnnhO0YCSXyHy5iiZsDfWMbveQXEnmFoWfgvMSVx9ymsJw
	 ml27a4pukJfojRx2V6f1G8b1Ou1F7CRGrrDkwORq052yHUBt/Lq1+4goaYmcdbjFTTUDK
	 yqTEYp8J//o9FpIhMWbimcgdsQNT2OucA46QbNaEmvQy7wt9ff9akYAWOTaRsZAYUmW/Z
	 B9fsBQ7s4BF0ZXOliHF8ZhSq57CYoYlC+PTbBk1SccUDM4PHWhk5wLvVpyMzAogMmyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831246;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oI2PoZUNsjbzYmP7Aixw7aVl29D6Z3H6sUH4jmeyQGU=;
	b=wWNKZmYI6eskpFZvMeHeGBLLs3CMbyUQTtWD0enhKkPi8lU3EaVcr65fECniFcMvxth2
	 rM0Pw38BQmYeRKjVwNL/2TNhEffcXoquq9v9Pk5VuQcVFYBBf9hYXYV9nK8Vfp2DSXCXT
	 B0MigjWDJtuP8OzghO5Gw9aCmqQ9KgvGs51iXJ+7bEugG78PRi7333y9GhdCJnJMtf4W7
	 yAVMrgicC5Pj4ZUPFVLO4DjRSFA1CJfArTWOi4SrRtRnmiB/PeQc7RWSA77h+lNLJ73qo
	 MagceS3iz73qcTY0cBVnF+Xcfb5jZVURK2x4MvUoAKYETxxQzY1JfI6YL7pri10EZ1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F3FCgjY5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947ED606A33E;
	Wed,  4 Nov 2026 22:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F3FCgjY5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B6B1F000C1;
	Wed,  4 Nov 2026 22:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831246;
	bh=oI2PoZUNsjbzYmP7Aixw7aVl29D6Z3H6sUH4jmeyQGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F3FCgjY5vPTOpsooX4yX5wqOf3uRcggEvyh11FlKYHHSv2H7+3LvUQ3Uvwod5e6Ve
	 glfAP2dutk9zp4Qkajx475RJLTW/9ZCAqEM2YXIkRO6sWPZimtjHc4g5ZR6eVDqdwk
	 IOsa3JDYQCB1J9/FqjQ9xcVZDZkn8dDkhhczPxhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahmoud Nagy Adam <mngyadam@amazon.de>,
	Ming Lei <tom.leiming@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0586/1005] selftests: ublk: install test_common.sh and trace/ scripts
Date: Wed,  4 Nov 2026 16:05:19 -0500
Message-ID: <20261104211100.281832844@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Mahmoud Nagy Adam <mngyadam@amazon.de>

[ Upstream commit c4fa55f85c47cd5d54d717fb8170746edb10292e ]

Every ublk test script sources test_common.sh from its own directory:

    . "$(cd "$(dirname "$0")" && pwd)"/test_common.sh

and test_generic_02/12 additionally run bpftrace against the scripts in
trace/. Neither test_common.sh nor trace/ is listed in TEST_FILES, so
"make install" does not copy them into the install directory and every
ublk test fails when run from there:

  ./test_generic_02.sh: line 4: .../kselftest_install/ublk/test_common.sh: No such file or directory
  ./test_generic_02.sh: line 8: _have_program: command not found

The bpftrace tests are affected even when bpftrace is installed: the
missing trace/*.bt makes bpftrace exit immediately, and the tests then
report a skip rather than a failure, which hides the problem.

Add both to TEST_FILES, matching how other selftests ship their sourced
helpers (see kexec/kexec_common_lib.sh and zram/zram_lib.sh).

Fixes: 6aecda00b7d1e1 ("selftests: ublk: add kernel selftests for ublk")
Fixes: 723977cab4c0fd ("selftests: ublk: add generic_01 for verifying sequential IO order")
Cc: stable@vger.kernel.org # v6.15+
Assisted-by: Kiro:claude-opus-5
Signed-off-by: Mahmoud Nagy Adam <mngyadam@amazon.de>
Reviewed-by: Ming Lei <tom.leiming@gmail.com>
Link: https://patch.msgid.link/20260909132602.68852-2-mngyadam@amazon.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/ublk/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/ublk/Makefile b/tools/testing/selftests/ublk/Makefile
index 0062784b1a308..d441483eb1e78 100644
--- a/tools/testing/selftests/ublk/Makefile
+++ b/tools/testing/selftests/ublk/Makefile
@@ -41,6 +41,8 @@ TEST_PROGS += test_stress_04.sh
 TEST_PROGS += test_stress_05.sh
 
 TEST_FILES := settings
+TEST_FILES += test_common.sh
+TEST_FILES += trace
 
 TEST_GEN_PROGS_EXTENDED = kublk metadata_size
 STANDALONE_UTILS := metadata_size.c
-- 
2.53.0



