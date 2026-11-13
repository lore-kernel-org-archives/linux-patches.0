Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585684;
	b=cBhXpKb8idDVFthJS51+FYXsxD5Un9YEZThhRXMK8Ajlyi6QY+syyZHZtTqV5Qg32FV6
	 iSToMkGExb3mkzln2Qd2ikud627JGp3nhuCT2Ewo7TFCFY7NFhAr0NmAhWi3d8dX01CyE
	 4+/u4VnPInKAdGOmuDujFOdVS01YlaoNyg36jzI9A3nKKpDqUvUB16+4zYfHDH/Xu22tp
	 7V7Zdicc8OBx79c9vfnxQG50ZNmsGmbofo6HUNgD6d+DYvaV2QzDKy/HsoSlBT/3TzPtX
	 XVXUXdrnlO7UuWkLotWChCSvkBYXIN71sxCe3XUH7zFzLH4buBIKTIICBncbMdZ9Jlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585684;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mr2bJ0THXdR2AX9KlRuDEkVHZQOwNn0r669RUPfM2KI=;
	b=aTADgoe3WQy/TMcLcC6HeeTrZ7ZH6vaIywymUlb6RSRNJ3AZ9fxgivgejmi/TeY+c9TX
	 /6VZ5yHFl1KwwAYaMiizURJwxgdPnH7PXUAuDAu739GQTCEzXHZdNNGqxEAbjCPoc5cWo
	 iw0UPwQkFrly3Wfo8sUv0tbL8DvN0VZ4JiCJitAk7V/kBqODmRELywDQKK2Bp2MvHK/V1
	 xHe43/wAVx6Yi1ibWSSouBs6U7kNwkCMYSd8vVvwHBahwAKFKoiSjHrfI2Oj9HTSvGMrN
	 yBgnol2+IeyNKzJWJ0izYm1bvRQgNHUQxPl5ZMWBHi+4JrhpLKm8mA6aGtoA9ugWYBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s2o7ElsC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6D9606A8AD;
	Fri, 13 Nov 2026 16:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s2o7ElsC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED911F000C4;
	Fri, 13 Nov 2026 16:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585684;
	bh=Mr2bJ0THXdR2AX9KlRuDEkVHZQOwNn0r669RUPfM2KI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s2o7ElsC0rQEutRP5OAbYUevVRnn6nyk0vfExFvNti/32F4jCGdMr07CTngAX+0pr
	 lDbaoor4zeKZ9pmg4S+FSQ7APAdEnrT9yb8LmYmRguvHdj8wfCaLpEfwTmNtZKTgxn
	 N3rqDYsKkZyBxKwG7DMJkhmS9VbZA7gDTZddBdaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reid Downing <skibletz@gmail.com>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 277/507] xfs: fix wrong compat fields in xfs_ioctl32_bstat_copyin()
Date: Fri, 13 Nov 2026 10:49:41 -0500
Message-ID: <20261113153804.239101846@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Reid Downing <skibletz@gmail.com>

[ Upstream commit b7eb276a39b14e685c2fe578f8ac22fc48ff9e6c ]

bs_blocks and bs_xflags were both read from bstat32->bs_size.
Read each one from its own field instead.

Fixes: e94fc4a43e5c39 ("[XFS] Add compat handlers for swapext ioctl")
Cc: stable@vger.kernel.org # v2.6.29
Signed-off-by: Reid Downing <skibletz@gmail.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_ioctl32.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index c66e192448a89..e411f9453bfba 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -123,8 +123,8 @@ xfs_ioctl32_bstat_copyin(
 	    xfs_ioctl32_bstime_copyin(&bstat->bs_atime, &bstat32->bs_atime) ||
 	    xfs_ioctl32_bstime_copyin(&bstat->bs_mtime, &bstat32->bs_mtime) ||
 	    xfs_ioctl32_bstime_copyin(&bstat->bs_ctime, &bstat32->bs_ctime) ||
-	    get_user(bstat->bs_blocks,	&bstat32->bs_size)	||
-	    get_user(bstat->bs_xflags,	&bstat32->bs_size)	||
+	    get_user(bstat->bs_blocks,	&bstat32->bs_blocks)	||
+	    get_user(bstat->bs_xflags,	&bstat32->bs_xflags)	||
 	    get_user(bstat->bs_extsize,	&bstat32->bs_extsize)	||
 	    get_user(bstat->bs_extents,	&bstat32->bs_extents)	||
 	    get_user(bstat->bs_gen,	&bstat32->bs_gen)	||
-- 
2.53.0



