Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7E319AA62;
	Thu,  6 Jun 2024 14:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683031; cv=none; b=iO/ZeHzgEkhR0+KonXkAgDKeaa8pV4jv04BjP0yjh75uUggwGwbHU3md2HPHJc1bKWw4IA9IFY5AKc4gc9dEPft2L6545HxxHneRSN/BzfduLR6TRqKpEJti5MAJdv8aUqgNGl3cUAoCCezvdGQ4JQHuaG6lp5VpSoL2ZP5+BmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683031; c=relaxed/simple;
	bh=68h/OHPdw+0Gc+h4VtDK4167BzAlqL9PxKPhU54jb5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PHdgYHjSyBTobt70YjZcoKhAThcgcQWMfaB1jdGEgCkLqrPom+lUtoQX02Tl9XjjPbp/dwf7w/wd0xfmVJDzl+Kc7l3WLHC2XIE8CHNv/rhEX41JCShjmT8fhOJhfrYR1xXPISm5q4IYqL0bNPsj90cj+ECQbpmDeW8EA5cowEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=deDxVYmh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="deDxVYmh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFA06C2BD10;
	Thu,  6 Jun 2024 14:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683030;
	bh=68h/OHPdw+0Gc+h4VtDK4167BzAlqL9PxKPhU54jb5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=deDxVYmhkRWoIYiukWWoFjgn5yQRWBbh5SRIR78kercD4FdqvUosQDM8Ukyw7qhdh
	 l7quJrMKgvtCY6SJuTjgNwLGzkALYP9yRCGgD7iPRyJwMWqUdiILNTVHTvHtDTiUsB
	 OJZd3+MqrlRRsjIpyC6LGkGZBkNjkVBfA8nxryQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <kolga@netapp.com>,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 254/374] pNFS/filelayout: fixup pNfs allocation modes
Date: Thu,  6 Jun 2024 16:03:53 +0200
Message-ID: <20240606131700.350819904@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



