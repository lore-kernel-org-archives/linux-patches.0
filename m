Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061911;
	b=ygRLVj2C9ziSGnomE7dsLEbMq1hCMD1rc33HickTaLHZ4Vk8M73LQYBnxkzNdxdRsFTB
	 HxYwz44Caev0yirOpesKVWcX+ZcHTvylLPOncYYNCWTmBLZSNUAPHcUArSJ2IoP2Kd3KO
	 SNgDCv52BOXCUNqJOoqR+2QXhpIzUvrV9L2X8mrmZIWzNMTwWjGm7XkU716P5p5cP26OZ
	 CQ4zTQhDMXn4b+fPr5+/8DHO0FSA7oSQutOmji6zLOwhSQ8gcdMdVeWhunVrvRxsIpd9C
	 kSBxeoIkzLNzrUUCSgeoyEqdUStRKKbv9csr0TIqf+1u/LoysvH2m53tpA+KFt7CFpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061911;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ooOxrLeBHIsrYQ0wQ42xfSAF6HvmFlU4RjxfHk+mAfA=;
	b=AhW2+im0cy249HwThUrJLUoOjAMAatrjAFWFugtcoK4jse8Qr/IYQG6Nxo74hXgr8nEy
	 9v+uG3dNy3XRn5HCKNbyIH6q10GAy6OgaSnLO3o3xETDHI6Sbs7drDa3qfQ8VE4fUkWUG
	 tiOuqeuWTE0FYoKSaxknOUkU9qW0YM0FltbohdONq0wv5TgIxnthmUzskfTcsU9wrqaJj
	 DhGEwG7Vre1dGTN1wmXVGC36kDP4wffX4awlmWBYSvb8t5FkIjzgq6DCopu2hfTB1LE/T
	 wGcgq7aPgja0jaKfsm58sJh8OsrSNWjzKTATsOSFtO3oz5RG7qr7cPv8C1LQzIW6snQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TwYn03lq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5F4606A326;
	Sat,  7 Nov 2026 14:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TwYn03lq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AFDA1F0089F;
	Sat,  7 Nov 2026 14:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061911;
	bh=ooOxrLeBHIsrYQ0wQ42xfSAF6HvmFlU4RjxfHk+mAfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TwYn03lqbdOgBLZnn2kaTNX2hLf1x9oGJTP9AEwcCAjNeNJ8HztWHvV9xFO8r1c88
	 O8VH0qazMILtjZ/TiC+stYLu1+aLL+M9skYro/s+ewDfU4rpnHFImyG4nADwgkuf3z
	 U3GtFtllXDd6ORlQjIq9VjDpw79nuWxmVbhZJ3lE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serin Yeh <serin.yeh@intel.com>,
	Kieran Bingham <kieran.bingham@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0920/1536] media: i2c: ov8856: fix debug message to report actual CSI-2 lane count
Date: Sat,  7 Nov 2026 08:48:56 -0500
Message-ID: <20261107135023.485070195@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1062eac8fbc3b..1381bf4c3d8b2 100644
--- a/drivers/media/i2c/ov8856.c
+++ b/drivers/media/i2c/ov8856.c
@@ -2327,7 +2327,8 @@ static int ov8856_get_hwcfg(struct ov8856 *ov8856, struct device *dev)
 		goto check_hwcfg_error;
 	}
 
-	dev_dbg(dev, "Using %u data lanes\n", ov8856->cur_mode->data_lanes);
+	dev_dbg(dev, "Using %u data lanes\n",
+		bus_cfg.bus.mipi_csi2.num_data_lanes);
 
 	if (bus_cfg.bus.mipi_csi2.num_data_lanes == 2)
 		ov8856->priv_lane = &lane_cfg_2;
-- 
2.53.0



