Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044679;
	b=mfzphVLnqzFT1AEemIgpy0aCNoqCTz8pVeAtAjsvE3+jsGFJPUc4/wPO3lejjru0fFGT
	 iU5dsOSqBO7l55HAo+mMu4T9Edi5iuhfylUdHjBo/VtDvNOd7FF8runsbpfwFpc/G9a1f
	 z37Yk0K4H/06Q130ZVG47PxLc+jCAylY4W1Mj52Yz+E+SkOOgpDwzgyVtXn6+q+bgd/vf
	 7Ubz6WIQVDOLslfGhq/btZFqoMk/yb153T5XgsuFSDegzOinTN/l+kaAA439hyx+mQrLs
	 gqRTbKm4Z6dzOjN2Jl7ZDJLq7Uo5ikUssBT8pDWoYEVLfG4deNjpfcSnL8NmbfuZLMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044679;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BQyjhrr8ITn7Yn+nDuCmIrD5/U3B/uB2tlqYcKNUM9w=;
	b=FAWrlH47ijvWu4URa0iRCWnmY+z+9Br0E2hIFhYYKtJG486A/TUfDQprS2P2T7LYVQPL
	 hoF1blR3F2N+S88eaCOuwVRbkrCtCik/LoBsbN2vEXdcXRmJ4uH0RFkQT83jA/8SXKwpp
	 kG6dOuwjiH4xfEZQ9Oyfs8TjUePiLcJGrKwNkEqZAesQ/NANHvUuEBpj+yIViOI3LGiD0
	 qa1VQb86lGOz+L4mNJcZgfg8gSgO3QZJNqHzunua0k1po9as1loQcxLPudEPhKtBeN0MX
	 wCz4TbW037/bNpfY8MIL8bwi5lOFR26whhOZFY81MglaO1xw3RUmbuWFMrvP/fakEYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JTC6bOw3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA83606A31C;
	Wed, 18 Nov 2026 23:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JTC6bOw3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA9E1F000C4;
	Wed, 18 Nov 2026 23:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044678;
	bh=BQyjhrr8ITn7Yn+nDuCmIrD5/U3B/uB2tlqYcKNUM9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JTC6bOw34L6CK6rq1e/+KeFEY+iIw4PoCA9SjTwqQ5k3V+OXJOLHZHJEU8wCn5Sou
	 /fvynv00LIpGLoLn6EjpVFDdjmpP5pPewCmTZyfSfNjla2hILPuJzyaDp7DSOz8mCb
	 m4Zck45LPuxRqDCsM/AvKxPppfz4/y5+7jOlS6SU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.1 0652/2857] ovl: set the revalidate flags after d_instantiate()
Date: Wed, 18 Nov 2026 15:28:06 +0100
Message-ID: <20261118150225.036860708@linuxfoundation.org>
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

commit 75e89c0055c1d7f7eeb462995f11253ca5864f79 upstream.

stat() of a file on an overlayfs mount triggers a kernel warning and
fails with ECHILD if another task is creating that file at the same
time. This happens on an overlay with a FUSE upper layer, which is the
layer where overlayfs creates new files. Write access to a directory on
such an overlay is all a user needs to run the two tasks.

The revalidate flags are DCACHE_OP_REVALIDATE and
DCACHE_OP_WEAK_REVALIDATE. They tell path walk to call ->d_revalidate()
or ->d_weak_revalidate() on a dentry, so that the filesystem can check
that the cached dentry is still valid. An overlay dentry only has one of
these flags if a dentry in one of its layers has it. FUSE dentries have
the first one.

When a flag is set on an overlay dentry, path walk calls
ovl_dentry_revalidate_common(). That function only expects a dentry
without an inode in RCU walk, while the dentry is being destroyed. For
such a dentry outside of RCU walk, it hits a WARN_ON() and
returns -ECHILD. So a negative overlay dentry must never have the flags
set.

ovl_instantiate() breaks this rule. When a task creates a file, the
overlay dentry for the new name is hashed but still negative.
ovl_instantiate() then works in this order:

- It copies the flags from the new upper dentry to the overlay dentry.
- It calls ovl_get_inode(), which can sleep in a getxattr request to the
  FUSE server.
- Only then does it call d_instantiate().

A second task that looks up the name between the first step and the last
finds a negative dentry with the flags set and revalidates it.

Reproduced with a FUSE server that delays its getxattr reply: stat() of
a name that was being created hit the WARN_ON() and failed with ECHILD.

Fix this by setting the flags after d_instantiate().

Fixes: bccece1ead36 ("ovl: allow remote upper")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
[backport: no tmpfile case and a 2-arg ovl_dentry_init_reval(); no WARN_ON,
 but a negative dentry still fails with -ECHILD]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/dir.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -269,7 +269,6 @@ static int ovl_instantiate(struct dentry
 
 	ovl_dir_modified(dentry->d_parent, false);
 	ovl_dentry_set_upper_alias(dentry);
-	ovl_dentry_init_reval(dentry, newdentry);
 
 	if (!hardlink) {
 		/*
@@ -296,6 +295,12 @@ static int ovl_instantiate(struct dentry
 	}
 
 	d_instantiate(dentry, inode);
+	/*
+	 * The dentry is hashed and a path walk can find it at any time.  Set
+	 * the revalidate flags only now, because ovl_dentry_revalidate_common()
+	 * does not expect them on a negative dentry.
+	 */
+	ovl_dentry_init_reval(dentry, ovl_dentry_upper(dentry));
 	if (inode != oip.newinode) {
 		pr_warn_ratelimited("newly created inode found in cache (%pd2)\n",
 				    dentry);


