Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035774;
	b=CtJjpl2zdGWLG6figkKEBJcUvwjtLvep9KUFz8KtfEhLK0Ctrzdv4QJ34SvCHOKJ8Pwm
	 c9/zm2VxGPjDwq7KbMs3e1yNP3yLQEI79efoxqot1RDZfWaPodcuqtErSmaGSXRsPhcAy
	 sCTJ/8BChxvsWPGaG5rK5JnNemuDaCKW2JZZeF45XrhPRIH/el6I5aW+d2aZpMbb5Qe2w
	 Qj9xYK4qrhy0TZsDk972gyCjGynPk5k1qC0z9WRk+RLp1isJIKZ27PUypgCk0KA45Dz4b
	 3fba09lsYoawHgH+HigyY9TRxl+Z5aR3JEsFoLPZSCiFq9ZNbo5LgcEibk2r/+FPulQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035774;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FyeWh9ydxsA0SR600tRbUynus7tyM0KirV/rLHSONHI=;
	b=aXgMbesXT7Ekef4KbdrH5gSeRXZEW7X1uT6hZ75BB/pN2NfjRGL1NWpr3G2EMFMuL/fU
	 Nt6GCn136EtdkKO10YAtMwk95vC9MV1ij6J2FhGxYnbldvM8B+tgHr7F8J7UndXRXjOtV
	 K82N2LvpThm9hRlboUWvisvEAVUoDFlMGKx+mdvFaZRnKL4zXixaNf1/V56jc6LzpKoIx
	 +tmIuPDaR9JIbqYX/QRZU3s91fiQjL9jiVFd51kR38J6Y23gzIo7Lij3aZk/uPkbBXg9N
	 GZ3pfsjus/9EQDMX+REdoTwUAciEn+3a/no0VqeRTzbBNEDhuxApMBwlaA2QLLYrh1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uIi5KWR0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A23606A31C;
	Wed, 18 Nov 2026 21:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uIi5KWR0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423DF1F000C4;
	Wed, 18 Nov 2026 21:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035773;
	bh=FyeWh9ydxsA0SR600tRbUynus7tyM0KirV/rLHSONHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uIi5KWR0kvZD2TwBGUrNBYCh9IhiqSA0SAeXGuW/4HBGVxlI60ydQjj8zcOG35JmX
	 HDuuLUuivhe8oLUhdrmVclhV8pKoNcrpTICLwn8rg+A05I3GDPCShKu8vS/+XT3jti
	 y9yLdmrkl6pBYoHv2bYgIQWzG1xTCgX+IDaGSAfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serin Yeh <serin.yeh@intel.com>,
	Kieran Bingham <kieran.bingham@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0821/3318] media: i2c: ov8856: fix debug message to report actual CSI-2 lane count
Date: Wed, 18 Nov 2026 15:24:03 +0100
Message-ID: <20261118150343.686368844@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 91981437c572d..1d1595b3cf1aa 100644
--- a/drivers/media/i2c/ov8856.c
+++ b/drivers/media/i2c/ov8856.c
@@ -2374,7 +2374,8 @@ static int ov8856_get_hwcfg(struct ov8856 *ov8856, struct device *dev)
 		goto check_hwcfg_error;
 	}
 
-	dev_dbg(dev, "Using %u data lanes\n", ov8856->cur_mode->data_lanes);
+	dev_dbg(dev, "Using %u data lanes\n",
+		bus_cfg.bus.mipi_csi2.num_data_lanes);
 
 	if (bus_cfg.bus.mipi_csi2.num_data_lanes == 2)
 		ov8856->priv_lane = &lane_cfg_2;
-- 
2.53.0



