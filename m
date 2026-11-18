Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024941;
	b=Z/vReK0Ev3mtzS5vqP5fyCF/Vvo8tcMD8YPa8afM/cHjYro//hJ6IewrpaZ5rfB7MYzO
	 wQL1wTDZA62wEfmHmMIfVTeroN3a/qHxpkNPW4hdR/iDvOMhumwkQUjBLUuPkuk2vhMa8
	 E0LzWKSrOiAn9G7vFmNLM1HXJL2UA6vAIDaTEe2BuwniV3WQSk3RmfeAnOzqF3lOe736T
	 cIpAkx6xovmLZ1oLmOgrw9rVg07A+Svb59PYcd045paABj6dUE3leEqNq36tBON3vIRbX
	 2Or7AEvifByL9ZmFLO6PaOzABuKsHegYG+kBgCtPjanCIBGRN4F6J0JhV06SwOVVj0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024941;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FH1ka0fbdVdZHj89zSPcsUP+k73CC9KmKZ2zf4Cu3hw=;
	b=4LRPXaNWytmsECph8SDQQ6qSfJd0A6Xd1yZob6+qlzrj/q0PRb0NdVCJNx2HJh0qLXn/
	 FYGlWdxQhRNeDEOkl16uSkpnJgjA86uug8Q1gZIabeibOVN7JQjblxtUrZ3DTR21dSpgt
	 M/WEcJm59Mu8gA5yV76j1vQF7cmHyTk6aDuZHq+adRkHm/TK8lEHId8qFtSxE2Cj2RT85
	 A0Am+mZTe5GQPsRuyaDPkDfGrrkxrqvl94zO0iS+2AN9b+HUPgNRZ18xEll4AsqcWsbS6
	 ZCxtBkh7IhJKNUl0muBlLZrsn2snN8LEivCSO2Sf6anBr+V8itz4OPARFwXnA1Niblg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xmGSPY49;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89DC9606A31C;
	Wed, 18 Nov 2026 18:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xmGSPY49
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A427D1F000C4;
	Wed, 18 Nov 2026 18:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024941;
	bh=FH1ka0fbdVdZHj89zSPcsUP+k73CC9KmKZ2zf4Cu3hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xmGSPY49AKoI98zZRhTe28uUzwDKQsuDwiNeeBqyOFlmSt6EbUxQs92le92c8Kq0p
	 jVKq+8v5GyFU0KufpxVHtOfENcTdOfTDYzSJL7SehPt7LdWUBN5zz0S7T5d50CBorv
	 xLYraP6HjL+JIMROKvO7YUrvaDAt6/OcmYabv+Lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0902/2151] f2fs: quota: fix unused-label warning
Date: Wed, 18 Nov 2026 15:43:57 +0100
Message-ID: <20261118150155.151052505@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 4faeea625cf730bb20f609f061ff81c9b6852931 ]

The newly added label causes a warning when QUOTA is turned off:

fs/f2fs/super.c: In function '__f2fs_remount':
fs/f2fs/super.c:3142:1: error: label 'restore_holder' defined but not used [-Werror=unused-label]
 3142 | restore_holder:
      | ^~~~~~~~~~~~~~

Fixes: 3f140a60c92a ("f2fs: quota: fix stale lock holder on remount failure")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index e0257f6eff868..19da33bf838a0 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2992,7 +2992,9 @@ static int __f2fs_remount(struct fs_context *fc, struct super_block *sb)
 	sbi->mount_opt = org_mount_opt;
 	sb->s_flags = old_sb_flags;
 
+#ifdef CONFIG_QUOTA
 restore_holder:
+#endif
 	sbi->umount_lock_holder = NULL;
 	return err;
 }
-- 
2.53.0



