Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591166;
	b=Snit4pToviCNCFc22/5kOFWAwxlIXmp5cX10rorFFskv8my1AKbKSltJ+WlLbBRA93tS
	 Fk3Gwg5+O/4QD2qubPn195admdBO2c2S2CzQ2Y7QgosqvHyhsuzAyNZ/HwNn/7sfbmeVO
	 vS2uVMLFoPWeLUWJxASMGcPRwAz8XKbjaIou+vt3IEXFRDcKP1KLfPR546tnPIstSm0Gt
	 huDuy78CAYfPMjDlOvyt2Ydzi23dxP7sgkEaDOVUeKXTuIoISEueCKaPq/Adx1x1rC0Yw
	 QR1FeSuzx2r3HJWxi81vNpWTUV4AmJDb6gVauqlwz+5jXA2aJHsmPggq+9NVaF6YyfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591166;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XUNjaivu77DkIqFnDT7Eisc7jxDQXGksWXZ/vhc9BJA=;
	b=sGpHJLEb/RgRfAWGWkCymAD1CvIXrJxeIohollmHM9vV8TNmSNJQEfVLLqxFV0xRqan1
	 aSDA3vs3gxX5S/HagfF1OiiTdfi3QXuwj0Q+U9uLlvs3GXUJaJO2IWH65RlY1FxGf073P
	 BgMfl9P+GJxnbk7Vrz7kSx25Mj/aJYvRilAlW7kF/5zLn1lpk4khi+r2KxkFudv1whm3Z
	 z4DyTdj81QnIluVM8XsT1D37+/K82kTm3T/uZ6We8gnTggH473emAzu1Vcm636LIa0j1h
	 a/XcbNGAxqXs4VEPbAG4trWzlKzshFagPe2vLT9+XqqEEoyMzJGTllgEZ7+GKp9OOdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fF40P98C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD78606C0A9;
	Fri, 13 Nov 2026 17:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fF40P98C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3AC1F000C8;
	Fri, 13 Nov 2026 17:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591165;
	bh=XUNjaivu77DkIqFnDT7Eisc7jxDQXGksWXZ/vhc9BJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fF40P98Cgj8QxPb4ZD8KUf02xlFFTVHMV5wyP8cduEcl1rVMAApXvVUUXLDcD2pbP
	 bQNKpms+4aVwX2CK4EQGMJzt0If5UClm6N96vMGjqQEKA+o0o1NHPehesXtrXOiKt7
	 O8XT7PVV7B0Mv+mV79eJfExjMFUlE7pDRAmx0lOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reid Downing <skibletz@gmail.com>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 308/670] xfs: fix wrong compat fields in xfs_ioctl32_bstat_copyin()
Date: Fri, 13 Nov 2026 10:47:52 -0500
Message-ID: <20261113153822.346279031@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



