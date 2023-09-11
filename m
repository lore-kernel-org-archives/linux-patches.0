Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A9611706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:48:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56914C433C8;
	Mon, 11 Sep 2023 14:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443721;
	bh=/KyEbqhVUgctlcL7WdQgqriOzAYqYFHV0Ums6tA3rnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oK1ztYA3JnidsacBJHD+wQ/s77csq3EOIaWMRwJbC38OZxeIjHIjvt8hjudfSah1h
	 UzuK8AT5sGCa3XTI1BC3R+jrn/pa0hDVUY6B4fHANUY8AC20T+J35zo4u5dulPEmey
	 yUzbpoEtQT2WuT1Hq85qOVqAYwNUL3v+CgOy95ws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <kolga@netapp.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 477/737] pNFS: Fix assignment of xprtdata.cred
Date: Mon, 11 Sep 2023 15:45:36 +0200
Message-ID: <20230911134703.902445998@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

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
index a0112ad4937aa..2e14ce2f82191 100644
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



