Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545472C692;
	Fri,  5 Jan 2024 14:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XdEDzzJY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A6EBC433C7;
	Fri,  5 Jan 2024 14:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704465689;
	bh=b30KRt62vTzSMwhgrYVVxEZCthQ+CqiBXofAf+AzjUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XdEDzzJY4QUp0Oe74FcrIOS2GMs0gPwoc4CLjNw5JApK6B+O8FYKohVNWe+rxHRZt
	 9PpBzESlWbWHDVrkPbnOLR3SNlNRsgrE4tuhjPDV2pHXIW65gTsV7++8Pih7SPqebo
	 AP5stwFeUq+XSyv1CwdYmMJuh4DlAg3F6zMq06qk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hu Haowen <xianfengting221@163.com>,
	Saeed Mahameed <saeedm@mellanox.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 10/41] net/mlx5: improve some comments
Date: Fri,  5 Jan 2024 15:38:50 +0100
Message-ID: <20240105143814.392205423@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240105143813.957669139@linuxfoundation.org>
References: <20240105143813.957669139@linuxfoundation.org>
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
index 97e6b06b1bff3..21dbb25552140 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -651,7 +651,7 @@ static void mlx5_fw_tracer_handle_traces(struct work_struct *work)
 		get_block_timestamp(tracer, &tmp_trace_block[TRACES_PER_BLOCK - 1]);
 
 	while (block_timestamp > tracer->last_timestamp) {
-		/* Check block override if its not the first block */
+		/* Check block override if it's not the first block */
 		if (!tracer->last_timestamp) {
 			u64 *ts_event;
 			/* To avoid block override be the HW in case of buffer
-- 
2.43.0



