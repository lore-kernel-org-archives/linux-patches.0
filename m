Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053440;
	b=o5nxxUV6eI4GFKvmtDw9WJrVe2T0xObu329tf4V1lvUJNuag79zJZluZMeAKxawlfOUn
	 qt8TTZH48TLPtc/HXAnm1RbcqPpYQYAkN1bNVSOf1A99YC6mwSpEIRRTRdc0cK8dPTFsC
	 4eVwGYkL0Zjx3+TZEt+h/ZKb0PM1WgO46W9qhojdChCAUEiMno+rCkLgotxCT2+ltE5q7
	 a3iQzKXUrhuFQwTk7jo8sIDJJ/TFFC3tW5Uhsrjw+82rijTnw1Neyc5t1b5BFShqQp/aT
	 ioVs3/R0N4Yhx0RrXinEa+WDPiLY8L9yEQ4Wbfb38nY0VOaxbLBqkxdzUKMZ0J0kIfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053440;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qEJA4M0HWNbPTlD5TT+Hq/13jH4Y9Mp4yhMAs7KdWSE=;
	b=azo+AjyD9BGlNYlXWmAKh75729ZIpq3YeI6BbjLGcp2m02J+YZrQuady6apJ/RJZ6nsj
	 bz+FDj2b4Z/PNBEMquddlEdyyNI5ENmeVjG9JEISMNk7mdoLW7G+pE3JhH9qN0LbyeMxG
	 Y63+C4nEhX0faDyRJ8cFmCvsypeFZqNXgQQC8WZ7FYzXQY3CD0ntB0xFYshSDlq1/GWel
	 448VJr/iMKqZd0Jt8iN374xokaaJOhYorbxxIofqwurYmmLbjA8S0GqkHH8l7x6a/baez
	 Irj4rbA38zOpjhhyDRXaNJthVj9KNGQcOhuFXzXfTsTc/4J4YoN+R6Gd/63mKvb02ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Of6wEPhO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E764D606A31C;
	Thu, 19 Nov 2026 01:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Of6wEPhO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B43F1F000C4;
	Thu, 19 Nov 2026 01:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053439;
	bh=qEJA4M0HWNbPTlD5TT+Hq/13jH4Y9Mp4yhMAs7KdWSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Of6wEPhO4L60eVmd5Gg2ugWqFwGcSUV0oaZWj0UFWaRhM2NtRN7+XlnmnKKTi3qMr
	 WA6x8udhxYMz7OgdHNDSfb7WfZWAgqD816YPo40J+E9NQ/yHIxGHNIrDN4+dxwm/N4
	 g5PgOsiDKxWep3k9pZeWWMpXLs45AfxhvDIn1wv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reid Downing <skibletz@gmail.com>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0893/2214] xfs: fix wrong compat fields in xfs_ioctl32_bstat_copyin()
Date: Wed, 18 Nov 2026 15:42:49 +0100
Message-ID: <20261118150048.012340158@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8783af203cfce..1270fe0f5f24c 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -136,8 +136,8 @@ xfs_ioctl32_bstat_copyin(
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



