Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037741;
	b=QT8DcqWm0Shx8x0rQ80Y7j46mj6kl45eXNOj14SurREO/RXTqRDRGwvkZZZSoMJM1ofU
	 5TMUid1HdUYX7TPFEuVBYA2G5QLluRV0VxJt6C1K9Nrr7FIlG4AFCB6P3JndO9018m2QZ
	 4lvpyhP7DZ5uT6PEo9pycF+1NoaScra8/TdhHfOQ298fI0oxFvV1hEdkBFyi/fRbnVi9Z
	 slrkt3zNdgICRQoelQ8EHEi3R1qYPmLjPwWN9umq+70uvcJ1QR8PD6mQ64n6JlwtrYpgv
	 CFuujuEERs1FLps5dnrPsJkRFrYaUvNX0p8XElXDT516hakJNzSKybZjXfq03ghdhOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037741;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oGh7FB7JAaZkcsX3TTTxSbGSd/g2XRjVQjRMRo2sLSE=;
	b=a4lHjVawL10gt7a5hDkM0hKC1VATxDeutKGu6p61LHUMFEtlxZJjzPXwAqP0nJy0y5eM
	 EPGRQl88tRIMGU6XzFjI2BfTlxyKxBvebln/Xhg9SpAjCcIbqSwI+cORbb7plnfSgrwrx
	 BAanOc67/AdolYlLfO9b4P9CPKbVKhxYdwMOH+yaHl4R74rlxYwU7F4zckLnuXGQMi49n
	 ugUjD2VbRpojHtaVMVECvQInJPfBygpH1NQY38fqcnkrXApncsKS1eFKgqhjV1KvfOBoX
	 zZkLBIt7A9BarsLfREXrPFsOvGbdsh+BJ5K8geO3TyS1sgxnTr65Fqzk+9lQEgFS/BA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lIofoKyW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6247606A31C;
	Wed, 18 Nov 2026 21:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lIofoKyW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071C51F000C5;
	Wed, 18 Nov 2026 21:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037741;
	bh=oGh7FB7JAaZkcsX3TTTxSbGSd/g2XRjVQjRMRo2sLSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lIofoKyW7hITMtCP1DACBbXFInnHKAPDSgK/42Essxqtf5FPkyqLOTXPRbYDs3uCd
	 rR6R7W6gjlnqaBxIg1zGZJNIL67QFIjfh1GOok/hBcKLsSogRGFt2DthuHGSVEuhU7
	 er7h+dAPE7SAopGtCuzbnGtkRv+ESezVhFfUee4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reid Downing <skibletz@gmail.com>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1502/3318] xfs: fix wrong compat fields in xfs_ioctl32_bstat_copyin()
Date: Wed, 18 Nov 2026 15:35:24 +0100
Message-ID: <20261118150405.978898376@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ee35eea1ecce6..7a4d6ebb97cd7 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -122,8 +122,8 @@ xfs_ioctl32_bstat_copyin(
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



