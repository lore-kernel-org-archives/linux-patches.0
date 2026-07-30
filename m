Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE5844D020;
	Thu, 30 Jul 2026 16:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427989; cv=none; b=Q+no5qLD1N29eF6SE1kdpxYOgw8zHRDu+KGtCiX2OyeHLvNgnoQ965Wo7mfEHppFjMDS5KgJIqEHeoJqtNZUepnl7jJFGwsUFAvOJbcHPYHgOQlI9uZ2QpvH+ePSW5mh5XwJ7DDg3fxyx1GI6/xEWEJUYUMFc1Ql8e8U2QmSdbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427989; c=relaxed/simple;
	bh=TOx8s3rF8bpNPjTUwPlG+aCegTajYg/kyCV3YrX08VM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tftHqInPjdhk58yVElIGp0vQeN0tkXvu8po0hfySLb4+UyOuBOJLPRwGry/79ZlWlrt1bu0NkuEqx+FClT1hZskuhfs9bcDK5JNkylP31W56WEhO5sKG9JSWEQPL0GPiA/S0ZoYPxUlGOQW1IWEWBBcjk4ZCCoMsUwLutGHhTqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rywWXkf5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rywWXkf5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 679E41F000E9;
	Thu, 30 Jul 2026 16:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427987;
	bh=WavHdZCHmg6POrTyC2/J37f3LuPVYYDqxDgd2kBIjEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rywWXkf5BQJwwgpJjiWLjPUgjBuxf1OZ5tya/z8PbdYj3n+ONVoqBKWml5oe8gyJY
	 glzX5DJI1zRfQDJ9x/Z35z+uCCZRh1b95PYpkxxxxwXrSakRasxZQwx7OIIy24rX4D
	 JyYF8p8jHUxwjdVqwejln2X7YspRk+7WbgQfWi+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Guan <guanwentao@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 362/484] bpf: drop bpf_lsm_getselfattr from hook list
Date: Thu, 30 Jul 2026 16:14:19 +0200
Message-ID: <20260730141431.339391216@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Guan <guanwentao@uniontech.com>

Backport ("bpf, lsm: Add disabled BPF LSM hook list") for v6.6.y bring the
warning "WARN: resolve_btfids: unresolved symbol bpf_lsm_getselfattr".

The lsm_getselfattr from commit a04a1198088a
("LSM: syscalls for current process attributes"), no need to backport
the huge patch, simply drop the entry to fix the noise.

This is a fix for stable v6.6.145 backport commit, so no upstream commit.

Fixes: b3b4719429d5 ("bpf, lsm: Add disabled BPF LSM hook list")
Link: https://lore.kernel.org/stable/20260728225520.stable-0003@kernel.org/
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/bpf_lsm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index 147c3a8ad4e8e0..984e944a0221d9 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -42,7 +42,6 @@ BTF_ID(func, bpf_lsm_inode_need_killpriv)
 BTF_ID(func, bpf_lsm_inode_getsecurity)
 BTF_ID(func, bpf_lsm_inode_listsecurity)
 BTF_ID(func, bpf_lsm_inode_copy_up_xattr)
-BTF_ID(func, bpf_lsm_getselfattr)
 BTF_ID(func, bpf_lsm_getprocattr)
 BTF_ID(func, bpf_lsm_setprocattr)
 #ifdef CONFIG_KEYS
-- 
2.53.0



