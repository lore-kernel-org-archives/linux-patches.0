Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3872615C82
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:22:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1A3DC433C1;
	Mon,  5 Dec 2022 19:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268159;
	bh=zcbLxW8A+/qX2TinoCzZONiC97abHuXt0MaaBHh+8Kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o9hZj/YaF+dPPdD18pZAjHWi7TmQgyPMQIbkEu4WuDGSCerxOsodJwLDkuWbgI/l0
	 a4SbsiMLUMjOnTyRzsNrccQlgomMBwYlHhu6jozj+3+M1Ac0I5OQsriAIiZFSC8Qom
	 xmtRWpCr/JEnn2Me12krOBVxdlRylOJt3FQJlbQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 094/105] parisc: Increase size of gcc stack frame check
Date: Mon,  5 Dec 2022 20:10:06 +0100
Message-Id: <20221205190806.296201818@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.124472741@linuxfoundation.org>
References: <20221205190803.124472741@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Helge Deller <deller@gmx.de>

[ Upstream commit 55b70eed81cba1331773d4aaf5cba2bb07475cd8 ]

parisc uses much bigger frames than other architectures, so increase the
stack frame check value to avoid compiler warnings.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Stable-dep-of: 152fe65f300e ("Kconfig.debug: provide a little extra FRAME_WARN leeway when KASAN is enabled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/Kconfig.debug | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 9ded3c1f68eb..556aae95d69b 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -224,7 +224,7 @@ config FRAME_WARN
 	range 0 8192
 	default 3072 if KASAN_EXTRA
 	default 2048 if GCC_PLUGIN_LATENT_ENTROPY
-	default 1280 if (!64BIT && PARISC)
+	default 1536 if (!64BIT && PARISC)
 	default 1024 if (!64BIT && !PARISC)
 	default 2048 if 64BIT
 	help
-- 
2.35.1



