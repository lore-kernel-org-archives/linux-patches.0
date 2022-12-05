Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F5D15C8D
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:44:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04970C433D6;
	Mon,  5 Dec 2022 19:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670269461;
	bh=mdrr/4Kk9yMjkMwHYbYbdgAouBMiCdLP7fBBM/NUt2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yI8Djz+qCBSSBzZVU1wP0YFGQr+v4Wc+UJnMNch0iIKqqCGA8gZ+J3fMRnvpPeRld
	 A0eglJzJhV7bKZ9I8xXyLRWJFqd+1a91wK/7iaxAXEBs4y1yvYEWO+OArkZVJYD2P8
	 +NnkN4Q4gzFasufn53CugZXd/vJFK9paAyvmyurQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 135/153] parisc: Increase FRAME_WARN to 2048 bytes on parisc
Date: Mon,  5 Dec 2022 20:10:59 +0100
Message-Id: <20221205190812.530679366@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
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

[ Upstream commit 8d192bec534bd5b778135769a12e5f04580771f7 ]

PA-RISC uses a much bigger frame size for functions than other
architectures. So increase it to 2048 for 32- and 64-bit kernels.
This fixes e.g. a warning in lib/xxhash.c.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Stable-dep-of: 152fe65f300e ("Kconfig.debug: provide a little extra FRAME_WARN leeway when KASAN is enabled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/Kconfig.debug | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 42b6fff962b7..3ab05ca63c6e 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -253,8 +253,9 @@ config FRAME_WARN
 	int "Warn for stack frames larger than (needs gcc 4.4)"
 	range 0 8192
 	default 2048 if GCC_PLUGIN_LATENT_ENTROPY
-	default 1536 if (!64BIT && (PARISC || XTENSA))
-	default 1024 if (!64BIT && !PARISC)
+	default 2048 if PARISC
+	default 1536 if (!64BIT && XTENSA)
+	default 1024 if !64BIT
 	default 2048 if 64BIT
 	help
 	  Tell gcc to warn at build time for stack frames larger than this.
-- 
2.35.1



