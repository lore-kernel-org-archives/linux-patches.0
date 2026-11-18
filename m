Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028486;
	b=RXchhuLJ2/RY/1gl5PJ0HQ5xN2TNztL4K8JBJq34oW8HJDaGjcF2a3G+3IbiK+Q/PVRj
	 cGhmRocb8vHZLyG/kcVLEOE6VGEQhy4KLpFSIU4a9gfK0Y+LewSEKbYrl0yLp/1BHHjfp
	 81EY89x7sBL4YO5Zo25SQuQtcbDYjxaEWee5ST5IJw1gTOayu88SFld5TmwM3YgzuBm9O
	 ERSE19FrhIUJ/RcQ5TKV+ApFTV6emNcrGJeZ40AiJdMb0S/mDKZuTIS9hXVV0YnBqmsPQ
	 OmhU2+tJaIx9Tvbrvk4K5cXtAnPbNbq2jcxraQs7JBhIeylMI4E4+GTB5Ik5bJg+XKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028486;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KaEndS6jtuCF/811B/DVOI5L792zlkh2tEwCVAMSm2A=;
	b=OHtZHU6jCnWc7vaN+wHlgM9RHGyaHKBxHPd7rjjjcU3yAp0LjbPaQNoApTFxMwsHGpvR
	 G7wJ7k9Uhn8C1jteJdVsJ03qDskrTa8ABEKxAUJY22GUwyOVuLQD6UzRVB3zHznE7psxl
	 AOsQRha8PWRov+DUW5rH7i6EXgLPw/qjhSozjM07Xrjb2mngxm6NUtWz0WIQtyQQrH5b+
	 qIglpZ0b5M6NeHF8WsWCL5cR76bVdAwxf+L6QfQ3hb8c6j97CzxnCUaNjvwnty2veS8hs
	 Kk6Q23rwPC8vETLHJF0naXY4DnSz3s7QZ0qYht03rz4xN8nwboxWNpXtHoejHj/4a8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CGd9PBsS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675E3606A32A;
	Wed, 18 Nov 2026 19:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CGd9PBsS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B8A21F000C5;
	Wed, 18 Nov 2026 19:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028486;
	bh=KaEndS6jtuCF/811B/DVOI5L792zlkh2tEwCVAMSm2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CGd9PBsSe9o+vfk8VvopcP0X10BdreqYifywb1+9ydqOOA4UHtX95xu5YOaA3Kmkc
	 Ltp9dHrfoaT9+FBGHwU6ofcUu9xddHsayd6+5UEtPN8+lxrJwuoTxylbtQBtIafAZb
	 uOJ4aHtCbAzp9uvDX6w7oRFj1H+HOeDxGnsmnVbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	guolingxing <guolingxing@tju.edu.cn>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0013/1756] btrfs: prevent deleting the wrong subvolume by ID
Date: Wed, 18 Nov 2026 15:35:40 +0100
Message-ID: <20261118150008.482526029@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: guolingxing <guolingxing@tju.edu.cn>

[ Upstream commit 1960146913b31b288ed2cd607d103ee3b41681d4 ]

When deleting a subvolume by ID, btrfs_ioctl_snap_destroy() first
resolves the requested ID to a name, then looks up that name again
under the parent directory lock.

A concurrent rename can change which subvolume is associated with
the name between these operations. Since the deletion path does not
verify the ID of the resolved subvolume, it can delete a different
subvolume while leaving the requested one intact.

This was reproduced by repeatedly exchanging the names of two
subvolumes using renameat2(RENAME_EXCHANGE) while deleting one of
them by ID. The wrong subvolume was deleted in 9 out of 14 independent
tests.

Fix this by checking that the resolved subvolume ID matches the
requested ID while holding the parent directory lock. Return -EAGAIN
on a mismatch so that userspace can retry the operation instead of
being told that the requested subvolume does not exist.

Fixes: 949964c92843 ("btrfs: add new BTRFS_IOC_SNAP_DESTROY_V2 ioctl")
CC: stable@vger.kernel.org
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: guolingxing <guolingxing@tju.edu.cn>
Signed-off-by: David Sterba <dsterba@suse.com>
[ sashal: Changed goto out_end_removing to goto out_dput to use the existing cleanup path. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ioctl.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 3c3c767c858f6..aa49622cd302a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2536,6 +2536,17 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 
 	inode = d_inode(dentry);
 	dest = BTRFS_I(inode)->root;
+
+	/*
+	 * A concurrent rename may have changed which subvolume the name
+	 * refers to. Verify that the resolved ID still matches the requested ID.
+	 */
+	if (destroy_v2 && (vol_args2->flags & BTRFS_SUBVOL_SPEC_BY_ID) &&
+	    btrfs_root_id(dest) != vol_args2->subvolid) {
+		ret = -EAGAIN;
+		goto out_dput;
+	}
+
 	if (!capable(CAP_SYS_ADMIN)) {
 		/*
 		 * Regular user.  Only allow this with a special mount
-- 
2.53.0



