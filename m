Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3CEA15B10D;
	Mon, 28 Oct 2024 06:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097692; cv=none; b=icpY/Q3uSwrJoZqlpf58ipWgJAF1oNJM4CDZIMGvNhCMzOaGmsGhbJIdy2v7TVVQIdBbHIJX/ALKeMCU/S/YZIHwQ37JO1DuN0OR1DkYAcuzzfxHkCb2a6jVEGX7ljeqFURdx6SA5cTdmkhfYj17JTzZeenlf+DKFUEYUaOlIxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097692; c=relaxed/simple;
	bh=W3GRvjaH34BEpuKlv0+4lGGpoPJPq4HFE1SE8pQH4IU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h/cJv91ZougV1NcakNPfNEmWHpBpYFp4voUjdt0Yd0nfpOZuGgSam137Uua7FipvZMOaEJkD36vKkedPXuRQ0aiqXhy4dReLDmVIh9C4uEoOjzqzPeVRyBDK7yNdp44nHUjsCVp7hPP3J/Tageg6d8NWdFu01a/14uLhk/M3FLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tVlXrliD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tVlXrliD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B5E9C4CEC3;
	Mon, 28 Oct 2024 06:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097691;
	bh=W3GRvjaH34BEpuKlv0+4lGGpoPJPq4HFE1SE8pQH4IU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tVlXrliDuGqx3AblkNriUb5QuzrbHAeF8OgfI7PACVxn6hJzc033Gjm6NFZwT5ZH4
	 0qzTcg/ahCkck1ZsKhksE7uE1CbSYnQkbGM7y21pNqcCdEZlzLCRCyfVl4fCQt5UlG
	 0zudbo3FRavStFghgJR8bgrNcMsrLOvAxn29+LSU=
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
Subject: [PATCH 6.6 069/208] ravb: Remove setting of RX software timestamp
Date: Mon, 28 Oct 2024 07:24:09 +0100
Message-ID: <20241028062308.352122575@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c6897e6ea362d..8f62cc4517918 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1675,8 +1675,6 @@ static int ravb_get_ts_info(struct net_device *ndev,
 
 	info->so_timestamping =
 		SOF_TIMESTAMPING_TX_SOFTWARE |
-		SOF_TIMESTAMPING_RX_SOFTWARE |
-		SOF_TIMESTAMPING_SOFTWARE |
 		SOF_TIMESTAMPING_TX_HARDWARE |
 		SOF_TIMESTAMPING_RX_HARDWARE |
 		SOF_TIMESTAMPING_RAW_HARDWARE;
@@ -1687,6 +1685,8 @@ static int ravb_get_ts_info(struct net_device *ndev,
 		(1 << HWTSTAMP_FILTER_ALL);
 	if (hw_info->gptp || hw_info->ccc_gac)
 		info->phc_index = ptp_clock_index(priv->ptp.clock);
+	else
+		info->phc_index = 0;
 
 	return 0;
 }
-- 
2.43.0



