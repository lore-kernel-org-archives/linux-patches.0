Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053201;
	b=fMarhm267IzPIgR5hlMU8Gek6H/XpL9eMWILF60EKuXUxQmVzWa048Q+CME1PrZGYpIK
	 NoZsBQ/hw4MQxIaK/T89wxCosILlBvbbP71ZquyDWXsFrhXIAJozlSbMxGk5tSCgToHbR
	 uU4t+/VWh4V1BnRnbcJdY8RoRwL1c1YhsQ91LxkiB+mEeVb6x8Wf0NFa1HCfdIIboeOCX
	 sBUrufM18FHRAwRu/eCH8+iDNddcHlsUWglBFi4OFCbf9ewRkuCfrB4J2AsmL+ByzHG3Q
	 HcOEsYG9/ioJeCfAU7FJ8XcB77YNsyqFjgxzqa7gOQRud+68fg6cuUZKLHScf74GojQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053201;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wzw6Gqz2yF6zBtWB2Z723ewH/UDNZGJn1ybAbUo7RiE=;
	b=Q7aSIHcbk78HVP/2nmyzZVM/p9nEluH5+uoS4MHBq0bP4DzvH+7kPUr09TfQJd+7MKm9
	 dTLmt5ns+TYbGUtncoStwfzFi+UEi/fA6sFBRJwmOm98XJMv7Xi33jPHr4njDIzeMDlSr
	 TZUr7XeK/h2JVRqd0jCRQRvSWqoMhFFmvSB7rI2uwOTI6BBm0PY8UTn8qYOuxzg2+Veoh
	 CIYuVuG78duZDQ4B/UUBzQ8RRg9sqD0lN0uXxOS8wz05WsCBgIXjEBYh3y5vjgNux1rWi
	 jKjQTGPPIY0Kdaj9qj4N7WMDUVVSSWYj1SK3qGMzpXxdDIy3TaKTg5wy9q4onwICNng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kNRtzGGB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68992606A325;
	Thu, 19 Nov 2026 01:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kNRtzGGB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B769D1F000C4;
	Thu, 19 Nov 2026 01:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053201;
	bh=Wzw6Gqz2yF6zBtWB2Z723ewH/UDNZGJn1ybAbUo7RiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kNRtzGGBZ0IqANchsDZdaC5obg0OFl+p5UNNgPBRe6x0ACquHzx1w6AVyPINnchW/
	 W7yvETuN6QkCKtdBXP0Du6Avhdfq/1C8ML0FNUamHKgjcUUDv5v1OLQM62V6sJmV7C
	 lfC/s7llT9j/ysxkGTrWFEDn3zY427b+4FiLszoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0833/2214] 9p/trans_virtio: reject mount tags longer than NAME_MAX at probe
Date: Wed, 18 Nov 2026 15:41:49 +0100
Message-ID: <20261118150045.359760947@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 96eecc2dcaa36..9a42db03793e2 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -594,6 +594,11 @@ static int p9_virtio_probe(struct virtio_device *vdev)
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



