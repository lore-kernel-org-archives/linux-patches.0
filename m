Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061138;
	b=fgO4ETaykBvzuKV8kgOFWhnrOxcfxDXj8kfkx6jGkyPFLH4ZW7RWLu9Oro6gAJga2HW/
	 b6yt34eYBhCoD2vtz+Mt0h+0HHmBuJJDFk5vpn+LIHNu7BpKVoHmC8l+q5xX6QhT71+mv
	 uMirHmIaDR1pT/I8j9QzdZN/n7sIFRroHwkGvmgAN5CXWtb8sqEJL70c7q9dUuMC145Z8
	 8fVbeGWnfKTTfB0eOLe4VHMcSI/xptVbCJbf4QdciEOmkJnrK4T4j2FuWRVHKnO4tdHuT
	 rQkiot1XbTnb5MReSW4BQkTB/gcfuCs+gvsYv25o1usSMFzhz6WI89POTuQaZC0jcEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061138;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dj5qd7DseZMF3zTjj8fTxTuICPjCmnh8Mhu1MQsqfYE=;
	b=k5z2JKVDQstzB0QxsgEAbN9hvVwMs8DFNPdy1rB5a/0BfcJ8PnWbOl4c/OqSYtbayv8r
	 wRc62Glm+poIw6fP1RTqLAKlzg15XdxCUV/w7cMqUJuQHioXXPqsaKNFJEte7MN2Prlwa
	 Vw8rVBTx2nCGt39Z28c04akE7DPNOjFz94JfVDb9nqNcpQjGiQDwMnM2aomUyM49kMPai
	 IK5jsRdXSRkYp4/wvye/YZnpW1qBXMu8WngJqufgZECwZ44GdRDRUTwsaLNrXToTpnetj
	 28GDrV8HbBksIEpMJepqs5kEQVg+EKJby1DxorEMGg5hGuV56dQVHJACLXFtjxCEL3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fp2RNQWi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC953606A332;
	Sat,  7 Nov 2026 14:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fp2RNQWi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A8451F0089F;
	Sat,  7 Nov 2026 14:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061137;
	bh=dj5qd7DseZMF3zTjj8fTxTuICPjCmnh8Mhu1MQsqfYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fp2RNQWi7vQQ2+UPfMqdani/iEjxPBwA64yzgO6XzpLsx3Qc/EnaZyU5/OEMOwRkH
	 iF+dkwnMA1M1YOCEjIZNl/blQtAjZ/1nHVMCnenlRM7vpyDtolLjFNQZn1l97MAwdg
	 Zm2TVzDIG5IqFVeoFROQ4R2u158ycI5X6mxtSXnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Giorgi Kobakhia <gkobakhi@asu.edu>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 6.12 0446/1536] udf: fix return value for non-recorded-allocated extents in udf_map_block()
Date: Sat,  7 Nov 2026 08:41:02 -0500
Message-ID: <20261107135010.069346886@linuxfoundation.org>
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
@@ -368,8 +368,8 @@ static int udf_map_block(struct inode *i
 			map->pblk = udf_get_lb_pblock(inode->i_sb, &eloc,
 							offset);
 			map->oflags |= UDF_BLK_MAPPED;
-			ret = 0;
 		}
+		ret = 0;
 out_read:
 		up_read(&iinfo->i_data_sem);
 		brelse(epos.bh);


