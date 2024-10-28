Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A028818E34F;
	Mon, 28 Oct 2024 06:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097332; cv=none; b=Qr5qHIWC/MHrFvES1UbWumBPOtwKx1cWTOSR4dSXo8SYatJAl1n+jApH4XQMlbsRxvFf1XQweMRPER8yBaZt2KDVWxprz0Eqf50uxyVm0e8KYDa4YhAq9UAX3SUtspxMWml5eoY5s1iwfmwep1AOMX+IBZmdbZUatUARPuB4TRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097332; c=relaxed/simple;
	bh=cw+7idIYpac/N0kAmoYMXRL0kE5P8b2206QkBcGCjnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aa2z0wGootF654J8PGxgf92PjNRxDcCZmGlXGVOdVqf9Gfgd9R7i/sn4iSg+XNXOanGsClIZr5Jv2EitxC25VTKwoNrepXXZvdFu4vr0wRW5QEhuMrDhJCWm3jmyVhpfyKxkYJx148nTQVkGO3xX/2r/fGy4pcsC7+DgaZZ3IWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pi//QGBz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pi//QGBz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F676C4CEC3;
	Mon, 28 Oct 2024 06:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097332;
	bh=cw+7idIYpac/N0kAmoYMXRL0kE5P8b2206QkBcGCjnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pi//QGBzd5IDDrMGR32PXkQPiy8JLzDeRN+qahNew2oi+H8xrmygg6YOx1ncdbASG
	 2uxY+f7MYjusSwE8don/B1h03VEtZSf6sJh7+AE3GsodBMRo27bJbSgQcoGK49iKaE
	 ejvaj4DqPQweekI1QfMSn6ycc35rT1kNPH1SHOpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 084/137] jfs: Fix sanity check in dbMount
Date: Mon, 28 Oct 2024 07:25:21 +0100
Message-ID: <20241028062301.082109459@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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
index 384aa6dfdb95e..a6b1d748df16b 100644
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



