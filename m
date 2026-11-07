Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063993;
	b=3OyojroxTV9WdVRPkw3V8ZAVFifHJGzWogHDPkBRjYozy5LXNmAfR9qlZoPoLDQrK1O6
	 4eFzlrNdgwStlhI6BBC178WMC0AXecrEAt//VvgMKWACz1ybgPUbJeh7ICMUt5eX+6CSN
	 YOTjjO/YoznURKzGcZA/0XQu7/Dz7C+kIVWd4qjo5ScJvyMQWL2HJDx57hpHAbVTsWtOa
	 0BBXps4L+HM/TYvWhfwxTwaeVLWP4iJLqfZ/8xkeyv29KLojNXM0YfL0K0VFMjbb55YB/
	 Zhvs7LXVh6du5tXedZ1Nz99XATM7tWMDT8Biefb0f4c4Ch/uIWblYPp36eXJakqTJYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063993;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SZ+lpMZFb0PhBIMP9nCb7Secma83Z0y+ITEPEaPUhGI=;
	b=wVPeqkF4E8oEmchmZ1pbqy18eQe1jWjWWgvwMnxIJEa60sA+KgnwIaSafT3Bt1Q2039V
	 CuiCupGOG4ERjlZuBy8Oy0w8b2kKXS1DL+lsiqCpdScDFPDURThkbeTf6JVXEColUNbid
	 MTN9q6EZvooDR7WyGaCBh/5yrMVPAj/CCcgRpV7EU/ZPdFejIzuXh4iTk66iD5rRxVfaO
	 tjyxbU/6Nivl67DyfkJ+RFGVTMUZPwDdO6Vi0diLlVtd0+nC8G5dq0qCc1QpM7JP2PBFy
	 l3RzGwxBt8/avXnLhPFEW87T6zG4E9sZdoZdaf/WqJ8gM2KhNUTz3uI6b6otSRBzxXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UbLoo1zl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950B4606A332;
	Sat,  7 Nov 2026 15:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UbLoo1zl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 401A81F008A1;
	Sat,  7 Nov 2026 15:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063993;
	bh=SZ+lpMZFb0PhBIMP9nCb7Secma83Z0y+ITEPEaPUhGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UbLoo1zl04RLXrLCJbwYYZT9ykgVOrNAoamJNY4ZXOlzlDBsrnRBUKku/zCS5ES2o
	 HxkwbVY9G/OLvmHP+pyP8itoNme2CKblqCpTCED9BLGzNA3mMbqa4QrWQ3VHYbTMvN
	 ItAzbam07f/p4xOv0Z5sR6wQgNYU0lSbdRjo8Kr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4b4ec878e25fafefa70f@syzkaller.appspotmail.com,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0176/1257] ntfs3: reject empty iomap before reading its LCN
Date: Sat,  7 Nov 2026 08:41:12 -0500
Message-ID: <20261107134944.325037731@linuxfoundation.org>
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

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

[ Upstream commit 666af227b12fcc3f4ac9827d449ee0910f7bcf9f ]

attr_data_get_block() can return success with a zero run length when no
cached or on-disk mapping covers a read VCN. In that case it does not
initialize the LCN output.

Check the returned length before comparing the LCN against the special
mapping values. This preserves the existing -EINVAL result for an empty
mapping without passing an uninitialized LCN to the comparisons.

Fixes: ecbb433f9a8e ("fs/ntfs3: fold file size handling into ntfs_set_size()")
Reported-by: syzbot+4b4ec878e25fafefa70f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=4b4ec878e25fafefa70f
Cc: stable@vger.kernel.org
Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/inode.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 4ac26c80bd34f..fd844f9c556a8 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -981,6 +981,8 @@ static int ntfs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	if (err) {
 		return err;
 	}
+	if (!clen)
+		return -EINVAL;
 
 	if (lcn == EOF_LCN) {
 		/* request out of file. */
@@ -1016,11 +1018,6 @@ static int ntfs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 		return 0;
 	}
 
-	if (!clen) {
-		/* broken file? */
-		return -EINVAL;
-	}
-
 	iomap->bdev = inode->i_sb->s_bdev;
 	iomap->offset = offset;
 	iomap->length = ((loff_t)clen << cluster_bits) - off;
-- 
2.53.0



