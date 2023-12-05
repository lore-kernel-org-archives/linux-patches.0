Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C24A6FB1;
	Tue,  5 Dec 2023 03:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Das8/2E4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1DC6C433C7;
	Tue,  5 Dec 2023 03:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701748071;
	bh=bFvRa91DVHoUuO1RG5oxD8nhoURejLIH33PtwXdXDn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Das8/2E4TrTToae/RL2fxvNusidX7nHPs7IW+YoZHRXYW2Jsfrln3Hn6H5+3IDgt4
	 Zh7aQNtmrW/2rMmL58esQ+rjssMtw4IxOxMM932Vq80+OgbKKdDC7UJjNNc80BjtH6
	 CRuTVjJvqSyDXZEaTbKs5MXHWYivv9QgtBOc9NDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Yongjun <zhengyongjun3@huawei.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 93/94] mmc: core: convert comma to semicolon
Date: Tue,  5 Dec 2023 12:18:01 +0900
Message-ID: <20231205031527.991466664@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031522.815119918@linuxfoundation.org>
References: <20231205031522.815119918@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zheng Yongjun <zhengyongjun3@huawei.com>

[ Upstream commit 6b1dc6229aecbcb45e8901576684a8c09e25ad7b ]

Replace a comma between expression statements by a semicolon.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Link: https://lore.kernel.org/r/20201216131737.14883-1-zhengyongjun3@huawei.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: 8155d1fa3a74 ("mmc: block: Retry commands in CQE error recovery")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 7caf9ef27d227..c88e991f787be 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -564,10 +564,10 @@ int mmc_cqe_recovery(struct mmc_host *host)
 	host->cqe_ops->cqe_recovery_start(host);
 
 	memset(&cmd, 0, sizeof(cmd));
-	cmd.opcode       = MMC_STOP_TRANSMISSION,
-	cmd.flags        = MMC_RSP_R1B | MMC_CMD_AC,
+	cmd.opcode       = MMC_STOP_TRANSMISSION;
+	cmd.flags        = MMC_RSP_R1B | MMC_CMD_AC;
 	cmd.flags       &= ~MMC_RSP_CRC; /* Ignore CRC */
-	cmd.busy_timeout = MMC_CQE_RECOVERY_TIMEOUT,
+	cmd.busy_timeout = MMC_CQE_RECOVERY_TIMEOUT;
 	mmc_wait_for_cmd(host, &cmd, 0);
 
 	memset(&cmd, 0, sizeof(cmd));
@@ -575,7 +575,7 @@ int mmc_cqe_recovery(struct mmc_host *host)
 	cmd.arg          = 1; /* Discard entire queue */
 	cmd.flags        = MMC_RSP_R1B | MMC_CMD_AC;
 	cmd.flags       &= ~MMC_RSP_CRC; /* Ignore CRC */
-	cmd.busy_timeout = MMC_CQE_RECOVERY_TIMEOUT,
+	cmd.busy_timeout = MMC_CQE_RECOVERY_TIMEOUT;
 	err = mmc_wait_for_cmd(host, &cmd, 0);
 
 	host->cqe_ops->cqe_recovery_finish(host);
-- 
2.42.0



