Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044667;
	b=MVJ9Dqs9Sdm6ptxKInrdrnzOQyxOUlK+SFfmW44RLyfIdClKEGQtjePY9ITiUHhpNCB0
	 ZQdCbz5MWDJ8CxUw4HrCymlnhNAN/kMQ4olxl1JhY7c2YoxCn/q7UdOJrdgaL9PuT/N3X
	 y0NRgOOPScxQ5p/JV8zYVP1WoDJPEmXrx7p4wDK9Y756i+EOZoZ5D93Y/Jv+AjR3HFDE0
	 Nm/r0hATdO3qGIXN2n9YexpYbC9RFa/SxawIvS2c4uKjLQaVWiKGFcPP7XEXcUHLzOvTK
	 w8QzH2Kya+OGxEf1Iud5rEtwvE3vIxe/LH1ECkqitUO7WqbQxj3cIoZurecjOx2ihOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044667;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hPKMbkQ3hJnPzUsGolFPHIxgaKItRt4+2C0x1LmIyA0=;
	b=wtdFrZ23rbSt84lBGI+AjdHITRQq3pztM9+8qSsJBleHL27jZ+/+TYUv3AP5cjFMYk5J
	 u04+JvKaRuvOHg7YTJlBmDVvMHDLU5jUX8WfPpxwqAt4hZG8fleEOYmVm31WqkAu05YI7
	 l1d+YBBt5D6ymhqxfkmlWCEC+E6n+pStluFoL/34/9muZB4mjPrYx86V982yffwj3z8ix
	 MbeYFiPAjT/sePNq70IDAhuuDosOWFoSFge5inj409s/RzrF+rbLCpwSV5DzM7YRSGiXA
	 /36tnDs8xqq9934UOknuw/7oR/vzKVSTpS6WDWU/9k33XYjHIJNCbBV9rs0be/kPOBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2YrJRKVw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7BBB606A32A;
	Wed, 18 Nov 2026 23:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2YrJRKVw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00FB51F000C4;
	Wed, 18 Nov 2026 23:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044667;
	bh=hPKMbkQ3hJnPzUsGolFPHIxgaKItRt4+2C0x1LmIyA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2YrJRKVwtjrphKXO5SQW8BWtxT63PpfJ0XBivdgo3qY9qrm4ljkWt8yC/hs8sWhVl
	 hJY3h8L6PG7civlABSK5Dhk2RH7DXXjwzsiyYMOFJmQExW8yugD8Hvn4SyNDrRIdVH
	 4uTZ4ru9bgcLzl6x7MwseHkyzd6F+AN00sAfO0zY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.1 0649/2857] ovl: set OVL_WHITEOUTS before publishing the upper dir
Date: Wed, 18 Nov 2026 15:28:03 +0100
Message-ID: <20261118150224.918698018@linuxfoundation.org>
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
[ backport: context: the store is followed by the unlock: label, and the
  replaced line calls ovl_dir_is_real(file->f_path.dentry) ]

 fs/overlayfs/copy_up.c |    2 +-
 fs/overlayfs/readdir.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -721,9 +721,9 @@ static int ovl_copy_up_workdir(struct ov
 	if (!c->metacopy)
 		ovl_set_upperdata(d_inode(c->dentry));
 	inode = d_inode(c->dentry);
-	ovl_inode_update(inode, temp);
 	if (S_ISDIR(inode->i_mode))
 		ovl_set_flag(OVL_WHITEOUTS, inode);
+	ovl_inode_update(inode, temp);
 unlock:
 	unlock_rename(c->workdir, c->destdir);
 
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -942,7 +942,8 @@ static int ovl_dir_open(struct inode *in
 		return PTR_ERR(realfile);
 	}
 	od->realfile = realfile;
-	od->is_real = ovl_dir_is_real(file->f_path.dentry);
+	od->is_real = !OVL_TYPE_MERGE(type) &&
+		      !ovl_test_flag(OVL_WHITEOUTS, inode);
 	od->is_upper = OVL_TYPE_UPPER(type);
 	file->private_data = od;
 


