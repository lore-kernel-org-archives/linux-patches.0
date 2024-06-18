Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C4416D9D4;
	Tue, 18 Jun 2024 12:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715352; cv=none; b=QHwLCvHB/7aD8chlCGTdFGpOHi7OSd454LJD1BP3iX0TdQVRlsL+pOfhGE3+9Xhw5Tq5fAx4hENpIIULxj4yyguwvimwBJjEOfkWDXLAJTfWvdvIs/WOFWQ0PGAERgMPZuSVmRSqjQjeTLjM193ZJbwqIyQoK0OIv1DMNx1PmUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715352; c=relaxed/simple;
	bh=Yft+wjDXp/xbr8wkO2oWjGMVuDIXXSgMDXhHx0L9NC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pazWgAcwqFCje6cHGgQco+Rw4u5Ghkm/Ht5z3CulkQx+3sH+TrY+/3rEAgAoOzTY73YPl7Gq67dh/eqeoyaQMq0LrbucgQQ/072QPPAQFZhPXmj2ccoC0+HC+GciObKoBnOybJSkfsjpB233hNUWl6VlrOm/kGtdbKw2WdkXCv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZULhRbAi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZULhRbAi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 433BCC4AF49;
	Tue, 18 Jun 2024 12:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715351;
	bh=Yft+wjDXp/xbr8wkO2oWjGMVuDIXXSgMDXhHx0L9NC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZULhRbAiOil8Fo96Y+IlnpaqmyNszIbN6oy7JFtclRp6742btmqijVP8506c/fvI0
	 EdRvLCijTS0N268EMxmuabNKRjRCas3L3/lvWTt3ZfDRXzxSel+lnK9d3nkwdXxB3t
	 J5MCyAuuqDIJURCLR3Jud1cmyyieTyiXZ3B8Ts8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hulk Robot <hulkci@huawei.com>,
	Guobin Huang <huangguobin4@huawei.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 248/770] NFSD: Use DEFINE_SPINLOCK() for spinlock
Date: Tue, 18 Jun 2024 14:31:41 +0200
Message-ID: <20240618123416.850692599@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guobin Huang <huangguobin4@huawei.com>

[ Upstream commit b73ac6808b0f7994a05ebc38571e2e9eaf98a0f4 ]

spinlock can be initialized automatically with DEFINE_SPINLOCK()
rather than explicitly calling spin_lock_init().

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Guobin Huang <huangguobin4@huawei.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfssvc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 0666ef4b87b7a..79bc75d415226 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -84,7 +84,7 @@ DEFINE_MUTEX(nfsd_mutex);
  * version 4.1 DRC caches.
  * nfsd_drc_pages_used tracks the current version 4.1 DRC memory usage.
  */
-spinlock_t	nfsd_drc_lock;
+DEFINE_SPINLOCK(nfsd_drc_lock);
 unsigned long	nfsd_drc_max_mem;
 unsigned long	nfsd_drc_mem_used;
 
@@ -563,7 +563,6 @@ static void set_max_drc(void)
 	nfsd_drc_max_mem = (nr_free_buffer_pages()
 					>> NFSD_DRC_SIZE_SHIFT) * PAGE_SIZE;
 	nfsd_drc_mem_used = 0;
-	spin_lock_init(&nfsd_drc_lock);
 	dprintk("%s nfsd_drc_max_mem %lu \n", __func__, nfsd_drc_max_mem);
 }
 
-- 
2.43.0



