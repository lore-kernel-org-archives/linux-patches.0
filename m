Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9C31ABE36;
	Thu,  6 Jun 2024 14:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683522; cv=none; b=hr7pH+IF4Ne6L/CwK3pnYokHh3D47qLDw7WX3aanze+EewQtmUKGgbhm5AcFjLX0zZU8y4V2xL9+dFyp+6KpZcHMuY5Fat0A67rQzOi/oxSEKaOAEI/JhOz/cL32GZLq42lwRxRWNfMQwuYmG6XMst3T3yqQQAVg7C1gsLhu1B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683522; c=relaxed/simple;
	bh=ZchhFG9OkxeqZR98q8rBfd1WidsacEqKSYguyhjKqRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i6tEEwkzTiefJAVctfBSSMj9TWbMbmlPrnZm1THv3a8zxM8RXbfihl3Q/fKmiS9dC6TwXwonFfD8bFKOePAlDxSGWCbBLbtdFx+2nM1OGrgfasKvSkJ4Js9K+zUb0e6YT8csxYjyThmovh0DmkHbu4dE38idgRL1GI+2nk94HEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bMEOnS9/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bMEOnS9/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79015C2BD10;
	Thu,  6 Jun 2024 14:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683522;
	bh=ZchhFG9OkxeqZR98q8rBfd1WidsacEqKSYguyhjKqRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bMEOnS9/xZYjAuMnBovuH6wMUqaRKgK+iLcEguxSl8idSVSp3kItpqE9lF3zWbuo/
	 +x7yLvbmP/kEt0Z1WFHd062nE+pZfTw2OSx9qiEnFifQ4WeG14jUJwOWUwEZ22n7JT
	 SOTy9NG7O8cYJ8F8eaAfu7gx06rdzl0g0QgRVVnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <kolga@netapp.com>,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 414/473] pNFS/filelayout: fixup pNfs allocation modes
Date: Thu,  6 Jun 2024 16:05:43 +0200
Message-ID: <20240606131713.477415524@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4974cd18ca468..b363e1bdacdac 100644
--- a/fs/nfs/filelayout/filelayout.c
+++ b/fs/nfs/filelayout/filelayout.c
@@ -881,7 +881,7 @@ filelayout_pg_init_read(struct nfs_pageio_descriptor *pgio,
 						      NFS4_MAX_UINT64,
 						      IOMODE_READ,
 						      false,
-						      GFP_KERNEL);
+						      nfs_io_gfp_mask());
 		if (IS_ERR(pgio->pg_lseg)) {
 			pgio->pg_error = PTR_ERR(pgio->pg_lseg);
 			pgio->pg_lseg = NULL;
@@ -905,7 +905,7 @@ filelayout_pg_init_write(struct nfs_pageio_descriptor *pgio,
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



