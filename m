Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901A71A1871;
	Thu,  6 Jun 2024 14:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683715; cv=none; b=NW08QqSnKsRlEU0NXv/fiF4dRChm32z9seT9umIbu61uoQ4fIpCgv0x7lHkv/N4/zqDoEhe9mtF0BljRuINVsByKnay/+VoRIep0R7f5d0nTekxbsVXPXEp7aBLO08htOfkEX2ZqaOCrguaZIIVEldKrBwPqafFK4zrjFmBh5Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683715; c=relaxed/simple;
	bh=uS4sLXEvwEds85cDw56zU1vAnFTzmnPokXqmSN1hi/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SviJbPF7yvHhEA7Ue4cOl3vwQZ0jUAi8/AcEFjqM2fPJPM/CpiVdps/DA6TSkCGQHp3/dVaBzOzSAgicuWS9b+DvosrU4sPt3YrCbsi281WsiQBZLG87w5lIDjtK9Vdb1ZgV+5o9vdpdl+faId0TIPoz/w+Cmr5xEk37zVZyusg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ljqbS3BA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ljqbS3BA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C44C2BD10;
	Thu,  6 Jun 2024 14:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683715;
	bh=uS4sLXEvwEds85cDw56zU1vAnFTzmnPokXqmSN1hi/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ljqbS3BAQuEairCM7DBvXxCSzSgbnyzM+KdSgJFaqu6jOZfD69uNgMLD3MV3xYgxF
	 lyFJzUmPclogVh7oWdPytVP3t3TlYbdb/2dk7gv5uQGkpJgIaUJoDOs4G0itaYqsG0
	 +RCzK837cB29DEBfoMLWu/lKk+qTPHKEzSY+38aE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <kolga@netapp.com>,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 649/744] pNFS/filelayout: fixup pNfs allocation modes
Date: Thu,  6 Jun 2024 16:05:21 +0200
Message-ID: <20240606131753.281399621@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olga Kornievskaia <kolga@netapp.com>

[ Upstream commit 3ebcb24646f8c5bfad2866892d3f3cff05514452 ]

Change left over allocation flags.

Fixes: a245832aaa99 ("pNFS/files: Ensure pNFS allocation modes are consistent with nfsiod")
Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/filelayout/filelayout.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/filelayout/filelayout.c b/fs/nfs/filelayout/filelayout.c
index ce8f8934bca51..569ae4ec60845 100644
--- a/fs/nfs/filelayout/filelayout.c
+++ b/fs/nfs/filelayout/filelayout.c
@@ -883,7 +883,7 @@ filelayout_pg_init_read(struct nfs_pageio_descriptor *pgio,
 						      NFS4_MAX_UINT64,
 						      IOMODE_READ,
 						      false,
-						      GFP_KERNEL);
+						      nfs_io_gfp_mask());
 		if (IS_ERR(pgio->pg_lseg)) {
 			pgio->pg_error = PTR_ERR(pgio->pg_lseg);
 			pgio->pg_lseg = NULL;
@@ -907,7 +907,7 @@ filelayout_pg_init_write(struct nfs_pageio_descriptor *pgio,
 						      NFS4_MAX_UINT64,
 						      IOMODE_RW,
 						      false,
-						      GFP_NOFS);
+						      nfs_io_gfp_mask());
 		if (IS_ERR(pgio->pg_lseg)) {
 			pgio->pg_error = PTR_ERR(pgio->pg_lseg);
 			pgio->pg_lseg = NULL;
-- 
2.43.0



