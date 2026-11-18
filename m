Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052132;
	b=X2HpviNNsp/ek9KL/BjoT/ho/TjqbHS2Vm38TdMb+MFtbjOypYZSvY9iL02TSD7Pq/uN
	 3wYQlrywWvQh6Vmf5lpCPdTBZ0JqI8qsXpp5LLB25bpfResArOjYeFq9btc032oROPyIw
	 C2+x40noQTiwoNzUAn7wMdjyGV2OO3ByNNYTuUb1vIQt8UE2RDh9Xnq9ZfB4tIdhBDyLJ
	 75QYJb5fTQlhBq8n4zxQmcsRcEeZift026wdffdnxzRVvXIoi4urhHPUh2suBHA2CkfQZ
	 LqehZ3SWe62uheOqhzkyYuEilAdQtG6ri3Vv4o7vjJuPrPnz4k0m6Ta1JLaUGxDHfOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052132;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c4+74fWHoHTd024rhuVYvaBppVWub+XaB3vwmIHUfS8=;
	b=4QoTnZ8SruqnOTbQ2JSVTvU0SKKsiW3NhuQfp1iyQzvYqNLPQZKX/d9USCiEcierojCF
	 LKkRxf72yVOOu3pUUciRETptmu4oY5cCdY9DPeIIHJcjU1lVsmRIv4tbwSFcRUO8rEmR5
	 ZlQ0G9qSzDzl1zeMXVJSbLWsuFKIaLtT7MCG4mtPlKS67EWj8nlEI7X3PxXTO5SSjBE/H
	 UjH6/1DeoPG5CiMqw+QUSPnpVunfmxn5hR0cEcZsSKrOu0hKWra15oqoet2EMRzRzFhtM
	 c5kCdmDcHc1iJGExBvAkTAKJMIhZsc3UQXCLAevXm5tt9v+HvHXp/z8aWMcj1XSeBTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=csJzhvLC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F02606A31C;
	Thu, 19 Nov 2026 01:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=csJzhvLC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B31371F000C4;
	Thu, 19 Nov 2026 01:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052132;
	bh=c4+74fWHoHTd024rhuVYvaBppVWub+XaB3vwmIHUfS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=csJzhvLC9W1uagvbcNPg0IXxoy0HnpV679MnjmUIbXuMLd6wbQ3+mJhextTlYkdZY
	 IwvzpYkWiEcxlg1BiBUHICwkOe2pTQQ/aZLgyHZ9exbi/5t5uBYYX1U4/N95pp5qS/
	 KxwS6dONlvQkyNfe01JeKsytmJByB5jejUD/bvgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serin Yeh <serin.yeh@intel.com>,
	Kieran Bingham <kieran.bingham@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0454/2214] media: i2c: ov8856: fix debug message to report actual CSI-2 lane count
Date: Wed, 18 Nov 2026 15:35:30 +0100
Message-ID: <20261118150029.344094209@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4b6c244126aad..3b1cb9823ffa2 100644
--- a/drivers/media/i2c/ov8856.c
+++ b/drivers/media/i2c/ov8856.c
@@ -2348,7 +2348,8 @@ static int ov8856_get_hwcfg(struct ov8856 *ov8856, struct device *dev)
 		goto check_hwcfg_error;
 	}
 
-	dev_dbg(dev, "Using %u data lanes\n", ov8856->cur_mode->data_lanes);
+	dev_dbg(dev, "Using %u data lanes\n",
+		bus_cfg.bus.mipi_csi2.num_data_lanes);
 
 	if (bus_cfg.bus.mipi_csi2.num_data_lanes == 2)
 		ov8856->priv_lane = &lane_cfg_2;
-- 
2.53.0



