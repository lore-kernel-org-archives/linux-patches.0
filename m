Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060875;
	b=uqhJrWjG6VjCpbwZ80NKN8eX3Hgb60UF3GB5U2MpJHMOkjWdctQWETARp9nE+aomPfnR
	 /1WJiBk6vuIWLcMkQ7d/+iYC7YW9wtp76dyaQF7rdstd9ujhqOxrwWKk+CTV+k9desMEn
	 MQLAwVuFBQWlgG0S/Xnucpf3fBzQtT66D7Q58v0SGTaUM7MKNHWVnpNybX4okn7BhvaV8
	 QY7bGr8pIuGv7FShP0xe9qWkJUaypR+5MJ2KTZVCSt1+b66NM/iCugVCHbGRhn0mDqET8
	 d2BTsAjyvREOvIKPG1JTHtsNBFD8qPl90vkMlmJpXXuhP7a3//HW2nkBruPCKrxD0rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060875;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WH6S8NjR1obCn74+WqAEKBPszv7eRLz/XruqNS9BNfg=;
	b=MA/QWUUyVGvHcrUs8ymTjSX0Gd9xW//x97TpVM2SSVdsHEAfk5lyrmVmvivql6eX8xn8
	 WnR2ZVmJOTzIf8urUz5mfspIs14zzy5dysiMi5cMP+OQG7gE/igyuRJBqGgj7pLmh8/4+
	 cWDNdPIzPigM9WPOrgX8n6Gw4dDaPIT224c0/RazN0zFqAJKwlBRXNPlPWB3TE3jczT6u
	 npq65AwuCuEEfyaKstOJOaftxHFKzaoI1kKp8wQPmgg+33vZdTT8kFsIp2fC5tMCO/Tap
	 6S5xN+Krz9NvzfYrCD1qx/O6ARdzEY+rkXbuKGf59PwNKpZ4kNM1Db5R9hVCxgJuw1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XfEphBkc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B568606A33A;
	Sat,  7 Nov 2026 14:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XfEphBkc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 609AF1F008A7;
	Sat,  7 Nov 2026 14:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060874;
	bh=WH6S8NjR1obCn74+WqAEKBPszv7eRLz/XruqNS9BNfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XfEphBkcMxcIb4Xs+v2BtQ5Cg4cQjsHoTaXXCSbQjXw2YV58BDrBVn22tO+TJZ769
	 VkWpwXDIuQMW0Slzzypn9VkYwhPSvCk8TMRfw/FBO8vb96o4JD3kLcdLBG/MpPj9Wc
	 Bp9YmsBPK4+0QWU/01uVP1bp8/R/s8zclYLNSZ7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+905d785c4923bea2c1db@syzkaller.appspotmail.com,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0205/1536] ntfs3: fix info-leak in ntfs_rename()
Date: Sat,  7 Nov 2026 08:37:01 -0500
Message-ID: <20261107135003.414749721@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 2fa56613b25d0c983ef3ff6d3e865d4254280abe ]

Hard to say about copy_to_user_iter(), but at least the first splat
looks correct. At the end of fill_name_de(), data layout is:

struct NTFS_DE *e = buf;
...

    |<- data_size + sizeof(struct NTFS_DE) ->|<- XXX ->|
buf |-----------------------------------------------------------
    |<- ALIGN(data_size, 8) + sizeof(struct NTFS_DE) ->|   ;; e->size

If 'buf' was allocated with kmalloc(), XXX remains uninitialized and
passed as such to memcpy() called from hdr_insert_de().

So using kzalloc() for all buffers passed to fill_name_de() looks
the simplest and most safe solution. OTOH if someone would have
said that an overhead of PAGE_SIZE'd memset() is too large, more
fine-granted solution is to memset() XXX only.

Reported-by: syzbot+905d785c4923bea2c1db@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=905d785c4923bea2c1db
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/namei.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/namei.c b/fs/ntfs3/namei.c
index 8e787c2f1777c..fb8921397d866 100644
--- a/fs/ntfs3/namei.c
+++ b/fs/ntfs3/namei.c
@@ -22,7 +22,7 @@ int fill_name_de(struct ntfs_sb_info *sbi, void *buf, const struct qstr *name,
 {
 	int err;
 	struct NTFS_DE *e = buf;
-	u16 data_size;
+	u16 data_size, real_size, aligned_size;
 	struct ATTR_FILE_NAME *fname = (struct ATTR_FILE_NAME *)(e + 1);
 
 #ifndef CONFIG_NTFS3_64BIT_CLUSTER
@@ -53,7 +53,12 @@ int fill_name_de(struct ntfs_sb_info *sbi, void *buf, const struct qstr *name,
 	fname->type = FILE_NAME_POSIX;
 	data_size = fname_full_size(fname);
 
-	e->size = cpu_to_le16(ALIGN(data_size, 8) + sizeof(struct NTFS_DE));
+	real_size = data_size + sizeof(struct NTFS_DE);
+	aligned_size = ALIGN(data_size, 8) + sizeof(struct NTFS_DE);
+	if (aligned_size > real_size)
+		memset((char *)buf + real_size, 0, aligned_size - real_size);
+
+	e->size = cpu_to_le16(aligned_size);
 	e->key_size = cpu_to_le16(data_size);
 	e->flags = 0;
 	e->res = 0;
-- 
2.53.0



