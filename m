Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053553;
	b=QCsiQ8oSl/BBnHpswoL3A44q/SCTVsVRGvfUiU4IPbCbl4xqlqSXp8CIUNn7rlPWJUdN
	 yoKB/u84qVfkPkD1Fz9FBWCUD4StPiWgj6DBnJcJmBSKITW+/72g4Gxp79UkdHW90upJN
	 RZZR0SpMQ/HXZCwsVAopdNiXh0eA4n0tzVLGnYPWjLqH/m99P7R9D9nC9Fy1a/jxFRY9v
	 cr8yO+Ojdj90j+eeYmuenu5JRnLy9gLD80gDgknLyzIfhNlDkjozDD/7fopvZ45YWFyoq
	 UaDLLvtSOGdCl3yt5uHnfgrprpwXTNbP6WY8Sn/WdfMzewbB2fuh01sSwJYSuwz1/bQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053553;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1odPw3AQ8dngYchTTioQvODStqCUPdD2LuTzhswnshI=;
	b=D7RRqZ1Y+hECzNWqmcw2FB2VknUV3N3PWt9eTX+QlUaWXfkEs4VJ+P4TST1Djl6Xd4zo
	 EK6H0gzZAFCIXq+EF6uV6kyVY67/2G9S7W6aEFakvmMFQjFtVb5BY1Br3QDaDw9ctN1Zq
	 xqK/S/YDolrb2r7FSdN8p28rPBjT8m22j2LUjwROwbB+wDr2inyJ16o7IdUF0sy4IsRif
	 Xit+Y/T6ijrTKfrWypK1d0T5ETpE/vAYQ+rYcrA9VPy7ljFN8fh3cJFgZDjj398+ooaP+
	 azjGjQwjGCoflxCj6grWGEBhQMcE7wqngD3bgBftG/fCwM+a+qbKDDFhpcTRC/it+2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rOtC8Rdu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205C3606A325;
	Thu, 19 Nov 2026 01:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rOtC8Rdu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5691F000C9;
	Thu, 19 Nov 2026 01:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053553;
	bh=1odPw3AQ8dngYchTTioQvODStqCUPdD2LuTzhswnshI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rOtC8RduKeKt/pBiOqUqSh7FclVV9vq5/WZOHoThTf8feochSo0vhRxjbsF3EX0Ej
	 UGEzB944Im5Xc4WIXmE5LU/0F2O5YlRYHbNzGojM7LwfxYRxonK1UdScYQSmMVHq14
	 fZ2i7Jq+Xn5hJUuuZLZ4f2B90Nbv4dv/7v46stu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Simon Wunderlich <sw@simonwunderlich.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0960/2214] batman-adv: Limit number of aggregated packets directly
Date: Wed, 18 Nov 2026 15:43:56 +0100
Message-ID: <20261118150050.695917965@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a424c5b7a2462..a6253f488ada2 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -450,6 +450,7 @@ batadv_iv_ogm_can_aggregate(const struct batadv_ogm_packet *new_bat_ogm_packet,
 	struct batadv_ogm_packet *batadv_ogm_packet;
 	int aggregated_bytes = forw_packet->packet_len + packet_len;
 	struct batadv_hard_iface *primary_if = NULL;
+	u8 packet_num = forw_packet->num_packets + 1;
 	bool res = false;
 	unsigned long aggregation_end_time;
 
@@ -475,6 +476,9 @@ batadv_iv_ogm_can_aggregate(const struct batadv_ogm_packet *new_bat_ogm_packet,
 	if (aggregated_bytes > BATADV_MAX_AGGREGATION_BYTES)
 		return false;
 
+	if (packet_num >= BITS_PER_TYPE(forw_packet->direct_link_flags))
+		return false;
+
 	/* packet is not leaving on the same interface. */
 	if (forw_packet->if_outgoing != if_outgoing)
 		return false;
diff --git a/net/batman-adv/main.h b/net/batman-adv/main.h
index 058b8f2eef654..30fa42211680b 100644
--- a/net/batman-adv/main.h
+++ b/net/batman-adv/main.h
@@ -102,9 +102,6 @@
  */
 #define BATADV_TQ_SIMILARITY_THRESHOLD 50
 
-/* should not be bigger than 512 bytes or change the size of
- * forw_packet->direct_link_flags
- */
 #define BATADV_MAX_AGGREGATION_BYTES 512
 #define BATADV_MAX_AGGREGATION_MS 100
 
-- 
2.53.0



