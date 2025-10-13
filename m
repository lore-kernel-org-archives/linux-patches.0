Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB1630C60C;
	Mon, 13 Oct 2025 15:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369030; cv=none; b=RwVYtNXjIhO1/sG7chzFhY6FWIFIULRomeN5Sbi5Vy+V20cUDPiS6maSdr3hAjZzxbc599vZr0HWOwezNrp4NqCDEgtykkDKrL5oWl+/WeEYDDLTlZ/zR3kH4U23WCZZPQ1Is9NnA/k5Xs0HCZgCixM0hiDerJw4MrGDNEzqd2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369030; c=relaxed/simple;
	bh=wcLSd64RRhJJ5e9w1P0pUIkaO2B2v64Ri+DLTfZlDcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dqgBWE/cMXCmUL6IJv9KGwX0rB3Kovx6Lsz4cOkIZ3Zzfa+SFu4xla4Dj4P/zkr4bc+7mGR3mVKU5PEXidC9/qewBufDmM2doAxf05XM9EUJvJZ28TdtU48i6HvfrOLezZEAWNG4hzXHtKNiN0JTjzlWVNY+57GH+3375moq1HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=noM0Y3rx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="noM0Y3rx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C114C4CEE7;
	Mon, 13 Oct 2025 15:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369029;
	bh=wcLSd64RRhJJ5e9w1P0pUIkaO2B2v64Ri+DLTfZlDcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=noM0Y3rxKmnuWfTvqGc460RV4H+saTw8VqTLlE6MgmOWnwsYsHbCE2KqXk5daYpeU
	 dypJNQgFXXH+i9cCDDIqz6ncWC4RPPuHom9D2T99HTRg/AiPEHv+xKXoM7tGQKtc7Z
	 E2UtTuUtQCq+DHv0D+enAE2SeJKr+PKR0uuRliug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Genjian Zhang <zhanggenjian@kylinos.cn>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 104/563] null_blk: Fix the description of the cache_size module argument
Date: Mon, 13 Oct 2025 16:39:25 +0200
Message-ID: <20251013144415.062693026@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 91642c9a3b293..f982027e8c858 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -223,7 +223,7 @@ MODULE_PARM_DESC(discard, "Support discard operations (requires memory-backed nu
 
 static unsigned long g_cache_size;
 module_param_named(cache_size, g_cache_size, ulong, 0444);
-MODULE_PARM_DESC(mbps, "Cache size in MiB for memory-backed device. Default: 0 (none)");
+MODULE_PARM_DESC(cache_size, "Cache size in MiB for memory-backed device. Default: 0 (none)");
 
 static bool g_fua = true;
 module_param_named(fua, g_fua, bool, 0444);
-- 
2.51.0



