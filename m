Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF6CD331EA8;
	Sat, 12 Sep 2026 19:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241089; cv=none; b=B8Nfi9IrAMzHZ3bvN0x71bNuGWQcr9Y50qX4hszsjVzFR3k5ST9IYt2w2bGCMo9Sv6PPdU4LZJy8Bgo6RHoGpe3vwcPQwUZ2vxdIQEKy3UrmeMESVjQVCkBMt3CFkm+BF6ALvBLCfOdJJw55nYiE/QguA8gFz+61XrbCGpytTfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241089; c=relaxed/simple;
	bh=69uKBr1LBleb/UITFj6KVEin4t0zKluCN2+POyNDqDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X4cSmWIm0Beq5rY6T2L6+nkez3SkF9AHbtptWVzywyH74FDz7MLkGHxiidBw6gecwDsG55ozN8ZQ9c+DEKCNFxDe8qtuNMEiBouOmVkGy5wzQppP83UJh9Clh9hzqQ7ZsxIuhcTuYnWJroClPnBhNt+50i7+tD9a2r6VwIMb1iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GriWhQ+P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GriWhQ+P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8FB31F000FF;
	Sat, 12 Sep 2026 19:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241087;
	bh=RjtvqksNMop9XesWETVnuBlLwf2byLcr9W/dZHIhXiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GriWhQ+Pv2d3LhfE3Db0m8aIO06gTF2qOW7HPLvHAzu6DkLA9l81Er0V7dWeWMC40
	 7t/IcGIcECFlbP2ruS2+tcoblWaxNqBeW0QBBM3PWcH0fi9s72A57pIk8Yaah1d3CZ
	 eZeM8Er0IBUS4EMf2YzSHiEaViSFbw3H8O6LpWHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yemu Lu <prcups@krgm.moe>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 065/798] fat: restore original value when fat_ent_write failed
Date: Sat, 12 Sep 2026 08:54:53 +0200
Message-ID: <20260912065518.454634589@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Yemu Lu <prcups@krgm.moe>

commit 64d9183203eebe33de6188b70a8c1e91f52885db upstream.

fat_ent_write() may have committed the new link to the primary FAT but
then failed on the mirror copy, leaving the chain pointing to new_dclus
even though the caller will free it.  Restore the original value to keep
the chain consistent.

Link: https://lore.kernel.org/20260525085649.781643-1-n05ec@lzu.edu.cn
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yemu Lu <prcups@krgm.moe>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Christian Brauner <brauner@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fat/misc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/fat/misc.c
+++ b/fs/fat/misc.c
@@ -127,7 +127,11 @@ int fat_chain_add(struct inode *inode, i
 		ret = fat_ent_read(inode, &fatent, last);
 		if (ret >= 0) {
 			int wait = inode_needs_sync(inode);
+			int old = ret;
+
 			ret = fat_ent_write(inode, &fatent, new_dclus, wait);
+			if (ret < 0)
+				fat_ent_write(inode, &fatent, old, wait);
 			fatent_brelse(&fatent);
 		}
 		if (ret < 0)


