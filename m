Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48833AEF3F;
	Sat, 17 Oct 2026 17:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258029; cv=none; b=B9Bc7489hXVf7Fzhay0Kj1b3MvCui0OhmUcdMKwkC6ZUcJ8G+2StL3ZHbWov4F2trX6ajbA2vYB1dZDqlQuqNLGoAkMnBjHqYOOrGaTL8c5mrrFzYAY3ZcJWn1N2jTGfOs+yMGjZ2G68fnD1aM9yQAZd0jnBK73c7ZbraTzsGbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258029; c=relaxed/simple;
	bh=OBWosmP99cH4jBU9+0Uehnod1rJEBCLWYldNLWYfPsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sqe7unju4vnSgl//V1E3V1ZGaDVDbB1XMAgCHxVHZ5lzqqdHYk+rLdicE+hZ4oQ4JVkxXbM/FtJ/peol0tuyGqwDUfZD7ZS5/MHg0h4J+ljhqtbkHsQygMiuRb1lz3m45Jj+RHngK5EoqQzLUuUyP3Wz0WsZq9uWJx0SRNaYc+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SCbY5X07; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SCbY5X07"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B9FA1F000C4;
	Sat, 17 Oct 2026 17:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258027;
	bh=ROVTgpZrJy8eg8Bo7YbFcw6rurXAGlvvB7vY8+zWHGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SCbY5X07vjaFMHGSJdbXmcDgN0t5lsuQZLFjotGFY6xu2fth0HPITEkk0JI4pOwht
	 oTxJBi/oDN3uKW+PfM5ZaRPwSmWZVlo7jGnwrwM40xQWfvGV6cyE9QnkHqfxdYSWNS
	 KnM47Qqt6lEh95KmwV3kSeTGMks0LCZ1GXE602Gg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ricardo B. Marliere" <ricardo@marliere.net>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0746/1674] virtio: make virtio_bus const
Date: Sat, 17 Oct 2026 17:50:18 +0200
Message-ID: <20261017160450.252068583@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo B. Marliere <ricardo@marliere.net>

[ Upstream commit 2b666ee29618f452b84aeacf08e1267894de7234 ]

Now that the driver core can properly handle constant struct bus_type,
move the virtio_bus variable to be a constant structure as well,
placing it into read-only memory which can not be modified at runtime.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ricardo B. Marliere <ricardo@marliere.net>
Message-Id: <20240204-bus_cleanup-virtio-v1-1-3bcb2212aaa0@marliere.net>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Jason Wang <jasowang@redhat.com>
Stable-dep-of: 8bd2fa086a04 ("virtio: break and reset virtio devices on device_shutdown()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index 71dee622b771b..70dba7235cb0f 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -340,7 +340,7 @@ static void virtio_dev_remove(struct device *_d)
 	of_node_put(dev->dev.of_node);
 }
 
-static struct bus_type virtio_bus = {
+static const struct bus_type virtio_bus = {
 	.name  = "virtio",
 	.match = virtio_dev_match,
 	.dev_groups = virtio_dev_groups,
-- 
2.53.0



