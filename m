Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059944;
	b=hkP+vFSB/6iFFKPbJuuY4hC19n03tF2Tv/a48uNwqcQexkB/ki6NZazSs1Itqm16LugD
	 Uhx+jppAWIgGwF6ziwhI9wK5h2PVBGFNdCdWkInlrbvqi2YwM76u4NKq62Z1A6HARZnml
	 pF7E2IzkAfsNAUK7pB5eoXJvxT/83QJDqKIT8C0nYsy2HaY/0XPO6g6mhLpUiaZA5kQze
	 c7Xn1oy4AXgZmeUhc0kqGprmG2QaFjNzuq+peYV1S4S1Imk5WNV+8PKYFXEQV2mpgTFkW
	 QyIdF2x2aIURSBoyRvjMv+/C/aVmlWnEkqYNCXM+zoBvH6Z7g0+8dXsw2gaRomMH9lA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059944;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TYD2A6NEe0XoIoYV08ye6vHAVPBF6kbTDITJ6Bi3XKY=;
	b=1Fp6JAh/9CW/a7kjHOgvxmXHXGAVcknPqIVlO6V1yV+uckxehUTq+4mEYkeTS6lO2cGF
	 MJXuSDuCT/MuNWQ/zuWEiUl1s21PdXSVLKFOiu7hxBzcHZsh0ltz7NaZbaBRYXCGsfLDh
	 7pRZGA+/lu092GZEDTGba1zXjVXh8PJ30gWqTP0tpA0Wso89qtQ8IjkckWsBEdoKS8ONd
	 YMXFWw4hUtXsh/QawTJ3r7ps7tXK9CEQCJ2cgW+0pXipBa1XkTsIT7jX9F/sADH1tZO+I
	 qBMlKLPcTg+h4REIdWbs3zDVsuDpZM3dblhGOyUq3I3iwnwDMOe/Kn9zeh595NYukfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XhfQNibP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D3B606A32C;
	Thu, 19 Nov 2026 03:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XhfQNibP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70A731F000C4;
	Thu, 19 Nov 2026 03:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059943;
	bh=TYD2A6NEe0XoIoYV08ye6vHAVPBF6kbTDITJ6Bi3XKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XhfQNibPPC08RGlFeMTLiPE3r6QUTVi42MCBb5Qf+M29q+zvPRTd7HL8R34p5sGd8
	 6tyZdvO4Gg4618qaDow0ztQVp8ya0Qt0uEb6K4Xd98cJXQQfWIxAH8krYrvks4RwXC
	 M0xFtuSc06/vjXTs2kyzuBXZRrgOukvA+U0EpQhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0981/1848] virtio_fs: read the vring size under virtio_fs_mutex in ->get_tree
Date: Wed, 18 Nov 2026 15:50:19 +0100
Message-ID: <20261118145957.987863454@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

[ Upstream commit e7ccc777a040343b80f95f4cc5c12ce1df3187f4 ]

The vring size was read after virtio_fs_find_instance() had dropped
virtio_fs_mutex, so a concurrent virtio_fs_remove() could free the
virtqueue first. The reference from the lookup keeps the virtio_fs
alive, but not its virtqueues.

Hold the mutex across the lookup and the read.

This issue was found by an in-house static analysis tool.

Fixes: a7f0d7aab0b4 ("virtiofs: split requests that exceed virtqueue size")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Co-developed-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
[ sashal: adjusted context for kref_get(&fs->refcount) instead of kobject_get(&fs->kobj) ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/virtio_fs.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 1f58c4adc2ae2..035eb73be78f1 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -257,26 +257,23 @@ static int virtio_fs_add_instance(struct virtio_fs *fs)
 	return 0;
 }
 
-/* Return the virtio_fs with a given tag, or NULL */
+/* Return the virtio_fs with a given tag, or NULL.
+ * Callers hold virtio_fs_mutex, which also keeps the virtqueues alive.
+ */
 static struct virtio_fs *virtio_fs_find_instance(const char *tag)
 {
 	struct virtio_fs *fs;
 
-	mutex_lock(&virtio_fs_mutex);
+	lockdep_assert_held(&virtio_fs_mutex);
 
 	list_for_each_entry(fs, &virtio_fs_instances, list) {
 		if (strcmp(fs->tag, tag) == 0) {
 			kref_get(&fs->refcount);
-			goto found;
+			return fs;
 		}
 	}
 
-	fs = NULL; /* not found */
-
-found:
-	mutex_unlock(&virtio_fs_mutex);
-
-	return fs;
+	return NULL; /* not found */
 }
 
 static void virtio_fs_free_devs(struct virtio_fs *fs)
@@ -1505,13 +1502,17 @@ static int virtio_fs_get_tree(struct fs_context *fsc)
 	 * in fc->iq->priv. Once fuse_conn is going away, it calls ->put()
 	 * to drop the reference to this object.
 	 */
+	mutex_lock(&virtio_fs_mutex);
 	fs = virtio_fs_find_instance(fsc->source);
+	if (fs)
+		virtqueue_size = virtqueue_get_vring_size(fs->vqs[VQ_REQUEST].vq);
+	mutex_unlock(&virtio_fs_mutex);
+
 	if (!fs) {
 		pr_info("virtio-fs: tag <%s> not found\n", fsc->source);
 		return -EINVAL;
 	}
 
-	virtqueue_size = virtqueue_get_vring_size(fs->vqs[VQ_REQUEST].vq);
 	if (WARN_ON(virtqueue_size <= FUSE_HEADER_OVERHEAD))
 		goto out_err;
 
-- 
2.53.0



