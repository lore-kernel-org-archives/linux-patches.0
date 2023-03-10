Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4BD848D
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:25:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33EE3C433D2;
	Fri, 10 Mar 2023 14:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458336;
	bh=OXGUG7vSYfbnfwXGVK38zneb15HWuHT8FIJReQMokaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g3o9D9w7xZI6JCsgM4iGIDnfgI91L1+ztg7pL164VXMP2CrA1rfurHCiYCJu3yDjI
	 ovblOE60NZposB10YK4nHYuRpoVXvX+ZezmuGXq4lySIQJVROZQ6dF2EKlwPtxLG2S
	 DqQ/hfK/QWOmG6CwEkefwfXWLMXNn/0rdKtuzLio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abaci Robot <abaci@linux.alibaba.com>,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 244/252] phy: rockchip-typec: Fix unsigned comparison with less than zero
Date: Fri, 10 Mar 2023 14:40:14 +0100
Message-Id: <20230310133726.910213988@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit f765c59c5a72546a2d74a92ae5d0eb0329d8e247 ]

The dp and ufp are defined as bool type, the return value type of
function extcon_get_state should be int, so the type of dp and ufp
are modified to int.

./drivers/phy/rockchip/phy-rockchip-typec.c:827:12-14: WARNING: Unsigned expression compared with zero: dp > 0.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3962
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Link: https://lore.kernel.org/r/20230213035709.99027-1-jiapeng.chong@linux.alibaba.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-typec.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/phy/rockchip/phy-rockchip-typec.c
+++ b/drivers/phy/rockchip/phy-rockchip-typec.c
@@ -817,9 +817,8 @@ static int tcphy_get_mode(struct rockchi
 	struct extcon_dev *edev = tcphy->extcon;
 	union extcon_property_value property;
 	unsigned int id;
-	bool ufp, dp;
 	u8 mode;
-	int ret;
+	int ret, ufp, dp;
 
 	if (!edev)
 		return MODE_DFP_USB;


