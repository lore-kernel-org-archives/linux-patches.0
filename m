Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590998;
	b=CDcNvXR4TLvjVf0ge0LFwotz05P/FQhzwG2y8he4GSyOypS8AABV6q6NxgZ9yfO3Bx7w
	 dUd8DIMNzqM4BY0XnDlvK8gy+5U0p85GuUgREtln5+sFjqPMdOAASjwL6l7rXnXszm/B2
	 ZkK/3lbRTEdY3W8vetOEvKQfrjHz3omzpf3m7kXEcpww34wuwqgxtingI94P/gWjxrwgg
	 PR5rqxmbsIsBCYCPAroVjrtNxogkjUOef8o7KdFlDev5VjGqKwcFVDBzPzCh1jwzj/nnk
	 wrOLj0D11BnTrxmN20wi3u0/l+wFj3Ng/lJ1NLkNME3qaeM9rfnoTySwuS2E6Q5pOJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590998;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r9F1RDKiMhJI6pYFDx2Lys0zG7cihroTLOqBRoUZmUQ=;
	b=KXSyVSGcMU9qxHIzOetNYWg+ECPLK5+butv2TF/UodX3w/mUH0MiJrBVPIEFWQopRJ1K
	 GYLkxorAUntEGvPsRhzNRJTr44F6tfm/7UoIgPpNH9LEM7g+43U6ymgieGCk/B6H9Scl+
	 sK/4+h5Vdmnr/zY6aN9Pd2ZNIKtKVrNnzKnoyGQw7iY7FzBIYPQGFGPV55rb5PMdIuZMI
	 udTEmH2h6HraH1k3CNPUK/Q90HDYC0aqiOE19Y7NvPIiSltggV9Bj4CtydV/8zWrkt8Fm
	 dNxCspun8jkV0RcJ/hSILaySHeYVgWyVHlQ947jUzX8Yc5CN81EbPdI6e/VsQi5F3cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ljSgpg9j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1BB608317D;
	Fri, 13 Nov 2026 17:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ljSgpg9j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4E081F000C4;
	Fri, 13 Nov 2026 17:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590998;
	bh=r9F1RDKiMhJI6pYFDx2Lys0zG7cihroTLOqBRoUZmUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ljSgpg9jIV9vVDeOupPj+fiIAaEgr2wN6jq/PtwmOOor5wT7O6t7WJxmE9fOog2SG
	 IOKVIrTO64cK/fDOaNDzIH5T8BTJd/B01pcgNycdRk3yJb1+GDod8ZEO1QVb4cdfEq
	 4Ya29fPB1lCIyyypRt1RY/r0jxcJuRiSFrjfwEng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 171/670] 9p/trans_virtio: reject mount tags longer than NAME_MAX at probe
Date: Fri, 13 Nov 2026 10:45:35 -0500
Message-ID: <20261113153817.859992277@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



