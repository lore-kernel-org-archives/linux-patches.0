Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024102;
	b=kzwUzGGzMxmHsc7m20gVQDKlXcc3BdJp/gKKJsOzdpTdqQ/DQSUm1yXx8a4qXzRMyici
	 swEXZRLxq5u2WUMFLOpWThrIfFj+jiVeilcRouKG7C48Ws84BxpNI6dA5dmgtJ5+9irtF
	 hReA0PVLhgRr+ptGXinTCe8o+wXQl5oqWPGMk5A6vdkYhNzz2GHjYMBu/IcB7y2a4Tlu0
	 4hx7GjH428rSJfCTV3V8fXbr96cA4fCs4qwJ2BbgDEmm+UM/2fAOZtDJ+h8Hwuy2RJgr3
	 EExoN0yx1F7N6VTAB35Q6aJj1M8ePl87fhT5lfW6eXhtXIMWoJzspL08Iv5t8gNr6nQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024102;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aMS8ZPTJMwsI+tJ5WD4WpLRUoML03/Vwb4C9etb+NhM=;
	b=z3bl/i5t5z/GTV0wGQGWBapZvw8Ce0HmbkzPf5ESczWciCscRFvXpQQNaJPQ1O5YRILG
	 wQxbMsA9jIUezU9PoWwUCNOGqdAuIz7fI9/eWS3urvrNMF+z9zBq/y41eiNzQYWdbqkyJ
	 PVHvbbFLeEomEGzpQznVjjz/R23BHKAomxRW0zN+gOiH4GpcqZGzeLV6ZBN776knNTTbS
	 00dPWlOJHbRH0jfNCbsBXizX3L7sdqs/Lx+dO6M8xdkc7umipfqowc3pEDTCdJwx0g2ud
	 O3GFbMLs01jWDJ8eAIwn+k5whNpLe1ZQknRmdDLdAvaoQi6fgbUjyoD8H0FLNv4Vreg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UX8LzMcL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC28606A320;
	Wed, 18 Nov 2026 17:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UX8LzMcL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF7521F000C4;
	Wed, 18 Nov 2026 17:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024102;
	bh=aMS8ZPTJMwsI+tJ5WD4WpLRUoML03/Vwb4C9etb+NhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UX8LzMcLlTM+fxV+eB9WSV9rwTpCqEI2t5+aedIU8zUziXSRTgp0v3PlwVdDyTgoO
	 RQrZblJlzFCbxJJv09J5LZdtyXe1t27jQw5NFSthdz01E8tXPcSp+7WDqjnDUjiMVo
	 0mbVhjxBWHafgnkBpCQJ51HD4m8DGIuBvikWuuw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yun Lu <luyun@kylinos.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0565/2151] selftests/bpf: Clean up child when task_work__open() fails
Date: Wed, 18 Nov 2026 15:38:20 +0100
Message-ID: <20261118150142.532695378@linuxfoundation.org>
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

From: Yun Lu <luyun@kylinos.cn>

[ Upstream commit 8715b13c1a800f34f9d8177837e5244ac8288f60 ]

task_work_run() forks a child that blocks reading a pipe until the
parent wakes it. If task_work__open() fails afterwards, the parent
returns without closing either pipe fd or waiting for the child.
Because the parent retains the write end, the child remains blocked in
read() until test_progs exits.

Route this failure through the common cleanup path. At this point
cleanup is safe: pe_fd is -1, link is NULL, task_work__destroy() accepts
NULL, and the pid > 0 branch closes the read end, wakes the child,
closes the write end and waits for it.

This is the last early return after a successful fork. The fork failure
path already closes both pipe fds after commit 5730dacb3f17
("selftests/bpf: Task_work selftest cleanup fixes").

Fixes: 39fd74dfd5d2 ("selftests/bpf: BPF task work scheduling tests")
Signed-off-by: Yun Lu <luyun@kylinos.cn>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Mykyta Yatsenko <yatsenko@meta.com>
Link: https://lore.kernel.org/bpf/20260918024300.18321-1-luyun_611@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/test_task_work.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/test_task_work.c b/tools/testing/selftests/bpf/prog_tests/test_task_work.c
index 774b31a5f6ca1..fe0cb1702eaa0 100644
--- a/tools/testing/selftests/bpf/prog_tests/test_task_work.c
+++ b/tools/testing/selftests/bpf/prog_tests/test_task_work.c
@@ -85,7 +85,7 @@ static void task_work_run(const char *prog_name, const char *map_name)
 
 	skel = task_work__open();
 	if (!ASSERT_OK_PTR(skel, "task_work__open"))
-		return;
+		goto cleanup;
 
 	bpf_object__for_each_program(prog, skel->obj) {
 		bpf_program__set_autoload(prog, false);
-- 
2.53.0



