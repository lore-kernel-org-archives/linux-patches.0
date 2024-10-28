Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E32118E374;
	Mon, 28 Oct 2024 06:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097745; cv=none; b=u/bW5srTrnX45kSMF9SkwYtZBpbYggpwzed22R2I6NTjSUThzhCqYQjWoQ6CX3osVqwmw5/LQMG8j2gWoyfzCX/6w772OnJuIlyJ+IO/mr1KcQwhgAo8s5gMHqJHjrReAx+AW5bxNUGljWrg9k5Zo23teFVjR+Bc1BO4JHDyeoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097745; c=relaxed/simple;
	bh=zTN2OE+szvuaUtBU9IU+3/He7aHGqq4frPiYsdqv4gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LTr95Zmv86TYMAgn+G5ohh8f5hqsmRk5kYXRDvkRgTiO2bF2/aJDw7VGk3BQ1S0+KvKP7wU1GE96SxIXQSqVQCalyuSH/JKUraQ72sz7qk8tIYWmHRBQlEBHLM9j5hrFxoqg06KKdHWGLfOpwz1su7QdfIHAKrBgjFhzRzgJ5CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R/5omt40; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R/5omt40"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2520C4CEC3;
	Mon, 28 Oct 2024 06:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097745;
	bh=zTN2OE+szvuaUtBU9IU+3/He7aHGqq4frPiYsdqv4gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R/5omt401qbmP3V4IZc15+0A5nDUqCKYBDX1gcuToTzQoyrXDuSH0+2kZJDOGrN+L
	 rhg0s6WlaMqhNggxVvm3fsQJlj608yMGlKce+pvEUNdrbG7MAg9ENTNrpaBOTHF83o
	 zgU5wZulw73IB8IVy1cevTFluJWdMx+8naLBhzpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 128/208] jfs: Fix sanity check in dbMount
Date: Mon, 28 Oct 2024 07:25:08 +0100
Message-ID: <20241028062309.794852242@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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
index 974ecf5e0d952..3ab410059dc20 100644
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



