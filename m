Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046189;
	b=eOP+uDmjbFPwwSnj9TWKTWE/KXBp37ygGYbW/4mwaY7DsJlUot79NHKcsB3O0nQPmMPk
	 pnwDeSkuiLZifMh6Kr93lmLtuVvbUbV0TA0LyvNutysqTkg+ER28+QRLvx4L27p2KAY27
	 Bi01fPwKUxiOoYOgKXFapkB9KnrD8p3j9CV+EINSLiGNN1zKHQFVt6ZU+6krssGdEmwKS
	 N5bFHUsTs039brJQJtSkVUiU0+Bs2461dJlzidt42nR/VF3MjMKQ6yi3/STX4z21Om8Cv
	 A8SKZZs/KB78L2Z45UqNpHKcSveKQ+VDxA19UL4HXkuWx8W6J8f6dG+bN059NPuFkZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046189;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i+qAt9ThCI0IpGRgLaZGHpqXE+ZipQmDjLg43QE0xsw=;
	b=xJ3d53UY/JiKKJI8BtfA2ZN7FCF1c8EZE/yc8E5/GORyJxiFNbWOAwgNpYhY+OCdrZhM
	 3/sqXS8UvapKt5EgouWXtqHQWyJtfoWFtcXKH2FfMyd4l3pVWb0QUaAHUeVZe9ggcNAiN
	 dN1eodSNF9RilMiYGJ8uI72ji+qT+KHAP9k620QU7bBLHKS/CWvNXspOH+B6cnIWf6SIB
	 CbEVaTbc3N4swngfwovBkTRziIkP1DBU2ostwcZsXWkZ4AWbwxoYABw64Gc5ZS5l77qbh
	 GXRG09Orqraef4BqJfh4PWhXEgz/cFee5QUaggYFq5dzJmFT6UUzvVRZYC0Wd4hAXgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dTfvyTlh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D71606A31C;
	Wed, 18 Nov 2026 23:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dTfvyTlh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10FB11F000C4;
	Wed, 18 Nov 2026 23:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046189;
	bh=i+qAt9ThCI0IpGRgLaZGHpqXE+ZipQmDjLg43QE0xsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dTfvyTlht1ThkbInJt7b+C34QH+W6XRzwv4a0QtXU7j+zogWjI1UUQr/Lurm0KnI9
	 Yv7O8s3uGcI6C30D6AB/jOtcEeWJnUCXjMCuOddSDv4x81sOTrFZjEBQUlJBN0askE
	 LlXHlQxw69T5sC6dhgt1Af06+g17IVnJAqTPiHJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1191/2857] 9p/trans_virtio: reject mount tags longer than NAME_MAX at probe
Date: Wed, 18 Nov 2026 15:37:05 +0100
Message-ID: <20261118150244.492926471@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3cf660d8a0a7b..f938731b29940 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -630,6 +630,11 @@ static int p9_virtio_probe(struct virtio_device *vdev)
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



