Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020107;
	b=ed/Z3l5fyH1JUtSciHzTLF7Kc+xCHVVJBWm4pIniPORdIdlIMMhH9J4h/Oy5pK/C9uFE
	 lEZFFCHna3DaA9+R+6R8VgBe9XjT/2PAMvTw02PqsCJvJYhy+Hsn+3NqqUT9b7yD5xlgo
	 Qq/WpmD4KNrKomVUoUPI64VgPzdtjHettZnqlgVx0yQ656cqExc+pEpYET+RjzYsRncMc
	 JmnZDgoYbI/MgjKUomUQIAofBiFeMU/N9kUnhLBoOtRXHOks65GeWQq14F3Df2/k+fAgK
	 gMQaa7c7icxHSWal30CFJEC558eLX7qA/CgZYTg9aJkqsZy3YqQan6vWdl6P7DTwPzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020107;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B9kXP6b277TjF47PFvlHCz4sqik5UsbIXaNkSt0puI8=;
	b=SUpTGKGlVs59tkTvrL7kX4KPndP/Sun3VXofsn2VMHLDrEFhN0XQ7ZQKtbnZjXGK1P2/
	 hnwHZmdBU4Xl9D/MhRmb5X8ZMs1e2j8XJExPd9xrHgFAOFbIhIGA+c4eHdqJE/yoM+4HN
	 v79adg2UhRIKwbY/Utc/hUXNzxVFFGQVeI04PT0QgGNZ2ByrskeLaSMMuD/epX9Ip/+Gq
	 exHwFgsWAHveE7eiyjSQA0Uog+q+AwYFVfxJRVqxUvV0y5JL3/BmAm2kC1WiC2aDnpSPx
	 11b7N9xDP7A7fvir16A46Lbf5S4LvPhxx52ELoagYlUOWQdwzHWrUvRvqQSctn1aYgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ntTNpw4i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 392A5606A31C;
	Wed, 18 Nov 2026 16:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ntTNpw4i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93FAA1F000C5;
	Wed, 18 Nov 2026 16:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020107;
	bh=B9kXP6b277TjF47PFvlHCz4sqik5UsbIXaNkSt0puI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ntTNpw4iVRRLbuIeXamD9+V++qrc3zqciBtdhzMxPk6KpYkal1EpWM6vh0cSAiF4Y
	 KgbW05a9F/jsxA3ZAf6GIv23/2qrUctuK6FOYNIXweBesY2hp/41qpnTfo/2fXb1rI
	 47VIoW8cpVLxYUOLDsndNsK8e8KcpVvRsfhrvZdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1793/2651] ASoC: mediatek: mt8196: fix MCK error handling
Date: Wed, 18 Nov 2026 15:50:33 +0100
Message-ID: <20261118150351.872142797@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit bc0cd0eb030389a78885561dc92f087e7595458a ]

Disable the clock if setting its rate fails after the clock has been
enabled, preventing it from being left enabled on the error path.

Fixes: 7384ecab34eb ("ASoC: mediatek: mt8196: support audio clock control")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260929061121.124001-4-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8196/mt8196-afe-clk.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/mediatek/mt8196/mt8196-afe-clk.c b/sound/soc/mediatek/mt8196/mt8196-afe-clk.c
index 1dc4210e58c71..1d107b85d03c1 100644
--- a/sound/soc/mediatek/mt8196/mt8196-afe-clk.c
+++ b/sound/soc/mediatek/mt8196/mt8196-afe-clk.c
@@ -502,8 +502,10 @@ int mt8196_mck_enable(struct mtk_base_afe *afe, int mck_id, int rate)
 		return ret;
 
 	ret = mt8196_afe_set_clk_rate(afe, afe_priv->clk[div_clk_id], rate);
-	if (ret)
+	if (ret) {
+		mt8196_afe_disable_clk(afe, afe_priv->clk[div_clk_id]);
 		return ret;
+	}
 
 	return 0;
 }
-- 
2.53.0



