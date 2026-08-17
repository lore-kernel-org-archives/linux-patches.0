Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F56D424D6D;
	Mon, 17 Aug 2026 15:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979629; cv=none; b=kaaWMkCyC7buY7YRyaBtawyXqr8pYNSmxVkrFFAJQ8ywrfSTNEG3bnWeTp1FUg9jVHSPdQGXOOLIt/hBMP6NRzdHDKj97CHj0xiAvp4T917Dwwv8Lj5F5HLBynJYTEttpN1o90+4cSoZKyEtO5NBzn+wio0zAT0/n+qC2y/JclY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979629; c=relaxed/simple;
	bh=pCilB45EwWEgPlEzNuyKrRcG6qjPyKKwwz7cFp5o85s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=neCaMAtbqyux8kUoI85naj1eAiFIwp5dZt4P5bYxP6vOaG5MXE41Vydv5j3SroRYyHERcpTetHgFQybdv6LtNFjhiJUQ2z6Fs9g+Wbh/Luo7U/8joMuOwiBC01gg2PIUPrf0m9cYFaMxNmY21PQMm8PYaBXbjLCR06C8Rxysfjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VeaicsrP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VeaicsrP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A082B1F00A3A;
	Mon, 17 Aug 2026 15:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979628;
	bh=ubnRKyGlPnwcojNazrFZYyqTBFgPATW/tul6yg2xW7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VeaicsrPAAWJ46esDj0lhaylO7NipVNIzO2qduxdsn459F/4an5czozJ3n3JMv6tv
	 /j8LGWZRnfyZ4apwKOcOUQBqB4WNiTciyhm+wMJq4LDUSxad2kf8MnzY7t7r26JHeI
	 BOSK8hHuzQaE9PzR/AUHYkeerY7T65j1Af6aBBxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Guan <guanwentao@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 293/609] bpf: drop bpf_lsm_getselfattr from hook list
Date: Mon, 17 Aug 2026 15:29:49 +0200
Message-ID: <20260817132554.014420840@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Guan <guanwentao@uniontech.com>

Backport ("bpf, lsm: Add disabled BPF LSM hook list") for v6.1.y bring the
warning "WARN: resolve_btfids: unresolved symbol bpf_lsm_getselfattr".

The lsm_getselfattr from commit a04a1198088a
("LSM: syscalls for current process attributes"), no need to backport
the huge patch, simply drop the entry to fix the noise.

This is a fix for stable v6.1.178 backport commit, so no upstream commit.

Fixes: 0562ae02a6c4 ("bpf, lsm: Add disabled BPF LSM hook list")
Link: https://lore.kernel.org/stable/20260728225520.stable-0003@kernel.org/
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/bpf_lsm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index 4bb8c363c0bfde..61e93253b6b5e7 100644
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



