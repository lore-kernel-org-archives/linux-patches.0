Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036977;
	b=DXSP19xC0g8ZC9kLZFtoaA4xxCIHAiFZ4jS0GWDY9XYwi00sk2VIGEuG27EMjdaQaNZn
	 N2//WS+ZZiTNzJSr/jHQaf/VVc5Ekkh4NEeO9XZK99Jeuo7GuYxQtzp87v5Z6ncM16glM
	 yNrRmhQsOqwBZviy5c2czwzg119wnf88iG+0DM5Z1hm3RkddBxy2+Y3d1GMAMWAObepeR
	 I8FJruJxetZpm1ao0XPRnXqLtxHzTP8pdGiI/rFbrVB1g+f1zkc9Y4YFIYSDlz6vmMfv/
	 IiKsvKB1xW+bgJSvpFR4L1DeBf5OtPVZrp0mAjhbGlI201Me892A3uqpnfy7WVRzxJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036977;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KwNDVSc1alP+a6+unCzzKFLwKJbF2cZGZU9gHmF4yIs=;
	b=5J4/xgwpt0PeQVnvOyi41hgFB2h/friOYkBI+XnCjY7BUrb7QokHuroqd/28/Ol8buzc
	 8aRRRwdUbBpl05oU5oJ2ISkQm7IhmMzAwP8GiZe6iLoVTv1dfbgfOtgXrVOs2VfOq0kov
	 43hwDX8S9F3tDy7cjJ7H/cUq/m1VUuHqFj2w1XSWCOYEWSqYcrxUCtKHVH2lhUQpnLzGN
	 JvFWwCo12rocjP6blaBUILkpJcur+SALI+yL1CEgLUNALH+vKkLC7Z1QkHQyfcRLXWoia
	 2A1LN9bVKdGLZJ2/dKuX2DOHxfvmZu/qZb5iavCHgJ3vacyJN/KLLmldDrGL+Kl6IlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YVSZO9Gk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502D2606A32C;
	Wed, 18 Nov 2026 21:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YVSZO9Gk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A47701F000C4;
	Wed, 18 Nov 2026 21:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036977;
	bh=KwNDVSc1alP+a6+unCzzKFLwKJbF2cZGZU9gHmF4yIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YVSZO9GkbWF/bXoaTHbNd5S3stitphPfGQoZAiUg7IdsO7nn7LjkhJFGo5nS3wINy
	 5IAxETtMhLMjOx2tUNoPvoaiy37eJD59SX+zcraztETcYFz/msif09+//oInMMqpx9
	 iAvAkfdUog6MCV3TWU7tY7gB1RWl9MORpo5ynl1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danny Pidutti <danny_pidutti@hotmail.com>,
	Danny Pidutti <danny@lightningiq.io>,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Chuck Lever <cel@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1197/3318] exportfs: Release the get_name() directory file synchronously
Date: Wed, 18 Nov 2026 15:30:19 +0100
Message-ID: <20261118150356.083198871@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <cel@kernel.org>

[ Upstream commit 49184daab01674ca400cbef58ee101dba6dbbb9d ]

get_name() opens the parent directory with dentry_open() and
releases it with fput(). From a kernel thread, fput() defers the
final __fput() to the delayed_fput work item. NFSD threads are
kernel threads, and NFSD reaches get_name() through
exportfs_decode_fh() whenever a file handle's dentry is not
connected to the root.

On a filesystem with more directories than the dcache retains,
nearly every READDIRPLUS needs a reconnect. The deferred releases
arrive faster than the work item retires them, and each pending
file pins the directory's readdir state. On ext4 that state is the
htree fname cache for the last leaf block read. A 64-thread NFSv3
server under a parallel tree walk showed unreclaimable slab growing
by about 90 MB per second, and the same workload on a 5.15 kernel
ended in a global OOM.

Commit 5ff318f645eb ("nfsd: use __fput_sync() to avoid delayed
closing of files.") stopped NFSD's own closes from feeding the
delayed_fput queue but did not cover the exportfs reconnect path.

Release the file with __fput_sync(). get_name() opened the file
itself, read-only, on a directory, so __fput() involves nothing
that could wait on the caller.

Note for LTS backports: Kernels before v6.6 need the __fput_sync()
call guarded by current->flags & PF_KTHREAD, with a plain fput()
otherwise.

Fixes: 4a9d4b024a31 ("switch fput to task_work_add")
Cc: stable@vger.kernel.org # see above, needs adjustments for < v6.2
Reported-by: Danny Pidutti <danny_pidutti@hotmail.com>
Closes: https://lore.kernel.org/linux-fsdevel/DS4PR04MB9846BA3C16BC5ACED8B589228D952@DS4PR04MB9846.namprd04.prod.outlook.com/
Tested-by: Danny Pidutti <danny@lightningiq.io>
Reviewed-by: Benjamin Coddington <bcodding@hammerspace.com>
Signed-off-by: Chuck Lever <cel@kernel.org>
Link: https://patch.msgid.link/20261008140903.2784-1-cel@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exportfs/expfs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
index c20704aa21b3d..7bfce59722153 100644
--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -337,7 +337,11 @@ static int get_name(const struct path *path, char *name, struct dentry *child)
 	}
 
 out_close:
-	fput(file);
+	/*
+	 * @file is the read-only directory opened above, so __fput()
+	 * cannot block on anything the caller holds.
+	 */
+	__fput_sync(file);
 out:
 	return error;
 }
-- 
2.53.0



