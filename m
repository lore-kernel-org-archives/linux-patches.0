Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86BEA20010E;
	Wed,  6 Nov 2024 12:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896773; cv=none; b=tet0cjgG8Br1shgmpBiVeXTEvla5kaht3clrTrjFCOQ1ynWNM0lY81Ysxph2hro3Gaqhu+hiY6mCSELg6SbYjYoTJ6MXnKjwYJY12EN3tal7XiJ6PPbbzg7oG61NtRnfLcJFJFskXRNF8/acexLELnyCNbk8xGzIymsj1V8TbqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896773; c=relaxed/simple;
	bh=ULO7wLgl4a5uQ3LX6y9kbuDgqx2dPalqfuFZHkI3Hq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Me2Ox4svfmlMsLp0rNMAD+RLc8GOJz8Q8Jwx0p4q3aRK33GeQ9PeZJzUsq8To3PGUgNd/W2uGcqCPHe7TjlBFi4GmiireFOyh64znrlAKJjzX7pGJcrdUo1zQsuZahodBEtbmkaifR+2LBEGdDjwtcNXOeduNGHuYqpihUU1U8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V9KSbf7p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V9KSbf7p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A51C4CED8;
	Wed,  6 Nov 2024 12:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896773;
	bh=ULO7wLgl4a5uQ3LX6y9kbuDgqx2dPalqfuFZHkI3Hq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V9KSbf7pYe6YzeWRZCDjq2Gd+JtQMzxnQjxLNxdAql31Pbt1hJYOkOvp3LseX3CDw
	 b5l9XymTeJxM0gOQWb1QgaGrXQaTa/SuQJDJKrIM4ImdBw1Cqnx2RVxu6yPhJdXdjJ
	 uRt7VyFTz5Din9A4RR+V+jXSIqY1+n0cktKqelp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 031/110] jfs: Fix sanity check in dbMount
Date: Wed,  6 Nov 2024 13:03:57 +0100
Message-ID: <20241106120304.048106342@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8efd93992946b..559f6ebebfc0c 100644
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



