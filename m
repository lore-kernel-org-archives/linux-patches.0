Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061477;
	b=TTgcQ8qd43NQhAfXx1pqD00VgrjdMil/+81pLdOiZUe3RXGzb9L1HcNC+vUbGvZU5kfh
	 jNj3NiNXRPaBtjraUW7UpGrLm0Hz+gEvXWBnH/EKTjS+0bzn92pseLgAddZ6B3a7w5EK+
	 P/QVpBol2rn4dHv5HDfYF3XHOGsWvFUqMARctn75vNfmn7jvmwywg3TtRxBU2g65eR/E9
	 wskGTtctUhD/YeKb+HZcQ7fm+J9KTITLiugj/eSEXWEB9wJOzYnneNrzsjYpmx5XAqRky
	 kzTk5SvQL1ldPIUZlgV450MVCMXxn9KjhyFJvFTxztKP4fYgkPvhFatD5vMwtYQ1cUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061477;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iRngBLc0ceukZ8Jiq0B+tB0McAP2odRNQGzEVW6RoFE=;
	b=koHolm4egvUhtT0xqzQ9/6xKPrNJaQmvSNMgBKun1Qctieph1uwa18KnH0ZnvjSoJKKO
	 mx4kAnCW2jtBLhXJbvsAIQhYlNvoXyKfG0SC4YzB//D1amWUAko4KCQpMnyRxRx18Dc3v
	 kmmsXQDmNmhL715K4FGdS8FgvY63NuyjXE5UNoz5BTSOpId/doXVNKAu5z4LwSoKiZCQo
	 RdTfK8KXiHUdMOi9L9mb722jGdUaHVWrLD2yUhk7prN465/fxal7CnLV6zaSiUEXGpsLk
	 qN4vtpBjT6XmCqsLiDPk/+10XBU4hkfiRxNG07WsL6G4W5R+G2TIj6h4dd6Nb6u/Z1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AEh5vRZc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38CE606A326;
	Sat,  7 Nov 2026 14:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AEh5vRZc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53E0C1F0089F;
	Sat,  7 Nov 2026 14:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061477;
	bh=iRngBLc0ceukZ8Jiq0B+tB0McAP2odRNQGzEVW6RoFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AEh5vRZc+9gadqZyW5dRYYAN2AMpPmxG3gq7xSpFKg7bqO3e4ftPAd78idc3BWrto
	 h6rupiRGNYLYD3N4SfGXCjGAmv5InoAPfG5+pSkfAPudLB9O2qvxUVADzTC6nCtmtJ
	 +rTrX0nr4B//pIQASUwHu/s/LIaLiEeov3vHI9Io=
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
Subject: [PATCH 6.12 0540/1536] smb: client: discard post-EOF pagecache when extending a file via clone range
Date: Sat,  7 Nov 2026 08:42:36 -0500
Message-ID: <20261107135012.791303985@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced upstream's local i_size snapshot with an inline i_size_read(target_inode) call, using min_t(loff_t, ...) for the type check, since this tree lacks that variable. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsfs.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 23ffe878dc3eb..b845010829c5b 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1378,9 +1378,15 @@ static loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
 		target_cifsi->netfs.zero_point = fend + 1;
 	old_size = target_cifsi->netfs.remote_i_size;
 
-	/* Discard all the folios that overlap the destination region. */
+	/*
+	 * Discard all the folios that overlap the destination region.  Start at
+	 * the old EOF when extending so the folio straddling it, which may hold
+	 * data written past EOF through an mmap, is dropped too.
+	 */
 	cifs_dbg(FYI, "about to discard pages %llx-%llx\n", fstart, fend);
-	truncate_inode_pages_range(&target_inode->i_data, fstart, fend);
+	truncate_inode_pages_range(&target_inode->i_data,
+				   min_t(loff_t, fstart, i_size_read(target_inode)),
+				   fend);
 
 	fscache_invalidate(cifs_inode_cookie(target_inode), NULL,
 			   i_size_read(target_inode), 0);
-- 
2.53.0



