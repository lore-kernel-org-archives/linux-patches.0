Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042066;
	b=G5SLqpBt7KNavOuNGGSc+/Hh/J8Fj75KmnkIZ11sCNAeeQ0Ue4hQNYOW1RGRdd+m5DCU
	 hcZyam5NVrqJUsmIf81ZgfTD7sOfsLjMnlz2dz6voYHje+X9F2JAuljNlhGbV6Xm4HJFB
	 Un0ol95zGcqcy9UUQU4Vju5y6Q374dW39dmdEMDk4CooC48lVbBx7vuI0FGvCLTS/tSSx
	 n/QDkpU5XzXVMPj7UlZAg74wUH7BFcXRRM2ms+XJ5EL9NqBkHXF2Swj6ebkBML1bWtjUu
	 Uaq/5d7nOPqnlE7ocV4aczbgd7XxGWaMKwTAYsTFDcZfkkgvxq5Jkf8vl280unpd97A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042066;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=txRVmpqbA6CR2KFaOss4Ef/KKqEi7FY29BmwNCOONaA=;
	b=xLWctKJoR2Lm3F1GJ802s9pYO66q8ZoipX2wvhDr5Y7Rf2BNgmJMpUu6J+6hoxC7zjnh
	 n+tNZowkhHJvI21YbN52YtSDr43l24f9MbvQeEWTZ4FA5iBF58E3N2yf5nmmsEaaMhT0L
	 WuQwqv+xw4OCqRa7RmVFaM8YkZylX5PjUUYCe6HJZvahnqinqPZ40wcs8jCGx2hhz+7/E
	 WDL8E8P6+Lroyt/yNpVqprZqw6vK/FE71cixT9H9Y3qivkHnnV2TVuiKLYqAzHoq3jdMp
	 XEtivFgJyb+iasl95rxXVU1u1WI49ukQ3a+wTFsfIipQfX48VTWTxRJCA8H8bPfC4rA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r+reWWUC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7FA606A320;
	Wed, 18 Nov 2026 22:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r+reWWUC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 079811F000C5;
	Wed, 18 Nov 2026 22:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042066;
	bh=txRVmpqbA6CR2KFaOss4Ef/KKqEi7FY29BmwNCOONaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r+reWWUCYOOD389CME+jYdHu2cA+OzfwmNSlM5XylfPNgdF8To+mNHzDRtvGNOra6
	 jf2iT72BQ8P8mxerRJFRFloNrthTLFrt3tOjBwUsBQsbrVf+iMC9SRZwgnOJQR4Omd
	 WndCF18q9RpaKd58XL1IvH0jGslz7wXyRR+A/q2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiliang Yuan <odys.yuan@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3039/3318] selftests/bpf: Run the cpumask map insert tests only for the test task
Date: Wed, 18 Nov 2026 16:01:01 +0100
Message-ID: <20261118150451.339548689@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 674a63424dee3..76daff114cb29 100644
--- a/tools/testing/selftests/bpf/progs/cpumask_success.c
+++ b/tools/testing/selftests/bpf/progs/cpumask_success.c
@@ -387,6 +387,9 @@ int BPF_PROG(test_insert_leave, struct task_struct *task, u64 clone_flags)
 {
 	struct bpf_cpumask *cpumask;
 
+	if (!is_test_task())
+		return 0;
+
 	cpumask = create_cpumask();
 	if (!cpumask)
 		return 0;
@@ -403,6 +406,9 @@ int BPF_PROG(test_insert_remove_release, struct task_struct *task, u64 clone_fla
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



