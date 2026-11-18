Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044915;
	b=N3HOdkKiGSGeFLw6ASiT1DWRYlYKPogROeejCfpK20rtvIKhlElJ8ZwotpB2lNFJLNfz
	 sN0yxZuGQOdEZHvI1lRcn0SvfadlwbQKixZwbHVC3u8HFnI8kojFm1psxBKV3pQ2ve1XT
	 +QaWVmjUqCKJg1PVtp0SPDztZruNHyhaxnZh/uIIb/9QsW2XKkMTyOU+wp0reQanUNon2
	 wufp+NoKoEtelyz0/hUFcBzr1idAXCrb42Z3Q5/bYUcPXOk3s9O8ZQx6jDgUowKKfi56P
	 3t1ptlqnLbkMed1QG6Pccb58bkhBi7HNC1F591F2bDoXqodEit4/rLYb5oCsn9H/Vbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044915;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lvkUAiaX5UCXLRLT8oEP6hfYXRsxV8gF4dcekCJ2JZo=;
	b=M15J6ZKinqfesYdEyMzqa+c9pIKGGkskBgjMmgx3YOEji8sGqAWHrSb34HzU+SzYYAHR
	 zzp6RReYat+WeUXJI+WZybBzHEkCwdaiSsR5PzA5aghb/4xeqEy46XwSMXgQ+VmtJ+X0e
	 I0PrYI1mFbnkjpcAGmS22qNAhQK140wu/NsFHbPix/dUgspEmtbUcPckN4oaakdkpvRk1
	 kcZF3kypNwsgtOfDzkZi9X2j3wwz8pny3v33AfJLCBmE+sw2vlRUj/9Erdqh+UUQsbNTj
	 PNqiyYyuO44Rw3mrBsNycLQUmJj2NIgeIil9DFbK6JdpnUym3UwJFSMeb0eqns35ZBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oXVpvnmI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3425C606A337;
	Wed, 18 Nov 2026 23:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oXVpvnmI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8DE1F000C4;
	Wed, 18 Nov 2026 23:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044915;
	bh=lvkUAiaX5UCXLRLT8oEP6hfYXRsxV8gF4dcekCJ2JZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oXVpvnmIbSrU+Ot//XAc33r0BbNpWHQht9F3zsIbnkx/H+qYSf4Uki4W5qjCGnPQ1
	 erb/2TbPve7dRbE4TsJNQAHhFf/ftIMQ08U8JJ/nB4tgjKTVSMfN2pqekqHTUZ/tQN
	 zkEi+KOSbgXAd7PS1emc9zGubAblEzKqb3wGb/O4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serin Yeh <serin.yeh@intel.com>,
	Kieran Bingham <kieran.bingham@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0730/2857] media: i2c: ov8856: fix debug message to report actual CSI-2 lane count
Date: Wed, 18 Nov 2026 15:29:24 +0100
Message-ID: <20261118150227.832679497@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Serin Yeh <serin.yeh@intel.com>

[ Upstream commit a15976e69b1c70ea16ef1f7172a846f6ef5dfa14 ]

The driver currently prints the number of data lanes using
ov8856->cur_mode->data_lanes in ov8856_get_hwcfg(). However,
the ov8856->cur_mode structure is not assigned to a clearly
supported mode at that point. Due to the missing pointer,
enabling dynamic debug may lead to a kernel panic.

Instead, the correct number of CSI-2 data lanes should be taken
from bus_cfg.bus.mipi_csi2.num_data_lanes, which represents the
real hardware configuration determined at runtime.

Fixes: c492ec9ae9ed ("media: ov8856: Add support for 2 data lanes")
Cc: stable@vger.kernel.org
Signed-off-by: Serin Yeh <serin.yeh@intel.com>
Reviewed-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov8856.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov8856.c b/drivers/media/i2c/ov8856.c
index 72af528d02b60..c509a0e540602 100644
--- a/drivers/media/i2c/ov8856.c
+++ b/drivers/media/i2c/ov8856.c
@@ -2370,7 +2370,8 @@ static int ov8856_get_hwcfg(struct ov8856 *ov8856, struct device *dev)
 		goto check_hwcfg_error;
 	}
 
-	dev_dbg(dev, "Using %u data lanes\n", ov8856->cur_mode->data_lanes);
+	dev_dbg(dev, "Using %u data lanes\n",
+		bus_cfg.bus.mipi_csi2.num_data_lanes);
 
 	if (bus_cfg.bus.mipi_csi2.num_data_lanes == 2)
 		ov8856->priv_lane = &lane_cfg_2;
-- 
2.53.0



