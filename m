Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026462;
	b=m0PIjieK+8fkzpLlzsMtGXdqjnPBit6UBvfRheo93XQCm7KEKou6CteEnI/yDjOm3qjq
	 7jzeP090FUj/VisRJTv0xsVab7iFa9sZTcuNpP4MOz9MbH/DcU5m4r7tsefgbzz3Z0002
	 NEYcI/3SZLCEkP9y+pBQKyzFONPcFg2cX7Fsd/kZdUTPmljT01fMhhgGns0ghTIkEIKyk
	 8DrfoMaZSR8WNDZuA4vPUoewI81ESeCR3l+94lOTkO1pbdhNstn7ItOEqcTinHunnIGhU
	 hJPGgj01JLwVfgLYMUZ3gYxKpN6AZ2hSSnz/YTXk8PtkbK6aOXN3TOeDDQOnAFesUfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026462;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6Tiy3WAicATOuf3vg2sHSHKPs2fNWOBGV8xIDkbeWgc=;
	b=J04B6GzUtI2KAwUo6h7bsftJFp3FK0BtUfc7tQvh+kx7PT6aM6e9+LBESDJnATfhpZuI
	 zfD0F1spi9C7QtftRJRqow35QkWrPzz/UjXhgqzWP6x6FUH+AEo/npfD/eebzGcHBszwF
	 9syHSYp3d0zdDFziyfkaSfmMEMnJF97NYEnBgMMtsvqPfkY0n+DMN8tUE84wRSG12ENbb
	 WZFY7DYG0LlvbXPka3tWp36QlWDWhq/IbOpitjFJvb9Fz2qqN3z8Wn5/j6mka4MbLLAD3
	 YQeRThTeXZtBmxS1NMScTcXrrRqvCwSIrjI4KpRg1xx0KIr3AYxXjB6hzi0itkBh4bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vrnhC6YH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E63606A31C;
	Wed, 18 Nov 2026 18:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vrnhC6YH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20EF91F000C5;
	Wed, 18 Nov 2026 18:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026462;
	bh=6Tiy3WAicATOuf3vg2sHSHKPs2fNWOBGV8xIDkbeWgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vrnhC6YH0QsvC6+RC8OrQamz3eeTZ2hWfF6izVNJeEfKPrBD2G/kaTj7VHQItPGqJ
	 oz4m20mcjewmD5Z8e5XMI6fv7nDnZVHED98MiZKggRv/rbl62AVi0OC0biyFUjDIMl
	 +ikMOBeEPlKGWp1lEYio+v2zJ+izBfAujd37XlUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Yao Sang <sangyao@kylinos.cn>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1444/2151] nvme: pass partition flags to passthrough checks
Date: Wed, 18 Nov 2026 15:52:59 +0100
Message-ID: <20261118150214.533659948@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Yao Sang <sangyao@kylinos.cn>

[ Upstream commit 6908a702955929b0876baac9fdc57070780a76f0 ]

nvme_user_cmd() handles NVME_IOCTL_IO_CMD on namespace block devices,
including partitions. It receives flags identifying a partition, but
passes 0 to nvme_cmd_allowed(), bypassing the partition guard and
allowing unprivileged passthrough commands to access sectors outside
the partition.

Pass flags to the permission check, rejecting unprivileged commands on
partitions.

Fixes: 313c08c72ee7 ("nvme: don't allow unprivileged passthrough on partitions")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Yao Sang <sangyao@kylinos.cn>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index b3e58de6f5cc5..2c0d00352f919 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -343,7 +343,7 @@ static int nvme_user_cmd(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	c.common.cdw14 = cpu_to_le32(cmd.cdw14);
 	c.common.cdw15 = cpu_to_le32(cmd.cdw15);
 
-	if (!nvme_cmd_allowed(ctrl, ns, &c, 0, open_for_write))
+	if (!nvme_cmd_allowed(ctrl, ns, &c, flags, open_for_write))
 		return -EACCES;
 
 	if (cmd.timeout_ms)
-- 
2.53.0



