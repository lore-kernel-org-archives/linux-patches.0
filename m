Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015574;
	b=rB601u1FWTvgwUmRAOM02zFpIu+jUsjNfLn7avRT32WKJpNRst4l012R+2irYSYv3Uv+
	 QLPR6Yaa1l4Pd4TwsoD7lANqJmA6gyItcB5SQM34B3RvZEfC5YvnhDPpM0UR5hoPkEC7y
	 KqV3bCm63L5Zl2CrOJkzLVgSonYeuyAHSklYzpYJy1OexQ9F8HS/K4EP63reAjtwXHqfw
	 42RZDoNZNU7p36Ds3aOP2uZBkp4uzNQRn9miSXa/cgSYo6sPoCGn09KB5+N8PUK1J071W
	 JVElYOxy4SMb0vxPc3AuAyvaRp4RtcS+DOS1k8gGkKVip3FmeYU6wVhegVRxbjKf3Rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015574;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tQg2xLpApWw3jgM5vHZHUtLj5Ak5MdQhVgapxMoLr2c=;
	b=pqYTqQfSFec2D5wAOtomQoV7ppkfICdJK2qYQNHrUc7CWsWqiXPrrbXOgLUJ7a0srkCe
	 rmzA8tRBlrRJsM7qD4y6/9UcCo10+eosFJ63qwUS/O8zzh+7Z2tEx3dxCaPIX2mp/GKy6
	 QyFTAioWeE2tNv225APuByBYKJ8u8qJ++w5Bg8AHXpdEwmzsoBTnFofpGnqXE2IKfzp/e
	 f87bisr2U8JZTktMXR2ZC9IKOW+WW8E1htEkhavrI6a5l3ytlVv28057aUXKCQhdbSrpH
	 hgSm8kWtUcbvHjLqsPdSMAKa4cl18f2o2BLxr1N4XIG7+zUjxsjLNtBQWRu3CZht7GA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0vmcGAWL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067EB606A325;
	Wed, 18 Nov 2026 15:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0vmcGAWL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C5FD1F000C6;
	Wed, 18 Nov 2026 15:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015573;
	bh=tQg2xLpApWw3jgM5vHZHUtLj5Ak5MdQhVgapxMoLr2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0vmcGAWLcjjy2IXrQ71v5uiTTTOVZnHQFjg26MWzQ6EuTc+Ag8wNWmt67l2QSFLCz
	 tokN/wFKSf4jD70kNZpEx063fdwaTEnHQu2OckX/GI9wbhaQ/HtxziaH7TMecKIjei
	 gaodk7yf1ekEqOf+iXzVUscKzSKvkMNLgQZK7ZWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Dolan <paul.dolan.dev@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0205/2651] selftests/clone3: tighten CLONE_CLEAR_SIGHAND conflict test
Date: Wed, 18 Nov 2026 15:24:05 +0100
Message-ID: <20261118150255.248849537@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index de0c9d62015de..0ad62b80ada20 100644
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



