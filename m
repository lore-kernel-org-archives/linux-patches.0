Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059314;
	b=L+ufJm8sQDgGda0Yud8HTlBObO600Y3QQ9leb3CQbH34GyUzKDXQyzjpJGZ2DsYgI0dB
	 +XYkrraqiGA3fbvDFdKIvNiZ+hd5dm7XmQRN72y6FGk+d/EKlAKqN2b3yZWwywTGQ0M+t
	 F/pfj4snhe8StRqidbGgPlVWRZBWLpE427ULVC9m2O9JG+btrGGsKRdds1hDetP+Wz6qk
	 iS4J4U0HxPYrCwK+BpvSc4+XQEyGr6ufNaAX+Tghxlum14fOZHcz8LB+9He9Ou+FID9uD
	 4ITVoU/F6uVq+wGkWFcBhntUuAIxe5Ac5zS6ZprSvPnfH7qLCCwkpJf9AA0KcL6EcFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059314;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U4Opy/otnTpHC/QMrCSw+og618aL7F9HMgpZA0w6su0=;
	b=YQn4NB4a/MHHvInE71f/G9uM8YZnJVTQW0Ox/3P89wtPHpnR0ixTq7tCx/pdWkiWaTD8
	 A/dzOQWpPRgytQSR+jjyAu3Sk6NXALBXEymEEsKOG7pk0jkEm2Bw49eod4VvQnMKUoRYP
	 t+SBpEs4Dd0Xy2mgXEjSbN1Kt2XqlUN7gGEwsy/oSh2TxNInBdDBdXTil+4mJFrCMBzGQ
	 UQwu9eeBe/XcRQDaa89SAYl+HijFmxlNVu6hxKoD9Sh+1I0mm3NUNM5twYAWpdBkdSL0V
	 JWQbqFbCsEdCOvpCYaYR9sJHl5JqrapMXorEAC7kOZr5j8Fabse72OA28fUuK4f3hFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qsp8qiFH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65BE1606A326;
	Thu, 19 Nov 2026 03:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qsp8qiFH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD2E1F000C4;
	Thu, 19 Nov 2026 03:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059314;
	bh=U4Opy/otnTpHC/QMrCSw+og618aL7F9HMgpZA0w6su0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qsp8qiFHttiv98ekIz4OPqfuTLBeYIZB+JgmjncfpGcCKv2+XYK1g1qzH2qrYdFhw
	 5e04CU7z2mmZwbq++xExbcRX+o+3FmLdyYBYUIHjYdVilMnIA3qf7cXm/R8YTVFtfe
	 TlweNUj1cYUqNNbC3AE/VjkUPVtifvfUwCXQDdDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0795/1848] batman-adv: tpmeter: fix u32 truncation of reported bytes
Date: Wed, 18 Nov 2026 15:47:13 +0100
Message-ID: <20261118145949.687756711@linuxfoundation.org>
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

commit 1025b76d13288a311e8259a0eefde0854fa63c41 upstream.

When more than 4 GB are transferred by the throughput meter,
batadv_tp_batctl_notify() will cut of the upper 32 bit of the u64 counter
and thus under-report the actual transferred bytes.

The data type of the temporary storage variable must therefore still
continue to use u64.

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/bug/linux-08bb3be4-6c6a-452d-b4e4-606940c6cfa5
Fixes: 33a3bb4a3345 ("batman-adv: throughput meter implementation")
[ Context ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/tp_meter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/tp_meter.c b/net/batman-adv/tp_meter.c
index 3a1561f579198..7910e7a7f79fc 100644
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -225,9 +225,9 @@ static void batadv_tp_batctl_notify(enum batadv_tp_meter_reason reason,
 				    unsigned long start_time, u64 total_sent,
 				    u32 cookie)
 {
+	u64 total_bytes;
 	u32 test_time;
 	u8 result;
-	u32 total_bytes;
 
 	if (!batadv_tp_is_error(reason)) {
 		result = BATADV_TP_REASON_COMPLETE;
-- 
2.53.0



