Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590380;
	b=wAd8TIPhWUaBsAGmoPzipOqqQkPw13eBqkkPX8+zZ0W3BRbU+64EK1ANC9Fzy0j+aIzJ
	 if9zd1BIP2hxNoMeqpT2uNaPMUW+Tbjc79D8HEth4JxWuoZGQupa07ydpyNfeN0c48r5s
	 wmLT0cvSmJ+S3dLU2jbV+7DbrskrunYGB+JYgAuZWge8HKGGcFN9/nYOZg+EI6HOzXGeX
	 NYcuS6d6z7lHszm3MKEwB499kycNefaVlZX3Ikd8TWdoF1Ccy5dB1zrc+KY45Ttqiauso
	 MqZ8mMNnzY9/g8wah2JCis01NifBmcurF2+IaYpaZYEZ/QC7pfZSQ9vsC7tNeAIq0mA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590380;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CLt3fEi7f8KEXVYQJBkjUhU4EBQCMP684LinbBj8KwU=;
	b=a52zjD/0e90raBt8kcVUZBrZk8ThtWpryNCyGsxH8vUWhvGqThV89ebYL+pulnlNzL1s
	 ZdfNrdJIZuyDR366UvA5bpdosZTYNK5LlESG+siTmA+kWMvV8ecYQy8NJqN5eGQQ0fMJl
	 KJL9De45WPTr1f+DuAAIBIVaFrkYJ9Vrl2QH+mPFMxhuhIjtSFPLxwH+Hq9qd+4m9bRQQ
	 sMZ1Q2m54xHqDdeuGzz0ULER02iCLdGQwH/RS47UqDWN1QCgjzUMpuuzuvpNPx+ShtMnk
	 a0uyonwpbbGVBbRQXekZ87YZcftXMIW8mR0N+qQYM1SNLpeABi3NEashxi2tBTxPXGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FD7ODKtM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3373606E660;
	Fri, 13 Nov 2026 17:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FD7ODKtM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F9731F000C4;
	Fri, 13 Nov 2026 17:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590380;
	bh=CLt3fEi7f8KEXVYQJBkjUhU4EBQCMP684LinbBj8KwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FD7ODKtMlYV6V2gykB8ojzJbdy/oxoblsZzX3tnlOla40nOr6kRD1+Qtbp5bKPQhU
	 HsEKt36YjAqXqxKVzbSh9oDW21mR+wlIz9/birF0gwNdyWnmAB7HSr6pdKfcigxk58
	 wTOJ/5yhzH4ppIMGlbV3fYMtkHprknoOW1Jvj0gQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reid Downing <skibletz@gmail.com>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 351/686] xfs: fix wrong compat fields in xfs_ioctl32_bstat_copyin()
Date: Fri, 13 Nov 2026 10:48:04 -0500
Message-ID: <20261113153832.812608653@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b64785dc4354e..c2e01fcb6015d 100644
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



