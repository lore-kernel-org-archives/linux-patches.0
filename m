Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020990;
	b=1ag2pkuqqJMdEaiGs7GpmG0ZGXeYxwB1xEBDenCx2Xu8m6n9b6guL9iPbzWApbJuapBn
	 6SYOgkRCibWGoUM7iDneJT5o/P5DWCFs4WSODmqf/d3RyPgfKajZgbCNRZgPammH+tJJm
	 3y9mbL+5eYDCfp3f9u7ujydrpTwN59wj/3tVnwpXb7rmFK6LYJALXvNcW5SmKvt9OOxYE
	 ViXvuS3GtgZQCfhF2b8dsx0mWGqHAkHQFEew4kAtUAF9apa7bAgMOkIPOq9n7t6/fuKsw
	 xlDYRH5dd5EK47OsEXqrabfF0TInSOQVPb0BxHDxOymPTuQzQYz7mPJQ+5N2ZE1r+Ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020990;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NH84FJ2NIkZ3VShteDG3bXjz6GbfAslGNCUPvFeOJcE=;
	b=Xwk2jS6ohk9TwTDfhYhoHSxB8H+psC6WmWM/Fq2oXofIAv92pc24yMLxQNtMe/stTIMN
	 Fqh7Jnvlg3T7SXCkXgJ5c07oQd9+KzWmuLMbVHu/rEUxc3hWg1mGEv1W7/WJ+FfIAo/zT
	 ga69qxse084mrgPw6MfpVcIj0xmvvy1CHdHld1DGhT2l/l0YAkLT9adWSn7WcxsuxooCr
	 vRSDE1ymasrCPkqmomYi6/9JwI1GiYnmej8VxBUlKnRIxK+40EnfNqrRqxvVAJvTGzbzv
	 yRo56mqWAAnFXnC0lX0UoVByeF4Ze0024GD7meYoD21D8a5XDCrp3ZDGEne9e1NArFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wXTRsNB6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6A1606A320;
	Wed, 18 Nov 2026 16:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wXTRsNB6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E227A1F000C4;
	Wed, 18 Nov 2026 16:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020990;
	bh=NH84FJ2NIkZ3VShteDG3bXjz6GbfAslGNCUPvFeOJcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wXTRsNB68rIByqVwWkpUh6q2jY90MeX4y2tzu15uiAls1n+bnQtNGmE0KkU374O3h
	 HAsPk/+SUET/1/2KyLXr22YSy+h7S0u6y4y7gdzOyABlpJuKdBCzr9m/ilVzP2E1xb
	 3aJeHSZTQUkdZXotEPPyU5RC9lW9xyGv2HNHOiMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	KaFai Wan <kafai.wan@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2149/2651] selftests/bpf: Use _exit() in uprobe_multi_test clone-ed child
Date: Wed, 18 Nov 2026 15:56:29 +0100
Message-ID: <20261118150403.203714594@linuxfoundation.org>
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
index f0baf5738b751..7fbcfddc3cc36 100644
--- a/tools/testing/selftests/bpf/prog_tests/uprobe_multi_test.c
+++ b/tools/testing/selftests/bpf/prog_tests/uprobe_multi_test.c
@@ -94,14 +94,14 @@ static int child_func(void *arg)
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



