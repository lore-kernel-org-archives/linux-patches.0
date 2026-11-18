Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021519;
	b=pQ/UsjZsuBe9GPP3+MN72W6J790VlV2RhN4n8C+UVMC/l0gbv/8ct+g/iGtRgknvp/9A
	 wPOHle97Glln7RrXkd83aYs8MqR3UkvmIY0dBMq8oQinGx0wTSVJRfsxpGpc7PMsQocY1
	 Yl8SagAjLrmrDYbifVEI/yBAzOT7XSE6PVjIeOBjQikQq4pmxhUjN397BF/J+Ib56LU4O
	 VMSzEKOk2pouoWtVOFjJ17xkC1ZJiw2Plruc6p5nbDqJvy9ofXSDAFYUEgXCKzPrtIsta
	 HRe2SN4DCfb1Pz+8CNsJqPTjZcC7+tSJlKCGbqBvRXvut0Q2YviH0Vpo3aAnwaWGGHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021519;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LG5W/l999DOL30yvO/29/hyI44amTFHcCjojFKK/7qM=;
	b=hBhDUDZiOKZ2pA6a4z5G2EbKnDUJ5VQwpFcmCXPCeoOVougaU0w2rwS0BJEsuNtt5c2V
	 Q4KleIWS+wJYH/YUnV/C/ZkL1cbYvu2jLktaQxj5Y1iksK20cS+SyxfBFz+6I+dWN0Vuo
	 +ArStrEFFbKcv+k+I2pj9xD6Wj0QJD6/1GycLZpEnw49uGGuwhxu8APPVSc2E/G/olDQO
	 2I7BSgRbViCmGhuiNMsDAq+jZjQB6Lbv0+LLYuyTJt+BZ/Uu2hBiezE9a5V0xOm+hwKmy
	 8XG1TJWzPyt1n9bf56CbD9Vp1yTDPu/9iMwyuzxt4JA7pV1t9EVzlbFAi73vHz2KBwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=maM467vj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D089C606A325;
	Wed, 18 Nov 2026 17:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=maM467vj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326221F000C4;
	Wed, 18 Nov 2026 17:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021519;
	bh=LG5W/l999DOL30yvO/29/hyI44amTFHcCjojFKK/7qM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=maM467vjVhczreuIuU0hng9EOr/CvOa2hcprr1R74Coc3WNdYt0k5cWcEHWkbkROR
	 rOqYV7wVf6iHDrc8IJxHeB2m0z6Wmb0APXHrHqGvJRRro/Ri5PeZOK4ZCz6UWfqafx
	 nqErJqdmA8vp01ZEX7v8N0E1sfH/f3oNVlJjzrQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Joyner <eric.joyner@amd.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2336/2651] ionic: free port_info when probe fails after the port is set up
Date: Wed, 18 Nov 2026 15:59:36 +0100
Message-ID: <20261118150409.210872736@linuxfoundation.org>
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

From: Eric Joyner <eric.joyner@amd.com>

[ Upstream commit 4e15e0a941ce901d51b5f203713fa90feee9c4d3 ]

ionic_probe() allocates the port_info DMA buffer via ionic_setup_one()
-> ionic_port_init(). If probe then fails anywhere after that, it
unwinds through err_out_pci, which never calls ionic_port_reset();
ionic_dev_teardown() and ionic_clear_pci() do not touch port_info, and
so the buffer is leaked. The call was lost when the setup code was
moved into ionic_setup_one().

Since ionic_remove() already frees the port_info DMA buffer with
ionic_port_reset(), call that on the probe error path too. Every path
to err_out_pci runs after ionic_setup_one() succeeded, so the BARs are
still mapped and the firmware gets a PORT_RESET before the buffer is
freed, the same order as in ionic_remove().

Fixes: 0de38d9f1dba ("ionic: extract common bits from ionic_probe")
Signed-off-by: Eric Joyner <eric.joyner@amd.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20261015-ionic-port-info-lifetime-v2-2-57232013fd79@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index 05f19489ec5c8..68b3bceedd999 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -397,6 +397,7 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 err_out_free_irqs:
 	ionic_bus_free_irq_vectors(ionic);
 err_out_pci:
+	ionic_port_reset(ionic);
 	ionic_dev_teardown(ionic);
 	ionic_clear_pci(ionic);
 	ionic_debugfs_del_dev(ionic);
-- 
2.53.0



