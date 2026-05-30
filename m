Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8B11DE4EF;
	Sat, 30 May 2026 16:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780158928; cv=none; b=lskqIuBIufT22K1FyNhNhEL+CIcksAm7+uC6BGZWh5tRDzQBzMjCy0/xBz+PaeZnrAopuPMPb0fHL1wxpFo7qKKddvdV2DBlzQ0eO/lZlWnfYD8alSo/z2P1rZPyS7duLbwanRiWPmYJutREh2OBSzrymhY9ef705mvAMNawodM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780158928; c=relaxed/simple;
	bh=Ev4b2uFekUMtBlzPcv6/0iu6pARIG4i0BYYRwOT/jtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tnGa0JzxaFVk2O/gnSskHIofWOn8SwTV4PK5WohXB9q27+ZnY4LGtTWUuAacd80PrJXKILUpj4PaQ1vkCOokUJpznKNNSzwdWxO5XpAjFzZNqIWD7grfhJlt+PtSlS59KnCiA9GOUQnTmiGgNQ+YwHwc/VZi6sBsRM+r0eNvbOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zf4fv4Hi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zf4fv4Hi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FACB1F00893;
	Sat, 30 May 2026 16:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780158927;
	bh=KvmDCl3o2/32Wt8QcEQidPjGBTf4wGvKEXcYACeTB+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zf4fv4HiA5d4xjGjh4idchxNLodkzPZsE9gWpSgbR/MLD9p67L7+CPjAVMkwQzHxA
	 XggNDYvjopj4gOZs1+p0VCm80a8VFuzFZwxXJ5BONnlhU8MJx/iWkREnngjZZxQelF
	 WtnhJzQfpCwewClXgG0hmk641WQnsGWpm5Y0OpFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 088/969] Revert "dmaengine: idxd: Fix not releasing workqueue on .release()"
Date: Sat, 30 May 2026 17:53:32 +0200
Message-ID: <20260530160302.768063527@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit fd4cb61bbd0fc3a749a8da6145cbb56d8f6dba35.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/sysfs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index ea222e1654ab9..0689464c4816a 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -1663,7 +1663,6 @@ static void idxd_conf_device_release(struct device *dev)
 {
 	struct idxd_device *idxd = confdev_to_idxd(dev);
 
-	destroy_workqueue(idxd->wq);
 	kfree(idxd->groups);
 	bitmap_free(idxd->wq_enable_map);
 	kfree(idxd->wqs);
-- 
2.53.0



