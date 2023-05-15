Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0355FFC00
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:11:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57802C4339C;
	Mon, 15 May 2023 17:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170689;
	bh=2sZutiC7z09prh+YrS1LiTRI6Y9uBuWFt6BTMg2XhQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xw2S1qEXZs8z2GUS3A6FX9yJS2kKJi7MNcMGmKIsRHzNF4Q2xRp1GVW2xuYjdYBFy
	 KGIZyNA9gSLvxViLt+rVO1tKsW6N5w/TrzX7DCZpKa5cqN/Iarkm+baCIyP/j7Eaeb
	 DOYyWiEgGQJ/u4oAY0CCP7d+vRV2s6aXixdadFOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Rudi Heitbaum <rudi@heitbaum.com>
Subject: [PATCH 6.1 182/239] fs/ntfs3: Refactoring of various minor issues
Date: Mon, 15 May 2023 18:27:25 +0200
Message-Id: <20230515161727.124523398@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

commit 6827d50b2c430c329af442b64c9176d174f56521 upstream.

Removed unused macro.
Changed null pointer checking.
Fixed inconsistent indenting.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: Rudi Heitbaum <rudi@heitbaum.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/bitmap.c |    3 ++-
 fs/ntfs3/namei.c  |    2 +-
 fs/ntfs3/ntfs.h   |    3 ---
 3 files changed, 3 insertions(+), 5 deletions(-)

--- a/fs/ntfs3/bitmap.c
+++ b/fs/ntfs3/bitmap.c
@@ -661,7 +661,8 @@ int wnd_init(struct wnd_bitmap *wnd, str
 	if (!wnd->bits_last)
 		wnd->bits_last = wbits;
 
-	wnd->free_bits = kcalloc(wnd->nwnd, sizeof(u16), GFP_NOFS | __GFP_NOWARN);
+	wnd->free_bits =
+		kcalloc(wnd->nwnd, sizeof(u16), GFP_NOFS | __GFP_NOWARN);
 	if (!wnd->free_bits)
 		return -ENOMEM;
 
--- a/fs/ntfs3/namei.c
+++ b/fs/ntfs3/namei.c
@@ -91,7 +91,7 @@ static struct dentry *ntfs_lookup(struct
 	 * If the MFT record of ntfs inode is not a base record, inode->i_op can be NULL.
 	 * This causes null pointer dereference in d_splice_alias().
 	 */
-	if (!IS_ERR(inode) && inode->i_op == NULL) {
+	if (!IS_ERR_OR_NULL(inode) && !inode->i_op) {
 		iput(inode);
 		inode = ERR_PTR(-EINVAL);
 	}
--- a/fs/ntfs3/ntfs.h
+++ b/fs/ntfs3/ntfs.h
@@ -436,9 +436,6 @@ static inline u64 attr_svcn(const struct
 	return attr->non_res ? le64_to_cpu(attr->nres.svcn) : 0;
 }
 
-/* The size of resident attribute by its resident size. */
-#define BYTES_PER_RESIDENT(b) (0x18 + (b))
-
 static_assert(sizeof(struct ATTRIB) == 0x48);
 static_assert(sizeof(((struct ATTRIB *)NULL)->res) == 0x08);
 static_assert(sizeof(((struct ATTRIB *)NULL)->nres) == 0x38);


