Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5041828DDA;
	Fri,  5 Jan 2024 14:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XtLKfyFj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9704C433C7;
	Fri,  5 Jan 2024 14:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704465818;
	bh=tITjgX1JAzjZXBixOhS0LbJvzyciXHUcNUHKSWtEauw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XtLKfyFjOxhCfZ1+jkAOXfTauK0irMFWjCfEfRc83yONjtRB/s9aMtyv8z5QEHOk7
	 9v+UDjTpUzgngnpLs4LQiikOt8YxYKgA+TnRmY8jvBU9AyD/QMHNjtBL4j5zvVK9de
	 BZ6H2cRjOVVIb446hb9VIqxQCBsh1DWiAA5ycw9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hu Haowen <xianfengting221@163.com>,
	Saeed Mahameed <saeedm@mellanox.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 08/47] net/mlx5: improve some comments
Date: Fri,  5 Jan 2024 15:38:55 +0100
Message-ID: <20240105143815.839048294@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240105143815.541462991@linuxfoundation.org>
References: <20240105143815.541462991@linuxfoundation.org>
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

From: Hu Haowen <xianfengting221@163.com>

[ Upstream commit 6533380dfd003ea7636cb5672f4f85124b56328b ]

Replaced "its" with "it's".

Signed-off-by: Hu Haowen <xianfengting221@163.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Stable-dep-of: 4261edf11cb7 ("net/mlx5: Fix fw tracer first block check")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index 58d48d76c1b8a..8bd5b9ab5e157 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -687,7 +687,7 @@ static void mlx5_fw_tracer_handle_traces(struct work_struct *work)
 		get_block_timestamp(tracer, &tmp_trace_block[TRACES_PER_BLOCK - 1]);
 
 	while (block_timestamp > tracer->last_timestamp) {
-		/* Check block override if its not the first block */
+		/* Check block override if it's not the first block */
 		if (!tracer->last_timestamp) {
 			u64 *ts_event;
 			/* To avoid block override be the HW in case of buffer
-- 
2.43.0



