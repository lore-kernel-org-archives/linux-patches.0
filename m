Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029209;
	b=R2CKjNB8yrQU9ZlV5/R+efvrgMHZwrP2XiKaUJxZbZXTqu5mBk3vmYNLQL5ulCTatZRy
	 /T47pQc+o7Qv5/rdxH6Adi/mj09LJU7tFcusxmsr2VxLoMk9Kt/eXz3knqDIB01ePfaNQ
	 O8lpp52CWZEWgDFhr9lB7eYUkYfULEfCuJ69BjGk0x9uCyslHWem2K+Odh0ZL9+aBS/iv
	 SSkpiMjzzI3t7Noq7EjGkBWa3Cisi2KbolUJMZ6NyNkjM0ogEi2yT2SLkG9ceuHN2+qRg
	 tmMsgR33y18NsnavOhowU+eSsItB15HWBN6g0AQeHo6s1dMaCnnwZN6g7HfnBPDfRNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029209;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0YZ5SVH85grbUkSCrNtxF255w8XEsF+VPMKGep56nVc=;
	b=pStikb0kctSQyqhjvalZfL0YvV4stf4lTj8bwwj9s6SLhD9qqBtyO4gYHAxJ+h228BZJ
	 UvRxQQDY2VDqbhbOaRUVHE5HLvy3/GvVT2UEP53OD/LK+pfwVdto9jUsplweJ772tqOf6
	 CKLGkssIeK02/OOijLYs1aEofugkAZAg4KF80JdOYUH2H+Lp0puj2rfkrSd8+a1uEazM8
	 Dkg5GV/MQDIHB5qY3efRsf82lq6oVxq4ELl2MCTmlCAONfqOMKoUfSCQjLYOe4tDYVHp1
	 Xw5PlYnlmtiPRBDitQCTPbRd+xJRLZUursGkvyKf1flmu5HsoKiO4eqShCG0qrhZtLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TD8bwmMr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CE4606A31C;
	Wed, 18 Nov 2026 19:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TD8bwmMr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E9551F000C4;
	Wed, 18 Nov 2026 19:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029209;
	bh=0YZ5SVH85grbUkSCrNtxF255w8XEsF+VPMKGep56nVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TD8bwmMr9VgtdrXX9xEcoX1dTlWUtgiIl3BEhKqi7vajXThLUtNx8r8KFReEOPMau
	 etXew43TkR0K0L7LuvxqcNw1K8rlXEPH4EPvbeSnCNp7ezNxP0pLn21sbw1TlnPP9A
	 QvZqYwT5rD/e8keXd5NPAcNKclMrdwb7sCGWzZ6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Dolan <paul.dolan.dev@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0218/1756] selftests/clone3: tighten CLONE_CLEAR_SIGHAND conflict test
Date: Wed, 18 Nov 2026 15:39:05 +0100
Message-ID: <20261118150016.993103249@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ce04267868288..2be0221104456 100644
--- a/tools/testing/selftests/clone3/clone3_clear_sighand.c
+++ b/tools/testing/selftests/clone3/clone3_clear_sighand.c
@@ -50,12 +50,12 @@ static void test_clone3_clear_sighand(void)
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



