Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C75A2F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:35:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF90C4339B;
	Wed, 12 Apr 2023 08:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681288524;
	bh=wgK3+jgdKBVajpaRqXnNSnOp/bZeO8KFUql9Iu1k4Kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u7BcdfPrzTxGIwDMOnKD1x60DrzAPIHx8HhrQOZfn8HlkTanMQ9RHK47ELCzplSVu
	 79JZVoQFzxOpOW2M/Dk+rF3kTJemRfT6JecpvaaNC0MwZDSoAl7OsVIlzDuSrlqiy3
	 KUvwwYVzfT9x7MqUhseYhSbyLWI5kaRPGRui4WgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 11/93] NFSD: Fix sparse warning
Date: Wed, 12 Apr 2023 10:33:12 +0200
Message-Id: <20230412082823.514392422@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit c2f1c4bd20621175c581f298b4943df0cffbd841 ]

/home/cel/src/linux/linux/fs/nfsd/nfs4proc.c:1539:24: warning: incorrect type in assignment (different base types)
/home/cel/src/linux/linux/fs/nfsd/nfs4proc.c:1539:24:    expected restricted __be32 [usertype] status
/home/cel/src/linux/linux/fs/nfsd/nfs4proc.c:1539:24:    got int

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: 79a1d88a36f7 ("NFSD: pass range end to vfs_fsync_range() instead of count")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index b817d24d25a60..c91da7bce17ea 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1513,7 +1513,7 @@ static ssize_t _nfsd_copy_file_range(struct nfsd4_copy *copy)
 	u64 bytes_total = copy->cp_count;
 	u64 src_pos = copy->cp_src_pos;
 	u64 dst_pos = copy->cp_dst_pos;
-	__be32 status;
+	int status;
 
 	/* See RFC 7862 p.67: */
 	if (bytes_total == 0)
-- 
2.39.2



