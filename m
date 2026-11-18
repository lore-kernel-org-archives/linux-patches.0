Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018368;
	b=lG/sXu/HaUbkBEKJnabT+EPdC++bkA7b0CSy+NiaNWf/iRoiA5Ua6IDsGHaqEFjoWHL2
	 NOvSExg/zFbNxpaHre/bcN19nQpcAwS0K6O8vrwV6tPqgpULZh99wEjIayaH6UyDHBMXj
	 4xigK1UPR4n8GA/wA7u2+iVxV+ENKPAO8CwI2K4xFPb9dcl6p7RMRz/eVdfcoxJi+uxXf
	 qXg/pQnOcNCk7AuABpuLxlAb+cDkXhjLCiEuUhKSSXynNH6zG1SrTvAla/Qf53XwBrFP/
	 xhSr5Zf98HrK9P2DXMN7wh6n7CUzWG/F+LSzpdww/1lnE41YAYXVD9YaTtdYpW4iyBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018368;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1YNshP8imJzG3UThh5tsvuF6k4uK0aXCQTHmWBgErR4=;
	b=WOyFomjL4+0PfFZar2PlQht4X9pMb3bvmp2P+dxoTua6t75EKgvU3gLtWhmR153LibBH
	 tODCAO70vKq8Oxa0kXGgBxhquvT9QxM2bQE1RueS+PVc5GIyu3I2SIRSvgxLSQ0uCLdWQ
	 Tic4ndVvVb0hSKBaoAQyM2aehXzs8To4fvln1uuY6GREpyKDkzPSkfE2ypTGR4JjDejWF
	 4T6xy4tWjzUCaPgId8nbJdULqv+h3hQJTxwttejzwls85jtgHd4Dt953iGUbONStF2GAl
	 BKobE9oB0WQ45LS2wVCW4HrMOAogwAdWlN1PgcziceeKIWhpczF5INxlphQeeoI5Lhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=txdyR3I3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3440C606A31C;
	Wed, 18 Nov 2026 16:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=txdyR3I3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 889121F000C4;
	Wed, 18 Nov 2026 16:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018368;
	bh=1YNshP8imJzG3UThh5tsvuF6k4uK0aXCQTHmWBgErR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=txdyR3I3Y+n2iqWIi9w1ao8hQP8YswGrKeWyK0OYK7SfsWTlSdQ2JuuVM3T5hkJXT
	 XT8NH5TrnpoFUzj2YgIYG/1HG4gSN+slRcCEDYxcsSkyjrN6VYSK9MlEOaj7M5DZxw
	 V0Lffcm7p1efO6WMW8mn06brakczk1fpx00KKvHI=
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
Subject: [PATCH 7.3 1213/2651] phy: rockchip: usbdp: Hold mutex in DP PHY configure
Date: Wed, 18 Nov 2026 15:40:53 +0100
Message-ID: <20261118150331.666435204@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 572c76f2c2126..13c74d62b7266 100644
--- a/drivers/phy/rockchip/phy-rockchip-usbdp.c
+++ b/drivers/phy/rockchip/phy-rockchip-usbdp.c
@@ -1135,6 +1135,8 @@ static int rk_udphy_dp_phy_configure(struct phy *phy,
 	u32 i, val, lane;
 	int ret;
 
+	guard(mutex)(&udphy->mutex);
+
 	if (dp->set_rate) {
 		ret = rk_udphy_dp_phy_verify_link_rate(udphy, dp);
 		if (ret)
-- 
2.53.0



