Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065173;
	b=EAUFeBj8H8yEoUi5MgBHFDKLiO1uuQRrKqsf88vHCpSZvOsIIxQbpA3LXTIQXVJlj/vd
	 geD+voEGNXIueFY6rswWUklLqjiWWf3YRA71pi+92xSDcyx/AjwzTmMNMpf+KbLhpZdxW
	 Y1JkMol4t9sPGefK2uAz3z1RvfTIBgbVW5dAzb+4qCkQvij/9Fb0u5Yo01erBlcMaknw7
	 LqeUriCxP3Bbcac9LOW35Q5YiLFpMveWm3f6vmDeg7systDoWf9Ko4mZNtoQl8Oa4S8jh
	 bq+MmXLYqtqrM1GQW28RNjH9EdJR+3b3ZTZBDs6rWMRBOANjgJQN/ERGnlvvvTBPvKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065173;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZE97gir8uj14FYWoGoaAO9ijqwDolKGHve4kSqKOpw4=;
	b=eSzV2fFp5HK9VSfI317Eq/Iw5crP4X8PhApqJ5SaHzKhohinXca606nqFh/TT157Kth9
	 6sOHZN5l8e8tn5/dzLiiJjkp8TPDMNvtSekgG5v3e/pucsp9DwT6vyLSWbbStQFcnXu4K
	 u/w7V3pamZY9SZ1FCJioSy/i2fyk8mH+B04n+aCHxMQYd3OKyfnev41FwX0edWbw2obXN
	 Jc9PgXA2m9IO3F5FQudcpBvPlZJ1F+Uq9fTnahQNPypTXXxV7D8vMLzMMUTmHOsO55Kb8
	 4nT59LCMiXWWYxrjkOamKq9snrbHtg0HrAuyJFSG5cCrWRScd7goAPiRIjINfDvhQiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I23WavQF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6D4606A331;
	Sat,  7 Nov 2026 15:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I23WavQF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 330361F0089F;
	Sat,  7 Nov 2026 15:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065173;
	bh=ZE97gir8uj14FYWoGoaAO9ijqwDolKGHve4kSqKOpw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I23WavQFQZB6EofAIRkPnR6PhKx/iRtQ7PmZEeQ3Y5/1drZYDxaG6CccQ2Kk36zNV
	 bjlOaVtBE/lbTq2czRtUi7PEXDYvUJbms3kafQyX6Ky9hzbSDqK80JrXlux2HauFQV
	 5MU0F6Fl5ytHLXMkVocrFjhg8GjoifplViwvTd8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Morris <rtm@mit.edu>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Baolin Liu <liubaolin@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0927/1257] ntfs: validate attribute-list sizes before allocation
Date: Sat,  7 Nov 2026 08:53:43 -0500
Message-ID: <20261107135004.959979364@linuxfoundation.org>
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

From: Hyunchul Lee <hyc.lee@gmail.com>

[ Upstream commit ca43660672050337f4b845e36f732e3af1e308ca ]

The NULL point dereference could occur when an on-disk
$ATTRIBUTE_LIST size was truncated before it was validated and allocated.

To fix this issue and prevent excessive memory allocation, limit the
$ATTRIBUTE_LIST size to 256 KiB.

The following existing implementation and Windows test provide evidence
for this 256 KiB compatibility limit:

NTFS already treats 256 KiB as the $ATTRIBUTE_LIST limit in its
attribute-size checks and $MFT attribute list repack/expand paths.

For additional Windows testing, when $MFT's attribute-list data_size was
above 256 KiB, Windows attached the disk partition but did not mount a NTFS
volume and target access failed.

Fixes: af0db57d4293 ("ntfs: update inode operations")
Link: https://lore.kernel.org/ntfs/88468.1790006025@30-10-12.wireless.csail.mit.edu/T/#u
Cc: stable@vger.kernel.org
Cc: Robert Morris <rtm@mit.edu>
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Reviewed-by: Baolin Liu <liubaolin@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/attrib.c   |  2 +-
 fs/ntfs/attrlist.c |  2 --
 fs/ntfs/inode.c    | 21 +++++++++++++++------
 fs/ntfs/ntfs.h     |  2 ++
 4 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/fs/ntfs/attrib.c b/fs/ntfs/attrib.c
index b01cbc9eea4ad..e8a672c84a02f 100644
--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -1775,7 +1775,7 @@ int ntfs_attr_size_bounds_check(const struct ntfs_volume *vol, const __le32 type
 	 * $ATTRIBUTE_LIST has a maximum size of 256kiB, but this is not
 	 * listed in $AttrDef.
 	 */
-	if (unlikely(type == AT_ATTRIBUTE_LIST && size > 256 * 1024))
+	if (unlikely(type == AT_ATTRIBUTE_LIST && size > NTFS_MAX_ATTR_LIST_SIZE))
 		return -ERANGE;
 	/* Get the $AttrDef entry for the attribute @type. */
 	ad = ntfs_attr_find_in_attrdef(vol, type);
diff --git a/fs/ntfs/attrlist.c b/fs/ntfs/attrlist.c
index bb191953dcb1b..1abe0ec2a398a 100644
--- a/fs/ntfs/attrlist.c
+++ b/fs/ntfs/attrlist.c
@@ -14,8 +14,6 @@
 #include "attrlist.h"
 #include "lcnalloc.h"
 
-#define NTFS_MAX_ATTR_LIST_SIZE	(256 * 1024)
-
 /*
  * ntfs_attrlist_need - check whether inode need attribute list
  * @ni:	opened ntfs inode for which perform check
diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index 86e359a7c53af..a6700c5f93791 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -805,6 +805,8 @@ static int ntfs_read_locked_inode(struct inode *vi)
 			goto unm_err_out;
 		}
 	} else {
+		s64 attr_list_size;
+
 		if (vi->i_ino == FILE_MFT)
 			goto skip_attr_list_load;
 		ntfs_debug("Attribute list found in inode 0x%llx.", ni->mft_no);
@@ -827,11 +829,14 @@ static int ntfs_read_locked_inode(struct inode *vi)
 				ni->mft_no);
 		}
 		/* Now allocate memory for the attribute list. */
-		ni->attr_list_size = (u32)ntfs_attr_size(a);
-		if (!ni->attr_list_size) {
-			ntfs_error(vi->i_sb, "Attr_list_size is zero");
+		attr_list_size = ntfs_attr_size(a);
+		if (attr_list_size <= 0 ||
+		    attr_list_size > NTFS_MAX_ATTR_LIST_SIZE) {
+			ntfs_error(vi->i_sb, "Invalid attribute list size %lld (mft_no 0x%llx).",
+				   (long long)attr_list_size, ni->mft_no);
 			goto unm_err_out;
 		}
+		ni->attr_list_size = (u32)attr_list_size;
 		ni->attr_list = kvzalloc(ni->attr_list_size, GFP_NOFS);
 		if (!ni->attr_list) {
 			ntfs_error(vi->i_sb,
@@ -1955,6 +1960,7 @@ int ntfs_read_inode_mount(struct inode *vi)
 	} else /* if (!err) */ {
 		struct attr_list_entry *al_entry, *next_al_entry;
 		u8 *al_end;
+		s64 attr_list_size;
 		static const char *es = "  Not allowed.  $MFT is corrupt.  You should run chkdsk.";
 
 		ntfs_debug("Attribute list attribute found in $MFT.");
@@ -1978,11 +1984,14 @@ int ntfs_read_inode_mount(struct inode *vi)
 				"Resident attribute list attribute in $MFT system file is marked encrypted/sparse which is not true.  However, Windows allows this and chkdsk does not detect or correct it so we will just ignore the invalid flags and pretend they are not set.");
 		}
 		/* Now allocate memory for the attribute list. */
-		ni->attr_list_size = (u32)ntfs_attr_size(a);
-		if (!ni->attr_list_size) {
-			ntfs_error(sb, "Attr_list_size is zero");
+		attr_list_size = ntfs_attr_size(a);
+		if (attr_list_size <= 0 ||
+		    attr_list_size > NTFS_MAX_ATTR_LIST_SIZE) {
+			ntfs_error(sb, "Invalid attribute list size %lld (mft_no 0x%llx).%s",
+				   (long long)attr_list_size, ni->mft_no, es);
 			goto put_err_out;
 		}
+		ni->attr_list_size = (u32)attr_list_size;
 		ni->attr_list = kvzalloc(round_up(ni->attr_list_size, SECTOR_SIZE),
 					 GFP_NOFS);
 		if (!ni->attr_list) {
diff --git a/fs/ntfs/ntfs.h b/fs/ntfs/ntfs.h
index a5cd5493c5011..cb69707c3f3d5 100644
--- a/fs/ntfs/ntfs.h
+++ b/fs/ntfs/ntfs.h
@@ -80,6 +80,8 @@ enum {
 	NTFS_MAX_LABEL_LEN	= 128,
 };
 
+#define NTFS_MAX_ATTR_LIST_SIZE	(256 * 1024)
+
 enum {
 	CASE_SENSITIVE = 0,
 	IGNORE_CASE = 1,
-- 
2.53.0



