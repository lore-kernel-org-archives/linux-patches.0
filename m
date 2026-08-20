Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9D328C2BF;
	Thu, 20 Aug 2026 17:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247276; cv=none; b=Jgv0hx03z9rZ0SBhwNlUFg+uV6uVz6d6Y9OUAq6hVlTlfgOUDZp6k+OvglpfrkNAAdUrkd7eBN+M9C+0dvDK9HjFsMTm4lSvJ4uhp1xHTUQESzfjQMK8Tg1XhsHx36TmXP5AazsO1i+EuPjAoVOW1eZ/bEzogP3sVuLwo+Ub99U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247276; c=relaxed/simple;
	bh=BhlbdViZXzOhjvXUZSsQfw0WtigWroxBQ4683qIj6B4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=evj1yGfYPpjMTS3J7CxZ0edHLk0t0bZNdQKyHeddk1y9WELcrqPiUX2W27Abw8tJGOnRv9M5361kqCKhS4y8AACNPBaVUwTC+RH+1acG7A7pikSY4iCYBa/5Tuzl+/T61JTg/qwGuy2nLHyEL0hp2/JgfLHA8K0S2L0ERmJojdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0eOFEsQ4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0eOFEsQ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 058611F000E9;
	Thu, 20 Aug 2026 17:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247275;
	bh=NUVRhgKoS9IC8sMZKcHe6ixBCgn3Oc3T66OgdO/DbYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0eOFEsQ4CXuQNC9g+myc8aspgm507TvcMihP8h+G7MdvVXqkaRorg2p4tjbhjWUmj
	 A4LPTWk/3O3fqs6/O6dtVsiue7UWlWiJvVXaNhwwxxcrPRXKHa+DL+QvbU4lv0ZZbL
	 KwLU9NpGdQIHfKD71jKSr3qJCtNC2f7mdQ2e7fe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 210/220] m68k: Define NR_CPUS to 1
Date: Thu, 20 Aug 2026 16:56:40 +0200
Message-ID: <20260820145229.834684205@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c777a129768a0..cc5d559b8134c 100644
--- a/arch/m68k/Kconfig.cpu
+++ b/arch/m68k/Kconfig.cpu
@@ -538,6 +538,10 @@ config CACHE_COPYBACK
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



