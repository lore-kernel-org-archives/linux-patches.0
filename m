Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064528;
	b=oTdJbxd6Cqg+yvmso9V+EsPYi+x7So4qQSwBF+oZqZ9zaBp1vyXMibSQEGUn7KDTpxdV
	 0TB+ALyp3Dx1Yvjfv0VzSnt4XnItqtAal4MG34V+CEj724M87ZGD7H9lVSnfztPlC4rGR
	 B4/qVnZiZb0oxqu1OlngAHbL1oUrLRQ9rBNsy4VH/FvKci8z9/+fBOVuQvuGfPoZPVmwG
	 5oM5QWqjYxI2EMcBh4ru5PQXToGmcsed4oZLW3i7ZWdp4ssJmHzWb9zwTteMQ4WNAlW2x
	 v/RGpcpmnSQpPUJDuFI9PMZPHcubMU86wWJWNw7vsi22adJaGvh1NkhfSQeaIaf4Zvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064528;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7FM+mTTD/F61XLtHcQQ5HL0XvPDU0qvVAo3aN4TDcXE=;
	b=ayYn9R7PQwsLbYEWJVs9R5HSZE+Q5syiSkHhWW5Yem8O2rrXB1XdQ8sNTNLp/c9/oooD
	 WoqqWwwllAheX2fbkIfEk9le8H3mfEf487GYmbXJWTqHOMXcNtzJKvX19ComMv/KqmMX3
	 CjumirNBeZfba6rrq54cNbLr3VhYdZy0AVhqDoIynYCV6Ege5YbvooRHFds0zabt+alYF
	 aVOGul03yuvLL1jWWgSnKLtfUbAM+N/8KBV7yYxn0fFn3yxuILNzCnAfILZ+pKj530iYo
	 h7yXuhDweeAWBtq1F1qxChIfw6Xj9SHti8Cfwr8h1t3R42CIUbDRjyGSnihzMPMadiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rOpkjdtA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1984B606B89A;
	Sat,  7 Nov 2026 15:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rOpkjdtA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA4341F0089F;
	Sat,  7 Nov 2026 15:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064528;
	bh=7FM+mTTD/F61XLtHcQQ5HL0XvPDU0qvVAo3aN4TDcXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rOpkjdtAb/N+6hYUy3jQIsLBWIK6UISFanAbVbRmxruM2q54r8cjmyKDMM1nZybP7
	 wp5e00bT18KSc05+JrTQLupNTnWYveOKkjKjWMtzDW7azc0dIYq0wEkc8Np2+4p2u7
	 thQUoZyc5Qi+1CbSy3Y+MNlt+Jm4UV7btJ4iDhpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Goergens <matthias.goergens@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0558/1257] fanotify: report names longer than NAME_MAX
Date: Sat,  7 Nov 2026 08:47:34 -0500
Message-ID: <20261107134954.789007451@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index a208a7ec1692a..71b3a2361929c 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -648,6 +648,9 @@ static struct fanotify_event *fanotify_alloc_name_event(struct inode *dir,
 	unsigned long name2_len = name2 ? name2->len : 0;
 	unsigned int len, size;
 
+	if (WARN_ON_ONCE(name_len >= PATH_MAX || name2_len >= PATH_MAX))
+		return NULL;
+
 	/* Reserve terminating null byte even for empty name */
 	size = sizeof(*fne) + name_len + name2_len + 2;
 	if (dir_fh_len)
@@ -656,7 +659,7 @@ static struct fanotify_event *fanotify_alloc_name_event(struct inode *dir,
 		size += FANOTIFY_FH_HDR_LEN + dir2_fh_len;
 	if (child_fh_len)
 		size += FANOTIFY_FH_HDR_LEN + child_fh_len;
-	fne = kmalloc(size, gfp);
+	fne = kvmalloc(size, gfp);
 	if (!fne)
 		return NULL;
 
@@ -1050,7 +1053,7 @@ static void fanotify_free_fid_event(struct fanotify_event *event)
 
 static void fanotify_free_name_event(struct fanotify_event *event)
 {
-	kfree(FANOTIFY_NE(event));
+	kvfree(FANOTIFY_NE(event));
 }
 
 static void fanotify_free_error_event(struct fsnotify_group *group,
diff --git a/fs/notify/fanotify/fanotify.h b/fs/notify/fanotify/fanotify.h
index 3710543dbf827..87ba788574bff 100644
--- a/fs/notify/fanotify/fanotify.h
+++ b/fs/notify/fanotify/fanotify.h
@@ -43,9 +43,16 @@ struct fanotify_info {
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
@@ -168,7 +175,7 @@ static inline char *fanotify_info_name2(struct fanotify_info *info)
 static inline void fanotify_info_init(struct fanotify_info *info)
 {
 	BUILD_BUG_ON(FANOTIFY_FH_HDR_LEN + MAX_HANDLE_SZ > U8_MAX);
-	BUILD_BUG_ON(NAME_MAX > U8_MAX);
+	BUILD_BUG_ON(PATH_MAX > U16_MAX);
 
 	info->dir_fh_totlen = 0;
 	info->dir2_fh_totlen = 0;
@@ -214,8 +221,7 @@ static inline void fanotify_info_set_file_fh(struct fanotify_info *info,
 static inline void fanotify_info_copy_name(struct fanotify_info *info,
 					   const struct qstr *name)
 {
-	if (WARN_ON_ONCE(name->len > NAME_MAX) ||
-	    WARN_ON_ONCE(info->name2_len > 0))
+	if (WARN_ON_ONCE(info->name2_len > 0))
 		return;
 
 	info->name_len = name->len;
@@ -225,9 +231,6 @@ static inline void fanotify_info_copy_name(struct fanotify_info *info,
 static inline void fanotify_info_copy_name2(struct fanotify_info *info,
 					    const struct qstr *name)
 {
-	if (WARN_ON_ONCE(name->len > NAME_MAX))
-		return;
-
 	info->name2_len = name->len;
 	strscpy(fanotify_info_name2(info), name->name, name->len + 1);
 }
-- 
2.53.0



