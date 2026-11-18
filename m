Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060329;
	b=PJp8tYg34NjTfK2QKBkEk13+U7xFlxPKVSqG+qA9c1i+ofhZRWgcEXOhpGx2HDVyIscQ
	 T8AQsDGMHw0XeIDYJrSfnqMpf7OkCJ+ptpUuRbjiBUZ/GN2lyqHxV8841S189EwxSGTcN
	 8At13v/7EAGwkEs3sNSINJdAQc68FL2cDBgvTcruVXRfGxImqttnvxxnP+Pooy7heCQGW
	 GtkVm8vDJ5UcHSm9ShgQX1D+oHdrVIZMU/LS0LjUTjOrAX5fGikzTCAFzDQRU0Yd+5VJd
	 QXLOGbh2LDpxdG6JUsn6S/tJ9j9Wx6JE8js9TXctmM9nVCq9jeIB+esnhgJBH8MV/LQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060329;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bHhg8eeU2FPAUWsyxEryZIY3AqDcFcz+toYI3nTIBVU=;
	b=OW4zHJAZVCGI5nixjABG+TR7oRqO5Z3Q/QrJIDH7oC7NXZraImfwnBhTcnPpO9i2Qu8S
	 ZktNazaq4wT3I6LvB0lHK4tJ0RaAX8UEoN72aeVErfHNVtA4/tZMe0uFc6BiV7aXkKoMQ
	 xmNMpHekHXr5ONDASn+NOY5n3FKWIp2IuzJC8SJv1XbqssTvL+xvIOGsegO6wc2ahEcvW
	 ab/7b/izo0ljTKyes2HRLlqtQHqWZAzd4F7edcgCH/8GCPzJPIZzr2xUTlrUoUnyXNs2d
	 i6CJMfEAnCo7+7MZAQXXI1xl1/HIAV0FV4xhwGy2+JQ21LE14Qug63dL0RQxK4GKKgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gGfjYzYb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78613606A320;
	Thu, 19 Nov 2026 03:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gGfjYzYb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8A881F000C4;
	Thu, 19 Nov 2026 03:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060329;
	bh=bHhg8eeU2FPAUWsyxEryZIY3AqDcFcz+toYI3nTIBVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gGfjYzYb9OqbfNUfmcWbxTC35fXRuSI0lB/7zxGUY8pSXh/p3382YMYNI/Ocisalr
	 lbZp2VTd1V1K/IP/uX/ljHC84eQXHuq8QTBh6hRqxr0ys0+nO+EnAalRPlGaJO1PQZ
	 QYeobviLq+AGwPk/B/R+72cKPNkjErm58HlMJq6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Dolan <paul.dolan.dev@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1161/1848] selftests/clone3: tighten CLONE_CLEAR_SIGHAND conflict test
Date: Wed, 18 Nov 2026 15:53:19 +0100
Message-ID: <20261118150008.292380407@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



