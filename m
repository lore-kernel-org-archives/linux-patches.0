Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831537;
	b=D+EYbMuN82yvTa2cArmFzmDW1ma8agYHYT7yGMrl7uiOMjMP84fM6Q1W7I/ov2Xb9J7I
	 p4IPXoaaZIkmgIA6t355xoXRsfJtFTtVR5SINg+ma/XAasVvdyinLlbS19Qad5YFHeAqm
	 mmatkNJ9aqDLrEN4FUTR1H6DuJXn+2fYlMwsPsmkoGur0DmSV+FJU1YAbCy+G0TEiYdQL
	 LRxpw17Sfsk8s8pT9N/NZD+oHMtco4cAFONz74Uq2b+XM3JFkiyOlrmXtd7RQWNUnZ16Q
	 a1BmvSy4h53hYp54vXWLlrpmEj6JBZaCxnaC0RI246hdWsP3VG+nfmU4T8Ey+52qdUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831537;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X37FAHOKHmNgZeYBBRuYL3HDWSHMANMHep0xJe6pJXQ=;
	b=ZXaRVD8LfXvgHYSG8hVmeLJPAfOMplxlfO31jA8EpkgEvNbxuUnYGwIuo2X4t4gAGUEI
	 aikioMrcJ2tMuzo4qn1Y1qOsDBPT69LpoWgdIuZxtcZhlpj6tBhTuz1adShvScSEZgrEx
	 N2C7s+B9CqqrFMdeUpEikK5enjPGjn/qal0zKRfdo1sJmXSgZgXnxjWnkg6OvfeGHEv7i
	 MXtmvGsITconMXf2fquF6RjS/GKbE1gYzkoW7kFptG97yO9guBAD9PbVMfXg7HZGBAP0+
	 OkPG2FsVh5mG7HihLhPbm1RiMzEv842bcJ7/CbThTFkpRdUPuaFQnBC+Cc6loYigGSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L2yd2VZ8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32026606A332;
	Wed,  4 Nov 2026 22:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L2yd2VZ8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE63D1F000C1;
	Wed,  4 Nov 2026 22:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831537;
	bh=X37FAHOKHmNgZeYBBRuYL3HDWSHMANMHep0xJe6pJXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L2yd2VZ8lB8rYer1HsHOtxLFWV8ZkZ5OLDhgVSMA8KdpwrWvt0gSgC9v0h8YLftrs
	 h/8fd05ZLiRRCctl00GlO4S2efWcBfS+AdnRLU7tEZI3HocdT73ELEGk0iJ8LM8bft
	 vJlNl8jo0JbljOxQlY7QaMAww7RaEOmFOjJZyUyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.18 0765/1005] ovl: check the casefold flag of directories only
Date: Wed,  4 Nov 2026 16:08:18 -0500
Message-ID: <20261104211104.838751995@linuxfoundation.org>
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

commit 1d27da7de3f74405b1de85ad26c5ea90f826114b upstream.

On an overlay over casefolded (case-insensitive) directories, every
lookup of a file that is not a directory fails with EREMOTE, and the
first file create triggers a kernel warning. No privilege is needed: an
unprivileged user can cause both in a user namespace, with the layers on
a tmpfs that they have mounted with the casefold option.

Some filesystems support casefolding, which is case-insensitive name
lookup. It is enabled per directory, and the inode of a casefolded
directory has the S_CASEFOLD flag.

overlayfs accepts layers on a filesystem that supports casefolding as
long as casefolding is enabled on every directory of the layers, or on
none. The mount records which of the two applies in ofs->casefold.
ovl_lookup_single() compares the S_CASEFOLD flag of each file that it
finds against ofs->casefold and returns -EREMOTE on a mismatch.

Filesystems only set S_CASEFOLD on directories, so with casefolded
layers a regular file, a symlink or a special file never matches and its
lookup fails.

ovl_get_inode() does the same comparison in a WARN_ON_ONCE() for each
new overlay inode. A failed lookup never gets that far, so it is the
first file create that trips the warning.

Reproduced on an overlay over casefolded tmpfs or ext4 directories, with
stat() of a regular file, a symlink and a FIFO, and with a file create:
each stat() failed with EREMOTE. For an unprivileged user in a user
namespace, on tmpfs, stat() of a regular file failed in the same way,
and the file create triggered the warning.

Fix this by limiting both checks to directories.

Fixes: 16754d61dc69 ("ovl: Support mounting case-insensitive enabled layers")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/inode.c |    2 +-
 fs/overlayfs/namei.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -1280,7 +1280,7 @@ struct inode *ovl_get_inode(struct super
 	}
 	ovl_fill_inode(inode, realinode->i_mode, realinode->i_rdev);
 	ovl_inode_init(inode, oip, ino, fsid);
-	WARN_ON_ONCE(!!IS_CASEFOLDED(inode) != ofs->casefold);
+	WARN_ON_ONCE(is_dir && !!IS_CASEFOLDED(inode) != ofs->casefold);
 
 	if (upperdentry && ovl_is_impuredir(sb, upperdentry))
 		ovl_set_flag(OVL_IMPURE, inode);
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -260,7 +260,8 @@ static int ovl_lookup_single(struct dent
 		goto out_err;
 	}
 
-	if (ofs->casefold != ovl_dentry_casefolded(this)) {
+	/* Filesystems set the casefold flag only on directories */
+	if (d_is_dir(this) && ofs->casefold != ovl_dentry_casefolded(this)) {
 		warn = "child wrong casefold";
 		err = -EREMOTE;
 		goto out_warn;


