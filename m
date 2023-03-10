Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3814C8825
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:59:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D565C433D2;
	Fri, 10 Mar 2023 14:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460348;
	bh=q7q0vhpP5EDbtfq0XQMlYN2j8y5A6PCx4dJkx1d9pNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oTOejGO3WEXOdEuNPUBn9WHQtEMh0Kv4Z5cTPHfhV1NiUd/0t8tmFuCnkkywoPhdr
	 PpvTMVuKUbWdNXBYJSrMhdkHBs7PwcdPx6kNEOxmU4A6g9Zm1oUOUjYGMeXtNDTnwt
	 nLm6k40cWYIrzreQenuB3umlGvKhtywKaRvCPm2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 304/529] net/mlx5: fw_tracer: Fix debug print
Date: Fri, 10 Mar 2023 14:37:27 +0100
Message-Id: <20230310133819.092910169@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 988c2352273997a242f15c4fc3711773515006a2 ]

The debug message specify tdsn, but takes as an argument the
tmsn. The correct argument is tmsn, hence, fix the print.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index 40d7bfca37499..0a011a41c039e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -603,7 +603,7 @@ static int mlx5_tracer_handle_string_trace(struct mlx5_fw_tracer *tracer,
 	} else {
 		cur_string = mlx5_tracer_message_get(tracer, tracer_event);
 		if (!cur_string) {
-			pr_debug("%s Got string event for unknown string tdsm: %d\n",
+			pr_debug("%s Got string event for unknown string tmsn: %d\n",
 				 __func__, tracer_event->string_event.tmsn);
 			return -1;
 		}
-- 
2.39.2



