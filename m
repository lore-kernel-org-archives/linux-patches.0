Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065017;
	b=MJp9Nn70KjJaaHe16dRdjkGVqAwscqH5puMJPJ/Rg0Q88U+42j8al/q3e0XpkDWbJb7T
	 x/tUruWVI4LmpY7yo79Bd6I7V8XFfyBEOFr6ABycxZw6E14T5zoZilH7qLiU5q67Z7yzu
	 nsbLDbcjMXQ49wjsLQ+9+4oCLIXal7ozFQ7gD1djASsPDlIUb3bHfLwavgm2mn8kFMzoV
	 NDrPN2oZND7WpArPfRP7QEgtib4lM0ZSHtoP0DNS+KDLhIpE64Bvo6mW50PKKEQWvbZ+y
	 t5nofA+m3Bc13sQZGxE1pBPebdsjaxphnPwg8l8T241YLT4cmzLYY+DlK6o8HX7svVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065017;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sXOUWcOQEX0eQLknkocjfnnWKbLGsH5eBo2eZqjJUUU=;
	b=kzeKKHM9a6hdOp27Cx1ORuT8Edz4g991o2r23Mj5xCsZB124we7JbCXc0ZW+XWdx7dQj
	 GStefFj1Ic0Xr5CAi9igCOKuY5IKHKC20q+5qYyhzKjN+o/YZ2IZbQq2JQE9V16tH07TG
	 mBJAn/lUk9eZRiYK5AN2i8ZVv7+STFZh4+vQw7o2CLJazHaFnEn001PWfJmGYko5LMmBj
	 JuaR+V6/mGHdVLRzyuPnxOEzVMLZsoSFWhII9D8Wvw8/3LIQwBW4xPQOMB2H3cfdzqaix
	 rBDhS4pFUL4T2GE+QHzrvp79jo9CO0Q7mpwn4553HwwC8naYGWEr8EBvln0yzsFzfVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ghxCQbJP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07C1606A9C6;
	Sat,  7 Nov 2026 15:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ghxCQbJP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12CAD1F0089F;
	Sat,  7 Nov 2026 15:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065016;
	bh=sXOUWcOQEX0eQLknkocjfnnWKbLGsH5eBo2eZqjJUUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ghxCQbJP1beDDVsg+Hu8W8SHlCbrmehurMEs+i4Ml0OOyPTgq1K/7/OjgY8oROqn8
	 Vj/eeXmEB5wF2q9skQhU6Ew645+i0zITjrFDcbQSjr84yUZEJvUHwbLz5RMTeeNXsk
	 vUXUbZ+AFdzDzPsYi2j44QFebfdidjfK7DIIsg9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0838/1257] virtio_fs: read the vring size under virtio_fs_mutex in ->get_tree
Date: Sat,  7 Nov 2026 08:52:14 -0500
Message-ID: <20261107135002.474002928@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/virtio_fs.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index f15e516ebcb5c..8519dfa09ccf6 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -455,26 +455,23 @@ static int virtio_fs_add_instance(struct virtio_device *vdev,
 	return ret;
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
 			kobject_get(&fs->kobj);
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
@@ -1698,13 +1695,17 @@ static int virtio_fs_get_tree(struct fs_context *fsc)
 	 * in chan->iq->priv. Once fuse_conn is going away, it calls ->put()
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



