Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041441;
	b=YVMZWZibxfLe2b03/F15996yZDqzi40hyCOYTf0FerptEh9AEJ77jqDkdeahUbuoUaLE
	 cEqnKAHmPnZZ7CZ0OWwHqaeRd8/95gF8ck1IhRE9kaWOL/vcjJSdQq0EDx+1XlHJT6rpx
	 CJQ7j5ou/CUTLbmMpNGXAybfGPBIeSyrpquo0ly/KUMto3jYc5HUt1QojbFNGRAnFUNA/
	 XNlCs8yTOvQ5aQOJ5DTmj117UNrm9III7fOVk+uwgP/rmz1SxkPzYBlvZp7kFo5iYQRo/
	 MP4CWLlrOo05s7kFggYT6Gn4CUrOO9NLzuvinO4f6uYiogad0NKFc6E7ZsPRux0i4Rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041441;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j9EuvuRGilb6gbcL8nAoJaLdE/XorjzuRWKMG6FFr5A=;
	b=2VNDRaeBNJgbMqDbnJb1FrFiXD3yzrfh1qS/AahKs2ZkHTK8qfC9B8I5I7HEmusDYEHt
	 PRn65j64EeyFZWSGRi5R+6u3qAc169x65MFZJSXmnbqmTfWuRAja6tkyY0BB1ExAxtyTJ
	 NTga+7u8WlS0pPNdO4b528rGZndYMXtg2WW0JjX1dlQF35GMW++yeeIoUAjqMJtQKaMqT
	 CG3y+TwCfD2QbyqMkVdtFiusCQt+uF7Jj6KP3ilR+C0qESSEXo5SEKmykkYi7JLFDD88C
	 No+9kOhkLow7veMKpa1DLh7YeEYRQ91JAKU/W+kpEQ1ZL55Hag1DlO9IdSgsdS66kMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0LGyNhXJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA43460A6F4C;
	Wed, 18 Nov 2026 22:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0LGyNhXJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 351391F0181F;
	Wed, 18 Nov 2026 22:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041441;
	bh=j9EuvuRGilb6gbcL8nAoJaLdE/XorjzuRWKMG6FFr5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0LGyNhXJcy7REuE7V5BkJC4OybS7Q3xYITWASGg6PXI3unZIZJbxD4rgbUnt6v1ZD
	 VPQ5VfrTEgDXWHOA4hMcZRT/ndokcFcgmfBZIxnFAfi5KwgWDxTED+Stu4Ca3r8B6a
	 Gytibj+Nfj10siQ3H674csULeDPcBtF68uLgzh4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Yao Sang <sangyao@kylinos.cn>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2816/3318] nvme: pass partition flags to passthrough checks
Date: Wed, 18 Nov 2026 15:57:18 +0100
Message-ID: <20261118150445.133884531@linuxfoundation.org>
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
index 38e3f17c79166..e688d06790415 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -410,7 +410,7 @@ static int nvme_user_cmd(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	c.common.cdw14 = cpu_to_le32(cmd.cdw14);
 	c.common.cdw15 = cpu_to_le32(cmd.cdw15);
 
-	if (!nvme_cmd_allowed(ctrl, ns, &c, 0, open_for_write))
+	if (!nvme_cmd_allowed(ctrl, ns, &c, flags, open_for_write))
 		return -EACCES;
 
 	if (cmd.timeout_ms)
-- 
2.53.0



