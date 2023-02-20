Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8EEE63B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:39:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CDE1C4339E;
	Mon, 20 Feb 2023 13:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900343;
	bh=ytcWzV0IyrUFqsS1ZJVaQl1PGe3nMZlwsSJMQdstmhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uI/1Lfk4EMK8+xFnMkK5if+Ro2dZDGUUyUTu1gMhqWINvjYYneGKoEdY5MyaNIDpT
	 wHPhgNmF88tw1kse3JF3l1fPafCtIYzWVW78GZUl29CifchnOKYEv0bROyr5yLu206
	 JL9RdPZSYK8hJl85jszTza88V2gm4WZ68TAntTn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Xing <kernelxing@tencent.com>,
	Alexander Duyck <alexanderduyck@fb.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Chandan Kumar Rout <chandanx.rout@intel.com>
Subject: [PATCH 4.14 43/53] i40e: add double of VLAN header when computing the max MTU
Date: Mon, 20 Feb 2023 14:36:09 +0100
Message-Id: <20230220133549.693886465@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133548.158615609@linuxfoundation.org>
References: <20230220133548.158615609@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jason Xing <kernelxing@tencent.com>

commit ce45ffb815e8e238f05de1630be3969b6bb15e4e upstream.

Include the second VLAN HLEN into account when computing the maximum
MTU size as other drivers do.

Fixes: 0c8493d90b6b ("i40e: add XDP support for pass and drop actions")
Signed-off-by: Jason Xing <kernelxing@tencent.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -2480,7 +2480,7 @@ static int i40e_change_mtu(struct net_de
 	struct i40e_pf *pf = vsi->back;
 
 	if (i40e_enabled_xdp_vsi(vsi)) {
-		int frame_size = new_mtu + ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN;
+		int frame_size = new_mtu + I40E_PACKET_HDR_PAD;
 
 		if (frame_size > i40e_max_xdp_frame_size(vsi))
 			return -EINVAL;


