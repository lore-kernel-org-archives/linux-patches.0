Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037447;
	b=pUx2206d3uvswfJfu9HRhhJNYlxb70yI/NnzCIqsU+tZ4p3SuI7fZZFZyXeCo2xtXuGo
	 eRwl5cTahHG3dG1wk9OqMA8J5ih54250NA6DNPe/ZtjKzlVrgabE15izSw2l/mARIxiom
	 uWia25enpDQ81SVLXdG6rkrYIB2pTRcfuhilYilW6c8gJON5G2qgc6OxuK7QRYPBGMCBp
	 Mhr2iIAVzWFb03kwwhX4LColxinZkBNDsL01FbLGaW2GPn0qbBFPHSqU8u6K1DtRg3IQV
	 Jjrd/3ECxnr6CZXTpIEcXnQQxJSIr8+tyQHs6mGIalK1iOHrMMVVABwUa6h23XBRlZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037447;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W/hX6GcHKdCZQWVe7w49lQbKeEutYxe8iQE8ZG66ehI=;
	b=08Qx+CTHHbvkQTMh5WDQEUzLJ0hGyYRxvzjeu0lnq199eTcBKlBPs+0hiSD+n0pJ4eUH
	 8VL90G1PT4HhIlOJ/GLYICCh+jREHBIqkqAbxSyixAhGzLE60xIsmm8krkvr/2/kEglh6
	 oEspyLt0BaN/4dLyJ2geLH1LTsVHEETrUanGgiBTxwNIRX2qESbD9Qp2Zz46xBSmKCqe0
	 pYPNrnia9fCRskcMJ/KJEgp9Jjare57A5aTrGTpbOuLG0Zueh/BUwaz6ibu/WJR+Rsk3t
	 Eqb+xpna5wLn7UjCSb/TsgbnF/B0brxgq1Ff201vPdu1hOEr3O1PyYhFVv4kewrW/8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NqRNi2x8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A75606A31C;
	Wed, 18 Nov 2026 21:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NqRNi2x8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F2C01F000C4;
	Wed, 18 Nov 2026 21:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037446;
	bh=W/hX6GcHKdCZQWVe7w49lQbKeEutYxe8iQE8ZG66ehI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NqRNi2x88hLKmCDn9LkVhprMWvR+F+EmLrCzhyVwgZTglCFqQuOBVRIBGLDsKE1As
	 n7Mb5A8xoSozUX9c0Cq9iArPs5YeLte4BbIJ7981rdrvk5w/amHXsILen6PfSbE4+P
	 PCqRxLTYSNo+o9KMvnSlaHiTXpaNCwGYYrHe8fg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1402/3318] 9p/trans_virtio: reject mount tags longer than NAME_MAX at probe
Date: Wed, 18 Nov 2026 15:33:44 +0100
Message-ID: <20261118150402.677343911@linuxfoundation.org>
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
index e305071eb7b8e..3230d9cf07e1a 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -629,6 +629,11 @@ static int p9_virtio_probe(struct virtio_device *vdev)
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



