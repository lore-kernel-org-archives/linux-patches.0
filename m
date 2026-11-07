Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062753;
	b=3aYHJf+l1Px8HMm/uav5rXx8Xed3wNDAMa7mLGJh1Kj0WiX5Tvwez7VPjvM4e0lledfP
	 5phSWnezVbYrm8cyLwpKxVdHTctIb9Y4MCDb/P2OWibKc4OO0iJjM8o7gnmKSUzYjJj46
	 TcHAJ64Xe/t4e3RgMfOrXVS4d2fAtOYIFEAVam79zv0qdpOkVY0daHewjXLbMhTNXorcO
	 H1NHzrYJ9HARnomFgXi/01woRdqtfdYTuYtmlDQFzInTP1pykc6E7sVUBXepB8nPIcSxn
	 WKhjkNuTPmMPhuBaF/Ck7wvpjNB9rX3jwQmh3/LYt0at99cSJJhvfnkbutF7Gpzg0Ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062753;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tn5lbCZRkwLV4OFvpG/ixoXgWNCssWLi7cDSQpTTrbw=;
	b=V6OtvHscchXHXBLRDNN4PfHYJo3jpX0Qb2Df80iGRfWbiNvqdJOMPqkNDgJgGmVZI0bo
	 lV3NERXkHBxZI2eijyThzxvjltNpq+87Fbkd0dd7k8bl2o0fDXP4Ae+73mJt/H0NJcSI3
	 vkVVeuQpmsqjm8HHrTY/EO6sL1HUcf4sMFtSfQl8vAOLmiQOVTyMvA4nJRXGjLgJXt6zV
	 5esiplba8hBGuN1mkq3uRx/lrHy9tbOc7cgzxdJiXq5StlKe+IThWykoI25DPa0e9+9Pi
	 4PquEqM05O4HGkShd7sCUxQsLkkwDNwbn86PwIPqGzkULqNP/0bjhm8qhw121PqdrFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y9NS92ip;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69468606A32D;
	Sat,  7 Nov 2026 14:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y9NS92ip
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F40211F0089F;
	Sat,  7 Nov 2026 14:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062753;
	bh=tn5lbCZRkwLV4OFvpG/ixoXgWNCssWLi7cDSQpTTrbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y9NS92ipGamYJGo8FHVm/mK8fJpz7CuoROs9WyqmpA8E5NqHEmcF6s4/aKG5qkx+o
	 /na3P/ne2OHcUbvhZe8I5+c9jzwEQ/e5mmckD5eOijPH/R+ckD0ODpmODcP3oYJCpI
	 AFs01URM75HqGGBIC7yJUQvyRq8kfHm0FtV5E1/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serin Yeh <serin.yeh@intel.com>,
	Kieran Bingham <kieran.bingham@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 066/869] media: i2c: ov8856: fix debug message to report actual CSI-2 lane count
Date: Sat,  7 Nov 2026 08:45:48 -0500
Message-ID: <20261107134854.585919783@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 2e104734ef0b1..27d7ca17d4d68 100644
--- a/drivers/media/i2c/ov8856.c
+++ b/drivers/media/i2c/ov8856.c
@@ -2307,7 +2307,8 @@ static int ov8856_get_hwcfg(struct ov8856 *ov8856)
 		goto check_hwcfg_error;
 	}
 
-	dev_dbg(dev, "Using %u data lanes\n", ov8856->cur_mode->data_lanes);
+	dev_dbg(dev, "Using %u data lanes\n",
+		bus_cfg.bus.mipi_csi2.num_data_lanes);
 
 	if (bus_cfg.bus.mipi_csi2.num_data_lanes == 2)
 		ov8856->priv_lane = &lane_cfg_2;
-- 
2.53.0



