Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023598;
	b=L/lcSgh/j/ZRssLjvjkHCu7AJbfskKakqXlQUn2vTD2q2CtAzpuqTzgTYKMVsSw++TqS
	 A6VUV+rIx7aaREKf9dvki8RhpcSiyOvo/e9NTqoQ4yItOR8oml4sEAL/3bAC45xzbQnpy
	 F84ah4xFOuEUqjDnAs+7TOgYF8f2bTIiue/9it7uBOgjGp9WNxKxxD3GOSCftTWpN9KNC
	 ws5IPl4fpcZy4gqfXuL9bE/yZln7+O6Olldn4qoCMwXq0EkOq9dKFZcP78+sqxxj8qyi3
	 LY7+hfUuX9c8FwkHslRsvpMVDp+gOS40ckEp5vVjn0TvZrQbvTjxKbjVL71e3tnG3wQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023598;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d5SI0x9bSg1y1wc8UG+Wy1n7R0R5ls8aupRYXRMkOZM=;
	b=2KYf2dRWRjr9xCwHGUgGC3t1wiLW5BEiMjUeVtr0i/mP2prAg40vW9kdjqHQ3ZDRHiu0
	 1MV0Ay2wrL/jfdm/w6qsB6mII0qK1E8zbL8E2Z8xgTW93IzF8kXEcxG+viIZETUkjEWnT
	 RbQVk2QoyVbCHipGsM1zD/npAB8WeK9Uz9sBDJDi/OYvzpotWfKdWX9p+hX2mpqUy/+e2
	 R1b1PZY3MAjmya35u/FRIRStqiLKrH9Az3ZjNeLRhI9WIgY9UFBOdBviljKnFHB/HvZrv
	 CJPJp+bRNwcAMqk4GruYiRHdsftr5jAb6kCZTD6B2wOXYigm+8isXgnhqxHKi8ufVGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I1r0mZMs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CD5606A31C;
	Wed, 18 Nov 2026 17:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I1r0mZMs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 525671F000C4;
	Wed, 18 Nov 2026 17:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023597;
	bh=d5SI0x9bSg1y1wc8UG+Wy1n7R0R5ls8aupRYXRMkOZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I1r0mZMslnQSbnSI6cXqajQDYgB+5hZ0yJ83tYU+9qkxbwA31E4AFpkqx33w1H+7Z
	 oFhhj2PJSGLnyxYdeBKPVyTq4vo0WeGwKSKmVX5ZTa+KTA3lXobbwWmW2vC+0Gkmfa
	 YRCboM2tSDIaVIU15/0BpEg9wg+Zd4kRGP1ob7lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0424/2151] cgroup/dmem: Fix eviction helper reference in dmem_cgroup_try_charge()
Date: Wed, 18 Nov 2026 15:35:59 +0100
Message-ID: <20261118150137.501350041@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit e8f69fe59a104b4a97a3365dbb43c72996c2acde ]

The kernel-doc comment of dmem_cgroup_try_charge() refers to
dmem_cgroup_evict_valuable, which does not exist. The name is
dmem_cgroup_state_evict_valuable. Say dmem_cgroup_state_evict_valuable.

Fixes: b168ed458dde ("kernel/cgroup: Add "dmem" memory accounting cgroup")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/dmem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/dmem.c b/kernel/cgroup/dmem.c
index 250810f22525c..3d769ebd03fc8 100644
--- a/kernel/cgroup/dmem.c
+++ b/kernel/cgroup/dmem.c
@@ -644,8 +644,8 @@ EXPORT_SYMBOL_GPL(dmem_cgroup_uncharge);
  *
  * When this function fails with -EAGAIN and @ret_limit_pool is non-null, it
  * will be set to the pool for which the limit is hit. This can be used for
- * eviction as argument to dmem_cgroup_evict_valuable(). This reference must be freed
- * with @dmem_cgroup_pool_state_put().
+ * eviction as argument to dmem_cgroup_state_evict_valuable(). This reference
+ * must be freed with @dmem_cgroup_pool_state_put().
  *
  * Return: 0 on success, -EAGAIN on hitting a limit, or a negative errno on failure.
  */
-- 
2.53.0



