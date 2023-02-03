Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5471FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:22:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69766C4339B;
	Fri,  3 Feb 2023 10:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419742;
	bh=Kfm10YM4wOU9MMngm6aaYAT2Dw2J8RCuxn/H1CXoZ0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y6Ns3rNYGF2L5dkiuwJ/IqQPLcBMfsU6TL5c/biQNqBBEVEWrPQCVnSkTl88mga8+
	 /JVzLwo6PjlaQREJdCvSxPzj1YyCAfLKaCa3+7pGMc67ExKwDiTA5/jy2M8HCL/LtF
	 KjHIkOt/lQJgQ7S8yrGkdNDIYS9bMwq0I7AhiIrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 22/28] cifs: fix return of uninitialized rc in dfs_cache_update_tgthint()
Date: Fri,  3 Feb 2023 11:13:10 +0100
Message-Id: <20230203101010.917245367@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101009.946745030@linuxfoundation.org>
References: <20230203101009.946745030@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paulo Alcantara <pc@cjr.nz>

[ Upstream commit d6a49e8c4ca4d399ed65ac219585187fc8c2e2b1 ]

Fix this by initializing rc to 0 as cache_refresh_path() would not set
it in case of success.

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/all/202301190004.bEHvbKG6-lkp@intel.com/
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/dfs_cache.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index 4302dc75843c..3bc1d3494be3 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -1050,10 +1050,10 @@ int dfs_cache_update_tgthint(const unsigned int xid, struct cifs_ses *ses,
 			     const struct nls_table *cp, int remap, const char *path,
 			     const struct dfs_cache_tgt_iterator *it)
 {
-	int rc;
-	const char *npath;
-	struct cache_entry *ce;
 	struct cache_dfs_tgt *t;
+	struct cache_entry *ce;
+	const char *npath;
+	int rc = 0;
 
 	npath = dfs_cache_canonical_path(path, cp, remap);
 	if (IS_ERR(npath))
-- 
2.39.0



