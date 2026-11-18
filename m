Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034445;
	b=TkQYcdBx8wDM6eedQETQHWfze5JYuwUUgyJU0Y2YzqoMIY6Z0QORYh08YAUnoahBsqjh
	 a4SewsQIDYbaR8EonmlOuZwWSHDzxWyjNhXTpBfIrTMwjZCG6+/ICSAgwfVX+o7XY9Ued
	 w0s6EYt317Qc0RHVaUDx2p7HsCjTyntO+9QvzVybd6nAdp4mNy/mxzlg8f9YKXpQ69754
	 GY7ihhLZghwf7SQp8gsXJLPedWKvCH1cA+O6ucS/Ay9u6eJrl3Zwgi9V7FNmomNA8Upw2
	 +d+emomtqnuPEgX4W6EFSR9Um8PsSQw3JKxt26fIJ9a6w8b1RFvapDKV16WSuCZ/c6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034445;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uXmZGmufmuvkuA7TcJ6Xusc/xLl0va/7Tf5xCmdC/m8=;
	b=NvvvLowDXnpfM+0KnTCJ/Nt5oVN5wIgDUJdaPo5tdVPJuWEF3JKYuqnWlESv4rwJytaI
	 u+yV0fGMZZgEk3XvJJLiJJl8muxlucUQcKBOThpuz2AuLmLEltLialr70lbFC/a9i1mdj
	 Ua+GCqv6FRFf1gyDrrww/DgzRPrOPVBAehsMD8R1aKGxl0EejDJkJjtmSCJqw44BXnE+T
	 8AalfV3I82FlRP1Ty9iqZ7ZgQ8Q/gWKiWnV0wyijOtTlPnpzNyBjgraP+LPI6L8VV0byl
	 ebqw7jVrQ/F2dCgriuv4NTjcX58kqg0nKIUnHGRmc9tYnX9dzu/z2739rN2SPArDI3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hev0Lp9x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA771606A330;
	Wed, 18 Nov 2026 20:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hev0Lp9x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B9921F000C4;
	Wed, 18 Nov 2026 20:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034445;
	bh=uXmZGmufmuvkuA7TcJ6Xusc/xLl0va/7Tf5xCmdC/m8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hev0Lp9xZKOxi5A/VDUE0aojmfMFUejZdsdxk8yH4XfV9i9wJcVR35EPmRYJEt47W
	 NTsPPh1E+l0ojT+egWcYAsZID39ln3+In4xf09BWkcMOzj6/ybUkIZNxQKiI3D30yN
	 zORQvujIPkxDYtVUy7wEE43ASZTXzlIRhKMs/4Ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Giorgi Kobakhia <gkobakhi@asu.edu>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 6.6 0370/3318] udf: fix return value for non-recorded-allocated extents in udf_map_block()
Date: Wed, 18 Nov 2026 15:16:32 +0100
Message-ID: <20261118150327.301274073@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -441,8 +441,8 @@ static int udf_map_block(struct inode *i
 			map->pblk = udf_get_lb_pblock(inode->i_sb, &eloc,
 							offset);
 			map->oflags |= UDF_BLK_MAPPED;
-			ret = 0;
 		}
+		ret = 0;
 out_read:
 		up_read(&iinfo->i_data_sem);
 		brelse(epos.bh);


