Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829314;
	b=wI057M44c7qyVlv90qfjy+hicW2ZCtZlh1lf5//yewfaZKvRs3YFOs2Apj1c+vwKEX0u
	 +WzTTlTw8BBWWxECylt43OwDo3cYId4fziX63l3GoxrxzBzo4NUMqfQYfqptQc8nIASAw
	 D0CUu9E8EmBoEZjlsXXP5QH8qlCFpbqCS18vu01+doftypC9W/Mie6lnzzFa0fHUwVASi
	 EoJhsmKS0u5x/ItMWN0QW1ZvIG//dd5aZ9rv0zPNb1fqgv5OABdsaRJI/qss3A5WZk7cr
	 PQDEn8YmLABUcskKzh7JK0Lq0qOKgl9yp3jX0geWtlHMiQwUpQuACcRWMaO/VPQ8Gdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829314;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sqjlldPIFFM2wtnRmJK6Jtk4XGiPewwyEOoZirlNcwY=;
	b=sL7bmwqp6ZriR1HqY1yaNkfOdvVspJ12lc8H570IE2paCzt3JptJT0CrS9TVdl7qaa7h
	 XiyWMwBCMuTiCv6vweC4+V/0vfyQgdOkK1n0kjfv8QGpJRZKwCvtRbpjMRDvv3rEoZ+ub
	 LCmzedCBZc/a0yXPEQsP9Pb+WpTqKdpzUiw/NH4/7ezx6RUyDFYyR6pME56JqFFUTz+Jv
	 Gx/1SlB43lIAe3ptBfXnSQB9sRmPSaQE3U+CDs/A5J4LE2Hjv4xYdCM/KM2PG8hZYcx9u
	 hpLOU+QeRmL1+MFlIvpNsRx9RGX/y6a/3e0bSOewQ7hcOdaC/Ks+g3VqL8F4lcIBMAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0FsJu7rH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850596074918;
	Wed,  4 Nov 2026 21:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0FsJu7rH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2615C1F000C1;
	Wed,  4 Nov 2026 21:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829314;
	bh=sqjlldPIFFM2wtnRmJK6Jtk4XGiPewwyEOoZirlNcwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0FsJu7rHlyTr/11BAV2wkN715AZPxjY2Z+mO19jCKyTNbEi5xajruzzSO9uc+ajqs
	 YtbNFkw2XYugw9859xBc+OF2YjybY6pfodIWu7Pzt/gfPsTpEO6yFN96QVx1rk2g9W
	 8wQtTWFFpWl1arzDSnaZm163u08YX6RIo9d+w9dU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huawei.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0046/1005] fat: reject name longer than NAME_MAX in msdos_format_name()
Date: Wed,  4 Nov 2026 15:56:19 -0500
Message-ID: <20261104211044.874496360@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Zizhi Wo <wozizhi@huawei.com>

[ Upstream commit 9d7ed813ee5ff0d469bd99630828ed6fdef4e8da ]

msdos_format_name() performs no upper-bound check on the input name length.
It silently truncates an arbitrarily long name into the 8.3 form (11 bytes)
and returns success. The subsequent fat_scan() then matches only against
these 11 truncated bytes, so it returns an inode as long as any entry with
the same 8.3 name exists on disk.

For example, passing a 300-byte name of all 'A's returns 0 with res set to
"AAAAAAAA" (8 'A's + 3 padding spaces), reporting success for a name far
longer than NAME_MAX.

As a result, when a user calls open() on a path component longer than
NAME_MAX (255) bytes, the VFS only enforces PATH_MAX, not the length of an
individual component. The dentry keeps the original long name but gets an
inode attached and becomes positive. Later in vfs_open() -> fsnotify_open()
-> fanotify_info_copy_name() triggers WARN_ON_ONCE(), and the event is
reported to userspace with an empty name.

vfat is not affected, as create goes through xlate_to_uni() which refuses
names longer than FAT_LFN_LEN.

Fix this by checking 'len > NAME_MAX' at the entry of msdos_format_name(),
the single entry point for all msdos name handling, aligning with the
NAME_MAX check that xfs/9p/ceph/simple_lookup() perform at lookup.

Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
Link: https://patch.msgid.link/20260629130943.3671939-1-wozizhi@huaweicloud.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fat/namei_msdos.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/fat/namei_msdos.c b/fs/fat/namei_msdos.c
index 262ec1b790b56..c03610d0e7247 100644
--- a/fs/fat/namei_msdos.c
+++ b/fs/fat/namei_msdos.c
@@ -29,6 +29,9 @@ static int msdos_format_name(const unsigned char *name, int len,
 	unsigned char c;
 	int space;
 
+	if (len > NAME_MAX)
+		return -ENAMETOOLONG;
+
 	if (name[0] == '.') {	/* dotfile because . and .. already done */
 		if (opts->dotsOK) {
 			/* Get rid of dot - test for it elsewhere */
-- 
2.53.0



