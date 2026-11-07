Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063978;
	b=YXUMNj0hT/xKUnk7/4uCad0Ads9ErZJcErTgOUFHjuBdPYD+vh4qcVBMT+6MgjJPm15w
	 mm9fVMV0GJxZWnGbxN4/9UjxSZgloJRWzy7/DWWzwaDq9/o5Xy1F+wBuWV2E3v5HQeHSi
	 3weuE0DrWfno9cX1F1O3/V8/OMU37tzlSI1P12R3ZEZV3RMij32sExt+Hk8Wiq62hTs3a
	 8YaXvTgiwU0JHt0vhZGhKTsz6Znp5WaWzMeS+jBIFtr3y3Aphxdm3Trgir+TJXdLMOWMv
	 s3ce8L0dlRpFhBVjyxh7s1WtH/mmbIyAJNO0mWeHd4LRERKMvEZktK1WwIeon36bgZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063978;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=3Gzj0DS1vRoNK6mayKdwxsXLD/rgkEGYLJ1h9if5+ME=;
	b=TDfVTPLzWOSGnnan9mL1vcpDa5tONpfD8mGN+r70iuBSs7xajxi4Z6NhWwbn+jJGi5Ws
	 NeWX6b1mUUbTt+xmbj6upQm/JSCFWvuyIjxM657HsoE8s0J5iWQxWRp+OCM8rzMVWufWn
	 BmReWFaqawOC4O+gQ7wdT8MuN0unqQ7kQpunRgbOeRDPcejhnNuxlxeM/O8xA5jbTy1/e
	 9cLy4IbioqbU3GdfTf00sX0VLf9e7IkOs/0webRz+77UTDlk4sv1MrBxjiPlnPZh1qmNe
	 oS8pHgoC0J7emqd3uwhiDte81N8uy7/o4ebamkWi/IzWWCCx96I1D4TAv2AoUVxuOgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cInmJF7d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680D4608362B;
	Sat,  7 Nov 2026 15:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cInmJF7d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4E21F008AB;
	Sat,  7 Nov 2026 15:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063978;
	bh=3Gzj0DS1vRoNK6mayKdwxsXLD/rgkEGYLJ1h9if5+ME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cInmJF7dhTncrF4LE63OEOqrulEZrhgvV2cmiva/kQ1oVpoyvv+3+cghSOyNagSKl
	 c37rHjLooPjvUdGlPh7PB+1a59LzTn9LdXGpTeGu177anmRowkgN6dMcq1928H/VHF
	 y2NBbiGNZYYZRbiCTjxJd7i1iiiPF4ty1BVcnDvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jiucheng Xu <jiucheng.xu@amlogic.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0161/1257] f2fs: force out-place update for all writes on compressed file
Date: Sat,  7 Nov 2026 08:40:57 -0500
Message-ID: <20261107134943.777104513@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiucheng Xu <jiucheng.xu@amlogic.com>

[ Upstream commit a64a3fec11e77a3a0dc0009bdc58b925e45a1bb4 ]

For compressed file, compressed write may fail and fall back to raw
write.

-Thread A                                         - Thread B
  - f2fs_write_multi_pages                          - f2fs_down_write(&sbi->cp_rwsem);
   - f2fs_write_compressed_pages                    - ...
    - f2fs_trylock_op                               - ...
     - f2fs_down_read_trylock(&sbi->cp_rwsem);      - ...
   - f2fs_write_raw_pages                           - ...

Thread B acquires the lock first, which causes Thread A to fail lock
acquisition and fall back to raw-data write.
IPU_FORCE is enabled on small-capacity storage devices (< 16GB),
so f2fs_write_raw_pages() overwrites the original compressed data
in-place.

The in-memory node has been updated with raw-data addresses, while the
node metadata stored on eMMC still remains in compressed state.
If a power-cut occurs before the node is flushed to disk, on-disk
inconsistency arises: disk data is raw, yet metadata treats it as a
compressed cluster, leading to decompression failure.

To eliminate this risk completely, force out-place update for all
write operations on compressed file.

Cc: stable@kernel.org
Fixes: 4c8ff7095bef ("f2fs: support data compression")
Signed-off-by: Jiucheng Xu <jiucheng.xu@amlogic.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 21f396ebe22ca..5a4af37b358d3 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2909,10 +2909,12 @@ bool f2fs_should_update_outplace(struct inode *inode, struct f2fs_io_info *fio)
 		return true;
 	if (f2fs_used_in_atomic_write(inode))
 		return true;
-	/* rewrite low ratio compress data w/ OPU mode to avoid fragmentation */
-	if (f2fs_compressed_file(inode) &&
-		F2FS_OPTION(sbi).compress_mode == COMPR_MODE_USER &&
-		is_inode_flag_set(inode, FI_ENABLE_COMPRESS))
+	/*
+	 * rewrite low ratio compress data w/ OPU mode to avoid fragmentation.
+	 * If IO comes from compressed write path and fallback to raw write,
+	 * force out‑place to prevent metadata‑data inconsistency.
+	 */
+	if (f2fs_compressed_file(inode))
 		return true;
 
 	/* swap file is migrating in aligned write mode */
-- 
2.53.0



