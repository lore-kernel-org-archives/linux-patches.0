Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020175;
	b=cVuHfKlRej5Cb8kMDP7D3ajikRCPtpK4Hxca8c3c7If2PmOf7lbdRRnTHhrCT/UsQXK/
	 C4Afbg7ydOqSuoJYhICorinpVUhrkicyEiY4V9eYuASZ6skGITmVzat6r/qLNe4YOUx6h
	 OeGL/gS8zdCmQG7/o1f29BfZF4MSdXg9UtsDdBtIYv1HwKtPJ5H+c5kgo/NBa+EA2rzPG
	 /9YwqmyMjM0rqepE/lwlX2Wmd1lVVuR/orF0P1l+2aYFKxNEDR9vkdjwSe+R5auaH0sG8
	 QIFj2n+QBaL8UeWI3m2o2n3IEv1cOPISpB/Kn5UunD0BYENIGvjvFcLC4+hF59lL9uQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020175;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=csDRKMQ3AwoMyIvDjo/UgIG97kjODSGENRuZJWIrwfY=;
	b=nhVhXld5Swk0XX8C3XETw8ECv5ZhuFbAkaGXxF6iLNrdRDMTPK7cjDMG8vDqOM8CcsIG
	 eqwdaMqnsxNtSWBwxPshZhXXjnbCrh/J2fy7fEDJ41m/mAovEajGKzSmyniNq73RoGKe8
	 ERK3WrsC8rs45lMamFjws3JsKF6YJhosHKojFrL3SvKlP45KePwsB/9cEi4WP5gaCm+zH
	 6JgOOiIyCzvV+Wb/l3zBS+dvT01F644Po8VLTvABXbaOrQ8dGRvqNzkeBmOw6iSk48Tin
	 vEz/Dr7XLGNUL5G2Gnn2aQNAltARgO8NZ780OZT7P++F94id/cw7k50Kx5A5B8zktCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ezNBy9n7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3FC606A33B;
	Wed, 18 Nov 2026 16:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ezNBy9n7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C6B1F000C6;
	Wed, 18 Nov 2026 16:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020174;
	bh=csDRKMQ3AwoMyIvDjo/UgIG97kjODSGENRuZJWIrwfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ezNBy9n7+2qGm6Yrl15C78lynXKzSzy/xvfYrKGx8U9BWDAHkCnWOPJAdf0XR+tkd
	 fDiOoazgteAoZXFCQE7JOK9DIwebrAd9jE/ul+gwJuBsZZzzxgBUm6Znq0FtEbJOYj
	 Qo4/AsBEicWL0zk6eYT6tqFkEYr6/5nULbzXlkgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1858/2651] ASoC: codecs: wm5100: Fix definition of EQ3 Band 1 Volume control
Date: Wed, 18 Nov 2026 15:51:38 +0100
Message-ID: <20261118150353.897616940@linuxfoundation.org>
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
index 2fe937a93026c..d0f5c4e89556a 100644
--- a/sound/soc/codecs/wm5100.c
+++ b/sound/soc/codecs/wm5100.c
@@ -658,7 +658,7 @@ SOC_SINGLE_TLV("EQ2 Band 4 Volume", WM5100_EQ2_2, WM5100_EQ2_B4_GAIN_SHIFT,
 SOC_SINGLE_TLV("EQ2 Band 5 Volume", WM5100_EQ2_2, WM5100_EQ2_B5_GAIN_SHIFT,
 	       24, 0, eq_tlv),
 
-SOC_SINGLE_TLV("EQ3 Band 1 Volume", WM5100_EQ1_1, WM5100_EQ3_B1_GAIN_SHIFT,
+SOC_SINGLE_TLV("EQ3 Band 1 Volume", WM5100_EQ3_1, WM5100_EQ3_B1_GAIN_SHIFT,
 	       24, 0, eq_tlv),
 SOC_SINGLE_TLV("EQ3 Band 2 Volume", WM5100_EQ3_1, WM5100_EQ3_B2_GAIN_SHIFT,
 	       24, 0, eq_tlv),
-- 
2.53.0



