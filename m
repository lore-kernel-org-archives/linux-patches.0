Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2D218F2DD;
	Mon, 28 Oct 2024 06:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097240; cv=none; b=qF4dtsigATbPBAw8mplEPDsjwBH7AVLcSnjqmBapwP0Sm3+rGlI+4fXv+YPNdMQx9hcxpZsKMRf8EQ5/VraWOV+ZduBWSRS2IBrSGeA9syfzaC5t9+VYWpRbstVq+gq1UI+KulovRe2VlZe2X3P4L7hwup/pS2nEyUpJB8gFdNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097240; c=relaxed/simple;
	bh=oWnTWUbpsbX7pEdE4B22JcVt6E05g9H2SghnWwlTLhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FaiBItTdV+ClfqF4wen98kV174UaAeHEpw0n4uaNccTWQk8SZ6MXidCsmOTsUmFyvZAWg34c7ArFgtu4Mn+s7tQKgKdh+Z4HkKHpv2C8yq7zZkzof/R3+Ac5F3B8EMhZRHqnlhUpOp2ZIoscnpIQSx2BYtdSQSosj5acnZ1EiAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hln5N+ST; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hln5N+ST"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D1B8C4CEC7;
	Mon, 28 Oct 2024 06:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097240;
	bh=oWnTWUbpsbX7pEdE4B22JcVt6E05g9H2SghnWwlTLhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hln5N+STB7viYbrqj3m9b5Q6+NI0so1AR4U0FZroPmanXa6gyo+03BoWew9oNUMIj
	 EPvEIFfPzZCSonVP1gXIUUpKsqtj27/f26OhtyEIxcZxCsoUiQlj+8udpToQpgwgc6
	 HmuaJ2jBsj4o+DLmidxc/Qhsiwr5XnF27SfCMo7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Gal Pressman <gal@nvidia.com>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 044/137] ravb: Remove setting of RX software timestamp
Date: Mon, 28 Oct 2024 07:24:41 +0100
Message-ID: <20241028062259.958251077@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gal Pressman <gal@nvidia.com>

[ Upstream commit 277901ee3a2620679e2c8797377d2a72f4358068 ]

The responsibility for reporting of RX software timestamp has moved to
the core layer (see __ethtool_get_ts_info()), remove usage from the
device drivers.

Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Link: https://patch.msgid.link/20240901112803.212753-8-gal@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 126e799602f4 ("net: ravb: Only advertise Rx/Tx timestamps if hardware supports it")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/ravb_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 756ac4a07f60b..96467b8d48b00 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1691,8 +1691,6 @@ static int ravb_get_ts_info(struct net_device *ndev,
 
 	info->so_timestamping =
 		SOF_TIMESTAMPING_TX_SOFTWARE |
-		SOF_TIMESTAMPING_RX_SOFTWARE |
-		SOF_TIMESTAMPING_SOFTWARE |
 		SOF_TIMESTAMPING_TX_HARDWARE |
 		SOF_TIMESTAMPING_RX_HARDWARE |
 		SOF_TIMESTAMPING_RAW_HARDWARE;
@@ -1703,6 +1701,8 @@ static int ravb_get_ts_info(struct net_device *ndev,
 		(1 << HWTSTAMP_FILTER_ALL);
 	if (hw_info->gptp || hw_info->ccc_gac)
 		info->phc_index = ptp_clock_index(priv->ptp.clock);
+	else
+		info->phc_index = 0;
 
 	return 0;
 }
-- 
2.43.0



