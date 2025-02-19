Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46FC1EB1AC;
	Wed, 19 Feb 2025 08:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954746; cv=none; b=h1rhHN+KLoRpDA/op8E9/SnOqczDGhXqesqtOt4GtcPatfO1uvsmkl3v8bJkAN7QOrjQxi4adV/k7UtyJpZrw+B3toqbf1BOw9jPeOSKbLlE84T2Tmo0kFRpr8V0DM6FlFbqDqVyX80cfKWrVal9VbjQ6zyUHW/60TCU5n7Q0ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954746; c=relaxed/simple;
	bh=cUr4jc6fufB1sZX0qUvCnwzmzOnz9HE1z4WB/7YQxqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rA3gYc56SN6zawrMIuuUZNjZMVcCkLWAirok1kBlCILIq/QHCgF/B6cCBDq+fQomhSO8QQncgCojrHuMiDiuZ1Kd8Z004Sh/xMVn6eFHsRMh0AK7WTJxqmZktgfmPkM1LlKfdQFOKFpUmWQ4/FSjHnF7j+4OZ1ym3jFGkBJIpRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BaFW8KWs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BaFW8KWs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C6EEC4CED1;
	Wed, 19 Feb 2025 08:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954745;
	bh=cUr4jc6fufB1sZX0qUvCnwzmzOnz9HE1z4WB/7YQxqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BaFW8KWsq5KDVqiT8dbhrwCz5DJuFB3XvwjdJ1Jip2/ewsusil9rmEQ3MhYFWeLYt
	 AdMlQ5lfk1E8c1EWdvQ1z6FqqNRSpHpUFU1ow4Pm3CK75djCIDnlj2dJL2h9MycL3l
	 Sg+KPqUM1PSHhAkG1pTshMSa2Aa3yRGLQ4ZvQQYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sridhar Samudrala <sridhar.samudrala@intel.com>,
	Madhu Chittim <madhu.chittim@intel.com>,
	Samuel Salin <Samuel.salin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 022/230] idpf: record rx queue in skb for RSC packets
Date: Wed, 19 Feb 2025 09:25:39 +0100
Message-ID: <20250219082602.574189134@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index cd7c297059aed..1e0d1f9b07fbc 100644
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



