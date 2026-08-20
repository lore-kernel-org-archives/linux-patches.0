Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D19360745;
	Thu, 20 Aug 2026 15:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238624; cv=none; b=QcPTrBb+K9NR89GsmPygyeoEAjGIHJ8UbyR97QPVpK1iAqvqHUxuQBlJ0iHpyG6L0oTfIiN12DrfLasjYK+kpNnrld6jDDHNOUsGJsSVKgH4vvjaXsR30jh1ThrimY0wwfqJdZ7apnReA98P3BhQd16eWMT9We6O+IFlv1j3XZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238624; c=relaxed/simple;
	bh=ngr8uEAxWy8ubb2FdJcCVhGKuw3Pu6UZWK9g+emsP38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l7YK5dxKTqWgkmpXfYZx5pmoTr77KLP/ooJ3jMQyXWGaGn2OCO7NLLEryfO2jdE5xzRy2HOasaE2ioNRJ/063w0FT6Qia4Fzhd9bEVk2wF1BUYQ5TkdemAGTY9PavJwKatIIInpcRIMwkEgtNcYoxJjBK/81IYCZL8iyJrgO/UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XCMNMi10; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XCMNMi10"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC3C11F00A3A;
	Thu, 20 Aug 2026 15:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238623;
	bh=dFFpAz1M6t2xOt1Dc/ef2vfVIZ0XukloxsSBc5u2ICo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XCMNMi10eAPJCN4h1zT8cEppxP09rxEA9cBQDGjEW0EM58aZbhYwF4PChTTE8fBLL
	 nVyypTCjUgTw1GusAPuI/jKDmKxp9hjTkZglfenT7PXaK+b1iFoqzAuAzVZPY+pGXT
	 cx4FZfsz4RWNRjFJYdkHHCGY8/J/xsmlFdWoVTr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 212/228] m68k: Define NR_CPUS to 1
Date: Thu, 20 Aug 2026 16:55:54 +0200
Message-ID: <20260820145251.477726081@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index c9a7e602d8a4d..83f46fd6b97cf 100644
--- a/arch/m68k/Kconfig.cpu
+++ b/arch/m68k/Kconfig.cpu
@@ -548,6 +548,10 @@ config CACHE_COPYBACK
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



