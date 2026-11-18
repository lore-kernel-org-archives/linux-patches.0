Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036375;
	b=o/33wLmhSmPRwklFyGC/JrPNrBPQMgrGEUu/Ga+ZsbGJY7xZjo/0qbt7hBEeMy9mhd0P
	 N6KuI7mfDZkJZBlz10S2+ipQMVBD6WepNOhtz+teqcggtp+kc4mAKwrbcG5EOcf80ORg4
	 etoKesAKEwUlkF/sfXtKgSSPVRGkSLyavVnlgby1ZXtqSrVcGzuIJ3JA90RmdK7yFj2SV
	 VBir1QhgSabkqFNNCq4jNWdwyKS9oz/FnRjYx2+I1HW5apxd0I4V3v5/R3MQrTXDt3XTU
	 fPGas7WeWxBKUqVe5ReH3Y3vXqiOX1MYjcek5dgid9Tj8nE+3HL+O8a/AWJaZNRScIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036375;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+zG6T+gEcFmxKQqZlMj8eMW/9E8zIHOQ6etKkJRsoF0=;
	b=aLIGHV33corz0/qzxW4X27SWS2DZLfL3a6TRFQcf577dHxg9la/7KykivAtoVgcgpo+v
	 Zas/ZMaUj2OJql/Nvg9SWQQeWR4XjEiPJKTvPHHxQxQJrPavNGY/rlSAy+2zNC4AfL2UP
	 gcRE6wzZgpWlveVHQ9CQ2wUhcbEu0/PZkBnpsripUOIxpdamBCmqCTNDvDa2tOq4mzhkT
	 6onJr0eObtYOyYqpozDCKA2NhmBN50y1GCt5LXqDFJq+sLWTa49fyV2ygyZS7aP1zQwAF
	 jZ1nQVJwId471hOgNWNjPogc1ytItgp24pHJPYs9ph1C5+TbRYDlUhRPTyR9Y7ZFB3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="FOx0OC/X";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A720B606A31C;
	Wed, 18 Nov 2026 21:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FOx0OC/X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12661F000C7;
	Wed, 18 Nov 2026 21:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036375;
	bh=+zG6T+gEcFmxKQqZlMj8eMW/9E8zIHOQ6etKkJRsoF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FOx0OC/X8AiGakR9juewPZgkea5xGKze9K3a87wvAqKrC7uGeFDI6J+Btxklpdm0A
	 +KYueJmzXtlNCHGFs0V04mY9YxIZ+oy9uPuJ6aElJa2TtmWBsYY53QpX+xeLNWQ4YF
	 IpPGnCw99SQxnPbNnU0Xgl0hfJ6n9dYa3JO6FVaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Goergens <matthias.goergens@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1037/3318] fanotify: report names longer than NAME_MAX
Date: Wed, 18 Nov 2026 15:27:39 +0100
Message-ID: <20261118150351.012904851@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 723ff9cad9ed9..0ef90c9c33a1a 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -620,6 +620,9 @@ static struct fanotify_event *fanotify_alloc_name_event(struct inode *dir,
 	unsigned long name2_len = name2 ? name2->len : 0;
 	unsigned int len, size;
 
+	if (WARN_ON_ONCE(name_len >= PATH_MAX || name2_len >= PATH_MAX))
+		return NULL;
+
 	/* Reserve terminating null byte even for empty name */
 	size = sizeof(*fne) + name_len + name2_len + 2;
 	if (dir_fh_len)
@@ -628,7 +631,7 @@ static struct fanotify_event *fanotify_alloc_name_event(struct inode *dir,
 		size += FANOTIFY_FH_HDR_LEN + dir2_fh_len;
 	if (child_fh_len)
 		size += FANOTIFY_FH_HDR_LEN + child_fh_len;
-	fne = kmalloc(size, gfp);
+	fne = kvmalloc(size, gfp);
 	if (!fne)
 		return NULL;
 
@@ -1023,7 +1026,7 @@ static void fanotify_free_fid_event(struct fanotify_event *event)
 
 static void fanotify_free_name_event(struct fanotify_event *event)
 {
-	kfree(FANOTIFY_NE(event));
+	kvfree(FANOTIFY_NE(event));
 }
 
 static void fanotify_free_error_event(struct fsnotify_group *group,
diff --git a/fs/notify/fanotify/fanotify.h b/fs/notify/fanotify/fanotify.h
index e8a3c28c5d120..142e64b8b7343 100644
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



