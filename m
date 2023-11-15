Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F953A8F7
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bxXHNR3t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36F0DC433C8;
	Wed, 15 Nov 2023 19:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077913;
	bh=gbsVdajFUePXxuXQCS8uPiqO3KqJuIYJ4LeStxut3jM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bxXHNR3tZCqyYSgf5MXfCNauO6XXFwnuhyYxELW/nasx+Kj7mzH2Cxkdh8zBwa0f2
	 lkzXPkUAkMz3Rx1SomCLmt1lxqdZy1Pr/630hYZYp7HalH746GpD3X+emxEkOBmVRf
	 GTmNKUc3D8aO8jwy8vJPRYt2KYJMyuOKHP1VV66g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 572/603] net: enetc: shorten enetc_setup_xdp_prog() error message to fit NETLINK_MAX_FMTMSG_LEN
Date: Wed, 15 Nov 2023 14:18:37 -0500
Message-ID: <20231115191651.089450591@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit f968c56417f00be4cb62eadeed042a1e3c80dc53 ]

NETLINK_MAX_FMTMSG_LEN is currently hardcoded to 80, and we provide an
error printf-formatted string having 96 characters including the
terminating \0. Assuming each %d (representing a queue) gets replaced by
a number having at most 2 digits (a reasonable assumption), the final
string is also 96 characters wide, which is too much.

Reduce the verbiage a bit by removing some (partially) redundant words,
which makes the new printf-formatted string be 73 characters wide with
the trailing newline.

Fixes: 800db2d125c2 ("net: enetc: ensure we always have a minimum number of TXQs for stack")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/lkml/202311061336.4dsWMT1h-lkp@intel.com/
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20231106160311.616118-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 35461165de0d2..b92e3aa7cd041 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2769,7 +2769,7 @@ static int enetc_setup_xdp_prog(struct net_device *ndev, struct bpf_prog *prog,
 	if (priv->min_num_stack_tx_queues + num_xdp_tx_queues >
 	    priv->num_tx_rings) {
 		NL_SET_ERR_MSG_FMT_MOD(extack,
-				       "Reserving %d XDP TXQs does not leave a minimum of %d TXQs for network stack (total %d available)",
+				       "Reserving %d XDP TXQs does not leave a minimum of %d for stack (total %d)",
 				       num_xdp_tx_queues,
 				       priv->min_num_stack_tx_queues,
 				       priv->num_tx_rings);
-- 
2.42.0



