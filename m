Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059311;
	b=Sam3e3GiotNla2L9tiA5ohQva6tmQHYxcgJItgiuMAc3dsF4a79lFETP1fMOdmzYl81w
	 +QtPl0unIJY+74TltfOnFo9CCo0QCztfeItNB2+0fIRXOhE5mCC2fl2jyDJ1abCOiOo8Q
	 MoiwB4MLGgJtFlxfFWo83m3ZEIylQT3p8q0sTawYOcuH/qvlXTEKjABD2suSkdoEsOaf0
	 mQRo4DqAqRF1CTgzygb5t2RoerjJfQrd/cv3dRvliRUXoOrGsfK0v/X2gd3dfFa9EKwBy
	 hfqq/HKVXxdTMlN4BhNJ0dkzsfpJqv4kQz6IF5fXMYCM8ojb4oD/j7ufjInqWvWl+cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059311;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hFPJoAfAgztb6Rolx6oARZqJHFYPAnvpB7+sNYKODvY=;
	b=HvsiNsWcDNCCwCZCCrJd6gO85K/xEDMitfOaw6ApYejjP6Z2vFh0OesS1H6Mv7xDV2Sp
	 4ZTEwtTt7iWQpWUDL/8+4smaAeb9qCKddBBPy3cbKfbpj54KZHLl6aIgJ6aXPOHVlmyCw
	 ewxdJVY/ujyeDFsQ9aeTFit83zYNZtEHOYwLNS0iChuh512FRd4y6gBOjs/AX9UKgAIvd
	 3reEDZpv18LUblIwdX8FXuCCyNGY/s6xbbvEs/DDRGf67fCKt7X3kSFi9ssybJdwx9PFg
	 M0ylvKNGC1AK8nXD8S3Kflh/iCsw5vx9pJbF1TE8rxLUQw9QuIBHzxI8hMAJhwKDsag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LhDffadV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7316606A32A;
	Thu, 19 Nov 2026 03:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LhDffadV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097171F000C6;
	Thu, 19 Nov 2026 03:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059311;
	bh=hFPJoAfAgztb6Rolx6oARZqJHFYPAnvpB7+sNYKODvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LhDffadV4UDWzM1+A2extvrkYmgAbWNJ8OK8q3q63GlskQzjhqzoNZJWL/9KjPCos
	 15cwmAKkEtkSjDM85lyLFfpuxIYSuAveUl5RIHuN6Hs5vbADwiKKrWmEcm52u52oLu
	 KmhHjw08+77bg5xXL3SimziMVC90jtkpFEI7mOJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0794/1848] batman-adv: Close OGM aggregation before transmission
Date: Wed, 18 Nov 2026 15:47:12 +0100
Message-ID: <20261118145949.654694912@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengfeng Ye <nicoyip.dev@gmail.com>

commit f91f64a91682c07e6c5f059804e709656364e8a6 upstream.

The OGM send worker leaves its forwarding packet on forw_bat_list until
after batadv_iv_ogm_emit() returns. Aggregation holds forw_bat_list_lock,
but emission reads and clones the packet without that lock.

CPU 0 can therefore start emitting a queued packet while CPU 1 takes the
list lock, finds the same packet and appends another OGM. The sender can
observe the new packet length before the corresponding direct-link flag
is set, or clone the skb while its length and payload are being updated.
This can transmit an OGM with incorrect flags or inconsistent data.

KCSAN reported:

  BUG: KCSAN: data-race in batadv_iv_ogm_queue_add / batadv_iv_send_outstanding_bat_ogm_packet
  write to 0xffff888100fedcf8 of 2 bytes by interrupt on cpu 1:
  read to 0xffff888100fedcf8 of 2 bytes by task 70 on cpu 2:
  value changed: 0x00c0 -> 0x00d8

Mark the aggregate as full under forw_bat_list_lock before emission. This
waits for any ongoing append and prevents further aggregation. Emission
uses packet_len to walk the OGMs, so all queued packets are still sent.
Keep the packet on the list so interface purging can find the worker,
wait for it to finish and free the packet.

Fixes: 9b4aec647a92 ("batman-adv: fix rare race conditions on interface removal")
Cc: stable@vger.kernel.org # 4.10.x: 434becf57bdc ("batman-adv: Limit number of aggregated packets directly")
Cc: stable@vger.kernel.org # 4.10.x
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
[ Use BITS_PER_TYPE(...) instead of BATADV_MAX_AGGREGATION_PACKETS ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/bat_iv_ogm.c | 5 +++++
 net/batman-adv/types.h      | 8 +++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index 06908c324f110..7dd42f91ac2d3 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -1807,6 +1807,11 @@ static void batadv_iv_send_outstanding_bat_ogm_packet(struct work_struct *work)
 		goto out;
 	}
 
+	/* Mark aggregate as full before forcing emit. */
+	spin_lock_bh(&bat_priv->forw_bat_list_lock);
+	forw_packet->num_packets = BITS_PER_TYPE(forw_packet->direct_link_flags);
+	spin_unlock_bh(&bat_priv->forw_bat_list_lock);
+
 	batadv_iv_ogm_emit(forw_packet);
 
 	/* we have to have at least one packet in the queue to determine the
diff --git a/net/batman-adv/types.h b/net/batman-adv/types.h
index 49cef1a85639a..b9337958fa8f7 100644
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -2209,7 +2209,13 @@ struct batadv_forw_packet {
 	/** @direct_link_flags: direct link flags for aggregated OGM packets */
 	u32 direct_link_flags;
 
-	/** @num_packets: counter for aggregated OGMv1 packets */
+	/**
+	 * @num_packets: counter for aggregated OGMv1 packets. Set to
+	 *  BITS_PER_TYPE(forw_packet->direct_link_flags) (independent of the
+	 *  real number of aggregated packets) by the send worker to prevent
+	 *  further aggregation while the packet is emitted. It must therefore
+	 *  not be used to iterate over the aggregated packets
+	 */
 	u8 num_packets;
 
 	/** @delayed_work: work queue callback item for packet sending */
-- 
2.53.0



