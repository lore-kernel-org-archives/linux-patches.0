Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863D818FC86;
	Wed, 19 Feb 2025 08:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739953877; cv=none; b=U8TlIzkED/UWd//fFTitPDZuyTNDgzM/SH9+TSOoy44R6YXo0YaObHDQ/eJZ6B5qDF2h56LhFQlm0VGLH70KA+6fAS6u/nQtHLd+x3JV7Q/SKOBIxFsqhiaQh/ctmGjs/OtqJHjZwCgsj6Q/WA5VL5lBZBl3yXrALPvi4r+Wmpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739953877; c=relaxed/simple;
	bh=2MYxihG9u/dtWpwmm/ylmzpjlZaqrwBxYQWE6LVJlxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N60TP0zOP0zC2NjLs4JjAu7ksxJiKoLtpgMzh/AXoYZfl1cDboSYeknDt1azL4k1sNVvVPRyCPGBHMlrixJzfL4QVEtXvUl/Br3h6W2q58pP7oe+5KCPDrP4ipcjR8wa2btf/4bCSVPz+sGKCCZoHV+XQz3LgI05Rgmf4Huygs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ItTcPFf3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ItTcPFf3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05589C4CED1;
	Wed, 19 Feb 2025 08:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739953877;
	bh=2MYxihG9u/dtWpwmm/ylmzpjlZaqrwBxYQWE6LVJlxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ItTcPFf3GZjB23Xp54moiJlMdt2SEk0tg4KYSVnIZf0rdzN/S/K7vpgsIY2Qgbf3Q
	 8DzHS+nyJ1+sNLP5+Zy0FKER6b7rnfRmN6o9RZh8JTzXT/YFARLkAZI7/i8PJUpzUt
	 KII1yTWCdC8uqSWJfUrmlgcxlxxZthWpc0k0aKp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sridhar Samudrala <sridhar.samudrala@intel.com>,
	Madhu Chittim <madhu.chittim@intel.com>,
	Samuel Salin <Samuel.salin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 026/274] idpf: record rx queue in skb for RSC packets
Date: Wed, 19 Feb 2025 09:24:40 +0100
Message-ID: <20250219082610.562333480@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sridhar Samudrala <sridhar.samudrala@intel.com>

[ Upstream commit 2ff66c2f9ea4e9311e9a00004348b6c465bd5d3b ]

Move the call to skb_record_rx_queue in idpf_rx_process_skb_fields()
so that RX queue is recorded for RSC packets too.

Fixes: 90912f9f4f2d ("idpf: convert header split mode to libeth + napi_build_skb()")
Signed-off-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Reviewed-by: Madhu Chittim <madhu.chittim@intel.com>
Tested-by: Samuel Salin <Samuel.salin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_txrx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.c b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
index c9fcf8f4d7363..9be6a6b59c4e1 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
@@ -3070,6 +3070,7 @@ idpf_rx_process_skb_fields(struct idpf_rx_queue *rxq, struct sk_buff *skb,
 	idpf_rx_hash(rxq, skb, rx_desc, decoded);
 
 	skb->protocol = eth_type_trans(skb, rxq->netdev);
+	skb_record_rx_queue(skb, rxq->idx);
 
 	if (le16_get_bits(rx_desc->hdrlen_flags,
 			  VIRTCHNL2_RX_FLEX_DESC_ADV_RSC_M))
@@ -3078,8 +3079,6 @@ idpf_rx_process_skb_fields(struct idpf_rx_queue *rxq, struct sk_buff *skb,
 	csum_bits = idpf_rx_splitq_extract_csum_bits(rx_desc);
 	idpf_rx_csum(rxq, skb, csum_bits, decoded);
 
-	skb_record_rx_queue(skb, rxq->idx);
-
 	return 0;
 }
 
-- 
2.39.5



