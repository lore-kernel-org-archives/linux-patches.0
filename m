Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032415;
	b=CGz+LwMfS2orMEgeoM+03XJUHvm5ujk0vzcMIOczNnbpMfjpS7AH7Wqz0rGVKXJDmyQB
	 uDxdKTM4M0exJqr101DrvmBogbi7Me0LSmDfZ5GOCut66ZLMbXgiQL+rXx82/tiFVvinS
	 EX9WMuPsEWwtwTGQL2vrmWWWwLErrtTZLn7OtRAEf3QqNDE340euf9LwfopCTfnO57+3N
	 fC6J1q2UwS19+0W8JzwJOq9dXLnP9jcJlt/U6p4KQgBZlq8h3oA8geq9YxUqsJnGN3aNF
	 DWNE3ubzAJ80zI0dLN4uRsbah4GLQnznzENsAe49PNOB9OnBIoA/1Pe4/EywThZrZmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032415;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+IxwOd+4dYdX1EmCmpBtkh/gGiAuGyd9jQhUoIMCWt4=;
	b=xh5LPA1P99N+CgqTSOLusV9lP33rgHhfZ32h/LEgye1EykJbKGrDM0bMDUBD6tyXh7/o
	 cNc59yyEXOwXx9dvTCaHJ6JE9Stdweahz57gZaAgKvtOP7q693W+MUvD8vvSgG9ZY1fF1
	 PdWtPv3TYYOSTbRtemdUpQCxqg77mhtCCaqVUvTbNSQKf2hcCx0KY5EvxzT7zrgzVAR7q
	 B/bMrk/tLWYFnIzC6KGw6CTj19nuWhLR3ftvdiT/kyFby3d9GS6fLnNNwSPnDoXj9frmQ
	 +bvzFIkPnoYkEOa6xseOrxJ6M4rfBho3vvyas2s4smr05m1bps/vYLos2U2LptYNxxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=okesLcPk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65EE760A3819;
	Wed, 18 Nov 2026 20:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=okesLcPk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 611D61F0182C;
	Wed, 18 Nov 2026 20:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032414;
	bh=+IxwOd+4dYdX1EmCmpBtkh/gGiAuGyd9jQhUoIMCWt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=okesLcPkRwgcRf91GhEUzifmWqxDrO/+3pRLNjvhT/BOiTxhKWho5bleDtJGDTNoq
	 uL+vhpDpyufEUHczAGzOhbXqJ+s1mTmz1Zj97QK8egoNflPz/kUIaX0U6m3/5DiQaf
	 tx1R5UcrWudST8O5ErefNjPoz5ygmI80fgX/lZbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiliang Yuan <odys.yuan@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1403/1756] selftests/bpf: Run the cpumask map insert tests only for the test task
Date: Wed, 18 Nov 2026 15:58:50 +0100
Message-ID: <20261118150105.040014867@linuxfoundation.org>
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
index 80ee469b0b602..7462474ef1adc 100644
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



