Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B979C142E9D;
	Thu, 13 Jun 2024 11:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279976; cv=none; b=jzWjbN37kxP6MntrxFuxmKpuIlKnalKfcOZgGp4NsD0/Z2YLBspP0XUZNvminLcIudiZeuFqRF9W8p1zlQBNWH2QYRhVL3OwfQkqrNlU25BO4cDVfVgmWTO8xgpc+cagX5CTPtJbCi8QMC1VzxIAiE+OiK9QHq/p7oYX1A/BeWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279976; c=relaxed/simple;
	bh=LibQTYVUypq9LpAmxOTpF85NtMeULiBT+X6nw6YM9uI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MD+6/nRPkbFKi6ri6by1jypWUKlN5EFkkCyx1fJMSt6O3v/3Zcus69ZAvX5c7xk+H6AExJoNVLOXxaZ5hKqA+IwqweuiB9NdC9sooz+jOCBBoM9q7qN8gQg9kc6T85bQqSTmLxeNkkC1rVXQBdrPWHL3K290lNmmJPxLV+83DJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pYKamC7K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pYKamC7K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44548C2BBFC;
	Thu, 13 Jun 2024 11:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279976;
	bh=LibQTYVUypq9LpAmxOTpF85NtMeULiBT+X6nw6YM9uI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pYKamC7KqULcyNwkC41FfrqhsO+tTa2B2qcaQ255LXJeBGLnIpaP+SBfXVpEHVdA7
	 b8CO/nsHLmJRFsZsg9ZJHeo7wf7oJ0ZF7lzHtNJ3VE34/lDwloTTpgBM6POK1J6Lvq
	 pdNmCuVnDkDjU0cIn9F02Y5B5uTmwHIj57KbYkXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 101/202] dmaengine: idma64: Add check for dma_set_max_seg_size
Date: Thu, 13 Jun 2024 13:33:19 +0200
Message-ID: <20240613113231.662534251@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 2b1c1cf08a0addb6df42f16b37133dc7a351de29 ]

As the possible failure of the dma_set_max_seg_size(), it should be
better to check the return value of the dma_set_max_seg_size().

Fixes: e3fdb1894cfa ("dmaengine: idma64: set maximum allowed segment size for DMA")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20240403024932.3342606-1-nichen@iscas.ac.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idma64.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/idma64.c b/drivers/dma/idma64.c
index db506e1f7ef4e..0f065ba844c00 100644
--- a/drivers/dma/idma64.c
+++ b/drivers/dma/idma64.c
@@ -594,7 +594,9 @@ static int idma64_probe(struct idma64_chip *chip)
 
 	idma64->dma.dev = chip->sysdev;
 
-	dma_set_max_seg_size(idma64->dma.dev, IDMA64C_CTLH_BLOCK_TS_MASK);
+	ret = dma_set_max_seg_size(idma64->dma.dev, IDMA64C_CTLH_BLOCK_TS_MASK);
+	if (ret)
+		return ret;
 
 	ret = dma_async_device_register(&idma64->dma);
 	if (ret)
-- 
2.43.0



