Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044314;
	b=BY+L904IOFhFFkNQZnCwRx/ev40V6JfRw0lpAjhuReU+9tW9lJbv4E8uD0eTJJKmTsLA
	 Br2R2m3fh9hi9AUc5V1gQizEynA7ejmxqq21qdot4/GsFSGWz8n8fi0kSKKoYkC5GHBCe
	 eTLVLea0Rew7Q5W0iOm95aFZBDihzvIsxQOlgQk2Pnz8kwRsC9tp/eWxz/O9lV3he4H+O
	 FhSb9LyZLwX5YYqN4ME7GQeZlWg5HpbTiu4gFLHirXLX3ZzbnXz8SyT8aHBHmYlBMjBqa
	 /5w0MJ+0iSEJBOmhm+SpzJzVjrtTmya0lZMUTEh2uGIu3VQKSfvpFIdnxaW4LQ53pWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044314;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EMtMuHal404Hm1tY/P5bbSuz9NoTcDl9jdRcyVovcio=;
	b=oooTp1WwBCcCFM6oce7oL+ZsOm6qecnrKnGq4g5lkheXk44iscr3ErrSd+sMWCqcWjE6
	 S3JH1Hf+v9+1CoUGug4OpqRdWECCcB+8uZCKLItGv6myDV6Tmo9NkTnH3svrQVM/bxpba
	 CBBKJSF6h76Oh3UmUBItnSvoJu2i04WvTlR+EKT8HYoAAKbWizJFd+AZUTlJx5k5MF1lK
	 Q+3w5lPnk2a3XGUDy0K2YAyAtc5noxE+5MnjqEVG4ouoeEci7zsYMXk6wLsplRyJzWqfD
	 mFp1dMODqD47cl0O0d2o0ieyjMMDRspMKQFL872qK0up85ghvtyjnL0hGc14yZoL9Jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ev+NR/GF";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813B9606A32A;
	Wed, 18 Nov 2026 23:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ev+NR/GF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3B1A1F000C4;
	Wed, 18 Nov 2026 23:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044314;
	bh=EMtMuHal404Hm1tY/P5bbSuz9NoTcDl9jdRcyVovcio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ev+NR/GF/PyBBcVop46F/oAQ5dTPYHSylO6ZN68U5/XOg2vEEiqiPht9OramF7HbW
	 5GvIUoth0yL3fcNu/TN+qfNO9Arwfbcc5zrB7uhB79sONfb97m6r+bAwyBTNk7Asm2
	 5Uc0PZ5WSy0DSBKn/mU3KQm2r7bU3Bqqg3tSwaXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Christian Brauner <brauner@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0472/2857] smb: client: discard post-EOF pagecache when extending a file via clone range
Date: Wed, 18 Nov 2026 15:25:06 +0100
Message-ID: <20261118150218.440021363@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit 4721587f96cb8de8164f3fd203093a0875560999 ]

cifs_remap_file_range() discarded the pagecache only for the folios
overlapping the destination region, so when a clone extends the file the
folio straddling the old EOF - which may hold data dirtied past EOF
through an mmap - was never dropped and became visible as file content
once the file was extended.

Start the discard at the smaller of fstart and the old EOF.  i_size is
still old here, so nothing past the old EOF is flushed to the server.

Fixes: c54fc3a4f375 ("cifs: Fix flushing, invalidation and file size with FICLONE")
Reviewed-by: David Howells <dhowells@redhat.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
[ sashal: Replaced the missing i_size local with i_size_read(target_inode) and used min_t(unsigned long long, ...) for the type check, with the netfs zero-point context omitted. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsfs.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index c43c937b3f577..01b4f34a23ad0 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1366,9 +1366,15 @@ static loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
 	if (rc)
 		goto unlock;
 
-	/* Discard all the folios that overlap the destination region. */
+	/*
+	 * Discard all the folios that overlap the destination region.  Start at
+	 * the old EOF when extending so the folio straddling it, which may hold
+	 * data written past EOF through an mmap, is dropped too.
+	 */
 	cifs_dbg(FYI, "about to discard pages %llx-%llx\n", fstart, fend);
-	truncate_inode_pages_range(&target_inode->i_data, fstart, fend);
+	truncate_inode_pages_range(&target_inode->i_data,
+				   min_t(unsigned long long, fstart,
+					 i_size_read(target_inode)), fend);
 
 	fscache_invalidate(cifs_inode_cookie(target_inode), NULL,
 			   i_size_read(target_inode), 0);
-- 
2.53.0



