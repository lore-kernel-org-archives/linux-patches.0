Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F6743AB9
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dnpf+LJM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E85F5C433C7;
	Wed, 15 Nov 2023 20:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081179;
	bh=Jlqqcj92CJBoDgfJIz9L1vBWdgoLdUqK6o5vEhYNRSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dnpf+LJM2dcQBOy6QtxjUva5N3y4WAm2v/p+XnT8gmskbKxuxgSRzOiYxlZgp36bv
	 zydT9urNXv2zyaO1tZIblt3uDAJ+i6G8jkF8nKc/YpcKWkKLukMVsr1sRV3lxXkvOu
	 /Dl06bfv/02CCb3BZgmbg7yzY4PJ5GqClPiHp4l0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 86/88] fbdev: fsl-diu-fb: mark wr_reg_wa() static
Date: Wed, 15 Nov 2023 15:36:38 -0500
Message-ID: <20231115191431.212812657@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191426.221330369@linuxfoundation.org>
References: <20231115191426.221330369@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit a5035c81847430dfa3482807b07325f29e9e8c09 ]

wr_reg_wa() is not an appropriate name for a global function, and doesn't need
to be global anyway, so mark it static and avoid the warning:

drivers/video/fbdev/fsl-diu-fb.c:493:6: error: no previous prototype for 'wr_reg_wa' [-Werror=missing-prototypes]

Fixes: 0d9dab39fbbe ("powerpc/5121: fsl-diu-fb: fix issue with re-enabling DIU area descriptor")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/fsl-diu-fb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/fsl-diu-fb.c b/drivers/video/fbdev/fsl-diu-fb.c
index bc9eb8afc3137..0a86a91614085 100644
--- a/drivers/video/fbdev/fsl-diu-fb.c
+++ b/drivers/video/fbdev/fsl-diu-fb.c
@@ -495,7 +495,7 @@ static enum fsl_diu_monitor_port fsl_diu_name_to_port(const char *s)
  * Workaround for failed writing desc register of planes.
  * Needed with MPC5121 DIU rev 2.0 silicon.
  */
-void wr_reg_wa(u32 *reg, u32 val)
+static void wr_reg_wa(u32 *reg, u32 val)
 {
 	do {
 		out_be32(reg, val);
-- 
2.42.0



