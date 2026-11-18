Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027366;
	b=B/i0yuWei7uqZhBWY9D6Sllg9xvzA+QpcOLHI5Aonwiqv+63e8lY5OFkBi4HTQF8furv
	 3ayfAHS5eCGZPc5aY51IoyQHzyQ3wSavwjZ7kugVftMwtzE1jAPd6FeWM2Ad87SMy4NHB
	 Nvm0LHtalji1lRGLlUMYTqnltMxcZau2PZ404MLWYmbdzGRiyfzjPZgq3DnJwsxCHo9e+
	 8aBIP1F4ydmkWX4v7eCYf7AMN/qIgbDimhsMjgmYNlDUNIItgLNimB66YT1xjKJSqlY5m
	 Wv1qN2YY7wODjzfbfwGzlSdbXx/a3OB5235ocbuKhTze/WDLJuKhf3ja4jt7vjFWAzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027366;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yXboQftmevQ32FHDXUZQK4ON/Cn6VuXTu37lifti1S8=;
	b=qX4Be8oRo4iyaLF10NNxdQ/oULhLaCp5uo1rqhopyQ6SdiavP8kma/+YQP1QeIpIf09N
	 tN/VJ5DFyS6u3wSjZD4RzwAUnELlZnXo/5+SUywQAgTWwvffL8C3ppywHPMeF3VNet3Ca
	 NH653QPpjfpW0IMhxNriTq09N0Rlac9TjbbA0xs92oitaKQavRAM0jQ84uSv+obcoZSGG
	 EyH3b+taFKNKjQK+M+eMUTnPJmhh/3YtmVeqin/uqq0/OVbbt8ByTuymg2sNa24+CVy3M
	 JbFpNMZRTOtsp1H2cor0/PIdoYv98ZUInUqBROZDffm9j7P5rmW42J7sS7ksOdwnQnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cgwz73np;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4CD660A2606;
	Wed, 18 Nov 2026 18:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cgwz73np
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 327291F000C5;
	Wed, 18 Nov 2026 18:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027366;
	bh=yXboQftmevQ32FHDXUZQK4ON/Cn6VuXTu37lifti1S8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cgwz73npECFobPHiq5WFtEQongT6FTN+Qm7oHxiIItKC7m/WxCzqq7EmtJZOwTOby
	 tHV12o7IwdZuj03FnU5qO4wMBDkIBqbfQgyMO397UETkN7fSpwJhSo+wc9obYUnad7
	 a2Wwv/P+pbkTNYIvAo6Uqww3UQ2VSWSSGWyrSfX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	KaFai Wan <kafai.wan@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1763/2151] selftests/bpf: Use _exit() in uprobe_multi_test clone-ed child
Date: Wed, 18 Nov 2026 15:58:18 +0100
Message-ID: <20261118150226.060625907@linuxfoundation.org>
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

From: KaFai Wan <kafai.wan@linux.dev>

[ Upstream commit ce42271dc517baa880352d76548d301850e7385b ]

child_func() terminates with exit(), but spawn_child_flag() also starts
it via clone(CLONE_VM), which shares the parent's address space. That
exit() then runs atexit handlers and static destructors against globals
the parent is still using.

LLVM commit `3c3ed59c6a2a ("[llvm] Add format check for
MCSubtargetFeatures")` [1], included in the LLVM 23.1 releases, added
Target::isValidFeatureListFormat() with a function-local static holding
the compiled regex:

	static const llvm::Regex pattern("^([+-][^,]+)(,[+-][^,]+)*,?$");
	return pattern.match(Features);

The child exit destroys that static while its guard variable still marks
it as initialized, so the regex is never rebuilt in the parent. From that
point on, get_jited_program_text() gets NULL from
LLVMCreateDisasmCPUFeatures(), so every jited program text check in the
tests running after filter_clone_vm fails, e.g. "verifier_jit_convergence",
"verifier_private_stack", "verifier_tailcall_jit" and "verifier_jit_inline".

Use _exit(), which runs neither atexit handlers nor static destructors, as
uprobe_syscall.c already does for its own CLONE_VM child.

[1] https://github.com/llvm/llvm-project/pull/180943

Fixes: d2520bdb1932f ("selftests/bpf: Add uprobe multi pid filter test for clone-ed processes")
Signed-off-by: KaFai Wan <kafai.wan@linux.dev>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261018005348.2195130-5-kafai.wan@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/uprobe_multi_test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/uprobe_multi_test.c b/tools/testing/selftests/bpf/prog_tests/uprobe_multi_test.c
index 2ee17ef1dae28..0f1109a6bb9e7 100644
--- a/tools/testing/selftests/bpf/prog_tests/uprobe_multi_test.c
+++ b/tools/testing/selftests/bpf/prog_tests/uprobe_multi_test.c
@@ -91,14 +91,14 @@ static int child_func(void *arg)
 	/* wait for parent's kick */
 	err = read(child->go[0], &c, 1);
 	if (err != 1)
-		exit(err);
+		_exit(err);
 
 	uprobe_multi_func_1();
 	uprobe_multi_func_2();
 	uprobe_multi_func_3();
 	usdt_trigger();
 
-	exit(errno);
+	_exit(errno);
 }
 
 static int spawn_child_flag(struct child *child, bool clone_vm)
-- 
2.53.0



