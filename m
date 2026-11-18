Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048280;
	b=K/Eep1jP7BTuhv42tz87VX0oCX2+U7aM/HEw8uYW3mBt+eK+wxfMXUbB5H8VbjZFPX0P
	 lBS6NfGw0Ttk4NT3A5YfrAaQtmngBEaUAwJd15hgllp3YffgYbzW0MzcQlrnr9KMp5l+Z
	 uvZcvnaEIhVYh0AlURX5+cCn9B+eNMtdpA0UcjsMc4mP2eZ3/mUhPhtx6bZb30s+smO6L
	 jPL9zS8oaKgwjTgPgVM/dfy32hOKorg0+x+ZsVea241oqOiw4ffq3KomktsGfRbRIkC6A
	 H0SNmrdwDpAfkPeeeTDbdDc7tiyScmrvKI7aOUKfERQ6+jOOUnrSyUjviFiGHHBgulg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048280;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hjZDuQQjvYWBlGWvz7nWlGzdG1HxRTCxaCv7KLn9bm0=;
	b=zzVwWkUms0dDxv7nOenqv0uXpCnp3aoB3DjgulD9cpGBZbUIY1slOUJpFsZt/LX+qhfl
	 a0xl3QHT7iHVtg5p4qlKyHf4u26vx1uPV/7WM43zrYDYollWHvGSzn3oxqg3joQ9ogZ86
	 CYI3xuQpmVbE73N628KUrWIPKF84lVnIWWHZPAD+BF3SRA0U8qwXEcGehWOclRnnSstRh
	 SnFm4+ScwWOhfjUIenRQjH0hDQ5w4tK2r0UaqsteD8ayu1aGkyvg8WtfaK6OUMPRG5mFh
	 5n7KhYnTpBnDC6yhYOK/z5qXPVXtzjSgEpGb+jZZ2Yw4WokXKiN4yDA027aExbg9jPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E1Jfms1W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F5E606A31C;
	Thu, 19 Nov 2026 00:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E1Jfms1W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D6B1F000C4;
	Thu, 19 Nov 2026 00:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048279;
	bh=hjZDuQQjvYWBlGWvz7nWlGzdG1HxRTCxaCv7KLn9bm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E1Jfms1WzVTWNwKFQi+L9julV98ciCZIZPyjCy31TC1kJ1plRmqqGkT47OokMTYG+
	 H03hFOLJF3WCbqpoJ/39hgPi90Ej4uzwjIGi1vTDs+hKpBlgoobA1GCPTp1MdIvI83
	 MhYIE4OEbV/b2fOHHDveEMv/XAdqe+7w74q7l/i0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <olteanv@gmail.com>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1937/2857] phy: hisilicon: hi3670: Fix OF node and device reference leaks
Date: Wed, 18 Nov 2026 15:49:31 +0100
Message-ID: <20261118150310.955934879@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 1499f3d3407f5310731bcdf324387c321258fd75 ]

hi3670_pcie_get_resources_from_pcie() leaks two references:
1) The OF node returned by of_get_child_by_name() is never released.
2) The device returned by bus_find_device_by_of_node() is never put.

Fix both leaks by calling of_node_put() right after
bus_find_device_by_of_node(), and put_device() after dev_get_regmap()
when the temporary pcie_dev reference is no longer needed.

Fixes: 73075011ffff ("phy: HiSilicon: Add driver for Kirin 970 PCIe PHY")
Suggested-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260219163843.1571-1-vulab@iscas.ac.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/hisilicon/phy-hi3670-pcie.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/phy/hisilicon/phy-hi3670-pcie.c b/drivers/phy/hisilicon/phy-hi3670-pcie.c
index 0ac9634b398da..6903148367dfc 100644
--- a/drivers/phy/hisilicon/phy-hi3670-pcie.c
+++ b/drivers/phy/hisilicon/phy-hi3670-pcie.c
@@ -565,6 +565,7 @@ static int hi3670_pcie_get_resources_from_pcie(struct hi3670_pcie_phy *phy)
 	}
 
 	pcie_dev = bus_find_device_by_of_node(&platform_bus_type, pcie_port);
+	of_node_put(pcie_port);
 	if (!pcie_dev) {
 		dev_err(dev, "Didn't find pcie device\n");
 		return -ENODEV;
@@ -579,6 +580,7 @@ static int hi3670_pcie_get_resources_from_pcie(struct hi3670_pcie_phy *phy)
 	 * right regmap. So, let's use the named version.
 	 */
 	phy->apb = dev_get_regmap(pcie_dev, "kirin_pcie_apb");
+	put_device(pcie_dev);
 	if (!phy->apb) {
 		dev_err(dev, "Failed to get APB regmap\n");
 		return -ENODEV;
-- 
2.53.0



