Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023029;
	b=HKdn0JoazseUa3rAgDRS1jx70YyDypTJ9adXwXYq03npfJlOsho3nYcl1YIUwziLvkWx
	 Qsk0wEH8g/M6l3uhMBz+9qAsdN1Ljnnv0wbgkMXWuSQMKB0uBDUmUmnGB7T12/VilCHLv
	 Oq++0FfsS0l1mPsDLEguqWRI+4HakrxX0rwvmnP2tPXvrRQoUzwV+0JLL8gUe8nd4sBR2
	 bM30ha7aMsKMCXwYfWxZ1bUWe/+gX2QHgXxF2gp07vwF7YaWdUH7cTqIFBhlfHSIJ01rJ
	 yR/gpg4gHwqBYFbhQTMlJboIz8mnBZksmr23B4VD8v+zZjHzB/GjqMPko2QZqqKsIDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023029;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Be0GfTTLUcvvLkvOMLp2bYlRGFCo/H9o733jasYhKHM=;
	b=T8tMwH512DBP/U3afB8M66KWnLmpVxp0Gga5YQl3yWaqK241duojMvUqzIVCrUUophA7
	 nVrmoki+yaL0KKy6VfjcJYxFtFE7oFFOScl1oh6fOvZ/zhqgXH92dzJx/71f7+dPTxHKc
	 NkCzYXFEY46ibXD9WrWpHu6uWdUB+9hEuiil2tFMLNxhLfM9cxr3YKtVTwpU7VDRG43Yx
	 pzYt6g2JNzgRfNPYi4oV17gxD8UXy9DTz3YsNPr5NV8AN63bejJHVvwvlmKg4zgBBC6BG
	 8RkliGajkHUEQqbws8/luY3+IGiSanEUI0DjuHGQlBpyS24KIM9MWlqNu6pQBVqMzyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y9qah1sG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460A9606A333;
	Wed, 18 Nov 2026 17:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y9qah1sG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5B91F000C5;
	Wed, 18 Nov 2026 17:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023028;
	bh=Be0GfTTLUcvvLkvOMLp2bYlRGFCo/H9o733jasYhKHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y9qah1sG9W2ApqmtEuSqJvorIPuP3JiSsGfdwjPR+wG4lrJ/A3v3KCeCoN69Xaidi
	 zAglvebbUetaEH1sc4ZXscfv3lUZl8Kibj91lCq425gIYYkDjhO08x7bseF39to2da
	 dVRij8v7URd4SM6GFxkcgWshR5TjOAMGIFStU8Lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Dolan <paul.dolan.dev@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0222/2151] selftests/clone3: tighten CLONE_CLEAR_SIGHAND conflict test
Date: Wed, 18 Nov 2026 15:32:37 +0100
Message-ID: <20261118150129.874593596@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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



