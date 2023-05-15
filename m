Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF64FBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:18:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DADC433D2;
	Mon, 15 May 2023 17:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684171128;
	bh=EnQHNNnWRJ9wA3vFxST/Puftf64q6UJyO9WhgEOAGFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xggbH7u0uw9NBuvtV7gJ5WBvKkxkl9q8ZX0AxNG5KtHI0NCz06IOEJBtlRTAB8Vah
	 CFUECYtN2o4/++duV/vFkgjKngIGaOhrBQ/a8AqgvgKI+c4HPjIQMevadzD4DKlpgg
	 jrTxIkz0k5CQXJnP9Jxp3W1vG/jOdUiezE2cU5kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Ghosh <sumang@marvell.com>,
	Sunil Kovvuri Goutham <sgoutham@marvell.com>,
	Sai Krishna <saikrishnag@marvell.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 071/242] octeontx2-af: Update correct mask to filter IPv4 fragments
Date: Mon, 15 May 2023 18:26:37 +0200
Message-Id: <20230515161724.033894252@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.802179972@linuxfoundation.org>
References: <20230515161721.802179972@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Suman Ghosh <sumang@marvell.com>

[ Upstream commit 2075bf150ddf320df02c05e242774dc0f73be1a1 ]

During the initial design, the IPv4 ip_flag mask was set to 0xff.
Which results to filter only fragmets with (fragment_offset == 0).
As part of the fix, updated the mask to 0x20 to filter all the
fragmented packets irrespective of the fragment_offset value.

Fixes: c672e3727989 ("octeontx2-pf: Add support to filter packet based on IP fragment")
Signed-off-by: Suman Ghosh <sumang@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
index 044cc211424ed..8392f63e433fc 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
@@ -544,7 +544,7 @@ static int otx2_tc_prepare_flow(struct otx2_nic *nic, struct otx2_tc_flow *node,
 		if (match.mask->flags & FLOW_DIS_IS_FRAGMENT) {
 			if (ntohs(flow_spec->etype) == ETH_P_IP) {
 				flow_spec->ip_flag = IPV4_FLAG_MORE;
-				flow_mask->ip_flag = 0xff;
+				flow_mask->ip_flag = IPV4_FLAG_MORE;
 				req->features |= BIT_ULL(NPC_IPFRAG_IPV4);
 			} else if (ntohs(flow_spec->etype) == ETH_P_IPV6) {
 				flow_spec->next_header = IPPROTO_FRAGMENT;
-- 
2.39.2



