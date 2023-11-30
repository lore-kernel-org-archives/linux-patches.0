Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F3154BFB;
	Thu, 30 Nov 2023 16:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b84RHCbI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DFF7C433C8;
	Thu, 30 Nov 2023 16:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361741;
	bh=koP2vmfshckH462ll3JuEfwjwC3v6OKR6J0YFmRJ3XA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b84RHCbIhs+26g29YglGONFP+Eq5C3gxuspkLjj5U6MjmG8ukD95e4SnP6v39p9k8
	 b6+HgGLuILUKx449KE/mUnMhkFiP93R+lBXI4OkE8/cBwCwQytSfb85AhfAsKtVvSg
	 ZJJXWGbk1jQUjKJ3HLshrx3C90KkwyMtt36VVR9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel.holland@sifive.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 21/82] net: axienet: Fix check for partial TX checksum
Date: Thu, 30 Nov 2023 16:21:52 +0000
Message-ID: <20231130162136.627745853@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162135.977485944@linuxfoundation.org>
References: <20231130162135.977485944@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Holland <samuel.holland@sifive.com>

[ Upstream commit fd0413bbf8b11f56e8aa842783b0deda0dfe2926 ]

Due to a typo, the code checked the RX checksum feature in the TX path.

Fixes: 8a3b7a252dca ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver")
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Link: https://lore.kernel.org/r/20231122004219.3504219-1-samuel.holland@sifive.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index d14648558338b..5ea9dc251dd9a 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -821,7 +821,7 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		if (lp->features & XAE_FEATURE_FULL_TX_CSUM) {
 			/* Tx Full Checksum Offload Enabled */
 			cur_p->app0 |= 2;
-		} else if (lp->features & XAE_FEATURE_PARTIAL_RX_CSUM) {
+		} else if (lp->features & XAE_FEATURE_PARTIAL_TX_CSUM) {
 			csum_start_off = skb_transport_offset(skb);
 			csum_index_off = csum_start_off + skb->csum_offset;
 			/* Tx Partial Checksum Offload Enabled */
-- 
2.42.0



