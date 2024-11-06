Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5908D1E00B0;
	Wed,  6 Nov 2024 13:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898938; cv=none; b=rQ05whde6W1LrLNXuhdmyF6zFpNnaPb3OGbPRKVs0hR0ePfHsole0Qo0wTTF30EKeHC+KbTGXYJ69JBODqz7VJWQJCAy8XvPGdSJCIIkYIMsrpvPk5GWJAU/xCFyNANZstDoWWE+f4IU+Pf+qHiZcS2kb/HYjTJDhREfyY6B4ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898938; c=relaxed/simple;
	bh=+ZEc2etkd0ZzhrY1LOl2gTVysBRbZf6QPDrzlVZ3HC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L8OspWWodLoP+FY33lELzaFwl/ks+kwrnmDnNf+JVEQXanJa3cH/t9QfxuJxTbMKLe/iDxnGzzXzb4c1WQL1n3MEEaLOhdPk4ITfGuYJfc3GYeW2qlRcnju2EIBnmbi7F4VZG94XwlN2lNExiFycIMr+9SVcYSdp4yQWMUbjpag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nRDF53Wt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nRDF53Wt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA10C4CECD;
	Wed,  6 Nov 2024 13:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898938;
	bh=+ZEc2etkd0ZzhrY1LOl2gTVysBRbZf6QPDrzlVZ3HC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nRDF53WtbQG1Q7LNT7y+TiwgcEB1uEYe6NKpjn4URrNd3fmepWwXvmKdPViqKp47g
	 pKuO/MlewvjYGy4CjUbRU5LRaBpTIEeKtWFvCkm19PyG6bM1B0uQvMKZK1w1sLr8Sa
	 9OUSJrQsDjod6a+e/IHTevIfSEC8zAKL5jubSpNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 406/462] jfs: Fix sanity check in dbMount
Date: Wed,  6 Nov 2024 13:04:59 +0100
Message-ID: <20241106120341.550914984@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Kleikamp <dave.kleikamp@oracle.com>

[ Upstream commit 67373ca8404fe57eb1bb4b57f314cff77ce54932 ]

MAXAG is a legitimate value for bmp->db_numag

Fixes: e63866a47556 ("jfs: fix out-of-bounds in dbNextAG() and diAlloc()")

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index 01cdfe7891b94..00258a551334a 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -187,7 +187,7 @@ int dbMount(struct inode *ipbmap)
 	}
 
 	bmp->db_numag = le32_to_cpu(dbmp_le->dn_numag);
-	if (!bmp->db_numag || bmp->db_numag >= MAXAG) {
+	if (!bmp->db_numag || bmp->db_numag > MAXAG) {
 		err = -EINVAL;
 		goto err_release_metapage;
 	}
-- 
2.43.0



