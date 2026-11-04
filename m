Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831739;
	b=tKoIgmcp34HspCe8diao2kfACjX5jGrAyLhwWfCSGs+hwiH8MCgXDdGg9tQlnop1CM9o
	 D/Rt1zldqQ9SRqWAA6Ou2QHmUOVoh0bhlZ0Y5mwVIizOVSeUfHzbYJbamoonU3wRnqJD1
	 vtehML6NvNqGVm3niy701FA7kzEkpSnJQLdwdGNh3P2W+Cs+I4QqIAvrcMPXyzVPOKzaO
	 8ol4kmNmEOOr/yeXZHYPlUS3rjdVNEjSsuLvo/D3G8+9w4fC8L+sA/ulTFuv/dAlbYwwb
	 TSBItNdxF2THPKBrzuxhY8f/i59gg8LSVEAIixNjpfZ1535EjPaXy4Ha/HTrwygV5sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831739;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zVlWQYbaBpPp5IEWgycOy9OqkaPQNxOn2JVmc/F0KhY=;
	b=CZSEggnRsKUrCL9ckzoVSTQIBdS1Y2yQSIbaevXV70blUAGnLHPR4/C4KF02USl3lYlZ
	 zjpmsehU+DnDzmuN/j/lAj5lLb4aMMSSzUDMsd2KSn7eKDviRTRrH7UHNTkGmML4qMdqP
	 missWbivQGhvjVFE63xdRZu5UTsh6dDq1E9VUSDu3uUV60UXEcO23JD8eNhHCVPk/3PdW
	 E33xI4tegGmArEwlLTvOE/Okb3aVHRyN5JqP9hdrNGyrSBXMoJDTwHt76mGWbolc2VZBL
	 wg8N1fhweeZmHPnPSqI6QMJdPKAe3aX3GanvXDZG7IgGTCZfTRkq/QL5gRm46mBQ9AQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2nJxSdn4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D8B606A32F;
	Wed,  4 Nov 2026 22:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2nJxSdn4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E52D31F000C1;
	Wed,  4 Nov 2026 22:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831739;
	bh=zVlWQYbaBpPp5IEWgycOy9OqkaPQNxOn2JVmc/F0KhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2nJxSdn42YyrULDtZ6c/EiH7UoKuqJgWm/0RcIwpQJh0iEmEnluF0nXCMdNrfUCEM
	 uZNqcb3F0wF8ZwptSMLdTS66V73D+KlW0GVX6iQm2ocI63vaYcnWGop71lZwL1gJGo
	 C4T4m9TBAdircxwcHKa7m4OzglC/EzQovwDifGnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 6.18 0883/1005] NFS/localio: fix nfs_local_dio_misaligned tracepoint
Date: Wed,  4 Nov 2026 16:10:16 -0500
Message-ID: <20261104211107.972099702@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Mike Snitzer <snitzer@kernel.org>

commit 1ea352a0db8bcb6ff6820e9a8715aac0aa3c761f upstream.

The intended focus of nfs_local_iters_setup_dio()'s call to
trace_nfs_local_dio_misaligned() is on the middle segment being
misaligned, yet the @offset passed in was local_dio->start_len.
It would appear this was a cut-n-paste bug from the preceding
nfs_local_iter_setup() call that passes local_dio->start_len.

Fix this by passing the @offset as local_dio->middle_offset and
calculate the start segment's offset rather than assume.

Example traces, before this fix:

   python3-32744   [006] .l... 132946.352360:
   nfs_local_dio_write: fileid=00:33:1286 fhandle=0xf1f7c10b
   offset=1048759 count=1048576 mem_align=4 offset_align=512
   start=1048759+329 middle=1049088+1048064 end=2097152+183

   python3-32744   [006] .l... 132946.352360:
   nfs_local_dio_misaligned: fileid=00:33:1286 fhandle=0xf1f7c10b
   offset=329 count=1048064 mem_align=4 offset_align=512
   start=329+329 middle=1049088+1048064 end=2097152+183

After this fix:

   python3-32744   [006] .l... 132946.352360:
   nfs_local_dio_write: fileid=00:33:1286 fhandle=0xf1f7c10b
   offset=1048759 count=1048576 mem_align=4 offset_align=512
   start=1048759+329 middle=1049088+1048064 end=2097152+183

   python3-32744   [006] .l... 132946.352360:
   nfs_local_dio_misaligned: fileid=00:33:1286 fhandle=0xf1f7c10b
   offset=1049088 count=1048064 mem_align=4 offset_align=512
   start=1048759+329 middle=1049088+1048064 end=2097152+183

Fixes: 6a218b9c3183e ("nfs/localio: do not issue misaligned DIO out-of-order")
Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/localio.c  |    2 +-
 fs/nfs/nfstrace.h |    5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/fs/nfs/localio.c
+++ b/fs/nfs/localio.c
@@ -448,7 +448,7 @@ nfs_local_iters_setup_dio(struct nfs_loc
 
 	if (unlikely(!iocb->iter_is_dio_aligned[n_iters])) {
 		trace_nfs_local_dio_misaligned(iocb->hdr->inode,
-			local_dio->start_len, local_dio->middle_len, local_dio);
+			local_dio->middle_offset, local_dio->middle_len, local_dio);
 		return 0; /* no DIO-aligned IO possible */
 	}
 	iocb->end_iter_index = n_iters;
--- a/fs/nfs/nfstrace.h
+++ b/fs/nfs/nfstrace.h
@@ -1771,7 +1771,10 @@ DECLARE_EVENT_CLASS(nfs_local_dio_class,
 		__entry->count = count;
 		__entry->mem_align = local_dio->mem_align;
 		__entry->offset_align = local_dio->offset_align;
-		__entry->start = offset;
+		if (local_dio->start_len)
+			__entry->start = local_dio->middle_offset - local_dio->start_len;
+		else
+			__entry->start = 0;
 		__entry->start_len = local_dio->start_len;
 		__entry->middle = local_dio->middle_offset;
 		__entry->middle_len = local_dio->middle_len;


