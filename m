Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829628;
	b=OTz/XSx8j55G084j2uPSaqnqH2UAHSe1UMBQkSDNHOOsTsogOE15xffywlZy+cbhqJAv
	 A6CokkE58za/h8ToUbpvlvIss90ia5mp7ePRgRZanRLF+S3XjPlclwv69IGH38N+MYVFl
	 KunU954IyDB7rInterFwQVeTzHY3feNw04nulNXMPjH5F5eYSCCmuaAHCY+RxnIfglKoI
	 GalM+d1aLmHy0P4dGP45Td6AmrgBdDrRY9LrGd+KrBapY4Aiq2wrKu6+C0PQ8P9kuLRkz
	 ArZ+zIg6E8ts/kwqrXEaASHg6nfhGWV+uUAzI/1uHkaaXFJOLh1a+e4ugY1lO4FUFFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829628;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tW1Y2YCBkQg7fMdF6G7QVOUtjJDxirwN2mF2QR/I+9c=;
	b=CsYzxiqmLEWKwr3vUw5r7wm1gYCYMAYsbKZpjABISLzpsgkCfgX4fQfwBbEuKf9fvWxp
	 VbU4mnMVsvCb2xKphljxp2kmps/dyY+/rwILFBfWiZYMbmO5pqRMiQnyDqJbrEzMnkJZ9
	 WU+8BTfZuF89XexajkJOaz8MvqSo0IcgDkzFJH5vRHapoFLJyEiQCytM5bjhuEGIB2u/e
	 fsgxVexFsIzp+sYgygyflVV92Tg0n/7Rk+HM2WMZPdTlA2qMSa8uhC9bfXaPGT7ZFS/Nv
	 dzNXZDvHP9PzPeyAQVELQpk93deL7V/rpeogAbVGbCdFerdnPMPy6PgPZwEg0Su84Kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=prvk+2jE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D50606A84C;
	Wed,  4 Nov 2026 22:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=prvk+2jE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45C4D1F000C1;
	Wed,  4 Nov 2026 22:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829627;
	bh=tW1Y2YCBkQg7fMdF6G7QVOUtjJDxirwN2mF2QR/I+9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=prvk+2jE53LyY1jU6+H9XBdUNB6DlB2EnVamYOpQjo79M3vl2pgCHSvxN1QIGdCDq
	 ZbLHJOUI7Hp1INjRx2Pu6WdcAPOCBrpE82A3i6DE2RSO7YRf6kxIS58hqERVoWVTLs
	 394ZWy/KoWUR3S02odQMaxjx/7jgiEv0NSQMcqYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+905d785c4923bea2c1db@syzkaller.appspotmail.com,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0243/1005] ntfs3: fix info-leak in ntfs_rename()
Date: Wed,  4 Nov 2026 15:59:36 -0500
Message-ID: <20261104211050.663911189@linuxfoundation.org>
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
index 64cde1a856f44..f547ce82520f8 100644
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



