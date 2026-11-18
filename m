Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039291;
	b=p4CmdQOWlvyJKXWJZcEIAwdA3vAOSCB3KpW9Bo62cwKwMPULMAP1CMoEbKqVENcYbokD
	 IKxUkaRVOWfN8Tv/9kWHB+/ru/BGzistzz/Wr2CBqDWvn/UIUDX3hWWX9yUdD680di/UB
	 MLhXuwYAcKSP6jYSeR0Bx/xVAlbzGL93O2XITBkqptkzXUGJX1HPjooCmakX8CuaARYRV
	 gkmQdoc+FgdVz0X3t+NX9US8nJJOU0UqFnSR6WgJM2h0p4MQJWIVKpta8zBxqJBOunno1
	 jn6uUScV3oqCi0ZqQSypn8xJwqwOo7Nvc5F78g7Us6tRfECA9k+DwsVwEG5xMTwht4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039291;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/I/M4EJxvJinhWmGjCYGe1NZ31u+McFmJuK0wsSRHtU=;
	b=jhryyS1KqTPjTq8CVURWo3rvwjTvsxQKgeQCVjvYM4Q9OyQ6Mwrxu0Jh8pWenToLWCEO
	 Gu47U5OYu6ilpUkAXScvZPBHWGVkFQ7WEfoGDu3NKahUFBGkIUuFzqVNjRH7szZQyplWz
	 2g32InrfCCVbsv/e9yfCLwBDfFBR+lrkS1Dvl375N2N6K1HGXxayYxIt4juyx3Yyu0vvR
	 QtI+Wp96Ykk5OAUAOFvj1yaIZUfCzEAfB7aE2f7XOoaC9ZvXPqKWRkx/vuL1d2yBRnQxU
	 pyq6Jxm4vDGkG/TEgez01R2itOsfmy2ESz1gipUDImv69aY40pQH8mwq9cYUfosnSUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l5yK5+wP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54482606A335;
	Wed, 18 Nov 2026 22:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l5yK5+wP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA4201F000C5;
	Wed, 18 Nov 2026 22:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039291;
	bh=/I/M4EJxvJinhWmGjCYGe1NZ31u+McFmJuK0wsSRHtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l5yK5+wPHpsxYesE13h1QF+GEqmS/90XYPoe1RS8ibPfZgRdfupSVzpO0oj2yRZSL
	 GnvoNEcT7uyD1bweaJrA2UnnkCtXus9B2UgWd0Xa09DsiEeSAYC9Ys0Isy/K6GFftU
	 TxkFQo2RwZYEkD9xg8t53zI18WO/zrOf5iebTZl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Dolan <paul.dolan.dev@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2046/3318] selftests/clone3: tighten CLONE_CLEAR_SIGHAND conflict test
Date: Wed, 18 Nov 2026 15:44:28 +0100
Message-ID: <20261118150423.423666894@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



