Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016098;
	b=GSrj+NbA8rksLRy9kHbNonruYP3GETMTKegFX9GwH+qlwttIqPUJArg81ts1uZ+Q8+/r
	 9KV6/R4pBwuEukar5poUctJFMpEqVW0855BlemnbjmL+BQrUh/9e7yYCBA0RifjGn/SnS
	 2wQ8E7dKdhbVXfi6WqTq2y0Up+kXxupARpkqRM2iod8sh4yqXU6tEN2Z8l9+itfdKnQyR
	 FLx8QFQMXq6rRoI2a+6vQXH2UNDNSm98xByKcomARZoWYN8l3YD93EZcDcjJkI+G425PE
	 K6C0xNpY1PRb71LqiOYfJjPoU66MQvRFQfGligfmrnKA7TLvkiTpMzcSTUlnbL55Opw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016098;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ft+2gM+cv5Tv0ZTHB9P8iT1QkVibO5QHPO2zVaxVWCo=;
	b=GnRueOZn3WAr49GvceYONCoS5Svc/wiq+vZF03zSErAJszRXh0GgJJPjIduj05OthArb
	 nswJIjkPZa9vABIaVHa86/n6ZJ/BS2K88ppl0AtSEM6CqdqJigtm3ScGDsbW6HnAPJliy
	 Ne7L6Nx9U9zOXA30AYve/0YXTyx/L7ZePllhcpGikdN3K/HnVk+oLvOpuZrQ0N5NvvrjB
	 fUibc6BU2Q2y73MooAiid+hlx9uaU5BP/UBytM0s7QzlcIqqCMgN85xiHW1SwrcyCnzv0
	 leSbxKkTVmDrdd/qZu6CyVhVIvM+zIac3r1Rj05QmG/mD5lLh293ZxVPMMlfQI2M47w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bHcpIT7v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E1D606A325;
	Wed, 18 Nov 2026 15:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bHcpIT7v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7BAB1F000C4;
	Wed, 18 Nov 2026 15:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016098;
	bh=Ft+2gM+cv5Tv0ZTHB9P8iT1QkVibO5QHPO2zVaxVWCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bHcpIT7v4B3OocDQoPHh2ONO7FrbbJd7SAsyHcRBoFmrd87l6tfmJ+2pwEM/Cfrml
	 /6dHvePhBxsRFo6w+NhHORh4DEyn0jdjLIaqxDf7mB/7Di3oFelh9dMMpeY4gWdv+k
	 Skbe+jTrdpaR/xeagKqQQEn+7ZjhN2kcg/Fo1Kgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0408/2651] firewire: core: remove unused link field in fw_packet structure
Date: Wed, 18 Nov 2026 15:27:28 +0100
Message-ID: <20261118150302.523068786@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

[ Upstream commit 00d4d31e4fdfe51312f0184f8d162b8d4de172dc ]

The link field in fw_packet structure has never been used since it was
added.

Fixes: 3038e353cfaf ("firewire: Add core firewire stack.")
Link: https://lore.kernel.org/r/20260911141602.3288806-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/firewire.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/firewire.h b/include/linux/firewire.h
index fd35a6570cd88..9bf26163a614f 100644
--- a/include/linux/firewire.h
+++ b/include/linux/firewire.h
@@ -337,7 +337,6 @@ struct fw_packet {
 	 */
 	fw_packet_callback_t callback;
 	int ack;
-	struct list_head link;
 	void *driver_data;
 };
 
-- 
2.53.0



