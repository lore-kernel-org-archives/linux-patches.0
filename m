Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020998;
	b=CDgJzXLNm5FDgx11HR6t9O4kHv70bxpFaJrOiF4jgP63dgQKYWz5SADOkRY/T/uvn0fG
	 9o9EdBo8OYuE6l8jxCA3+b5OpEF+gG8pkBYAKoUuJSDXPQ2j8JFviludbSPp2Y7Tf9lzW
	 uDnSucTdEbUmWq8jSJwbJuLt5PEVTIGI7ovPyh4+ioXmY43MvE4BqEgpZ7jAW5TMTS7KL
	 YKX3pS7e20qBHD5cd8pSlUorMI+tA/m3KauGP06PiyFxbJN9suHVAG724tjD6FXgCoLYF
	 0SqkFUehy3Cp91fN79TUcIISZURN5eyXxl3Xb1pI/8XYQrgYAE8m1Ao3iU47oedVtcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020998;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KyaCfwWiK9feel4TMa+Xee75f+pzZ7xNO8XQ+tSxjf4=;
	b=GYx4Rt/lvPDEQcSEVm0P2lf9+/biRc2Pl8GfUDjPufBg1PC58T5Bsts0RC1o4LonSy73
	 /yjIS8sL0ec1ElkBiws2LwIWeKBuIKEnVw9PvPXLEtCbUhg5hrpkq22A9lVlow4dnKCAf
	 2JwWV/cs8fE3K5lf/7K/Xdrli/HBNn0Ah9/4VkLXU0Lx1C/Y87RgGE5FLRxwXiMc08I0z
	 b3EQ+R8QAz98zSG9rHkkpGQqilP0GmTY56uiJYgd7OypRQObHwuoTfSZcDRnPugXMA68w
	 D2oWGSkmGtnfXvh+MDw3AZ9ZREiOMIVXpWcm2BKDOJ/6zCCzc3fhLHMk/q5aeHUQUig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ikdw3dzE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C325A606A31C;
	Wed, 18 Nov 2026 16:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ikdw3dzE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 279071F000C4;
	Wed, 18 Nov 2026 16:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020998;
	bh=KyaCfwWiK9feel4TMa+Xee75f+pzZ7xNO8XQ+tSxjf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ikdw3dzExEiYtvwhrMpfSct1J8cdRnbajic+NMT67qi65amNaHqjB651A1tfmDOc9
	 T4/E6/rAqsQwhSlzCd3haW7s3TL63v47GENtGv5rdtQ4t/a4AU0eFYtjU+lahzYfC1
	 52er54gysyZ+BC51LW/rB3k3mVIr+ATcch2Npz7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiliang Yuan <odys.yuan@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2152/2651] selftests/bpf: Run the cpumask map insert tests only for the test task
Date: Wed, 18 Nov 2026 15:56:32 +0100
Message-ID: <20261118150403.305357614@linuxfoundation.org>
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

From: Qiliang Yuan <odys.yuan@gmail.com>

[ Upstream commit e2c978ad415ce223e71f6ddaa92778225eca0bef ]

verify_success() attaches each cpumask test program to task_newtask,
forks a single child, and expects err to be 0 afterwards. Most programs
return right away for other tasks than the test one.

test_insert_leave and test_insert_remove_release don't, and insert a
cpumask into the single entry of __cpumask_map for every task created
in the system while they are attached. test_insert_leave leaves its
cpumask in the map, so a second task created, for instance by a test
running in parallel, fails to insert one and sets err to 3. Two tasks
created at the same time can do the same to test_insert_remove_release.

Return early for other tasks than the test one in both programs, as the
other programs do.

Fixes: 7b6abcfa15cd ("selftests/bpf: Add selftest suite for cpumask kfuncs")
Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
Link: https://lore.kernel.org/bpf/20261009-selftests-bpf-cpumask-insert-filter-v1-1-3249218594d7@gmail.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/cpumask_success.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/cpumask_success.c b/tools/testing/selftests/bpf/progs/cpumask_success.c
index 36f77b9732d46..ddaba4318c574 100644
--- a/tools/testing/selftests/bpf/progs/cpumask_success.c
+++ b/tools/testing/selftests/bpf/progs/cpumask_success.c
@@ -460,6 +460,9 @@ int BPF_PROG(test_insert_leave, struct task_struct *task, u64 clone_flags)
 {
 	struct bpf_cpumask *cpumask;
 
+	if (!is_test_task())
+		return 0;
+
 	cpumask = create_cpumask();
 	if (!cpumask)
 		return 0;
@@ -476,6 +479,9 @@ int BPF_PROG(test_insert_remove_release, struct task_struct *task, u64 clone_fla
 	struct bpf_cpumask *cpumask;
 	struct __cpumask_map_value *v;
 
+	if (!is_test_task())
+		return 0;
+
 	cpumask = create_cpumask();
 	if (!cpumask)
 		return 0;
-- 
2.53.0



