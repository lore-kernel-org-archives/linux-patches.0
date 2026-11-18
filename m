Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024316;
	b=5cLbPh4OysTUn5fd4Ae2amURo1snZJVQ4/iyHaLeNczcPQMBpnNZw/pMIHSoXyMBQ51Y
	 M/sArcvCo/+oSHOxk/ko51z4Lhvm7de8doWDqDyz9xg1hE/Daj1Uu6MHQXqRLmODH1NFS
	 zjO7aAd5yZB/HIGI7bkBlh5D8WZJlSmhBgqWmnapcJuv9cl66YnnUZKABJiZzohp7hskJ
	 V5tx5cnG0B6GCSQbkRqqcgufUvub3bzBue8XDoxxMylr2zoals0LHBwRXvoBoLS48v7Wq
	 jHCkvaH1WAl/OpP9KVjXzbWyAhhFi7os0iiiH2xZ1hbBMRcVQlLCLMHTLtfAj2lRs5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024316;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wpu5+ld6i5CM1jJr+ZgNvbcVukBzXO1Z1ehQhv4P6iM=;
	b=vVflCTx5uPeSC02oHTdRHIgqVDkpB9NYxTO6SKjqonjdj+CLYYhl+jNQJFazSSvUH3Nk
	 u2wHL8xrHk9gjwS5qe/ogzBhrIKoCjUDEQ6sYx1V71nS9wJxF+/uO54//vcqNp5e1Xvrb
	 3trnB8s44dDiz3tDsY4VywXFZUpemTu4hf/TV0b7YgjiDSNTdzPYZVp2PRvAQw9TZ6ZzG
	 695DfC+65TD5b0d15UzANTAOsGhJAL16LQfMbCqjJPRabqKe66dqbRivAPRgO0+CvW4zg
	 I8JdaOmEaDUO0DssNPp5IRko9SloCoRsHfepnNV1jLIQJpTjOiYN+ZISBASmKLSDV/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hCp7ipKN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4F0606A320;
	Wed, 18 Nov 2026 17:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hCp7ipKN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0430F1F000C4;
	Wed, 18 Nov 2026 17:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024316;
	bh=wpu5+ld6i5CM1jJr+ZgNvbcVukBzXO1Z1ehQhv4P6iM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hCp7ipKNGIZhw6YR61HQE8pRcApEID84KatAjTpY5fww5zcBDbwMWgOE6JJ8Qln55
	 vca/wAPOOh/sfTV3XjF772+ZgRTUDO3mGxooZZYKX0UrZS1R3ScRAc/92RWqLddVQg
	 mfVvL2aRt/fZtbF8sU6Nqh8DQaUGjVjA1k92MY5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0681/2151] ext2: drain in-flight DIO before buffered write fallback
Date: Wed, 18 Nov 2026 15:40:16 +0100
Message-ID: <20261118150146.614473977@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 1e2ef9f221e142ed19d874a71b2cae7fabbaf138 ]

An asynchronous direct write can remain in flight after the inode lock is
released.  If another direct write falls back to buffered I/O while the
first write is still pending, generic_perform_write() can dirty pages
before the first write completes its post-I/O page cache invalidation.
The invalidation then finds dirty pages, reports a page cache invalidation
failure, and records -EIO in the mapping error sequence.  A later fsync()
therefore returns -EIO.

Commit 15cdefd0c0522f9d5e12d947fa04f4c11649b699 ("ext4: drain
in-flight DIO before buffered write fallback") fixed the same race in
ext4.  Ext2 has an equivalent fallback after iomap_dio_rw() returns
-ENOTBLK or a short write, but does not drain other in-flight DIO before
dirtying the page cache.

Wait for in-flight DIO before calling generic_perform_write() in the
fallback path.

A reproducer using concurrent AIO direct writes and buffered fallback
triggered the following warning and made a subsequent fsync() return
-EIO:

  Page cache invalidation failure on direct I/O.  Possible data corruption
  due to collision with buffered I/O!

Fixes: fb5de4358e1a ("ext2: Move direct-io to use iomap")
Link: https://lore.kernel.org/r/20260629113827.4074335-3-libaokun@linux.alibaba.com
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20260924105125.577714-2-yaojiale02@163.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext2/file.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index 81f9cf3b884ce..dc261dc913b99 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -253,6 +253,13 @@ static ssize_t ext2_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		int ret2;
 
 		iocb->ki_flags &= ~IOCB_DIRECT;
+
+		/*
+		 * Prevent concurrent direct I/O and buffered I/O to the same file
+		 * range. Wait for in-flight DIO to finish before dirtying pages.
+		 */
+		inode_dio_wait(inode);
+
 		pos = iocb->ki_pos;
 		status = generic_perform_write(iocb, from);
 		if (unlikely(status < 0)) {
-- 
2.53.0



