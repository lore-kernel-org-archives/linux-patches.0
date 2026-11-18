Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027369;
	b=KUV5uNSK72xnzTQv2Kmdag+89LFO69nMpWsqyqeHE1gyu+za2vHzaN+ZPu4hUgmOEI+v
	 qXVHGly9tMmIeqTCAoTXhuBQBqAZJHSAke5PTNK5kRf1kTdg25z1tnUpq3PvuQiMrWlsK
	 b9daMtb1wiqEiLMj3AkVKFUINpe3Wpl45ndJBvqly/4SDpHLxq3TgZvLmIaHH+94TRFMi
	 F0BRrEdJvuZQhvyhrVsEMhmKE6yCofsSbyUNrSBUlWLW7Pc7CWB0sy3CpTZT4obNc5wsw
	 +/2gUQR5SoWhdaCoG1FlOc0rZzM7YvGq198Ox0pjo5K1pnkGJpQg1Yrmi05xH4YFNBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027369;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fad7ejHJxPyQfRiBIr63zSlX4RM/hqc1SQn5mS1TqAM=;
	b=mTlGyfeWxCTqvWTrWTPaeMHii3k68wAopZ+CzXgN83R7+yIGhe3cJaZ5BCgPYYl1n9zz
	 RNfyqYz0MtqHkdvQyAz4q6/FIaz7ctlQTAUM12VLd9Cw8gNMjqoyH5VTfnqbj2Hjg6XvD
	 4iQbCgTwBBN7Jm1j+us8/ubqQH70CuFRHXD4N4DIwtEVtJPrHh4+KC1FBkXb5g5m81X0A
	 Rg4OGNZk6m2+AHdPED0eOI0xg9IP1fZ59eLWa8kGF8+96c7Jr+Tpf8fFdEeVKiui0snFK
	 kolBC8jz2tCSV0emD7dsp+jABE6VHjv7Q6t6YbwQcUjCmUHXAVmjDSCztwN5RBRJKlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ypQ1kvdC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2E660A2603;
	Wed, 18 Nov 2026 18:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ypQ1kvdC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09D7B1F000C5;
	Wed, 18 Nov 2026 18:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027369;
	bh=fad7ejHJxPyQfRiBIr63zSlX4RM/hqc1SQn5mS1TqAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ypQ1kvdCMrfsC5z1I+l9tvUDXKXyxDoecGYytyLhujGNO4yfpU0bEpLAFmmzqVntm
	 Apxowx4mS0Bi34LQ4NIXN9HhkbrDB0aKm9fT+KHI20Ib+q8uuQi3zMSWv0li/ymNLn
	 l9li0DvwvZaLuOzyDdn09xX1qhyv/dM1G7NITQ8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiliang Yuan <odys.yuan@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1764/2151] selftests/bpf: Run the cpumask map insert tests only for the test task
Date: Wed, 18 Nov 2026 15:58:19 +0100
Message-ID: <20261118150226.097526905@linuxfoundation.org>
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
index 774706e7b058b..d623343adbaa2 100644
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



