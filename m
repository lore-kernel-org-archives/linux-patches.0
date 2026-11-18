Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029559;
	b=JEG0+PyVD7ukWR9w+7xvO6q7682mpIEUFprKL1P9TdFiviXPnWDSvwP5DtCeO7U0vDZW
	 4XgpbokEbDND2eWBh8niUESMb3UtgZfOgRzojkj3s1r0lK/yoXV5db4Krl+uQ/zylbVuw
	 P88s5Yapo0orxOrbltVFU8Rw7n4JXXigUAGVwl0KUtdgsTx7E++v+wsK30Yaizp17GfYD
	 2ZVi7vVp9uEcqsDe+kKJxVfYjLyrCFBjd1c/Jb+HxgdGU7pt4b56Vio0Kml5AoNNfAoBf
	 6iMf3PNGJtZ8otDi5sFT5Lsw9LPB086Iu/7030DpmQlHOoX/pJTWwSoMDqXen6qG03Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029559;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j/c2sgmziMiNADg70Cm1LijL1kTz1YLYp+29PxglTkI=;
	b=J2m6GlsjLT7eroBMaeg37WIz6XBYLevuc0vA+X+Ly6IYodAw/4YTQE/7vPUanlGzu6tV
	 bB/+e/xElHD2ZIDDVp8jEUlTGbo9XBB6nk2uaw6lewSEeTb+0j2usD6RmekC0OyxTcBnn
	 Em39uC7t+05/w0Y3Zi/hJzyGwhlQuDP/ZaurFMIh36cIlikvKJTzFBxt10C4ifkBCn/q7
	 NRGGtLhSRpAj/afgDcmxX80VGWpF5oM8X9SQrAyP0NpJgsoIxJw0qz1D5wlx90nz7H3aP
	 iCKFVAbQ7XmHwOlpN7huoGoPIjPLO5P9UzRgrVYW+nwEWDF3e4PCO6m1rXq2pFqh//Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U74+60hK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41242606A320;
	Wed, 18 Nov 2026 19:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U74+60hK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97BCC1F000C4;
	Wed, 18 Nov 2026 19:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029559;
	bh=j/c2sgmziMiNADg70Cm1LijL1kTz1YLYp+29PxglTkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U74+60hKbU8cu6accqsdBS0UthRUMk1r7FUMYpkkn74Fx9E2eVvr3uDjHdDo0+eXg
	 raO9GEtK86+FbmSyYWYBWE1oYy9xq8GVMXt8BbTyav2Hwbp2QrfG4wY9NfxZhJQ8rD
	 rHQCOOHzHqicBadAfhiXuCnE0Ee+4RfVSi2UzIhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Liu <liubaolin@kylinos.cn>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0393/1756] fs/ntfs3: update ctime only on successful setxattr
Date: Wed, 18 Nov 2026 15:42:00 +0100
Message-ID: <20261118150024.365437839@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Baolin Liu <liubaolin@kylinos.cn>

[ Upstream commit bfa6296bb6a0e2333796a9507beb4605b92a9fdf ]

ntfs_setxattr() updates ctime and marks the inode dirty even when the
xattr operation fails.

Do that only on success.

Fixes: 2d44667c306e ("fs/ntfs3: Update i_ctime when xattr is added")
Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/xattr.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/xattr.c b/fs/ntfs3/xattr.c
index f929cef0f5100..b37e8d477d3c2 100644
--- a/fs/ntfs3/xattr.c
+++ b/fs/ntfs3/xattr.c
@@ -958,8 +958,10 @@ static noinline int ntfs_setxattr(const struct xattr_handler *handler,
 			  NULL);
 
 out:
-	inode_set_ctime_current(inode);
-	mark_inode_dirty(inode);
+	if (!err) {
+		inode_set_ctime_current(inode);
+		mark_inode_dirty(inode);
+	}
 
 	return err;
 }
-- 
2.53.0



