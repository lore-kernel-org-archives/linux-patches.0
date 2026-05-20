Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86152369999;
	Wed, 20 May 2026 17:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297525; cv=none; b=koS53tUQTUEcLrvWBOg5dQFz6InPgbANGaSMjyg8zk++Vlp8+IVnAKRz4quXW7026Chm4LTr17QQnoG6AwaNoF/v3R9SPTdW2XPsef9PzxnwneQFOmnO885a75QU6F4bzpOnhVs+qJhbPE9uy5NyXZvZoGsx6JLwpQmwYeImPhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297525; c=relaxed/simple;
	bh=5WzMYUDBO7tnmn7UrPqqnIy8p7Wli9/k7KZRescmUmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tTCfGksM8TP8PRIz9LqX0VQXWCsxLQsfAI1NDLPOemflwRiAlS4gz7cWUvXUcpyJOX1kK8MCMfX86KYPO4ZPb/GL5T6p/PgjXnXVt+eFjtfTuE5OVTLz2SQ7ucCCV1Wy0MuAcWxHTwB4GFa7CgRwq6ADXJuhblYuR3ZCVrrq8jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PYdI9f+p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PYdI9f+p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB7681F00894;
	Wed, 20 May 2026 17:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297524;
	bh=B4zW9jIskH/LnU8aOI5+xgKWhtvM6w+tuCPA+7RtQWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PYdI9f+p9IAR1XX4Q+o27wzwY4nbBerlCXyb1idOU0Dd/lPS3udAbvw7Kb/AVQKBI
	 G9eWiIqQ/c6NAPdwA4INaMaa6v+id+WvVToWygjGqTz55Q4/LXknqdLggHILkiGbi0
	 7u+ohxBtAkuK5/nWthtW+49Nxc4NyVNRONkvQmp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Cai Xinchen <caixinchen1@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 064/957] dpaa2: compile dpaa2 even CONFIG_FSL_DPAA2_ETH=n
Date: Wed, 20 May 2026 18:09:07 +0200
Message-ID: <20260520162135.951044570@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cai Xinchen <caixinchen1@huawei.com>

[ Upstream commit 97daf00745f7f9f261b0e91418de6e79d7826c36 ]

CONFIG_FSL_DPAA2_ETH and CONFIG_FSL_DPAA2_SWITCH are not
associated, but the compilation of FSL_DPAA2_SWITCH depends on
the compilation of the dpaa2 folder. The files controlled by
CONFIG_FSL_DPAA2_SWITCH in the dpaa2 folder are not controlled
by CONFIG_FSL_DPAA2_ETH, except for the files controlled by
CONFIG_FSL_DPAA2_SWITCH. Therefore, removing the restriction will
not affect the compilation of the files in the directory.

Fixes: f48298d3fbfaa ("staging: dpaa2-switch: move the driver out of staging")
Suggested-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
Link: https://patch.msgid.link/20260312065907.476663-3-caixinchen1@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/Makefile | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/Makefile b/drivers/net/ethernet/freescale/Makefile
index de7b318422330..d0a259e47960f 100644
--- a/drivers/net/ethernet/freescale/Makefile
+++ b/drivers/net/ethernet/freescale/Makefile
@@ -22,6 +22,5 @@ ucc_geth_driver-objs := ucc_geth.o ucc_geth_ethtool.o
 obj-$(CONFIG_FSL_FMAN) += fman/
 obj-$(CONFIG_FSL_DPAA_ETH) += dpaa/
 
-obj-$(CONFIG_FSL_DPAA2_ETH) += dpaa2/
-
+obj-y += dpaa2/
 obj-y += enetc/
-- 
2.53.0



