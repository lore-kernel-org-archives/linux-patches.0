Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619672;
	b=dJ0j/1U60034R3ahsJBPHDOL9OIk4qOxLIKWT5gi5vVkaogDeIiBYqiSWaWb+hdUYEtZ
	 VY4KPdPnQLE6+PrHhwSKTcUvVm/fy3P+EVRE4vwUTyHNC1SsThyKuq/mSaq/Nlts0+9oy
	 3WBQYQK5emejMUkIb82ahABv41xTshmlMTdbenNsfWu+BrhuEVI3B3UoWfDLNKxhc81dk
	 Hzcz5Y1WDpADsJPd43eTVADCVig+l9uVtl0WErDgYHtr6mdiDwEGLAJmLhtvDyJjHrIkO
	 Y0RaZp+ZrEIW+uBPNFFp75wERfU2XQ/xNeKEE9QOso18Y6QH/0c9uWpj5M8O/Or/IiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619672;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B6v1c66XqazeU2uJwnWo8QOnA/HmNwazU5hB2FRWWjo=;
	b=LnaSF1yWAMJBjYfG4njguYyk/Ba/Uhg1858lDxbxngQqa7m1vgGmygw7JmDz9nNiN+mI
	 J3r2osCX3jC7NP4cJSY1iz8riXIX3r2IFQ8cHcT/w/NTYSiOqd8TWE0rqcVKVKDfDXjlg
	 4Qe9qsAK2pqMGIU0EpaJ221PxC/JdIFFCNA1XMfq5GdL1iJ2bBMJx6ZLAm0sfnwEhnQO6
	 3yxm9yxR/XmFLveZgAFYOVFtGBY/8ZYb3Xpsb6DAs4nN5J4x94Mke5TbGp6vTx+hS6isy
	 ZFn9E+cxIrrPr3GTZbA2B278RdE+3gB/bdiB73asmK6JhQ84m1XDni2bbh8I8hzvgeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vNrfTSlY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15DAB606A6A4;
	Wed, 25 Nov 2026 15:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vNrfTSlY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D201F00A01;
	Wed, 25 Nov 2026 15:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619671;
	bh=B6v1c66XqazeU2uJwnWo8QOnA/HmNwazU5hB2FRWWjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vNrfTSlYqIWpQj+yjOcodkIqob1/TTYrKFWEz2nI6gc1T2I9YrXxuLykjpiPpBLjA
	 HwLCWSjEY197Xrzv1NaD65GI6BXiHk+thWSnJLEunJXkZGqgrrZclg1oeRBv2B32ha
	 dZ2z+KKrXA/NfXPRGn3bDM2w9do9rb8O6bPi4hYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wahid Khan <wahidzk0091@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.3 0672/1005] ntfs: check the file name against the key length of an index entry
Date: Wed, 25 Nov 2026 15:33:30 +0100
Message-ID: <20261125143837.494327406@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Wahid Khan <wahidzk0091@gmail.com>

commit 5e7143476219eac7cab7bdd341db68dab1649737 upstream.

ntfs_index_entry_inconsistent() checks that the file name of a
$FILE_NAME key fits in the index entry. It does not check that the name
fits in the key, which is what key_length describes. Code that works on
the key alone relies on that.

ntfs_readdir() copies key_length bytes of the key of the next entry to
resume the enumeration, and later uses the copy to search the index. If
file_name_length is larger than the key holds, the name comparison reads
past the copy:

  BUG: KASAN: slab-out-of-bounds in ntfs_file_compare_values+0x2d1/0x4b0
  Read of size 2 at addr ffff88800a4ef2ce by task init/1
   ntfs_file_compare_values
   ntfs_collate
   ntfs_ie_lookup
   ntfs_index_lookup
   ntfs_readdir
   iterate_dir
  Allocated by task 1:
   kmemdup_noprof
   ntfs_readdir
  The buggy address is located 0 bytes to the right of
  allocated 78-byte region

Two bytes of an image from mkntfs are enough: in an entry whose name has
six characters (key_length 78), change file_name_length from 6 to 7, so
the key claims 80 bytes. The entry itself is 96 bytes, so the existing
check lets it pass. The next readdir of the directory reads the extra
bytes.

Check the name against key_length, and check that the key is large
enough to hold file_name_length in the first place.

Fixes: 0a8ac0c1fa0b ("ntfs: update directory operations")
Cc: stable@vger.kernel.org # v7.1+
Signed-off-by: Wahid Khan <wahidzk0091@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/index.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/ntfs/index.c
+++ b/fs/ntfs/index.c
@@ -41,9 +41,11 @@ static int ntfs_index_entry_inconsistent
 
 	} else {
 		if (collation_rule == COLLATION_FILE_NAME) {
-			if ((offsetof(struct index_entry, key.file_name.file_name) +
-			     ie->key.file_name.file_name_length	* sizeof(__le16)) >
-					le16_to_cpu(ie->length)) {
+			if (le16_to_cpu(ie->key_length) <
+			    offsetof(struct file_name_attr, file_name) ||
+			    (offsetof(struct file_name_attr, file_name) +
+			     ie->key.file_name.file_name_length * sizeof(__le16)) >
+					le16_to_cpu(ie->key_length)) {
 				ntfs_error(vol->sb,
 					"File name overflow from index entry in inode %lld\n",
 					(long long)inum);


