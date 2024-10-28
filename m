Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D3818E368;
	Mon, 28 Oct 2024 06:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098319; cv=none; b=LH3S3+ayCQNQNwE1A0Vfy0WjPJBiIh6x89LGpQmMTqcGmA4sEoevsGj3VViEC59xwDw/GeCHQtOCjSk+r4SlkWABjbAYjiYC7XXQvQBRf9CPMOJAHRuM0kFhe1bndqJZTAfwtN3AG12yNBiD0B7RmmRNflGtKlf/7ssQxgLcW/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098319; c=relaxed/simple;
	bh=UT0lygG3TrjJ3gLkjE0s4HBaYFG0V8DnsIix6WcgYx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EB95fNWsaI7vo3l5z8KXN3yn25GvQ7gIvz57+7gCNRgmCp/0Nu/8ByvxR+cogJ6Joi7Lg/JI0KH4jSFf2G3pXp3lpx9N+7cl/xX6+gcWlrep8kMPn+t6TsKs1W6s8ZJKW0q5K0OSU+WD08bcj2oriV9y24lHOWo/wZfQg2czHrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PLJkGYFn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PLJkGYFn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8454FC4CEC3;
	Mon, 28 Oct 2024 06:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098318;
	bh=UT0lygG3TrjJ3gLkjE0s4HBaYFG0V8DnsIix6WcgYx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PLJkGYFnlpE+B/JupAPwSKQqjziTT8EZjwyv6ZtgrjBnPWyYxt7svkFbYpjhSJQau
	 s1UEaSU57aLObVWrkiCgh6YaqN9+9o0FOHiKrtgbSWEd4PVByocAUB3XN0gb3aFJsJ
	 RP5flnvl29C2zUGikxPC/Z50HGzjkJjqNi88ELyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 138/261] jfs: Fix sanity check in dbMount
Date: Mon, 28 Oct 2024 07:24:40 +0100
Message-ID: <20241028062315.502587454@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



