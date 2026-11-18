Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059309;
	b=Oc4ldpvsssAvb9R4VoF7BLwJwZKGjitQ08dD7J3PC9EcI7W/kvdLE4Ili7lvi/oe84D7
	 5eSNTlg/9EM1wxj0vpxUeL/7loWoX2I5Dv2BPtauO2dfuejcbiQY3pBdg91P5wv6LU38o
	 pSGBnDBowtqk6BL9QJX+9OQ3xew28nMnrZaArBQyooTKqKWoAZe2tfC+L9aEYMn5BM0Zq
	 dt7MxSR8tsCGOUg7sYETDKqFwbHT2g1te2uxXprRI1PLTNuB1JtHtr0wFVpaKQOVzhzKz
	 GMhCLEyLgIkhL6y3XyVQUMmSN1eEOYmiNtt5N+W188W8AM7Xe2XLbo/hz70jW8DnaGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059309;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aumk/ZVWbUb071u2iIjS8nuq6ajVzm6T7ReUNqhvRTk=;
	b=vX9ApAZeaU0urzXaw/Ej/GrFd/vebvJctpwrL+yxsi1KMzNYjIxrM5L+AeDZ6uoDitgr
	 9YR4eQQCTro0kg7CbN7HCru8tTfyE3Yy7bj3M565hZuIkBcsW7CKYhFmuwLFzy5BiCqVj
	 /A2xG99pMiV40zYmLQfccXnO6dirmrXfMW4Z5zCG8G7EBqQ0FlIRe8jbOhavVCMqi8/Jl
	 K0IaC2G3bHp7KsIUAgdg5MO3ozQaBDsD4FK/AeasRyzTVG4w4B1bsR2E01kB6LNLY67vK
	 QdEF7gD8wHHx/Lm6xlMv0V4rsll0h/KtsC1qaxT8qE7qxBwtvaWQPEnH4/CQV8x+esA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lfjr1+Dq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47724606A32F;
	Thu, 19 Nov 2026 03:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lfjr1+Dq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 493281F000C4;
	Thu, 19 Nov 2026 03:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059308;
	bh=aumk/ZVWbUb071u2iIjS8nuq6ajVzm6T7ReUNqhvRTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lfjr1+DqaH/KUOaDonaYDrCQgYo5TDbxkxuQysK1W7QHh+JmESDQk3lEiDfCJaB6P
	 b+3VtgVMLlhG05nJ2EFINbVfwjAq/EhqNvobjZjvBf9l0QOMzS/VZhQxh3OOih0OTY
	 kDyUSeWRdgKUI90V4exSlODWc+jnAyVVC10G7mKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Simon Wunderlich <sw@simonwunderlich.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0793/1848] batman-adv: Limit number of aggregated packets directly
Date: Wed, 18 Nov 2026 15:47:11 +0100
Message-ID: <20261118145949.621351173@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

commit 434becf57bdc89f939db635ed3337b9d1da5967e upstream.

The currently selected size in BATADV_MAX_AGGREGATION_BYTES (512) is chosen
such that the number of possible aggregated packets is lower than 32. This
number must be limited so that the type of
batadv_forw_packet->direct_link_flags has enough bits to represent each
packet (with the size of at least 24 bytes).

This requirement is better implemented in code instead of having it inside
a comment.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/bat_iv_ogm.c | 4 ++++
 net/batman-adv/main.h       | 3 ---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index cc4fbfd0b7553..06908c324f110 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -451,6 +451,7 @@ batadv_iv_ogm_can_aggregate(const struct batadv_ogm_packet *new_bat_ogm_packet,
 	struct batadv_ogm_packet *batadv_ogm_packet;
 	int aggregated_bytes = forw_packet->packet_len + packet_len;
 	struct batadv_hard_iface *primary_if = NULL;
+	u8 packet_num = forw_packet->num_packets + 1;
 	bool res = false;
 	unsigned long aggregation_end_time;
 
@@ -476,6 +477,9 @@ batadv_iv_ogm_can_aggregate(const struct batadv_ogm_packet *new_bat_ogm_packet,
 	if (aggregated_bytes > BATADV_MAX_AGGREGATION_BYTES)
 		return false;
 
+	if (packet_num >= BITS_PER_TYPE(forw_packet->direct_link_flags))
+		return false;
+
 	/* packet is not leaving on the same interface. */
 	if (forw_packet->if_outgoing != if_outgoing)
 		return false;
diff --git a/net/batman-adv/main.h b/net/batman-adv/main.h
index a47dc332d7968..369f7c8d0c01f 100644
--- a/net/batman-adv/main.h
+++ b/net/batman-adv/main.h
@@ -103,9 +103,6 @@
  */
 #define BATADV_TQ_SIMILARITY_THRESHOLD 50
 
-/* should not be bigger than 512 bytes or change the size of
- * forw_packet->direct_link_flags
- */
 #define BATADV_MAX_AGGREGATION_BYTES 512
 #define BATADV_MAX_AGGREGATION_MS 100
 
-- 
2.53.0



