Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A48B1A76B3;
	Tue, 30 Jul 2024 17:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360096; cv=none; b=kjMNtanK7U79V07ARaaAvLPKfN2aRTysDEqdvmURdb4MEadO9vs1R0H+oTlbRZ1TJP4yD12hbpQKfDMXBfNZ98fv+zVaMt5KsQSXVVjstZVs0sZHimnXKdZTj1Vd+bNv2kf80OAaa3ARyluhmndg/hAXJJKnBKzxr51GdI4kc5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360096; c=relaxed/simple;
	bh=UDA6KJWPsk6BZmAnXlX3fArIE7FnsVa8hRAWjRkqDCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VmmkQG5VJYSxNFgu3QMFsIdC2eApMSTtY639w2EiPNqKonsYwzUud92VXsDUxbIKBYoEYNZnaaEkY9K44UWdjNDeHSAhoNPzNZNs1PZDMzkuilD69lDYhmSRy5REbwfBf6JkDP9q86bx3BqoHw74cm8fKpBuTkBvWaWSs+X4f4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WTFC0k3w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WTFC0k3w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C46BBC32782;
	Tue, 30 Jul 2024 17:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360096;
	bh=UDA6KJWPsk6BZmAnXlX3fArIE7FnsVa8hRAWjRkqDCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WTFC0k3wWtvXsHHxeLTeNZ7CPE8ZfytuPNYYXqHndXcA+wnNYAUH/ewgFc3wdNtZx
	 ABskA7kxw6DGlKoh9N16eG8RZpfofzAzU1Vxf8f2Vdm8DXpBeBt8zyKxTC5iuj6x56
	 nQCE6sJ085ljTog5AM2k/mXaA1ERtegFL5d60p9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.10 564/809] null_blk: Fix description of the fua parameter
Date: Tue, 30 Jul 2024 17:47:20 +0200
Message-ID: <20240730151747.043062600@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit 1c0b3fca381bf879e2168b362692f83808677f95 upstream.

The description of the fua module parameter is defined using
MODULE_PARM_DESC() with the first argument passed being "zoned". That is
the wrong name, obviously. Fix that by using the correct "fua" parameter
name so that "modinfo null_blk" displays correct information.

Fixes: f4f84586c8b9 ("null_blk: Introduce fua attribute")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Link: https://lore.kernel.org/r/20240702073234.206458-1-dlemoal@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/null_blk/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index 83a4ebe4763a..5de9ca4eceb4 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -227,7 +227,7 @@ MODULE_PARM_DESC(mbps, "Cache size in MiB for memory-backed device. Default: 0 (
 
 static bool g_fua = true;
 module_param_named(fua, g_fua, bool, 0444);
-MODULE_PARM_DESC(zoned, "Enable/disable FUA support when cache_size is used. Default: true");
+MODULE_PARM_DESC(fua, "Enable/disable FUA support when cache_size is used. Default: true");
 
 static unsigned int g_mbps;
 module_param_named(mbps, g_mbps, uint, 0444);
-- 
2.45.2



