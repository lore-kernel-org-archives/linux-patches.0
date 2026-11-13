Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585371;
	b=cPX0qGGcuCct74nz2HxsJRhJe9YbqpDIqdJXsySk44CETjNvyoE3PQ2Fsr8i7j+HkmIh
	 SpvP4+wOMeTE28YW1wOsrLhqjrkTW2NRZizUZFwkFzj0ZkXedplk4QVeCOHeulg6KFLrG
	 90WAfY5++nc2ptIS4HE8CA1N5WbZ7v4nnx12HCSKkCHPj4XZxzrNRNjBWQAsREV4mAWkL
	 cB8JeLeccqcwgQgn+0iHw/pfADto3k53HT8kgUCMVazCcAxpt+kYiOw+waCcnrkJ8lCnY
	 k4zaT2aAwrM0kQpPEIkE5YoairS+XoSc8t/k6k7BqGtw0EK9mkSCl0ShxsFRQx+YPpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585371;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0mbvso7pwtT2whB7pWOWMFQzNNTsl+KL0tfluXP1jaQ=;
	b=e37lxH4itbVDaOSFoG/ShZ1joT9SyjQdbcW/zflJM7ZNkuO3G4xanMj7OCzsDIWDfIK9
	 ZzDQceeeO9l0bwz8BUD1gUqLj6S9PJ4OlgtFQSdMUUXE0Am3ak7/0I2FhV6gz+Hi+OL3C
	 P7HKoVNyRoW3yWDBNHdq0oHiwgleg6pH9G7M+XSf4s3Mj/jfH7GGAVzsbWIYMxP9RaslL
	 RQcKSStAPDK/8WM0i10/pZheCOOsKczC6wOa0SBY/8Xa1rffo46dUdavn46SYaqBnJfni
	 ReSE11YwR0HlcX9gS8g+bMhRsbix92wdk6Nd5dpt70hBJsCVr9WPUGCM0zO1KTEsFCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hp1ZKYzk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2FF606AE1F;
	Fri, 13 Nov 2026 15:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hp1ZKYzk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 798DC1F000CC;
	Fri, 13 Nov 2026 15:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585371;
	bh=0mbvso7pwtT2whB7pWOWMFQzNNTsl+KL0tfluXP1jaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hp1ZKYzkmYqsBr/h+jjlAyQ66cmvPv0raT/TL+l5K9LQL2cOJFC3d1mqhwx79v75g
	 eDl80x5+GU7mLtt0w3gLrUDfq/eket91SeQPdPirDtjoewOHBYrFycaCJ+G/vNycqp
	 ne7Tav6ABEHHMs+ZUwRyid7Rp6yYGS4P9LvV6fMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 047/507] 9p/trans_virtio: reject mount tags longer than NAME_MAX at probe
Date: Fri, 13 Nov 2026 10:45:51 -0500
Message-ID: <20261113153755.147102050@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

[ Upstream commit 5bfef2b6dafe83fe2d8d210d54093a8f48cfc97e ]

p9_virtio_probe() reads a 16-bit mount tag length (tag_len) from the
device config and kzalloc()s tag_len + 1 bytes for chan->tag with no
upper bound. A malicious or compromised host can present a tag of up to
65535 bytes; that tag is later copied into the single-page sysfs buffer
by p9_mount_tag_show() (memcpy(buf, chan->tag, tag_len + 1)), a
host-controlled out-of-bounds write of up to ~64 KiB past the PAGE_SIZE
attribute buffer.

Reject an overlong tag at probe time. A 9p mount tag is a name-like
identifier, so bound it by NAME_MAX (255): that limit is independent of
the sysfs/seq_file page size and is far above any legitimate mount tag,
which keeps p9_mount_tag_show() safe at the root without hard-coding a
seq_file implementation detail.

Fixes: 179a5bc4b8cb ("net/9p: use memcpy() instead of snprintf() in p9_mount_tag_show()")
Cc: stable@vger.kernel.org
Suggested-by: Christian Schoenebeck <linux_oss@crudebyte.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>
Message-ID: <20260627211012.4042372-1-michael.bommarito@gmail.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_virtio.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index b0d0094ec8e2c..9fa63e3ebf673 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -633,6 +633,11 @@ static int p9_virtio_probe(struct virtio_device *vdev)
 		err = -EINVAL;
 		goto out_free_vq;
 	}
+	if (tag_len > NAME_MAX) {
+		dev_err(&vdev->dev, "mount tag too long (%u bytes)\n", tag_len);
+		err = -EINVAL;
+		goto out_free_vq;
+	}
 	tag = kzalloc(tag_len + 1, GFP_KERNEL);
 	if (!tag) {
 		err = -ENOMEM;
-- 
2.53.0



