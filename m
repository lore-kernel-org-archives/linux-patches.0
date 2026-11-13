Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590173;
	b=medUKI+2sd5/TaqT3pFEfoFdigkypTCabbLDITTSlaHXjv+IUQODy3auK5PpmtzepiTQ
	 83AM8ITsNVxFG0koU6rl9AO9+afvSckJUIglrFACSEZnv6ZGbh6C36cZRN2zjpjCb708i
	 4kMB9nafD37DZ72pPoZ/9lAJVZvTsxmd3/23sthF+AUQEnC71kcvb7HY/5tGMvzTH8EJ1
	 bJDmveeU+6IDuXxcTma0NGV81Lszx+P2qIU1OTOqlvnJAF0zeeZ32XiDKajE4dtiRW/DB
	 GWPfEieUdwO+PPBwJd61QtBzo5dX6yvHxevQSmGO0SG3SJnKvQYOQta2WLiOnD76cfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590173;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BNUAyh8KP7lDD8zTYUf12WF4CP/ElJkSVCRD1V53Z1g=;
	b=y6caSSEh03LavHKwaNJc64101CYeo56KxPvycOFqmkPzulv3vHM+iQ2vuCRUlobB3oyV
	 vUmU/1LAkz8nxGyOy7TUE8AwWjQ8MJxh3xtoLupsc9AJzXuf5uCVZZy4hQpVSUV6OvKhB
	 yMBJ46b6dIgmPxuzPrqRRTSX1BH15/fLjwfCWTU60Eq3PdB5GbETqj018faViuSsmoE/w
	 M8pFUAswGjwJGFmUh/IZE7OwysrHfbgzXX1MlmWF9SlDIzGDrrU6tBKA0syU6WT6nz2Al
	 8c6zJoyEJ2Krwkf+g/hl9TfKeuUchY6ww47Pda8lfFBy8m2aqVW/yaW1FQtfLnYgvGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QrxPA4d5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D717B606B478;
	Fri, 13 Nov 2026 17:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QrxPA4d5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65D661F000C5;
	Fri, 13 Nov 2026 17:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590173;
	bh=BNUAyh8KP7lDD8zTYUf12WF4CP/ElJkSVCRD1V53Z1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QrxPA4d57wibPCpuE0ajmZ2CwipByNbgZp3lQjBCedSGwWwBD4Xg7HI7Jx9A8GWAz
	 2jCwn0G7Tfw64vPTj9RkYhimAcLXASY35rqIt63DRu5QTXH+suXaowiuQ6C+NgwdwV
	 fcokaCfWWyJt0A5WRrHSrCcgieu6XSDn74O+j7Ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 182/686] 9p/trans_virtio: reject mount tags longer than NAME_MAX at probe
Date: Fri, 13 Nov 2026 10:45:15 -0500
Message-ID: <20261113153827.175211265@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
index 0b8086f58ad55..d1a680f699115 100644
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



