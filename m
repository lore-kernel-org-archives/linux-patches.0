Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142DD11710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:19:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89ACDC433CA;
	Mon, 11 Sep 2023 15:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445555;
	bh=9y2p5Kq5e/KZZsa8YkF6MDJtQvk8GAUTNDEK5nLtw54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PmeITOBLEr95ANSQ96rU1xhDDNGmpF21DeSZ53ARhz4SilagYKEBzV7pWUkUQpnkU
	 /P5tzY5ftVJEvTHK2gmdtM7bk76UCMLndkc170ftZtE66I3cWBsJi8+xTgOnGeYFdz
	 pDkl619OK9lGRhaPT0kh99DC3cepjSlPnEVY2qE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <kolga@netapp.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 388/600] pNFS: Fix assignment of xprtdata.cred
Date: Mon, 11 Sep 2023 15:47:01 +0200
Message-ID: <20230911134645.131443774@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

From: Anna Schumaker <Anna.Schumaker@Netapp.com>

[ Upstream commit c4a123d2e8c4dc91d581ee7d05c0cd51a0273fab ]

The comma at the end of the line was leftover from an earlier refactor
of the _nfs4_pnfs_v3_ds_connect() function. This is technically valid C,
so the compilers didn't catch it, but if I'm understanding how it works
correctly it assigns the return value of rpc_clnt_add_xprtr() to
xprtdata.cred.

Reported-by: Olga Kornievskaia <kolga@netapp.com>
Fixes: a12f996d3413 ("NFSv4/pNFS: Use connections to a DS that are all of the same protocol family")
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/pnfs_nfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/pnfs_nfs.c b/fs/nfs/pnfs_nfs.c
index 5d035dd2d7bf0..47a8da3f5c9ff 100644
--- a/fs/nfs/pnfs_nfs.c
+++ b/fs/nfs/pnfs_nfs.c
@@ -943,7 +943,7 @@ static int _nfs4_pnfs_v4_ds_connect(struct nfs_server *mds_srv,
 			* Test this address for session trunking and
 			* add as an alias
 			*/
-			xprtdata.cred = nfs4_get_clid_cred(clp),
+			xprtdata.cred = nfs4_get_clid_cred(clp);
 			rpc_clnt_add_xprt(clp->cl_rpcclient, &xprt_args,
 					  rpc_clnt_setup_test_and_add_xprt,
 					  &rpcdata);
-- 
2.40.1



