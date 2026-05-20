Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791B1366542;
	Wed, 20 May 2026 16:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294746; cv=none; b=Mde+siWxJlNFkcqLpis6QTpEmm21dkAzzU65Imd4MUMOSb1t7Z7unQ4uvI/MutpDQVZVMNiPAuWUPSYvW9/j6ZnxP8SNM4knlWUfdJEzsF6cj2/CqrjOek/BxlraEwxAyt2NL5qo3L3t22+7PnkuxU8LcQz0s9IWmbJKMklVu1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294746; c=relaxed/simple;
	bh=OjqKgx4KyiZ8sjsd6CB/aqS9PNyXkEMwAk2ede6RDfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQSlj0JcAtrvcaxhI/xOuohbL0zrOyYZ+Dgu8xWYV5s6L3C26b9RYcV+VQQU/bFzSL6mDmcv6G8ewD8kOLCGvOCpCbQNpAQiabXajtAY7/XyNa5JZYULPAOS9LwFlg2/dBWT7n198Bey5xvWUcEXKfMdoa2FIzYUW5CgdUz7B94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=th3U7LTm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="th3U7LTm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E55371F000E9;
	Wed, 20 May 2026 16:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294745;
	bh=FUqPHq9yP4vXGvJno9ep6vpMNEy9MZjc1UdfZhbNOyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=th3U7LTm4R/TmFq59MPmcRQZCwLPQMgl64+xXlSg5Yq/n61ziTjPNlVDVLjOJNBuG
	 EOgNsf2G8VwmV0fHxv8EN4Q3qz94OVIT6G7wxVTCuHJwi6y1FT9sygAAHOvYEjGRSx
	 ofF38IO6oPGTtMnmlmxOIdcMeLNSubo3J8Dp+aQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quan Sun <2022090917019@std.uestc.edu.cn>,
	Yinhao Hu <dddddd@hust.edu.cn>,
	Kaiyan Mei <M202472210@hust.edu.cn>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0155/1146] bpf: Drop task_to_inode and inet_conn_established from lsm sleepable hooks
Date: Wed, 20 May 2026 18:06:45 +0200
Message-ID: <20260520162151.810423388@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit beaf0e96b1da74549a6cabd040f9667d83b2e97e ]

bpf_lsm_task_to_inode() is called under rcu_read_lock() and
bpf_lsm_inet_conn_established() is called from softirq context, so
neither hook can be used by sleepable LSM programs.

Fixes: 423f16108c9d8 ("bpf: Augment the set of sleepable LSM hooks")
Reported-by: Quan Sun <2022090917019@std.uestc.edu.cn>
Reported-by: Yinhao Hu <dddddd@hust.edu.cn>
Reported-by: Kaiyan Mei <M202472210@hust.edu.cn>
Reported-by: Dongliang Mu <dzm91@hust.edu.cn>
Closes: https://lore.kernel.org/bpf/3ab69731-24d1-431a-a351-452aafaaf2a5@std.uestc.edu.cn/T/#u
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Link: https://lore.kernel.org/r/20260407122334.344072-1-jiayuan.chen@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/bpf_lsm.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index 0c4a0c8e6f703..0aa9378fae4f7 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -359,8 +359,6 @@ BTF_ID(func, bpf_lsm_sb_umount)
 BTF_ID(func, bpf_lsm_settime)
 
 #ifdef CONFIG_SECURITY_NETWORK
-BTF_ID(func, bpf_lsm_inet_conn_established)
-
 BTF_ID(func, bpf_lsm_socket_accept)
 BTF_ID(func, bpf_lsm_socket_bind)
 BTF_ID(func, bpf_lsm_socket_connect)
@@ -381,7 +379,6 @@ BTF_ID(func, bpf_lsm_syslog)
 BTF_ID(func, bpf_lsm_task_alloc)
 BTF_ID(func, bpf_lsm_task_prctl)
 BTF_ID(func, bpf_lsm_task_setscheduler)
-BTF_ID(func, bpf_lsm_task_to_inode)
 BTF_ID(func, bpf_lsm_userns_create)
 BTF_SET_END(sleepable_lsm_hooks)
 
-- 
2.53.0



