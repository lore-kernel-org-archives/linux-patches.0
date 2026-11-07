Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063583;
	b=Gi8g4xHb1E5yA+pO4dVJVFu+WKQgZi5oYPNnV/1d0JUNs1l+SxuCvHleeMOigVtrRp6T
	 RR3BJaTwjX1UMSm9afEBqEP8Ys0hwp4vsP63JtOWkpvzEMQUjLn9YsZSBMSKCWnX6CtEk
	 3k2zFH1u28MCOpFAwrJWPg4xlc8wBn+equRmo6ym+V+mRRVnaywv2GXd1I7m7DMbrtDgK
	 12TJnn2+hV3UMb7GZ6DWCl1eIbThMzOGRThRievDq6b68i03/VB85lfzl/rxp3fTIi2tt
	 t3YH2xpaFFSw5oifZTqUc7fuPP04COuTbKsODVuqaYLYKJILPceI/ZQUC1gZA/AeNmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063583;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FbLZZ26jz9Dm7lKYyt9hIFbkmDcuYbiTChefv3oE1i0=;
	b=kNC444h93s2MR/wVxM6uJccfSUXBNk13EOazU/hFsXxsoTl1dQHZrCzVeUdwxU6Xm8af
	 AQQeFZzF07fKepSoxqKI+8sAvAT8QVRTHmTRHGR4Ne9pqRs1nZZmMUEOno4w6OuIWi75o
	 YQI19rOhCoPwal3jtO+5CjRpUJxCc2WQ85kVsspYnNz/Zskpy31as5Zombg1jk0x6KJfr
	 rhcIyb20X/zIPpmqQ08T+4pJdB58HUDyejwxO0UunQTiahGv5T2hCQZT/gOeE9bHBoxIQ
	 LzJZtL/G6Y/yNIRemgQo6BiqAmCufaMKho+pv2LxNDU9ZHgVd8BLAhODbl+RGxPLe+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HeQJv33D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450E560A263F;
	Sat,  7 Nov 2026 14:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HeQJv33D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1CB81F008A7;
	Sat,  7 Nov 2026 14:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063582;
	bh=FbLZZ26jz9Dm7lKYyt9hIFbkmDcuYbiTChefv3oE1i0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HeQJv33DiSt9XGQyoL4wNXUKHfsxCjPzfbJb+xxCrz6wQSPO8Rb7UjDfMA5nVN3+Q
	 Pv+LOoSB9PQNmCQCT/FtZ9rF7ocP7Fk7rJKc0YBK4fhWUWYCkSYXcsx+ySEuN4LGYw
	 tecNCI4lgLBJHAOG4kY+3rR0VGvmCPHPfkHn0ixI=
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
Subject: [PATCH 6.18 710/869] exportfs: Release the get_name() directory file synchronously
Date: Sat,  7 Nov 2026 08:56:32 -0500
Message-ID: <20261107134916.964916230@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index d3e55de4a2a2a..ab470783e798d 100644
--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -336,7 +336,11 @@ static int get_name(const struct path *path, char *name, struct dentry *child)
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



