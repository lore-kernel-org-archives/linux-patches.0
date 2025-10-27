Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33BC32E68F;
	Mon, 27 Oct 2025 19:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593205; cv=none; b=t0x+LNwucejFmInIvUvMurha21gvrQDJ7PBbgkq0NuXzFCsppjXbpWxSyVJhEXQN2SkX8OSS6mTGM2jpGz3Q/r3aDwNsnbbvucl2TTKesS5QxCSGrQ6HL8pASpT1bLakqQBXaZN3VkJO15nU3SUxXicTzkj7tRF7fh3l6r26yYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593205; c=relaxed/simple;
	bh=TEbMnDmZp/AfkQZ8ZEbE6C0qww7sWJFboiJT5DgXZFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bVHrXVHD+DNy56xVuuDwkSIriGyzJ2E+RHvo43AJayk/OF8pPE9q85oy0V9is5xobmoORzIQkkOjo4DEYEdxxmfoe42t4EPMaKJUJFeRBORINcz9wKMp/CLAbbklQMLM1Sc4gKSQfZnKJck9KHFd8gXBAZ7zNpT2R1iZAHtWk4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C+bqASI8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C+bqASI8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57820C4CEF1;
	Mon, 27 Oct 2025 19:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593205;
	bh=TEbMnDmZp/AfkQZ8ZEbE6C0qww7sWJFboiJT5DgXZFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C+bqASI8CIHe2WodaZqHnZIj5lZTnflNDNuuyCe8MzXEeIjQwTP+ALWqvEeUjJC1y
	 6wmdKTUkvlFi9YDzowwugpddYKl0UWzkWS9fnWh/rM/EwVp7B7EM0PPdGwFMNjkFNb
	 /XL6W7ttds11TV8+9Vu9Vnll9J+OBrTN2FQG1SZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 053/184] ptp: ocp: Fix typo using index 1 instead of i in SMA initialization loop
Date: Mon, 27 Oct 2025 19:35:35 +0100
Message-ID: <20251027183516.325543359@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

[ Upstream commit a767957e7a83f9e742be196aa52a48de8ac5a7e4 ]

In ptp_ocp_sma_fb_init(), the code mistakenly used bp->sma[1]
instead of bp->sma[i] inside a for-loop, which caused only SMA[1]
to have its DIRECTION_CAN_CHANGE capability cleared. This led to
inconsistent capability flags across SMA pins.

Fixes: 09eeb3aecc6c ("ptp_ocp: implement DPLL ops")
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20251021182456.9729-1-jiashengjiangcool@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_ocp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 4e1286ce05c9a..f354f2f51a48c 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -2550,7 +2550,7 @@ ptp_ocp_sma_fb_init(struct ptp_ocp *bp)
 		for (i = 0; i < OCP_SMA_NUM; i++) {
 			bp->sma[i].fixed_fcn = true;
 			bp->sma[i].fixed_dir = true;
-			bp->sma[1].dpll_prop.capabilities &=
+			bp->sma[i].dpll_prop.capabilities &=
 				~DPLL_PIN_CAPABILITIES_DIRECTION_CAN_CHANGE;
 		}
 		return;
-- 
2.51.0



