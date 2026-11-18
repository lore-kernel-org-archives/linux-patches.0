Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017954;
	b=pgPpc4+48rchO8796JgfKrn6ZG9VfHgBvqOuXMsIbGuLc5gZ26jM6Z56TPJ4MkZkFuH1
	 vOnd+4xyq/Ev5zPyom1daPjD+CN9zHUF6jOskSSyzH53RjtKtBqsqrARnAlFgQoOZxZ2h
	 DlQBeSyasMsoE7jGsDGgMs+dc0osYlH6Cnx8OlRJSoQhDsjO6gj7UAKmXUzkEmfh2m4ii
	 rdtgEZqWzoIu7xX52yRxrqrmRqAcIJhlD2b6D0zTFOqMgCumuVVhgOF0G6YSyCKWDK91E
	 oAT3cveBvfli5sclJbRXIT1dXYXbX3vUOZNrUfpuSh4C3A1qdfHWJgTyyxTwpGKQZMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017954;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4SaDvTZvca9MlOA4/1F4QyvDiwvsHtkic/ev13b4F3I=;
	b=PZRZQUePNFYCllR4cRElTevWjlHrGhYArVlfFszkotP8u3n12oui/1hpWwm268HkCZQG
	 AIlztR84aTymw1vYfJCMgB8TujOxljx5TJV+uYJR/P/zHUOgVQsBFz4rzAC1hLoKnCOsJ
	 /EzrvFkDuFyH5xLt1uGIiFwiHJ+08Nn4BMXLg+v/PghgRrAccsq1U/uIAJxImaTKSrh1f
	 CCeBAmKIyPBMd7nRJEACu9jC7ZnuXdZ5Y8ODgbLt8zOX9Ywe3BePoxsrVCsbZuyQrIBvh
	 N/3uCtaBpgT/vyv9AUiswIFHaUhDUtqfOpZ1BGvZBlCHzjCSTTa1AwY7USbyC0VHutg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i41KvhiI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024D3606A31C;
	Wed, 18 Nov 2026 16:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i41KvhiI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 534D31F000C4;
	Wed, 18 Nov 2026 16:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017953;
	bh=4SaDvTZvca9MlOA4/1F4QyvDiwvsHtkic/ev13b4F3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i41KvhiIw07niLf9mVYiFrjyNqcm354RhQ2eT45hSfppfSMzpsqm5yuATPiY0UF1l
	 6Mgz74SAgy64ye1h0/vj346/gqY966o23SNh7m3tHi7RiHlxQuhwDhpuTunn/fuacj
	 DoF3hCKqKq7TH268e5HR+k3qG2FdTtc4vInPZxJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1068/2651] f2fs: quota: fix unused-label warning
Date: Wed, 18 Nov 2026 15:38:28 +0100
Message-ID: <20261118150326.429854743@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 17e00d5003b02..ec7ac09079cb7 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -3126,7 +3126,9 @@ static int __f2fs_remount(struct fs_context *fc, struct super_block *sb)
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



