Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E95E1C15
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:43:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A651C433F0;
	Wed, 28 Dec 2022 16:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245813;
	bh=F6dDl+KW5hbeIBPrrynok4uJ6F4jMZPJrJzxoph9jh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MkvFkAJmgfsMCvY8bSp68jWLYdpEgrc6pfWkFnOf+SMdxbm4pbf9Rk86C0N88yNdk
	 sLXrmcJoW9ZPy2jIMbTdz6DLlB21bPsAp7Xf9/XmRoPHM8CDGqj6hh69lNK46a5W1q
	 KPLPan1PEIQ+9420X8894l6fOO6jMRphPV692kZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Daniel=20M=C3=BCller?= <deso@posteo.net>,
	Song Liu <song@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0895/1146] selftests/bpf: Select CONFIG_FUNCTION_ERROR_INJECTION
Date: Wed, 28 Dec 2022 15:40:34 +0100
Message-Id: <20221228144354.505062000@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Song Liu <song@kernel.org>

[ Upstream commit a8dfde09c90109e3a98af54847e91bde7dc2d5c2 ]

BPF selftests require CONFIG_FUNCTION_ERROR_INJECTION to work. However,
CONFIG_FUNCTION_ERROR_INJECTION is no longer 'y' by default after recent
changes. As a result, we are seeing errors like the following from BPF CI:

   bpf_testmod_test_read() is not modifiable
   __x64_sys_setdomainname is not sleepable
   __x64_sys_getpgid is not sleepable

Fix this by explicitly selecting CONFIG_FUNCTION_ERROR_INJECTION in the
selftest config.

Fixes: a4412fdd49dc ("error-injection: Add prompt for function error injection")
Reported-by: Daniel Müller <deso@posteo.net>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Daniel Müller <deso@posteo.net>
Link: https://lore.kernel.org/bpf/20221213220500.3427947-1-song@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index 9213565c0311..59cec4244b3a 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -13,6 +13,7 @@ CONFIG_CRYPTO_USER_API_HASH=y
 CONFIG_DYNAMIC_FTRACE=y
 CONFIG_FPROBE=y
 CONFIG_FTRACE_SYSCALLS=y
+CONFIG_FUNCTION_ERROR_INJECTION=y
 CONFIG_FUNCTION_TRACER=y
 CONFIG_GENEVE=y
 CONFIG_IKCONFIG=y
-- 
2.35.1



