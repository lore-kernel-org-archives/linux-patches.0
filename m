Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026836;
	b=vTUqiiThcF7HbI2eOqDJCaIUM1KfKACYavG/53JKX3qv64CFwagYDBRqspVO4x4f1FEc
	 YITqelFUvBeJCcZiP4LJxK1QHD76Pn00/DwY4jtLU/sBFhUQ//TKZKqcvZULY6IKeXlt0
	 nO8Azj3fSgJnqNeMKeWhKkYtf9///KdLMpefmLxjBI2hS0DhKD0cmkTeH8REoO4ZrlXvP
	 ba0tFqcpOGVCC31pFV8HIbrT61yUKfKxTMCVKsWGUCVymQIxpWeg0o3TjM71EiWRbpM2X
	 BkWYSDRBF6f4NdsFUZLTY5JpXKlibndEgP07sLHd+lsj+M9K+TvEa7Xb1LtOs/432jA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026836;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vH+jhUdFEQ2NOTi+9uB8pN3I24IADsF0uux+m2pqBzE=;
	b=xGJ3Osgw3aAEmSma4n4kCEGId2YxPB6vcFqnQtemWoRbDiPiZeXWXRxD4uaigZ8XVdpd
	 GMjsUxcY/IkjoNJl5x/DIEx1ku+RaIkfBaPyAjW27zbk9tTkiSeqvxN1CEejf0lWddE00
	 y1wImmLA1ZgHrXTRjPwSXbswjbjprGPvWa2cildNCGSm4oLgupGAnOxXunWhAWlPYDUl2
	 3aMIrOibbCyiJkl6YwaK0u4qjvgov74TTd6kgk/GBnVl2AGpmGGNH8vpuIYjdoQH2e928
	 dcLIpm90T93tWaQSYh648wdUFOD92slT0ByGc9BXPFWP991Uq6p6pfOhpAHx+drTspA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zm5huLoW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C526606A325;
	Wed, 18 Nov 2026 18:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zm5huLoW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA061F000C4;
	Wed, 18 Nov 2026 18:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026835;
	bh=vH+jhUdFEQ2NOTi+9uB8pN3I24IADsF0uux+m2pqBzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zm5huLoW1ubC60U9JLKsKyelVGojSoFYymaYfxq9g3QnXQ9Q5470Zqh5meeeRdYzW
	 piRJHpdQlVu6DhJ4aO9gmPFqntaVNuYqwoWmnT7Z9rGBEsOSwuBhWvZoRasBdzAxmX
	 xm91MP9OKpG2UeNQMuwAVlhzOV1rSvcG6eO8modU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiliang Yuan <odys.yuan@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1576/2151] selftests/bpf: Expect at least one tp_recursion miss in missed
Date: Wed, 18 Nov 2026 15:55:11 +0100
Message-ID: <20261118150219.291807456@linuxfoundation.org>
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

From: Qiliang Yuan <odys.yuan@gmail.com>

[ Upstream commit a5e144985d6855c84b56ea5443fd6333490ce8ec ]

missed_tp_recursion attaches its tp programs to bpf_trace_printk and
expects each of them to miss exactly one run, the one that its kprobe
program on bpf_fentry_test1 triggers by calling bpf_printk().

The test is not serial, so tests running in parallel can add misses
to the tp programs while they are attached:

  - The kprobe on bpf_fentry_test1 is global. Any other test that
    does bpf_prog_test_run() on a fentry/fexit program calls
    bpf_fentry_test1() and thereby fires the kprobe program, which
    calls bpf_printk() from kprobe context and makes the tp programs
    fail the bpf_prog_active check once more.

  - Any other program that runs under the bpf_prog_active check, such
    as a kprobe program or the perf event tracepoint program in
    legacy_printk, and calls bpf_printk() hits bpf_trace_printk the
    same way.

Either way, test2_recursion_misses comes out as 2 instead of 1.

Expect at least one miss, as missed_kprobe_recursion does since commit
08a7078feacf ("selftests/bpf: Improve missed_kprobe_recursion test
robustness").

Fixes: 85981e0f9e9f ("selftests/bpf: Add test for recursion counts of perf event link tracepoint")
Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20261008-selftests-bpf-missed-tp-recursion-v1-1-0dd60471d655@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/missed.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/missed.c b/tools/testing/selftests/bpf/prog_tests/missed.c
index ed8857ae914a6..0b8f1aa5a3e74 100644
--- a/tools/testing/selftests/bpf/prog_tests/missed.c
+++ b/tools/testing/selftests/bpf/prog_tests/missed.c
@@ -120,9 +120,9 @@ static void test_missed_tp_recursion(void)
 	ASSERT_EQ(topts.retval, 0, "test_run");
 
 	ASSERT_EQ(get_missed_count(bpf_program__fd(skel->progs.test1)), 0, "test1_recursion_misses");
-	ASSERT_EQ(get_missed_count(bpf_program__fd(skel->progs.test2)), 1, "test2_recursion_misses");
-	ASSERT_EQ(get_missed_count(bpf_program__fd(skel->progs.test3)), 1, "test3_recursion_misses");
-	ASSERT_EQ(get_missed_count(bpf_program__fd(skel->progs.test4)), 1, "test4_recursion_misses");
+	ASSERT_GE(get_missed_count(bpf_program__fd(skel->progs.test2)), 1, "test2_recursion_misses");
+	ASSERT_GE(get_missed_count(bpf_program__fd(skel->progs.test3)), 1, "test3_recursion_misses");
+	ASSERT_GE(get_missed_count(bpf_program__fd(skel->progs.test4)), 1, "test4_recursion_misses");
 
 cleanup:
 	missed_tp_recursion__destroy(skel);
-- 
2.53.0



