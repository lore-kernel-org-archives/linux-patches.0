Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215361;
	b=jyYUm5/Cbr70Q4B9S2izPRMeYBinYCi8oVS3cEKEWUy2xNuIfIM6xPstukOsbBNkSjS3
	 xciLupbtzxA6vaUHN9MOhNLM7+zvlWkfdBmgQN2QGwPew7DQ+ec8Ljo0YXSuUJJ46eqMK
	 ZuwySBuCuFxPMCOT0Q84Q33mcm8Hct3Xjfb+M5uQilPvtWaW1ptv2GP3TEqBrTktUhlMD
	 A3kIo2QBUsB/ofPQYnvpiYl4qfPycOrXD/Tc5ZZmE6KuhkBpjGiwtQ9lNjCjG82dlyFkl
	 Y4rohm+fqydMNvToRMkRfPJyKP4S6xThzaduztIEaxBSAGlSzzwwL7lIj7YgMN8vAKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215361;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JILphpvScpL7a1+dfzzJc/uiLqrCqjOOHT8v9pnw6jc=;
	b=P+6IVIxLu4Ly8kJtnbbTvu511dzYnQIm2igJFPNsfcddq9ukB28xtmJvc60b4G463lZY
	 21Kp8X5yc4JB7g/UtAhNWeSvDTt3kQNmAwZvnNSa/v0BJLms2Z+Gi4hdHEblwtU0a/PV3
	 31KbN6G3mPRAlxU4FIr27N9b0t40hGiNws9rIRClYoqqAIzwrszsNeb03Pguppm1EbXQF
	 SQ3k3GNnZVRE0Xr8m40GJvaC/XoXCfvb5gK2p+gkEX93y9irDWDIZudL5gzSDqrXQPqMw
	 xW9gKSZLu4txHYc+Hq/pVcJRddD1/n6NgL8YCgGZkwI3QdMqz0BPjl6Qu8dL5UUYONw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pcvjkh1d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37148606A31D;
	Wed, 28 Oct 2026 19:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pcvjkh1d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E4551F031E5;
	Wed, 28 Oct 2026 19:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215360;
	bh=JILphpvScpL7a1+dfzzJc/uiLqrCqjOOHT8v9pnw6jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pcvjkh1dNfiSQxR5NOnzFlBOQJ40e7iLN/Fsthpyv4co6SrSypZRp2r9j5WGDEV7q
	 GBntOm+S1L+zEVhTm3gXTRcn4f0wCI85dpWcrNigfVc+707vAkxeXSef8y+ooshKyS
	 D7BCwISN0aprWWCaJratsQ3NiQzMPHOIOeR1QZ5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaiser <martin@kaiser.cx>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1141/1887] test_kprobes: clear kprobes between test runs
Date: Wed, 28 Oct 2026 17:53:57 +0100
Message-ID: <20261028170525.371497322@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Kaiser <martin@kaiser.cx>

[ Upstream commit ef5581bb30efb939cc2bf093475c6cc85258e5cd ]

Running the kprobes sanity tests twice makes all tests fail and
eventually crashes the kernel.

[root@martin-riscv-1 ~]# echo 1 > /sys/kernel/debug/kunit/kprobes_test/run
...
   # Totals: pass:5 fail:0 skip:0 total:5
   ok 1 kprobes_test
[root@martin-riscv-1 ~]# echo 1 > /sys/kernel/debug/kunit/kprobes_test/run
...
  # test_kprobe: EXPECTATION FAILED at lib/tests/test_kprobes.c:64
  Expected 0 == register_kprobe(&kp), but
      register_kprobe(&kp) == -22 (0xffffffffffffffea)
...
  Unable to handle kernel paging request ...

The testsuite defines several kprobes and kretprobes as static variables
that are preserved across test runs.

After register_kprobe and unregister_kprobe, a kprobe contains some
leftover data that must be cleared before the kprobe can be registered
again. The tests are setting symbol_name to define the probe location.
Address and flags must be cleared.

The existing code clears some of the probes between subsequent tests, but
not between two test runs. The leftover data from a previous test run
makes the registrations fail in the next run.

Move the cleanups for all kprobes into kprobes_test_init, this function
is called before each single test (including the first test of a test
run).

Link: https://lore.kernel.org/all/20260507134615.1010905-1-martin@kaiser.cx/

Fixes: e44e81c5b90f ("kprobes: convert tests to kunit")
Signed-off-by: Martin Kaiser <martin@kaiser.cx>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_kprobes.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/lib/test_kprobes.c b/lib/test_kprobes.c
index eeb1d728d9746..7f4d2a77b10ff 100644
--- a/lib/test_kprobes.c
+++ b/lib/test_kprobes.c
@@ -12,6 +12,12 @@
 
 #define div_factor 3
 
+#define KP_CLEAR(_kp) \
+do { \
+	(_kp).addr = NULL; \
+	(_kp).flags = 0; \
+} while (0)
+
 static u32 rand1, preh_val, posth_val;
 static u32 (*target)(u32 value);
 static u32 (*target2)(u32 value);
@@ -115,10 +121,6 @@ static void test_kprobes(struct kunit *test)
 
 	current_test = test;
 
-	/* addr and flags should be cleard for reusing kprobe. */
-	kp.addr = NULL;
-	kp.flags = 0;
-
 	KUNIT_EXPECT_EQ(test, 0, register_kprobes(kps, 2));
 	preh_val = 0;
 	posth_val = 0;
@@ -193,9 +195,6 @@ static void test_kretprobes(struct kunit *test)
 	struct kretprobe *rps[2] = {&rp, &rp2};
 
 	current_test = test;
-	/* addr and flags should be cleard for reusing kprobe. */
-	rp.kp.addr = NULL;
-	rp.kp.flags = 0;
 	KUNIT_EXPECT_EQ(test, 0, register_kretprobes(rps, 2));
 
 	krph_val = 0;
@@ -257,8 +256,6 @@ static void test_stacktrace_on_kretprobe(struct kunit *test)
 	unsigned long myretaddr = (unsigned long)__builtin_return_address(0);
 
 	current_test = test;
-	rp3.kp.addr = NULL;
-	rp3.kp.flags = 0;
 
 	/*
 	 * Run the stacktrace_driver() to record correct return address in
@@ -319,8 +316,6 @@ static void test_stacktrace_on_nested_kretprobe(struct kunit *test)
 	struct kretprobe *rps[2] = {&rp3, &rp4};
 
 	current_test = test;
-	rp3.kp.addr = NULL;
-	rp3.kp.flags = 0;
 
 	//KUNIT_ASSERT_NE(test, myretaddr, stacktrace_driver());
 
@@ -334,6 +329,17 @@ static void test_stacktrace_on_nested_kretprobe(struct kunit *test)
 
 static int kprobes_test_init(struct kunit *test)
 {
+	KP_CLEAR(kp);
+	KP_CLEAR(kp2);
+#ifdef CONFIG_KRETPROBES
+	KP_CLEAR(rp.kp);
+	KP_CLEAR(rp2.kp);
+#ifdef CONFIG_ARCH_CORRECT_STACKTRACE_ON_KRETPROBE
+	KP_CLEAR(rp3.kp);
+	KP_CLEAR(rp4.kp);
+#endif
+#endif
+
 	target = kprobe_target;
 	target2 = kprobe_target2;
 	stacktrace_target = kprobe_stacktrace_target;
-- 
2.53.0



