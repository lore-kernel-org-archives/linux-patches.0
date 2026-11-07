Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064200;
	b=FQuiaQh1/QEKaOle4iPkL/QCuMnwQgfsB0wH24ODMhar3+aB04/0al2o5LVTZaq0mm5u
	 /plG36yuJiIM3HDa19ViW4Qnk6CeXKB0SdvGCcOgVvCOaF4HF5wsHZESiq9niTpzJTtW7
	 cfeDKF3+SMDnK0U197iQvYTZYzP4PwL+pNi2lnxEepliqup4y8SnGjjCWaGoR/P7AiR4X
	 gDwZcGowQs0pGLOBYPTFNMIzWkp9HC0bIhteBXNJ0toZbzTHQoaKgRtNKwSre4DSEcM3H
	 9XpFlE/gCxlW52MgtMc2rpkClGQKmq7hutFJo7er4xJd9SWr0JZLX/mjCfZzI1lVmcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064200;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Df6i0TunELCDwFkwnNZAmKfi0rrcLEzaUFe6DusB07o=;
	b=n+sZ0N9FD+v+aYUyAwnuSz83ujY4Ltuyiq3oZWfBL83AHa/O991b86LD7HONEczbj1OZ
	 pb+qOBylMktAtu2WsW332V4wYxKtWS0JcFCFntM5pzlDtxVrG4iVreulcb/XYorlbbLDV
	 oVBOkwQSoj67Xkc5YPrUS6dFD7/q9rkDRXC+N+8xAmM/rjY80cOb0sinYtceaLPf9kfyh
	 x36RymrZoqtT8Aaye1wXKJ+7U99PdN3olxkJ0RoNZ1WTTWFhVF7icVddyPutUq0fSEPDX
	 CSv6IT6jhMba6aEgWM4oNqAt0fvcnLXLw4VofTp917VvaaeACrm1JSm6BgxZeUBXYaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZsRs42ZZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACDD8606EEB2;
	Sat,  7 Nov 2026 15:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZsRs42ZZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 599BC1F008A2;
	Sat,  7 Nov 2026 15:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064199;
	bh=Df6i0TunELCDwFkwnNZAmKfi0rrcLEzaUFe6DusB07o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZsRs42ZZy0A7ll0jTcFRuiO0+wQOLqK2SjZ45O++8Y9Og/CdOXyBO5lpN4X4qgvbP
	 vwwDPERQfe6N1cem0yesfLDNNMqTKJpuqzeHOHmlk3CwEAbJMnVIOPG9GNH07hTw80
	 tZYzDLsM6EuP/hlLAJC39LkbZV4+Qb4avV+nx6F4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0300/1257] fuse: dont drop destination page cache on a zero byte copy reply
Date: Sat,  7 Nov 2026 08:43:16 -0500
Message-ID: <20261107134947.742722834@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Joanne Koong <joannelkoong@gmail.com>

[ Upstream commit f7585e1ce3418ec282485854b3d8d31c6a961e37 ]

__fuse_copy_file_range() clears the destination page cache after the
server replies:

	truncate_inode_pages_range(inode_out->i_mapping,
				   ALIGN_DOWN(pos_out, PAGE_SIZE),
				   ALIGN(pos_out + bytes_copied, PAGE_SIZE) - 1);

A server may legitimately reply that it copied nothing, eg if the source
file turns out to be shorter than the size the kernel has cached for it.

If pos_out is 0 as well, the end of the range is ALIGN(0, PAGE_SIZE) - 1,
which is -1. lend is a uoff_t and truncate_inode_pages_range() takes -1
as its end of file sentinel, so rather than clearing nothing it drops
every folio in the destination mapping.

That is not only a cache drop. truncate_cleanup_folio() calls
folio_cancel_dirty(), and fuse_writeback_range() only wrote back
[pos_out, pos_out + len - 1], so dirty data elsewhere in the destination
file is discarded without ever reaching the server.

Skip the call when the server copied nothing, since there is nothing
stale to clear in that case.

Fixes: 9b46418c40fe ("fuse: copy_file_range should truncate cache")
Cc: stable@vger.kernel.org
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/file.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index b52f5b45646c9..0f2c9404af74a 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -3058,9 +3058,11 @@ static ssize_t __fuse_copy_file_range(struct file *file_in, loff_t pos_in,
 		goto out;
 	}
 
-	truncate_inode_pages_range(inode_out->i_mapping,
-				   ALIGN_DOWN(pos_out, PAGE_SIZE),
-				   ALIGN(pos_out + bytes_copied, PAGE_SIZE) - 1);
+	if (bytes_copied)
+		truncate_inode_pages_range(inode_out->i_mapping,
+					   ALIGN_DOWN(pos_out, PAGE_SIZE),
+					   ALIGN(pos_out + bytes_copied,
+						 PAGE_SIZE) - 1);
 
 	file_update_time(file_out);
 	fuse_write_update_attr(inode_out, pos_out + bytes_copied, bytes_copied);
-- 
2.53.0



