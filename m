Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294961BDF1;
	Wed,  3 Jan 2024 17:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k/Fjc0WX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84543C433C7;
	Wed,  3 Jan 2024 17:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301360;
	bh=L9P1erfDwbjhN3BL+EUn6s0/JjuQwXTTG7+kzdc5ik4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k/Fjc0WXhH5SpFPMPCu3iu+CEE+DQDBXq6I1Y9Q7OQQqThBMbTPMaduzK9Y3PBIST
	 ecaaIWNE55SQwK/zwxA2Spp5lKmxaWRTZmUi9sdzon+9d1VyVFFA5MTL5EhzwErffs
	 nVqfki4f/1C/XCpX5iwxqXWOsre5X5aZhDpF1nYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Feras Daoud <ferasda@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 11/95] net/mlx5: Fix fw tracer first block check
Date: Wed,  3 Jan 2024 17:54:19 +0100
Message-ID: <20240103164855.790445995@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164853.921194838@linuxfoundation.org>
References: <20240103164853.921194838@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Moshe Shemesh <moshe@nvidia.com>

[ Upstream commit 4261edf11cb7c9224af713a102e5616329306932 ]

While handling new traces, to verify it is not the first block being
written, last_timestamp is checked. But instead of checking it is non
zero it is verified to be zero. Fix to verify last_timestamp is not
zero.

Fixes: c71ad41ccb0c ("net/mlx5: FW tracer, events handling")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Feras Daoud <ferasda@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index b69ab30ecf03b..efa2e0a8fa1d1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -691,7 +691,7 @@ static void mlx5_fw_tracer_handle_traces(struct work_struct *work)
 
 	while (block_timestamp > tracer->last_timestamp) {
 		/* Check block override if it's not the first block */
-		if (!tracer->last_timestamp) {
+		if (tracer->last_timestamp) {
 			u64 *ts_event;
 			/* To avoid block override be the HW in case of buffer
 			 * wraparound, the time stamp of the previous block
-- 
2.43.0



