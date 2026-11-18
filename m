Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054854;
	b=XfkT00ke/699+IrdDZRkoacWJShuPrtIiZNx1lta0GfSHgVkRwo8XgnpB1PL+cBUduY8
	 eNLi0nEnMkxA0+KjRc9gjbcS2JMCau6+QjD9VZ+MeMeTyu8tio+SRoai8x+j85R1YS0yE
	 c1BqzEnfcbXUx2nG+StPl17WMiAuY1TH5NZRmZAg4CeHYlcCwouIUMBizxLPOwMCpiaV5
	 ACmVRtrJYmPOb58D0VDtv5pnTnh/Uzx2zsHCXNybsv5YCe2u2fvrM6pV6QXFeiebwViDA
	 XLdjTmGmEaz048Fy+Y/vMWgrR3U7+lSx360UApJduAPf6nuvNRgZpHE4BVwrjaRLe6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054854;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UykeX/7A2OVjQ9t4j1prrFPUiwq5aGuEm5E4C9jJffI=;
	b=pO4z1B7p8IqOdYEa7GiuXrJoqsZmjt25RBe30oe8VDcGMZ3eDJlSScrRbef3SRYRWB37
	 BjYa0ffmhFBkpUKJ/2bSfUuOXoH3/jrb4clJwj80DCOPpUgPqSttTr7b3ml95kCheopeH
	 feQyeFbt4N0hiJITJxl5ZJkgSnB9EBlBKWip5f3SkGnt3tXgfihB1A5Ml4b0V9HiI0t2q
	 qfYSx2lQ5AMhUcMOVdEt6mmmow6CNpM7ieCGdQUIBHUbnJD1i1nM6JiyjpchjEeUnxkMa
	 R26oVE789hHFLph2HwcSw5jmERuzUc5OyRyZu0imOs5/MP1n1JOK18Eqd/oVzq94Qgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VlYBQqu2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C05606A31C;
	Thu, 19 Nov 2026 02:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VlYBQqu2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB9791F000C5;
	Thu, 19 Nov 2026 02:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054854;
	bh=UykeX/7A2OVjQ9t4j1prrFPUiwq5aGuEm5E4C9jJffI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VlYBQqu2s2lDLeZr3NkmNEOKwU4kc90gIg66aHPlCJM3epDq48BEgr9lX/lm0Axm+
	 TLCbFYx0YFEE7bl7Y/hCJFBxWi+s4oHIH1/ZHRGSv2sha4FaFcUkENSmjH8kfgAvVI
	 S2D+sfCcbQFHEY/nvoXyfoB7nABmUf+ElS45AiwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Dolan <paul.dolan.dev@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1382/2214] selftests/clone3: tighten CLONE_CLEAR_SIGHAND conflict test
Date: Wed, 18 Nov 2026 15:50:58 +0100
Message-ID: <20261118150106.652208400@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



