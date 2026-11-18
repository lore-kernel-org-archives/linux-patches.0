Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025225;
	b=fV16+6ZusUeFnhrr3b9zTkO3CoiGV8alxW1oVoHmqk3HD/qF78NVH/ZPMEaotf7u+Yhu
	 KwqLLI0OqJHMdlQKKdA9RZsyBrdg54oNVBgVmZkOeP3eOUSJs88uUMvFIhVltro5zEzU3
	 sMfSnSY8hUor9WXoisAWEyA/o4xxptTf/CNcUdUARTipqxiuygnb7M4sSOcUBB7LDBV3P
	 QmgE92LWX28k1N+rk/2/f2JoqSx9djaZtfDdafDAlPeahyzLupHKYtX9cDer9iPtbHj3b
	 GiDk27fjjJA+Dc8iQ+6RJiFgYxihNF75RWfz0O3YzRJE05GfThPMVjkavuz8SpUx7tA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025225;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UTNYttU/3U9MxjwR5V1Q7Zz4J874l91S34s9s7mcVEY=;
	b=LcyIEuzucxXFWljTeLznAI9trKCXdmSJZ/rcatUZqY0ur8M55qUsEoo3xIMk3x3nLx6K
	 oi8gIWOwQ+MtF3RkysHp//S3njqqAFHA/MglNOrzl7x8Kfay4qgHGc/+/haGvfgAnDePd
	 6s/pzJEdtAHvttCT2voxERol0bsz5W/tdFA7nrd/005GQkRv4ZuqP+wuHADQwUt57eZQm
	 hGU//hJ14qgbraJg9YYqvHPF3h4eN3FxXUFjEd68gfWBzNjnoTebBKQ+PaH/P2JdPprYv
	 lZGobPkhRmTmj3pNWIiWLb/hsYZ64K7BkuVAlK5KPiHYw1i9Hmjr3UWs3MMvfeB/uNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BgBFBc9V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1F460A2615;
	Wed, 18 Nov 2026 18:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BgBFBc9V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F02B21F000CE;
	Wed, 18 Nov 2026 18:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025225;
	bh=UTNYttU/3U9MxjwR5V1Q7Zz4J874l91S34s9s7mcVEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BgBFBc9VjgYEcecgJESf/v2MMvAJevE7OBzbh6WLmbUMCnS6R03VtAjtAkS3DIxK7
	 pWUHikX7lp9/Xg1IaTUuUpP6qftGySNTy0oqqsJb8WVGdt8hLJTkCT+8PEE/8QbQQD
	 x0ZsQfONPkrosKQV0KRbe3PFkvKkzsRpuPBcg8s8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Igor Paunovic <royalnet026@gmail.com>
Subject: [PATCH 6.18 1003/2151] phy: rockchip: usbdp: Hold mutex in DP PHY configure
Date: Wed, 18 Nov 2026 15:45:38 +0100
Message-ID: <20261118150158.975600823@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Sebastian Reichel <sebastian.reichel@collabora.com>

[ Upstream commit 619233ce6b2329529c9f0ff9682d6e22d160ebd6 ]

rk_udphy_dp_phy_configure() accesses some variables from the struct
rk_udphy, which are updated independently from the USB-C framework.

The USB-C mux/orientation switch functions already hold a mutex to
ensure mutual exclusive access to the struct rk_udphy states, so
simply hold the same one in the DP PHY configuration function.

Reproducing problems due to this on real hardware would be really hard,
but could be possible when quickly re-connecting the USB-C connector.

Fixes: 2f70bbddeb45 ("phy: rockchip: add usbdp combo phy driver")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-phy/20260612164627.23D391F000E9@smtp.kernel.org/
Tested-by: Igor Paunovic <royalnet026@gmail.com> # Orange Pi 5 Plus
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260915-rockchip-usbdp-cleanup-part2-v15-7-8d507cb1174f@collabora.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-usbdp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/phy/rockchip/phy-rockchip-usbdp.c b/drivers/phy/rockchip/phy-rockchip-usbdp.c
index d1d78d9f7b096..0a3a75b75d422 100644
--- a/drivers/phy/rockchip/phy-rockchip-usbdp.c
+++ b/drivers/phy/rockchip/phy-rockchip-usbdp.c
@@ -1136,6 +1136,8 @@ static int rk_udphy_dp_phy_configure(struct phy *phy,
 	u32 i, val, lane;
 	int ret;
 
+	guard(mutex)(&udphy->mutex);
+
 	if (dp->set_rate) {
 		ret = rk_udphy_dp_phy_verify_link_rate(udphy, dp);
 		if (ret)
-- 
2.53.0



