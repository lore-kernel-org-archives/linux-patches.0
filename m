Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219CD3DBAD
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eDPfjDb9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80DDCC433CA;
	Wed, 15 Nov 2023 20:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078523;
	bh=IUe8/pu9sgYhh6IuRuPwJf6ZGE+U9xgNR9JDA1xfpD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eDPfjDb9/95Zfj1T9mV4mTnSLpdtQq/Y/Cu+T72HvZY6KT0CFiyx8shu5VbkNoNX6
	 R9yPU2jsGcv+5ZWzOxZ2bIF+dKvKram/rVpxtdAnP4jip6c6lyLOKzR1GEpDX1CJZV
	 b+qiweHKhrzO1cO7omDDbRgmCqfTGoHSrX0Q4yj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 374/379] fbdev: fsl-diu-fb: mark wr_reg_wa() static
Date: Wed, 15 Nov 2023 14:27:29 -0500
Message-ID: <20231115192707.283809616@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e332017c6af62..ce3c5b0b8f4ef 100644
--- a/drivers/video/fbdev/fsl-diu-fb.c
+++ b/drivers/video/fbdev/fsl-diu-fb.c
@@ -490,7 +490,7 @@ static enum fsl_diu_monitor_port fsl_diu_name_to_port(const char *s)
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



