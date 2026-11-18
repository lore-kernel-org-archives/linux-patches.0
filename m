Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030468;
	b=ZvABmh9uW2V5t7Fm1umbab7ewMQg87l3vvMUu5274J4kSwh3whv4WvTiHLESAEVtKnJq
	 0X1i9FKNOWV/WdQlInbbRjRmSfN+RBp4jlorb9zwESpbSFQYaTCkn3uaLRdKm26B32sgE
	 o+m8UdLFn1SkEi82rX6xeW+Rp24aKB498Nqc61RDg22yPVgKQc4Yw6SztIroQlfbRWKls
	 dm5uMmVdEYQTirSaZ5TcqTLfG+wwBPgM+GTn9XC1YYNJxB3kwzdtuP47CQF/IEcTqR/fP
	 Ou/TgFrvjxuTYEP+MpjHZfOZe3NGuz5ESsnFP1jW1teISrEqLIbSH2bmKYfTI6YZQdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030468;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HlawSS5Qw3secBYWf4sFvp7rcyJOCAQyL6gQXJQC85M=;
	b=iUGrWhqnFk7wGLjtrtsQtSi5aM+ThlrBF+aQyreBEvFjJ/ZLKFxhaO7CkbMXbdJ8q3Kr
	 YfJsFB6GVkQZAqkh4655m9kM9/Ntmw/34JclCtYzVRkhnXrUfTemiu8hmS4FcoIHmacMn
	 UfyFagb5uEv8WDWUuI29H3iQYtVKNFZ9oP6F8Ae0t4rieUWZAQ7LVwVA319ESftkOPq4Q
	 vajFMHKgzO3GzEE4uWM8rlQFTGzpYU4FyNowkrf6c4y7bMNULpQC5/qzWV9C1cqQjW8iR
	 8rJRnZLczWdvqtX3h4lKr/kcs+sf2EEYXQmv5nsxI2k87Ed/U0EUWRWhdqNy3cKrLtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jgh6KWQv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C126606A33D;
	Wed, 18 Nov 2026 19:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jgh6KWQv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350001F000C4;
	Wed, 18 Nov 2026 19:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030467;
	bh=HlawSS5Qw3secBYWf4sFvp7rcyJOCAQyL6gQXJQC85M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jgh6KWQv4HcnF6aF4igTd0aqRS2nEyeUuCeGouR5wSv+igMbX6N2zynkkc+qB4HhN
	 O77wPDbgKAb8dFdgj0JpdcF5r4u3sKh7V2jy9MOx5op6fbAfmRDWamgbTQ7I9JnmFk
	 tlfdwwyCkYJaokmK7Pfb5mbhsOfJ/i0mKpn/SfAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0715/1756] f2fs: quota: fix unused-label warning
Date: Wed, 18 Nov 2026 15:47:22 +0100
Message-ID: <20261118150037.995320678@linuxfoundation.org>
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
index 7f81ac832a858..acf6bdea8a451 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2646,7 +2646,9 @@ static int f2fs_remount(struct super_block *sb, int *flags, char *data)
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



