Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045373;
	b=l6yxax8x+MOX1vMqZX8iga/Ngovwn34XONN1QNL8Tvo2Vbyc8CXaSSzuNldp2vwdc9f1
	 hsOhnlNb/zejG3BvUYqUJtHdYbWa82olQGcP7rmyoMdDoV1NYy6ovC62LJe3zpVZbcv4x
	 9PiApDeiksvUyIpnti8j7ujBszYAGNbVLHCvGupsHpzkN7dKqPHAhyvxi/gNAX7ZCqRqK
	 6pwn+reJT39ltG0gEuDsc1fupCyPKyOl9FwqQ4kXsigfe4WNKRLJ3+ZvvREv+XmQAw+Ff
	 AYFI14xGJAvxp3Ahmn4pS4U5eoiaVExWa+2FMxmB8U9kdoA2fbdFKi56QkJjgrCKRsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045373;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z2FQQ365lHB19u2kbC+Ib0XLC/VkxkuAx7gXILcPuqY=;
	b=fRwZBG5muPEZ8bVPXNQwLLDMO5oQX9n0/z5N73F9n68542tU/x0jyvGQyYQJhCkIoFkE
	 2un1t4CIBb3C94M3ZFktTWxWtnWOlFN09r2ejfkHlzs8GJG4FE7+vlT5cz+Ls0JJFTSjj
	 im9FOD3/lOMVXP+W2VVF/sTmkaUhpShErDGRXrZU2ndmun+WMs+lcNQW/rdqQKGM01SDG
	 gs/fMAK4zSSOceU+8yHTHXxEt4N8+Qh9+Whpvpvp4+hAiFym2mcB0ADLQ8Y7Jf69zfRYZ
	 wI2GrLseBTQhyKDBusGegPz0ddArXVdHOxKO5GnFGwxcdg2C/tCNYgV8GJsaBaN5JFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MKoq15Nm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14856606A32F;
	Wed, 18 Nov 2026 23:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MKoq15Nm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BDC01F000C7;
	Wed, 18 Nov 2026 23:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045372;
	bh=Z2FQQ365lHB19u2kbC+Ib0XLC/VkxkuAx7gXILcPuqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MKoq15NmUicoVa68gXuux/prj7YKk1AAeLEzBR7l9sR6E/qZdxctTxNahtNpy42Vz
	 yqG3ppH5T5NpmM7LFC108p1dWXXlzmrYQ697S7C/fuNr4x1CCVMsYD4fQOT7vAFLLO
	 K1pihwNDR0J6h2l5FJ77AB1UqX9zExuNCGr7R4w0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Goergens <matthias.goergens@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0901/2857] fanotify: report names longer than NAME_MAX
Date: Wed, 18 Nov 2026 15:32:15 +0100
Message-ID: <20261118150234.003973043@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthias Goergens <matthias.goergens@gmail.com>

[ Upstream commit ff05910cb1b77c2b229c5e6e260c6173a17b579b ]

fanotify keeps the length of a reported name in a u8, so it drops any
name longer than NAME_MAX and warns:

  WARNING: fs/notify/fanotify/fanotify.h:217 at fanotify_handle_event+0x2e82/0x39f0

Such names are legitimate on some filesystems.  vfat mounted with utf8
takes up to 255 UTF-16 characters, which are up to 765 bytes of UTF-8,
and FUSE accepts names up to PATH_MAX - 1.  readdir() and inotify report
them in full.  fanotify sends the event without the name, and for
FAN_RENAME it trips a second warning in copy_fid_info_to_user(), after
which read() fails with EFAULT and the event is lost.

When syzbot hit this, Jan suggested accommodating names up to PATH_MAX
[1], the limit readdir() already applies to a name
(verify_dirent_name()).  Store the name lengths as u16, which keeps
struct fanotify_info at 8 bytes, and drop without a warning only names
of PATH_MAX bytes or more, which no path can refer to.  An event with
such a name can exceed a page, so allocate name events with kvmalloc(),
as Jan also suggested.  Names up to NAME_MAX are reported exactly as
before, and the record format is unchanged: an event with a long name is
just longer.

Link: https://lore.kernel.org/all/20241112115059.ecvomkalee5m4i4i@quack3/ [1]
Fixes: 2d9374f09513 ("fanotify: use macros to get the offset to fanotify_info buffer")
Cc: stable@vger.kernel.org
Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
Link: https://patch.msgid.link/20260926020851.2938961-1-matthias.goergens@gmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify.c |  7 +++++--
 fs/notify/fanotify/fanotify.h | 21 ++++++++++++---------
 2 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index a2a15bc4df280..1fafdcf6592c7 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -610,6 +610,9 @@ static struct fanotify_event *fanotify_alloc_name_event(struct inode *dir,
 	unsigned long name2_len = name2 ? name2->len : 0;
 	unsigned int len, size;
 
+	if (WARN_ON_ONCE(name_len >= PATH_MAX || name2_len >= PATH_MAX))
+		return NULL;
+
 	/* Reserve terminating null byte even for empty name */
 	size = sizeof(*fne) + name_len + name2_len + 2;
 	if (dir_fh_len)
@@ -618,7 +621,7 @@ static struct fanotify_event *fanotify_alloc_name_event(struct inode *dir,
 		size += FANOTIFY_FH_HDR_LEN + dir2_fh_len;
 	if (child_fh_len)
 		size += FANOTIFY_FH_HDR_LEN + child_fh_len;
-	fne = kmalloc(size, gfp);
+	fne = kvmalloc(size, gfp);
 	if (!fne)
 		return NULL;
 
@@ -1013,7 +1016,7 @@ static void fanotify_free_fid_event(struct fanotify_event *event)
 
 static void fanotify_free_name_event(struct fanotify_event *event)
 {
-	kfree(FANOTIFY_NE(event));
+	kvfree(FANOTIFY_NE(event));
 }
 
 static void fanotify_free_error_event(struct fsnotify_group *group,
diff --git a/fs/notify/fanotify/fanotify.h b/fs/notify/fanotify/fanotify.h
index 57f51a9a3015d..04263c5bbb8e8 100644
--- a/fs/notify/fanotify/fanotify.h
+++ b/fs/notify/fanotify/fanotify.h
@@ -42,9 +42,16 @@ struct fanotify_info {
 	u8 dir_fh_totlen;
 	u8 dir2_fh_totlen;
 	u8 file_fh_totlen;
-	u8 name_len;
-	u8 name2_len;
-	u8 pad[3];
+	u8 pad;
+	/*
+	 * Deliberately not limited to NAME_MAX: some filesystems return longer
+	 * names (vfat up to 255 UTF-16 characters, as Windows allows, which is
+	 * up to 765 bytes of UTF-8; FUSE up to PATH_MAX - 1), and readdir() and
+	 * inotify report them in full. Only names of PATH_MAX bytes or more,
+	 * which no path can refer to, are dropped.
+	 */
+	u16 name_len;
+	u16 name2_len;
 	unsigned char buf[];
 	/*
 	 * (struct fanotify_fh) dir_fh starts at buf[0]
@@ -167,7 +174,7 @@ static inline char *fanotify_info_name2(struct fanotify_info *info)
 static inline void fanotify_info_init(struct fanotify_info *info)
 {
 	BUILD_BUG_ON(FANOTIFY_FH_HDR_LEN + MAX_HANDLE_SZ > U8_MAX);
-	BUILD_BUG_ON(NAME_MAX > U8_MAX);
+	BUILD_BUG_ON(PATH_MAX > U16_MAX);
 
 	info->dir_fh_totlen = 0;
 	info->dir2_fh_totlen = 0;
@@ -213,8 +220,7 @@ static inline void fanotify_info_set_file_fh(struct fanotify_info *info,
 static inline void fanotify_info_copy_name(struct fanotify_info *info,
 					   const struct qstr *name)
 {
-	if (WARN_ON_ONCE(name->len > NAME_MAX) ||
-	    WARN_ON_ONCE(info->name2_len > 0))
+	if (WARN_ON_ONCE(info->name2_len > 0))
 		return;
 
 	info->name_len = name->len;
@@ -224,9 +230,6 @@ static inline void fanotify_info_copy_name(struct fanotify_info *info,
 static inline void fanotify_info_copy_name2(struct fanotify_info *info,
 					    const struct qstr *name)
 {
-	if (WARN_ON_ONCE(name->len > NAME_MAX))
-		return;
-
 	info->name2_len = name->len;
 	strcpy(fanotify_info_name2(info), name->name);
 }
-- 
2.53.0



