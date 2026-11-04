Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831162;
	b=KOh7iLGAnJV3iaPIEY3fQchGBvYQDl1+YPp5LAGuxK/X63tBomDU8GZNCBUGOy4S8exm
	 gT03hMIXesaUz+xyLFumizykujS9SHMUxbm/xuQeBdMbsB+MSxvdCVXvXayUT//oN9/R5
	 /gFF90/CAucASfkXbTb6cSU1Ze1dapCXmuakoL5+yrZ5NNpA/sgoXvySeFiZXjw6KJvbj
	 8iBs8G0hODpHRVGfZTOYpI3zR2MVj/6sUVgqFPauASlDv7IBHV53UQZbhvUzvlwLHoADf
	 WqD16/6ZkfQi3RClPKUDfse+NfxmQ14FjaI0qb4sn0Tzjpj3BGfhHn2ZOYTj76wXmnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831162;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VNQ3Gm3qQgO8XD7ZGQxys7KaBJ/Psmcm0INzaVjTcXU=;
	b=I4W18ok9SZGFwmeVBrQe8mZFZKuQ8ToHxNJmdGuNmzMCgBiwhfu5flTMoeBYrpD35GmS
	 gAP0jm+Y0ZQRavmD8xE6peVDQ7wNc8P1tJaq3BFj/5lnp1qTlm1083Nh9SFMCKcNo0rRC
	 rT87vYqRikgmimgdHcDWHW0CF0DcJHJhyXIRD4DR4MDIo5mTkv3jZxMUj/gDCRqya//zr
	 vuo3ddk3wrpUk6/hv535G/bsdnsgmE52w6Bz1NyIDv8KF5gfWC3kzKy2WqDzOeaXjC3/E
	 RCRbUhT33TCwL3+rQ/i1p4CmJFPkOzthTZ2XkZ5roe6BhEjPKslbM0u71rE/l5Zhitw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="urlF/aDj";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F57606D82F;
	Wed,  4 Nov 2026 22:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=urlF/aDj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D203A1F00919;
	Wed,  4 Nov 2026 22:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831162;
	bh=VNQ3Gm3qQgO8XD7ZGQxys7KaBJ/Psmcm0INzaVjTcXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=urlF/aDjFQN9717XnfmN5gomr171NU+HAQIHS7e552OUrrUaPIzMHXIjLqhLkagq3
	 LdrWth0cLehlt3sG6c6FNqmCyuF3iclOmX8WW1073OYi8uNqu66+UAbaHXRSHMh3wx
	 /z7f1E9cDGm4fhBkqTEngrrMAdVenTi/+6p++BBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Giorgi Kobakhia <gkobakhi@asu.edu>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 6.18 0534/1005] udf: fix return value for non-recorded-allocated extents in udf_map_block()
Date: Wed,  4 Nov 2026 16:04:27 -0500
Message-ID: <20261104211058.858348518@linuxfoundation.org>
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

From: Giorgi Kobakhia <gkobakhi@asu.edu>

commit 0f242ca0878896df30292f4922700a32e8fdd039 upstream.

When someone creates a corrupted UDF filesystem where symlink contains
other extent type than EXT_RECORDED_ALLOCATED, it can leads to a crash
like:

 Oops: general protection fault
 KASAN: maybe wild-memory-access
 RIP: 0010:page_get_link (fs/namei.c:6503)
 Call Trace:
  vfs_readlink (fs/namei.c:6419)
  do_readlinkat (fs/stat.c:583)
  __x64_sys_readlink (fs/stat.c:605 fs/stat.c:602 fs/stat.c:602)

This is because in this case udf_map_block() fails to convert return
value of inode_bmap() from 1 to 0. Returned '1' propagates through
udf_bread() all the way up to __page_get_link() where it ends up being
treated as a folio pointer with obvious results.

Move the reset to 0 line outside the if, so udf_map_block() returns either
0 or -errno, even if the extent type is not EXT_RECORDED_ALLOCATED.

Fixes: c226964ec786 ("udf: refactor inode_bmap() to handle error")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Tested-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Giorgi Kobakhia <gkobakhi@asu.edu>
Link: https://patch.msgid.link/20260928200445.18722-1-gkobakhi@asu.edu
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -375,8 +375,8 @@ static int udf_map_block(struct inode *i
 			map->pblk = udf_get_lb_pblock(inode->i_sb, &eloc,
 							offset);
 			map->oflags |= UDF_BLK_MAPPED;
-			ret = 0;
 		}
+		ret = 0;
 out_read:
 		up_read(&iinfo->i_data_sem);
 		brelse(epos.bh);


