Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021151;
	b=TGjB53T6Z7Z0ctaWaRWQy7uL7ZMzMmJ/qLxcAPBmLK6H3AbyT5VsTtrkA8abDTy/W/lF
	 5N1KS0Z281cFuVN1G5vpRJwIrPHrHVUZrcDB6QZyFU5LVkqAIBbN9Y739aPFTbE+aPhRl
	 ZPyhMAkHyMGpfcY2Jj5zvuPrn8XtwkbJNTlgfCDbXmOjaxjFn5+aVVqN5FZ+P2MTHnedn
	 JO4BGeHrcWCtxbHr+UdjxH2iCEiAit4fMkP+os91yPhbr2SvAZHhL4iB6v4K8Ve0tkAZZ
	 cFnjKmkYXtwUZC/BcFvqFuAGqMqyN/pwsuJPgE7VjV7J9juYHxqoNBRLwUIgq7+t6rA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021151;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y0brL3TZKuigpd65aejij40Fqi73p6GG04PGzZxq4yc=;
	b=XAalKysIPDozYeDUP9GLrfHUuWHrbu8bUG95vHhOjnyv2ghgaTQD0n/vPnNzxVJJzqb5
	 RMjYukXmYaDbPGI+OlaoAqYjHcWKn2N+Js8Pq+lJdnaYvU1tf1vT1syX6UyNgqh4N1946
	 9ht3t0RJTSrVo1iIB7XXCkEfiDSQnMl1ZSVQSen/N/oOlsSzFcO7LDrRX6D0wJE/MjCwy
	 pOXf5NznpPVw9Tk78Fxeq0jt+HbcM6uCfdwnVgikCdsSHzwcl1Wh8QLxrCmV/5j1ibsQ4
	 C19kg1j/6NSRzJxD3PAUCPFH2ystpmv8LYDqNGOBVt5qfJ17eLMQNAiqf1mKJ2hm7Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uXRwM3lf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA23606A320;
	Wed, 18 Nov 2026 16:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uXRwM3lf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CED51F000C4;
	Wed, 18 Nov 2026 16:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021151;
	bh=y0brL3TZKuigpd65aejij40Fqi73p6GG04PGzZxq4yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uXRwM3lfgno1Fpk2BMcWvv1US99HftlSeSBwiv0OqAMN7nTq7anRoYirjZxFchyw5
	 T/ROjCUrw74FZ7O27TK7WMR833a/g819PDu55JLqx4Iof4OWMrFNx23vOYOEakb8T1
	 yXJpyWh9c919oIvhuPf8uk5cdn0v1GBCa4TmkTvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Liu <liubaolin@kylinos.cn>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2205/2651] ntfs: preserve the truncate error in ntfs_enlarge_attribute()
Date: Wed, 18 Nov 2026 15:57:25 +0100
Message-ID: <20261118150405.061359151@linuxfoundation.org>
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

From: Baolin Liu <liubaolin@kylinos.cn>

[ Upstream commit 5cd6692db2725b111806a813014db864264ad8f9 ]

ntfs_enlarge_attribute() discards the error from ntfs_attr_truncate() and
returns -1, which reaches userspace as EPERM. The discarded codes are
meaningful: -ENOSPC when the attribute cannot grow, -EACCES when it is
encrypted, -EOPNOTSUPP when compressed, plus -EINVAL and -ENOMEM.

Most callers of ntfs_inode_attr_pwrite() compare the result against the
requested length and substitute -EIO, masking this. ntfs_ib_write() does
not; it returns the value verbatim, which propagates through
ntfs_index_add_filename() to __ntfs_create() and __ntfs_link(), so a full
volume reports EPERM instead of ENOSPC from create(), mkdir() and link().

Fixes: af0db57d4293 ("ntfs: update inode operations")
Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/inode.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index f6bf51c84795f..5e53a50edeea3 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -3657,9 +3657,10 @@ static inline int ntfs_enlarge_attribute(struct inode *vi, s64 pos, s64 count,
 		return -EOPNOTSUPP;
 
 	if (pos + count > ni->data_size) {
-		if (ntfs_attr_truncate(ni, pos + count)) {
+		ret = ntfs_attr_truncate(ni, pos + count);
+		if (ret) {
 			ntfs_debug("Failed to truncate attribute");
-			return -1;
+			return ret;
 		}
 
 		ntfs_attr_reinit_search_ctx(ctx);
-- 
2.53.0



