Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617758;
	b=Lo2P93Ihlz/MnjPX00Uc4zckFQ0Maup0z1DDtFQNmQvUjb2NuS0t65zdrEv//VfRU+NR
	 CpoZfluz8/xq9dbynug7+II/d+dw+2ScwQjLzW2WyW9fhvWHLWoMPSbz/8Y03ORC9KPUt
	 dh8Xs2EABe+O8NDJIq10zWEgrH26KB6QqUk9EksR+BNnl5h96CewbPJYgCRtQoomm7IN1
	 ksvCD6GpkU2CSROri4AYeH60nA9DK79QfqIs9xxFCBiJnVCbVRJsgq6M3o1Wks89oUTLO
	 bMpGkZLk6Ca52xEsoSTONfQdBGf2EzR4Zc+baXf77AXjqskpQLPaRf1dQTgpToJitbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617758;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/vfeXW1APBPmicSbHaeo/eeNqQoBJ1z+6f3jcTJZ/Fs=;
	b=M4a323lPvoY9kC3ek1mmH/jwBOSN+Vc5evh24fdHUWnLlT2j2oHSAM/B3329WfSrGfHf
	 sl8M5HDUKm1C6VDnojK0H+8A9tEIMIK+qMcUABDmH/JnLbWhvXu29+fB7JJP22lj31tXZ
	 HrUoKenDj0mDpmqx46Utz1tCrEhhXKAiMwEymeNYZcr9q7rc9uZalx+MZPvHJkblmrzGf
	 fnSIJtkNKoafkKscYjaa8o/f/AuDH4c2SQp47SQAOOJMhsNL88QM8a/Z6uad/tLOIq7OQ
	 Ej+QpbHT9fffK5NfCXzIG9Y1M50yfD9QaRKdaiIj/leOXjfh8Sz2ruo8CA9jvw+5qNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PJ51VHgj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECA1606A31E;
	Wed, 25 Nov 2026 14:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PJ51VHgj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877B01F000CA;
	Wed, 25 Nov 2026 14:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617758;
	bh=/vfeXW1APBPmicSbHaeo/eeNqQoBJ1z+6f3jcTJZ/Fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PJ51VHgj/Yn71KNt8Mqjo0mhy64yxrwosn2e0c7ws82d/Sy2h+RtIVlP9JoosBHKM
	 hYzTa7bXpQeTtw5t9Aj+L9MMaNmJ2GQ0/f4BpxavgVOjFg9r622xkg+0vZPkhGCr50
	 OCKaIlmk5hVXK0/+pSUvQqdgIp7yAezUFbgn6+V4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kang Yang <kang.yang@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0063/1005] wifi: ath12k: set MSDU payload correctly
Date: Wed, 25 Nov 2026 15:23:21 +0100
Message-ID: <20261125143823.218325247@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Kang Yang <kang.yang@oss.qualcomm.com>

[ Upstream commit fe74d991f3387febfd57b65c7383d2d49e14e19a ]

ath12k_dp_mon_rx_merg_msdus() mistakenly passes head_msdu to
ath12k_dp_mon_rx_msdus_set_payload() while iterating over all MSDUs in
the chain.

As a result, skb_pull() is applied repeatedly to the head MSDU, whereas
the remaining MSDUs are never adjusted.

Pass the current MSDU instead so each MSDU is processed exactly once.

Also rename the helper parameter from head_msdu to msdu since the helper
operates on any MSDU in the chain.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Fixes: 1cf514fdc790 ("wifi: ath12k: use different packet offset for WCN7850")
Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20261020-msdupayload-v1-1-1ca9a5936727@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_mon.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_mon.c b/drivers/net/wireless/ath/ath12k/dp_mon.c
index db20d27b63338..fdbdad72a3c9f 100644
--- a/drivers/net/wireless/ath/ath12k/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/dp_mon.c
@@ -186,7 +186,7 @@ ath12k_dp_mon_fill_rx_rate(struct ath12k_pdev_dp *dp_pdev,
 }
 
 static void ath12k_dp_mon_rx_msdus_set_payload(struct ath12k_base *ab,
-					       struct sk_buff *head_msdu,
+					       struct sk_buff *msdu,
 					       struct sk_buff *tail_msdu)
 {
 	u32 rx_pkt_offset, l2_hdr_offset, total_offset;
@@ -200,7 +200,7 @@ static void ath12k_dp_mon_rx_msdus_set_payload(struct ath12k_base *ab,
 	else
 		total_offset = rx_pkt_offset + l2_hdr_offset;
 
-	skb_pull(head_msdu, total_offset);
+	skb_pull(msdu, total_offset);
 }
 
 struct sk_buff *
@@ -261,7 +261,7 @@ ath12k_dp_mon_rx_merg_msdus(struct ath12k_pdev_dp *dp_pdev,
 		head_frag_list = NULL;
 
 		while (msdu) {
-			ath12k_dp_mon_rx_msdus_set_payload(ab, head_msdu, tail_msdu);
+			ath12k_dp_mon_rx_msdus_set_payload(ab, msdu, tail_msdu);
 
 			if (!head_frag_list)
 				head_frag_list = msdu;
@@ -296,7 +296,7 @@ ath12k_dp_mon_rx_merg_msdus(struct ath12k_pdev_dp *dp_pdev,
 		msdu = head_msdu;
 
 		while (msdu) {
-			ath12k_dp_mon_rx_msdus_set_payload(ab, head_msdu, tail_msdu);
+			ath12k_dp_mon_rx_msdus_set_payload(ab, msdu, tail_msdu);
 			if (qos_pkt) {
 				dest = skb_push(msdu, sizeof(__le16));
 				if (!dest)
-- 
2.53.0



