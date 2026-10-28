Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213368;
	b=TXLu8E5ahWDo9V6Qu6OhT9Ml8fgWJNgalb6J4h6/YUS2MYz+4A3iCML4aeCJkTPuoEN9
	 95onyqTKavg27hhxBSZHlfRwNI3xYrjXKeS5lNSX/3BUpCmhHUpbqqbDiX5OCgrtcUZkB
	 CT26mzC6V776lCnEXS2/6C1sUuuPqwhrHNE1/CzHLFfKqCfyvGkdgNgt6S/lEAKa0fmRi
	 3v9wODqHrFbFjP9MJ4vQwUUSgGGC1oH9I1Igpt/dQHnbZ3atiB0DL7MqCLceZbntKv3Jd
	 I1Eu/SqzwXSVCzz4wSMN/K260rnkG2a2McjJVo/4AZuVrv3J4C6GPrUGCbsDqXdWPQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213368;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0lACXP2kMeERNArm+gXhWiPaeSxBkfqkTSWDuBj9T1Y=;
	b=MHiKPGLX17jcXrMBxYTOOAgEBLzFa745GgP5BDuI7qOEFoecxVq0N4QvTUb7gCkei3+K
	 gzd6wVD9A5I+pE4QgOTYyB42MKp4EuVQEHXOuGZXuf5iqzmzWYPhyOc0lyXDczr0T7eJa
	 ThivmGzVZGBlJaen5SVvF6S14SqROM1qUVqMWCtPiKlHoQ7A0pASk9/VNENdLi9Y1Kv1u
	 F0RhElohc+oTdVMiJC+7CjeHaeYVx3cr0ctOeUyNXe7HPMS71hgftwl/liQRwph7GmnRH
	 2rGdYz6KIwhvAHxyEzp4k4qLUjeFA/j+nvEWCMC6JeHUsL/L685UD1lLvfI0XOGIkeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zE7zAvFy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E96606A31A;
	Wed, 28 Oct 2026 18:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zE7zAvFy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E31B1F01825;
	Wed, 28 Oct 2026 18:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213368;
	bh=0lACXP2kMeERNArm+gXhWiPaeSxBkfqkTSWDuBj9T1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zE7zAvFyQL7fBTX2bq6fjsyydANhnv/BQsZ4Y5MifvQnb7PrAX8UK8+dfN2eB3RxG
	 jKewUyJJYyrtCfMNeG/YypZB0uL3V4N+UfKmkhtNgI+dFv5d3X+vvsZfvex0ATS9Qh
	 HgqWqigzyB57s+Femi/4BN6hNWWprC/HZaZ0FAlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.1 0479/1887] fs: refuse fspick() on internal superblocks
Date: Wed, 28 Oct 2026 17:42:55 +0100
Message-ID: <20261028170510.152612752@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

commit 02587a4af82adccaef8e3b3624b4e7f1c401632d upstream.

There's a few instances where a internal superblock is reachable by
fspick(). Block that. graft_tree() and fsmount() already refuse them.
fanotify refuses mount and superblock marks on them for the same reason.

Fixes: cf3cba4a429b ("vfs: syscall: Add fspick() to select a superblock for reconfiguration")
Cc: stable@vger.kernel.org # v5.2+
Link: https://patch.msgid.link/20260926-work-mount-fixes-2-v1-6-f357abf3d17b@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fsopen.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/fsopen.c
+++ b/fs/fsopen.c
@@ -191,6 +191,9 @@ SYSCALL_DEFINE3(fspick, int, dfd, const
 	ret = -EINVAL;
 	if (target.mnt->mnt_root != target.dentry)
 		goto err_path;
+	/* kernel-internal superblocks are nobody's to reconfigure */
+	if (target.dentry->d_sb->s_flags & SB_NOUSER)
+		goto err_path;
 
 	fc = fs_context_for_reconfigure(target.dentry, 0, 0);
 	if (IS_ERR(fc)) {


