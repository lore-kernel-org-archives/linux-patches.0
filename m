Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056260;
	b=vXsFwEWxEw8xu/EvpDHE0nW7CHTte0Gznn7He5Bl6tkbMo4QdYqqMSF3fFupYSbHQyPo
	 xlvGwOe2GQ7niOirOZCjkMhv1K7Dr4g5YEk+IVYHPOIIBbhNieXgnmUyCEzUPJujpeVuE
	 0wot/06+BBjJjENZuYmVfnOG4IcnDbhpWH7VZnc9R3LofijvajiuLewGkSLB9IRII7emw
	 I6PMkK97JMBYWeJ9eftei5qLdnZ9p1/AhUVWeiW16B/JrHoznaDiWtJFFkjD/zPjQXEEL
	 ZIIcGBqUeVDuPXJjlQxJxrDQq/aC5CC3LVE2yAoIw2Y3cNrR4lSWNUimLHtq57CPXtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056260;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4H7oIEeNbaORyPkwzxo1ppMAilM4iSibC/KbTUNhym8=;
	b=hl+UcEv8f5tp8BceIxEwhhuJHE2l7bbjh9SIMYjf9972Bu/e1Hq35oOeKFnB3r0vWNTs
	 RuQ1jmD8mPKUyQOTlJJPzhCZ2jeKeE3c+HZLF5Cvo+J4UPrM1ks7Qk+2EZ8ISpPeeA8Ah
	 AU/oKKgCMp8N9xHTGPo/l2zW8JF8urII1/aBP5FH2xAEd6bYMR8DBdShkNLAi6vpiVZGw
	 dORFevSS7LiH/wdzHpq8HO/ikdglmaxL7F4ZCYLwo7bGguT/hWpg16jwZY+wT03xfwQKv
	 8k86pIfjZtlG6MInhbCr9BzV5rYPBmUXxn6NBUqF4pdACoqgUr+2UtlAWQjW1Q6OobQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BItbMtPj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9C5606A31C;
	Thu, 19 Nov 2026 02:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BItbMtPj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B3671F000C4;
	Thu, 19 Nov 2026 02:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056260;
	bh=4H7oIEeNbaORyPkwzxo1ppMAilM4iSibC/KbTUNhym8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BItbMtPjhqoKzaidUMrmxWrVSpf8B5gcO1hRSEpd4MSz9L3qk6TwKSu6neqwKjdyg
	 V9mLcws0sul1eddrMX9YUyQNCJeIonHT7WliVLIalzSQoig87bwe+zYXiknK6vNZNQ
	 GX3j/bczJET0SQntZsAyUf/SVZfvlDMAx3kd1oT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1924/2214] ASoC: codecs: wm5100: Fix definition of EQ3 Band 1 Volume control
Date: Wed, 18 Nov 2026 16:00:00 +0100
Message-ID: <20261118150128.010164260@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 96d30816a9a4fa6b3cc470f82d0f53e8a6425ab9 ]

The EQ3 band 1 gain is in WM5100_EQ3_1, not in WM5100_EQ1_1, which
holds the EQ1 band 1 gain.

Fixes: 6d4baf084f4d ("ASoC: Add WM5100 driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/d7f690e391feda7a6d8f38d0b238b165bc1f4fe2.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm5100.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm5100.c b/sound/soc/codecs/wm5100.c
index 9cab01ee4ee91..45ffe82abef57 100644
--- a/sound/soc/codecs/wm5100.c
+++ b/sound/soc/codecs/wm5100.c
@@ -655,7 +655,7 @@ SOC_SINGLE_TLV("EQ2 Band 4 Volume", WM5100_EQ2_2, WM5100_EQ2_B4_GAIN_SHIFT,
 SOC_SINGLE_TLV("EQ2 Band 5 Volume", WM5100_EQ2_2, WM5100_EQ2_B5_GAIN_SHIFT,
 	       24, 0, eq_tlv),
 
-SOC_SINGLE_TLV("EQ3 Band 1 Volume", WM5100_EQ1_1, WM5100_EQ3_B1_GAIN_SHIFT,
+SOC_SINGLE_TLV("EQ3 Band 1 Volume", WM5100_EQ3_1, WM5100_EQ3_B1_GAIN_SHIFT,
 	       24, 0, eq_tlv),
 SOC_SINGLE_TLV("EQ3 Band 2 Volume", WM5100_EQ3_1, WM5100_EQ3_B2_GAIN_SHIFT,
 	       24, 0, eq_tlv),
-- 
2.53.0



