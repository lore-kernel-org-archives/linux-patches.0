Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11FB141A795;
	Sat, 12 Sep 2026 15:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226983; cv=none; b=B52nVnWm6Qcb6sWehfrVrz8Jz8an/7dWFyfuwc5W9o7yTjyshHIR0kiFzE6oycgjW4yPhSz3tfHkSIb+QlVl85Tw9tAQT0erPZErP7GX+tazD99N3oYALWbD7FUfSOFoak8fvVlbGpnKGfTGJCwUjq6X1s4pl1WHmcqTb0riPxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226983; c=relaxed/simple;
	bh=wgXc/osN6rgEFHtPM3/NUmPsSKuC5CWOjihftsgkCrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NKSh4tBaZJlNU07V/BT2VqiqYrxV9e+VAqReL6mf9/OEhj006t9a6bfT0XXhPCTMWaw+vh1kfbSKAV8d1nzTo9OmipQehkXe+j8L4mmLShJV89vzmjvSZKZa63NRxZbYp+Z/92vHAM37dYfdaapqxdNP8UNTxMY9vCfRfgZjtT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=le886V1N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="le886V1N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA591F000FF;
	Sat, 12 Sep 2026 15:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226978;
	bh=/9V7NoN7HFpZZJ12JI0Lk8Pq9mFUJsvas9WPmiYbaQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=le886V1NO/qCnfhof2dmoe28csuplVMQa3PAP97mfb8GJk8YILnSJM6lGES9Xt4RT
	 2t7YtVvTwnAmzh6EFjh607EI8JZuvM0pnxT4wHyLzgzMna6bjDMuo7rJo0QdMoM0Km
	 l0kSZbNGaYJ4Ar5Q6hhd5xiQqs+CRqGQjxFtCr1I=
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
Subject: [PATCH 6.1 0086/1191] fat: restore original value when fat_ent_write failed
Date: Sat, 12 Sep 2026 08:46:54 +0200
Message-ID: <20260912065550.110423133@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -133,7 +133,11 @@ int fat_chain_add(struct inode *inode, i
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


