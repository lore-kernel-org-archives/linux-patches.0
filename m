Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015540;
	b=c5gRPIF7R1lbEoxRJloKsqo0pmROWdJOYykIdUC0KLSV3r0aIQncwgc40Hy5x9vIG3KH
	 z35H6ZJoY9GuGcRIb/4tg8a09wHherFxTelGev6oa58DkJCwGdm5zEVj+TCVtbqL0fV18
	 OZCRm7E1lKe2oCdP2ftF3LB63+r90D3wYaFvRNN4GfSg0diO2vnL9ApJap/1tZ4Aq7IKw
	 zwBwwJ++p0UaRPnbRZFEDGhrmKmsf+BdHLhZsaRiwTJmdfyr6z7b7aJswl9XzMQWhGxJF
	 eqo/21gOm5xQ1l3RbyZTF9IpTMIev8atTKtK8l81HakCzegLUwVP8Ysip/B7Qd0rztg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015540;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SEPlPQsmlKWypx+o40SlbwgKsCuhSQgq5NUiuTLZuTc=;
	b=VZnZxs2RmGTbLQebWYB4Rz8wNVyJGrggB2JOT87LiZgsSrc6QUzkcOr7G/xT0NKo9gRw
	 qJWpwSb9RzpmE4t3+9jT1jxhWCHEV7SwcW5GadnH5pwIrlEKzxWeRkr9aoGjb/eXz/PSc
	 CvWlG6y65QPSqGf5MGnNQ0bNK1HW6j4qhGNipGjst2/mjCeh3kVZHZGCYUOZu4eReynCJ
	 DMpPwCLoO8qJpb4dvsjVQdJBzmFrKf/4cHUMM09ERCQO7ZXwKd2h+Ul4HxaXPRKHNQyRR
	 CiPY31gWbZZCYoVmnpmaV/jMV4y5xlB/kG2p36FMnkvETIDdbowqBafthxGtOoe4aVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Nxx1pnC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE12F606A31C;
	Wed, 18 Nov 2026 15:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Nxx1pnC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A5CD1F000C4;
	Wed, 18 Nov 2026 15:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015540;
	bh=SEPlPQsmlKWypx+o40SlbwgKsCuhSQgq5NUiuTLZuTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Nxx1pnCF2o6qWc1hqowHu9zJnYipBoWapJJZkE2KueuWV+v43I9fvdx/XYBYhrCu
	 pmzjGe16pPXjKIN7XLmFQsNCiqTbcKNizjN/V2Ep9efebAXZZ16eeoqU+54WVXguid
	 CueOj/UYrsuEfGvz3yaqlXzDC1qwryypXDJq1zHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horst Birthelmer <hbirthelmer@ddn.com>,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0159/2651] fuse: dont bump attr_version for async direct read completion
Date: Wed, 18 Nov 2026 15:23:19 +0100
Message-ID: <20261118150253.575587320@linuxfoundation.org>
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

From: Jingbo Xu <jefflexu@linux.alibaba.com>

[ Upstream commit fc60668db85584da911e5d0a65c8698628f98bba ]

The attr_version counter should only be incremented when cached
attributes are actually modified (as documented in commit 1fb69e781729
("fuse: fix race between getattr and write")).  Async direct reads do not
modify any cached inode attributes (size, mtime, ctime), so bumping
attr_version in fuse_aio_complete() for reads is incorrect.

This unconditional bump causes a livelock when auto_inval_data is
enabled together with writeback_cache: fuse_cache_read_iter() issues a
FUSE_GETATTR before every read, but by the time the response arrives,
an async DIO read completion has already incremented fi->attr_version
past the snapshot taken before the request.  The GETATTR result is then
discarded (attr_version race), fi->i_time is never refreshed, and every
subsequent read triggers yet another GETATTR -- creating an infinite
loop of useless round-trips.

Fix this by only bumping attr_version for write completions, consistent
with the synchronous DIO write path (fuse_write_update_attr) and the
cached write path.

Fixes: 01e9d11a3e79 ("fuse: add support of async IO")
Reviewed-by: Horst Birthelmer <hbirthelmer@ddn.com>
Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index bf79c6eb3062c..7e6eba6e7086f 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -689,7 +689,7 @@ static void fuse_aio_complete(struct fuse_io_priv *io, int err, ssize_t pos)
 		struct address_space *mapping = io->iocb->ki_filp->f_mapping;
 		ssize_t res = fuse_get_res_by_io(io);
 
-		if (res >= 0) {
+		if (res >= 0 && io->write) {
 			struct fuse_conn *fc = get_fuse_conn(inode);
 			struct fuse_inode *fi = get_fuse_inode(inode);
 
-- 
2.53.0



