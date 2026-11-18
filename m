Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047867;
	b=d/4jvMxZ7jiPsLKzFjP185F4OTP5vvpfan+PbjBbW2OpDRQzEMeJqeFjumNAdC1xJBa7
	 uN+f2svdEsa46JSVurn0Fqe+gaa2uRcWM7Yd+5v22flmqyvmUdvXZ5L7C+jwZ1ukQ6A3U
	 4c6ozrvF2L2ArfWfthOokc6/JLjGMynL3BBM+jmOeWuUNMyH47y4QNJs+67BUre4P6IDK
	 t699rB11FkjPByNFyV8QttKk/QreaVz5wLHqfJADTaP43NBTZlVo9RqDePkop/OCULRbL
	 FgeeD8w3H8N8yXokK/e7PiWJ2P0X5x/N4RM7Y4FHMc+I2cy1u+B++wA/zMvcU9i0Wkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047867;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gnHaOlNz4bvZLzseW70RI7DOpQ6qfbjfomiNReCfyf8=;
	b=dL4QAOsf4b4OiknYgCBhyjcoWT9yWBVxTjD29v7VlKts//YtdWRUs4uislEqmXeB7RLq
	 eAvovFJK5MlgbGhNR3BhYvSFubYdfkA3gxZV3Tu8T1rHbGCnf4t33UoFSU8c8Kk/EuQHS
	 N3yVVfli5Lc+5v+ExoUaIFXDtgOTrU/F1+rlJI2OmL9pZTmRUC7o7KJKTwgyj2WDLk62Y
	 s8xoDUtM32Qpa3kG8pKnQ3bfCgzRuDPsVXLKrwXRRxJO06F2k65zjmKTtk1ur1yuc2dNn
	 JPa+T7c3SNOhVOK25UGbDkY9G+HX622+Ecc/H+7riIvINjpUxWxal8JeECrkgQP+wvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ijZ+Mo84;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6343606A325;
	Thu, 19 Nov 2026 00:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ijZ+Mo84
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 360921F000C4;
	Thu, 19 Nov 2026 00:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047867;
	bh=gnHaOlNz4bvZLzseW70RI7DOpQ6qfbjfomiNReCfyf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ijZ+Mo84czByFtSoNI6wO6Y9UNDoOUKbZTGqsEI8cqc5w8e0AhG8KebsoakBnducp
	 u0h+x54zc5m/q73zWler2Sos+BKH+k68gQpcppal8QMT7/xusnqrP+CZ0z0UqJvIDB
	 bA8hZJKT5oWZu+NH02OrZS4VXJTGESEQhfgEsMak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Dolan <paul.dolan.dev@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1792/2857] selftests/clone3: tighten CLONE_CLEAR_SIGHAND conflict test
Date: Wed, 18 Nov 2026 15:47:06 +0100
Message-ID: <20261118150305.788111476@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Paul Dolan <paul.dolan.dev@gmail.com>

[ Upstream commit aeebb4884f0e8feb9929f013067488b7f2081f33 ]

The CLONE_CLEAR_SIGHAND test intends to verify that
CLONE_CLEAR_SIGHAND and CLONE_SIGHAND are mutually exclusive. However,
CLONE_SIGHAND without CLONE_VM is independently invalid, so the test
input has another reason to fail with EINVAL.

Add CLONE_VM so that CLONE_SIGHAND is otherwise valid, and require
clone3() to fail with EINVAL. This ensures the test exercises the
intended flag conflict and does not accept an unrelated failure.

Fixes: de5287235631 ("tests: test CLONE_CLEAR_SIGHAND")
Signed-off-by: Paul Dolan <paul.dolan.dev@gmail.com>
Link: https://patch.msgid.link/20260902174939.15135-1-paul.dolan.dev@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/clone3/clone3_clear_sighand.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/clone3/clone3_clear_sighand.c b/tools/testing/selftests/clone3/clone3_clear_sighand.c
index 47a8c0fc3676b..dca5f617beb24 100644
--- a/tools/testing/selftests/clone3/clone3_clear_sighand.c
+++ b/tools/testing/selftests/clone3/clone3_clear_sighand.c
@@ -54,12 +54,12 @@ static void test_clone3_clear_sighand(void)
 	 * Check that CLONE_CLEAR_SIGHAND and CLONE_SIGHAND are mutually
 	 * exclusive.
 	 */
-	args.flags |= CLONE_CLEAR_SIGHAND | CLONE_SIGHAND;
+	args.flags |= CLONE_VM | CLONE_CLEAR_SIGHAND | CLONE_SIGHAND;
 	args.exit_signal = SIGCHLD;
 	pid = sys_clone3(&args, sizeof(args));
-	if (pid > 0)
+	if (pid != -1 || errno != EINVAL)
 		ksft_exit_fail_msg(
-			"clone3(CLONE_CLEAR_SIGHAND | CLONE_SIGHAND) succeeded\n");
+			"clone3(CLONE_CLEAR_SIGHAND | CLONE_SIGHAND) did not fail with EINVAL\n");
 
 	act.sa_handler = nop_handler;
 	ret = sigemptyset(&act.sa_mask);
-- 
2.53.0



