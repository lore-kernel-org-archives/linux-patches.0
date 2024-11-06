Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD0F1DF740;
	Wed,  6 Nov 2024 12:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895709; cv=none; b=HDoy5weLisInrNmoVNM0X4jWTnaLvIXIV6wVp223tavzF5VWEiGh46sv30bM6fUfXc6ON5CZXr2mtpcYBpd5Y6H/I+ErwUh8PR9reRUhSeNWz36D9zKE33Sdjl4IFeWTTv40U6bLqoooLFekyUOt2B2hWpKhY82FPSlTElIQ8FU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895709; c=relaxed/simple;
	bh=+nTPRk9zrjGRJE8xb15pmvyEGXXlMGqf0b3OB5Ek+FQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h1AAvMfNMscXCKVsaGBolzZAgF8Q811zP5MZU6Oqfnm+ZAibAwdb6I5r/Ht0fHRokQ7x/bI+un+Cuy7CFqcHcqDa4dGEN23VdMUdR4BUlGoowWDmYKSrCAvB9lffyntXRNSVqG0i2GOYEj5f12/tI7JaLi1HufkcouMZhts2aAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HlRhkdcQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HlRhkdcQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BAE0C4CECD;
	Wed,  6 Nov 2024 12:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895709;
	bh=+nTPRk9zrjGRJE8xb15pmvyEGXXlMGqf0b3OB5Ek+FQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HlRhkdcQoWWeaA8x7xbO8iw3u4njVWvlKDJQeJ0G+55UCHEjNObvi0nGd64IWfwgM
	 cuPDu/bKw7H9U6QVsDoVFY9LE5UfNtEb/qSECT6UpK056tPEbM2pCV4Ty9S+IqWt9W
	 rFLvsWdVTAw92+0KlFXxMo/z/FscsPYBM+80XgSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 309/350] jfs: Fix sanity check in dbMount
Date: Wed,  6 Nov 2024 13:03:57 +0100
Message-ID: <20241106120328.410236784@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 21597e8b727c6..b6c698fe7301d 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -200,7 +200,7 @@ int dbMount(struct inode *ipbmap)
 	}
 
 	bmp->db_numag = le32_to_cpu(dbmp_le->dn_numag);
-	if (!bmp->db_numag || bmp->db_numag >= MAXAG) {
+	if (!bmp->db_numag || bmp->db_numag > MAXAG) {
 		err = -EINVAL;
 		goto err_release_metapage;
 	}
-- 
2.43.0



