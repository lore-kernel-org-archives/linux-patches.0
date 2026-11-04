Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831596;
	b=F15D8JvinbkDcXmbjKxdzylrfQDVzjoJJH8M5L4IG4rZzn4I7q6iy1NNbhbkl7wm9iZE
	 W9WlpMBMOXBG3VDSI/Go07geQNcIowYedXzD4GlKMhlbnY/EPaLhyJ0941XQMaQiTgt7B
	 u/4dB4l7mWjfLiQ355CanmOrOVGD+OhtZeE9B8ZvBMeBnWGHKjwf+azJYATOz1JHkRAm4
	 sIitxi6hAxy6Da4U8GcpuolbA+bsmKhAV5T8K4r98LVi23HPthientjZl4DntgAQIHkJZ
	 brSf1r8NqnV/gxVseOljDB8LJK5V7et4kwBDjk61dV2KT0bJPmGJNbBVhdX+CgaWZYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831596;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9noTO+W2t43pvJN3rZOgCx7z2pEX7120mTXYJ6eWsiw=;
	b=lOn7Ul8dZrSkHG4Z3a6yXausJ/9mwHVa0Hq5I18EbkjG1WJIc8R7lDsXMM4sQ2yBDZHY
	 Alfvt5Jho6AHswgIButLuCDDa6Ejc6G9toHtqd3n+eCEGfVwuusdbB7qxuykEmBdIVEvZ
	 mcT4v86d3M06ESVzFubrvhIb43hmNnXjSGpPCel4yu646NjrrL3o52RaC4TEdB40RzUKe
	 5mFGY5+IDhmN8hXtRvFrYaow3mQZNy+0BIhfY1NkPU+uEVSUaHv832oqBTK11xg36YS4/
	 BRl987AKIVayaHzBVPDg4CLv9HJeS4kTQih4EI+H0QifDgBgEgWZSzllsKyyi23+P4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yFf+46O2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC2B606A844;
	Wed,  4 Nov 2026 22:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yFf+46O2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC9741F00A15;
	Wed,  4 Nov 2026 22:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831596;
	bh=9noTO+W2t43pvJN3rZOgCx7z2pEX7120mTXYJ6eWsiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yFf+46O2uDADozEovJC99DbJzVc5Kmb47NHjq/iX9uNkoeo6CZPObZCUgbMMp1YUr
	 UjrxJhMvLDcO2o+c9Yc1RR6nem7UsFcGkMdADrTpL9FAgMZ2mlPQG4wnlhmJYr2hCk
	 IJqXolSh7Ng01F/jIzk1m+NTpdDn4xBft0HUrtoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.18 0761/1005] ovl: set OVL_WHITEOUTS before publishing the upper dir
Date: Wed,  4 Nov 2026 16:08:14 -0500
Message-ID: <20261104211104.742317495@linuxfoundation.org>
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

From: Chris Mason <mason@kernel.org>

commit cbec8610ec5aaf35df50094ff639febc23f20773 upstream.

Listing a directory while it is copied up causes a use-after-free of
the readdir cache.

A merge directory must never be iterated as a real upper directory:
that mode frees the cache in OVL_I(inode)->cache without looking at
its refcount, while files opened in merged mode still use it.
ovl_copy_up_workdir() publishes the upper dentry before it sets
OVL_WHITEOUTS, and ovl_dir_open() samples both without a lock, so an
open between the two stores finds the upper directory and takes it
for a real one.

With a delay between the two stores, an unprivileged process that
listed a directory during its copy-up saw only "." and "..", and its
next getdents freed the readdir cache of another descriptor.

Fix this by setting OVL_WHITEOUTS before ovl_inode_update(), so that
ovl_dir_reset() agrees with ovl_dir_open(), and by testing
OVL_TYPE_MERGE() of the path type in ovl_dir_open(), so that an open
that observes the upper dentry never iterates a merge dir as a real
dir, regardless of the order in which it observes the flag.

Fixes: b79e05aaa166 ("ovl: no direct iteration for dir with origin xattr")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[amir: test OVL_TYPE_MERGE() instead of smp_rmb() in ovl_dir_open()]
Link: https://lore.kernel.org/linux-unionfs/CAOQ4uxh-1J2OBjnDVbrrrjy1puSOW0kABvghN85ih6dtKUBTyA@mail.gmail.com/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/copy_up.c |    2 +-
 fs/overlayfs/readdir.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -843,9 +843,9 @@ static int ovl_copy_up_workdir(struct ov
 
 	if (!c->metacopy)
 		ovl_set_upperdata(inode);
-	ovl_inode_update(inode, temp);
 	if (S_ISDIR(inode->i_mode))
 		ovl_set_flag(OVL_WHITEOUTS, inode);
+	ovl_inode_update(inode, temp);
 out:
 	ovl_end_write(c->dentry);
 
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -1053,7 +1053,8 @@ static int ovl_dir_open(struct inode *in
 		return PTR_ERR(realfile);
 	}
 	od->realfile = realfile;
-	od->is_real = ovl_dir_is_real(inode);
+	od->is_real = !OVL_TYPE_MERGE(type) &&
+		      !ovl_test_flag(OVL_WHITEOUTS, inode);
 	od->is_upper = OVL_TYPE_UPPER(type);
 	file->private_data = od;
 


