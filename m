Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406AA1F91E3;
	Mon, 13 Oct 2025 14:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367041; cv=none; b=hDXmpKVgix3zHm5gIfblOutk3ahF9+xelY679bWykXAy4qjJwnFargzEJ+jOJ46PTslzo5I0TADEPjsGANMICrgbx2zAaOR9Lq1heQrl/5Qh3qB06yrYCcLg4KnrzLNZjlAx8bBT5W+zeF06Hq/ADnlXgptin8HM/bwLP9NwT4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367041; c=relaxed/simple;
	bh=fT9qv7jyj4luEionCyDnSEQVjO5PT7hyHLFJlOWYLqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fe9/vRfzuPbVc0eg0ng9W3yKDXYtCr1ebJxo50KxUYIIovUoj5GY3tP0YeAXRBoB8kiZ95fusnp2ohfDn1yn3YSIgGHQer82sxZSmsO7xFVsRWzlLXH7aytV7/Cit852yex2npElZmIOamy7aQXzbiMyn546bejieelLOfVZNYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T2OLmuJd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T2OLmuJd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBED1C4CEE7;
	Mon, 13 Oct 2025 14:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367041;
	bh=fT9qv7jyj4luEionCyDnSEQVjO5PT7hyHLFJlOWYLqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T2OLmuJdtDO7xOJ/Fiwz8AmTLW8BKSHIWTcnjGiF35LjlV09eo3Q64s20KrImqGx8
	 DHIpzKrE/YJ/Y5i4RWUJxH9utCQH/JuhUiv2HmH5CreZPz+1A4BS0j214VdOD93XlP
	 pRPoJIyMnJc1zjhlmOFGVN/Wlz2lSSt88HTl06p8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Genjian Zhang <zhanggenjian@kylinos.cn>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 071/196] null_blk: Fix the description of the cache_size module argument
Date: Mon, 13 Oct 2025 16:44:04 +0200
Message-ID: <20251013144317.146551595@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

From: Genjian Zhang <zhanggenjian@kylinos.cn>

[ Upstream commit 7942b226e6b84df13b46b76c01d3b6e07a1b349e ]

When executing modinfo null_blk, there is an error in the description
of module parameter mbps, and the output information of cache_size is
incomplete.The output of modinfo before and after applying this patch
is as follows:

Before:
[...]
parm:           cache_size:ulong
[...]
parm:           mbps:Cache size in MiB for memory-backed device.
		Default: 0 (none) (uint)
[...]

After:
[...]
parm:           cache_size:Cache size in MiB for memory-backed device.
		Default: 0 (none) (ulong)
[...]
parm:           mbps:Limit maximum bandwidth (in MiB/s).
		Default: 0 (no limit) (uint)
[...]

Fixes: 058efe000b31 ("null_blk: add module parameters for 4 options")
Signed-off-by: Genjian Zhang <zhanggenjian@kylinos.cn>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index e66cace433cbf..683e2c61822b0 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -211,7 +211,7 @@ MODULE_PARM_DESC(discard, "Support discard operations (requires memory-backed nu
 
 static unsigned long g_cache_size;
 module_param_named(cache_size, g_cache_size, ulong, 0444);
-MODULE_PARM_DESC(mbps, "Cache size in MiB for memory-backed device. Default: 0 (none)");
+MODULE_PARM_DESC(cache_size, "Cache size in MiB for memory-backed device. Default: 0 (none)");
 
 static unsigned int g_mbps;
 module_param_named(mbps, g_mbps, uint, 0444);
-- 
2.51.0



