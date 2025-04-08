Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB9C207E14;
	Tue,  8 Apr 2025 11:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111453; cv=none; b=AMTLGTo46ZLApbXaVe4A/WyTNH8zKK79Fm3Jm94Nyy9HWIy4zqvaxk6z/n3XgHymwmAh+dZHQ0MIpFiRqBKGL9FbU4N0Q7gSn7QlsfZC96r9uw5YEEITWAiKDrLxSAH96hOx7FIKKf9JEf2O00ilJzCwH7+mQP15WCwR6W2LSMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111453; c=relaxed/simple;
	bh=n+ceyoTN1H7Om8Z7fR86I7mygkOm9aPGPxrITuKkB/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FsU6OosKLlMo0oV9BLFh2s7QA9urCPuPjoFJk2pOf+YOnXhjW3peMjY8NtYFtCe1qSxYNvtTRZbosKttP0TxBbX78ePS3htaj2B2Y2LTKWKz7ciC+MsGHSYhUDHK0qxHPTQTyBm6gdK2KVVncp7l9K3WEUSNotMY4toZADO4HxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rh9EI9iw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rh9EI9iw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C89C4CEE5;
	Tue,  8 Apr 2025 11:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111453;
	bh=n+ceyoTN1H7Om8Z7fR86I7mygkOm9aPGPxrITuKkB/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rh9EI9iwNl2yOxUMeoqi7Ul5Rl99afMa2m7lmuvFpr4qn8f+dMfL3VKiWyY2V7n+N
	 cDvPWe35DxaU8CTIaFGgJJfAlyX+Z5yv1e+oNe/bEYAyT0iNy0AwX4+VJcUsnuEULl
	 EnRltfN/4bREXXzthVx3odP5hb8l26nkyiqiSP04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Penkler <dpenkler@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 437/731] staging: gpib: Fix pr_err format warning
Date: Tue,  8 Apr 2025 12:45:34 +0200
Message-ID: <20250408104924.437721048@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Penkler <dpenkler@gmail.com>

[ Upstream commit 03ec050c437bb4e7c5d215bbeedaa93932f13b35 ]

This patch fixes the following compile warning:

drivers/staging/gpib/hp_82341/hp_82341.c: In function 'hp_82341_attach':
./include/linux/kern_levels.h:5:25: warning: format '%lx' expects argument of type 'long unsigned int', but argument 2 has type 'u32' {aka 'unsigned int'} [-Wformat=]

It was introduced in

commit baf8855c9160 ("staging: gpib: fix address space mixup")

but was not detected as the build of the driver depended on BROKEN.

Fixes: baf8855c9160 ("staging: gpib: fix address space mixup")
Signed-off-by: Dave Penkler <dpenkler@gmail.com>
Link: https://lore.kernel.org/r/20250124105900.27592-2-dpenkler@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/gpib/hp_82341/hp_82341.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/gpib/hp_82341/hp_82341.c b/drivers/staging/gpib/hp_82341/hp_82341.c
index 0ddae295912fa..589c4fee1d562 100644
--- a/drivers/staging/gpib/hp_82341/hp_82341.c
+++ b/drivers/staging/gpib/hp_82341/hp_82341.c
@@ -718,7 +718,7 @@ int hp_82341_attach(gpib_board_t *board, const gpib_board_config_t *config)
 	for (i = 0; i < hp_82341_num_io_regions; ++i) {
 		start_addr = iobase + i * hp_priv->io_region_offset;
 		if (!request_region(start_addr, hp_82341_region_iosize, "hp_82341")) {
-			pr_err("hp_82341: failed to allocate io ports 0x%lx-0x%lx\n",
+			pr_err("hp_82341: failed to allocate io ports 0x%x-0x%x\n",
 			       start_addr,
 			       start_addr + hp_82341_region_iosize - 1);
 			return -EIO;
-- 
2.39.5



