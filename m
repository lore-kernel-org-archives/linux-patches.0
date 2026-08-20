Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFCB442FDA;
	Thu, 20 Aug 2026 17:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247783; cv=none; b=Ra+/e+Szcrubq7Z3lbOk/UR8UuHW+jnz9vAmFern11dAvO4xk2JQn+8QoxFaoD79OMYc4bChQ72/f3BuWAUBcbWeSmzZcOOqAnSp7LFQ14gBprSGtn+7fKTzMudciroHNn8d2QwvyWuoZHjMtwI5N/3s2IUjZdosPiXjZlLmLIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247783; c=relaxed/simple;
	bh=s/Gx/lgvLUKlXEZiZ1QBqKM6mRQovp1qh9B63VUUiec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FHM6oaM/VnyDu4OA2wrdlToJhuRB/O+uxBMKp8A03RqmMxHsG7aIbTj5vW5ShOzk8ogbYFrEmGi1Ntnhwo7dvHnpxVmEiIlkVOVT00tNkQ0WdCTfZxk6tZ7xWNFfExg4mChR17MXNXJbd8uKDCmusQihs//Wh2ZY04dofEIIvFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UN8LCwal; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UN8LCwal"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B111F00A3A;
	Thu, 20 Aug 2026 17:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247781;
	bh=0jcVGhfQdaHAt1QGcb49ER47zwz8OQeTIdC7slOw5VM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UN8LCwalcufHh/ghP37Kda1VGtRiIp15SS21G5YyKOocVGRTpaLJRHD54ivEXHSrl
	 pSn6jeYWYH0jDYszsL8noOY8DF9xb9gpx8OfakJDXVAm7DMJcPzqfobB/dMdT1/Uqn
	 ArYigsWY1nIqhcjQoOVudhVbhmb4WQhEgGxuUY8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 160/166] m68k: Define NR_CPUS to 1
Date: Thu, 20 Aug 2026 16:56:59 +0200
Message-ID: <20260820145215.976546339@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <ukleinek@kernel.org>

[ Upstream commit 1fd495ef09eef96169a379a749c24b5e69974bb8 ]

This fixes a Kconfig warning

	fs/erofs/Kconfig:137:warning: range is invalid

which originates from EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS using
NR_CPUS which up to now didn't exist for ARCH=m68k.  All other
architectures define this symbol, so fix the outlier.

[geert] This also fixes:
  - CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS being set to the
    literal NR_CPUS instead of a number by automatic configs like
    "make allmodconfig" or "make olddefconfig",
  - An infinite loop in manual configs like "make oldconfig" when
    CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS is not present or
    has an invalid value in your existing .config.

Fixes: c9b47e6b2311 ("erofs: cap LZMA stream pool size")
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://patch.msgid.link/20260731094950.1988084-2-ukleinek@kernel.org
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/Kconfig.cpu | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/m68k/Kconfig.cpu b/arch/m68k/Kconfig.cpu
index ad69b466a08bd..3bae9f61f198f 100644
--- a/arch/m68k/Kconfig.cpu
+++ b/arch/m68k/Kconfig.cpu
@@ -536,6 +536,10 @@ config CACHE_COPYBACK
 endchoice
 endif # HAVE_CACHE_CB
 
+config NR_CPUS
+	int
+	default "1"
+
 # Coldfire cores that do not have a data cache configured can do coherent DMA.
 config COLDFIRE_COHERENT_DMA
 	bool
-- 
2.53.0



