Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024764;
	b=IQNb/YlTB5CyLCPfNYtjFWPm0JHXc2Rr3hqmaPLVPSkiY8SiEElNCQz7jDCDv3F9Q5Ja
	 pgmo3YxzzIj29IF8cs/NLmAkTZd7u6zxD7ZOx3sDYY/DY6cHDFstko10mtN+vrRteZoJx
	 ig94SrgkjZaqbJu+yophJgjpjnOW4BgWJZlD5fb5LbNa1KUMdJPbavkeAsYTm9Z8FcPFx
	 KwtJ/VfPcoPUNyrgU+IPUTcuHgI2Mj5cIL/7iwYwGeDJ016YYM5jEhMlEFOkuF3RT5kow
	 HsbMZt5dgGqRADiki7pt/Hiuk/r+Da4bSbAgfiE+tjLWCJC2WTWntMVVL8Sa5+n4gcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024764;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VG56PD8Zz5JHRYoZjk9P2BqGAdO0e1hZ3GxqMpUDRNw=;
	b=MCe9arkAXLejkib5dmQGmOKZWCp8h5nlUgf6BmI8RcI/GAS5Y0mhAW8x9ViIPw7M4PCl
	 uZ+KE4eS4hZwUhJfNaperfQ5NuZHMohDaUNRGjcD1EA5oa37NW9IU1g5SdAeIrZeMMD8m
	 3VHljHyuwbRnNv4rm9YfpfpocT95N/ROwcragnjIn3I+E3VVYFSiLP1dddWK14rYHTMl2
	 EiZ05vTdtwdXctwWX8WecmAB5zH8azrBHxSjZ6rEl3OMoP8GUxhJWGd2dEw9ZgoFdK7ew
	 XND2mBaIMzZ/Dpe3tjMO3Z1uqBHfgfrtfMLtBOegehZgGmRkWh+sn0WHR/Jjad8D8xQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E21oLR+H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9111606A337;
	Wed, 18 Nov 2026 17:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E21oLR+H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E75B1F000C4;
	Wed, 18 Nov 2026 17:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024763;
	bh=VG56PD8Zz5JHRYoZjk9P2BqGAdO0e1hZ3GxqMpUDRNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E21oLR+Hm4Rvg0rPZKMaBjHkkYNc2Z7vX34fg/N3GKZ2nzbTP7jKz8qWwvWK6RXO0
	 xsPZchCkpErLRWwqs8My2tCqlidcBaCpkBk161EpFLLLPOuBq5GKmhXbOJ8tuep97Q
	 z6T2xKTFgQEB2BdIHA26PwQWF5KovORUeVSJxpD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0841/2151] cgroup/cpuset: Run SCHED_DEADLINE shrink test on valid partition root only
Date: Wed, 18 Nov 2026 15:42:56 +0100
Message-ID: <20261118150152.885166731@linuxfoundation.org>
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

From: Waiman Long <longman@redhat.com>

[ Upstream commit 8a1c0f5c82843104d9bef2bc3726c89da70a9b91 ]

Commit f82f80426f7a ("sched/deadline: Ensure that updates to exclusive
cpusets don't break AC") adds a check in validate_change() to make
sure that there is enough bandwidth for SCHED_DEADLINE tasks if we
shrink a v1 exclusive cpuset that has CS_CPU_EXCLUSIVE flag set.

With the introduction of cpuset partition in cgroup v2, we keep setting
the CS_CPU_EXCLUSIVE flag for a partition root so that the SCHED_DEADLINE
check will continue to work as intended. However it turns out that the
current code isn't perfect and there are cases where a cpuset isn't
a valid partition root, but the exclusive flag is still incorrectly
set. This can leads to SCHED_DEADLINE check being incorrectly triggered
when there are deadline tasks in the system. This can result in unexpected
-EBUSY failure when making changes to cpuset control files. Fix that
by checking for a valid partition root for v2 and is_cpu_exclusive()
for v1. It is far easier and less cumbersome than to make sure that
the exclusive flag is only set for valid partition roots.

Even though commit a86ce68078b2 ("cgroup/cpuset: Extract out
CS_CPU_EXCLUSIVE & CS_SCHED_LOAD_BALANCE handling") is marked as a
commit to be fixed, the problem may exist before that.

Fixes: a86ce68078b2 ("cgroup/cpuset: Extract out CS_CPU_EXCLUSIVE & CS_SCHED_LOAD_BALANCE handling")
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Reviewed-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 15b6c9a6402ab..968a50997ac1e 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -714,8 +714,8 @@ static int validate_change(struct cpuset *cur, struct cpuset *trial)
 	 * For v1, effective_cpus == cpus_allowed & user_xcpus() returns
 	 * cpus_allowed.
 	 *
-	 * For v2, is_cpu_exclusive() & is_sched_load_balance() are true only
-	 * for non-isolated partition root. At this point, the target
+	 * For v2, is_partition_valid(cur) & is_sched_load_balance() are true
+	 * only for non-isolated partition root. At this point, the target
 	 * effective_cpus isn't computed yet. user_xcpus() is the best
 	 * approximation.
 	 *
@@ -724,7 +724,8 @@ static int validate_change(struct cpuset *cur, struct cpuset *trial)
 	 * becomes an issue.
 	 */
 	ret = -EBUSY;
-	if (is_cpu_exclusive(cur) && is_sched_load_balance(cur) &&
+	if ((is_partition_valid(cur) || (!cpuset_v2() && is_cpu_exclusive(cur))) &&
+	    is_sched_load_balance(cur) &&
 	    !cpuset_cpumask_can_shrink(cur->effective_cpus, user_xcpus(trial)))
 		goto out;
 
-- 
2.53.0



