Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033954;
	b=QqP8DmtLSOgw8O87iw+ss6Oh59e9WbKwNkppj3YdFRhEXFyztDjFfCFSCYAm0GBxMdLC
	 pR1biOvhwfZyJfYPierfam24u+cuRVsuyLaoAa6UdFiYPnysHy6aQP+OKVR6tkgUv5i4T
	 ChEy/qkmfb6/w0Qsw4vp95OpKJtnZLCNZ0kENel6L9SLN/06SNjdeGDHQn6y+9dHZ9nYc
	 LVTKKbzk09UgeTBGF5VUZkXkCfHrl4AUxY1eF5i/PbnhdI3oZWkLnU7omRd/Jqjvl1VIu
	 9n04vAlq6ftpVCpsF6LIUoYXdG/X5/gOZKP+XBY1IEroBSr4m2cHT4QrJux+lT0y0QQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033954;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WuawLbqE0aEMGRBRTBnLZmr0U0rdC9XDxJDmq2cMarg=;
	b=vYjNGQgCViefReeciprJt7nDxarLVL5cuLVh8YD6T5Cu5cI+CTJTRr1rVFWfP3XTLC36
	 2/4sbig4la9AMotr5EmGc2TAHlin4GL1HS/xIt1HBlRkSUJorKUcQgSIVc30OhX+AH0td
	 ME1g6BiuNXz50lMgWAiRR/uhrEsNhPtdB28nDCUBuw1D6a+eleTVqx8Qkk9SzWREiZ8QD
	 TErZsgKGKjXiU0K7xCXQEWNL1VHRk6MypwrMP9Lf48f3atk9AjWTeqHYE5VK/7yxExnSQ
	 Nlg7TIcesgGEL2xnADtGGelrNsqKYl7+dcDMESg8vJ+qP1S+AolUSXBvrfYRJw8zQuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qzWkAd9M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB7D606A325;
	Wed, 18 Nov 2026 20:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qzWkAd9M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B2BC1F000C6;
	Wed, 18 Nov 2026 20:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033954;
	bh=WuawLbqE0aEMGRBRTBnLZmr0U0rdC9XDxJDmq2cMarg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qzWkAd9MQ3pPRzIqCqv9P7CaMN1upMUCd2HlEWG/dhqsX+kLyzYAOUEmRW9A/CS3I
	 5Jm8uDA0YpqKPX4/MBWKEDcMrFePOzpF4WLtDGtSbVFDJ3SjXRM8ycAUQTmnmky9r1
	 x+tymG8uAwADu6Obm6b36UqzzFqewfubvASdxiqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0197/3318] regulator: rt6245: Restore state on enable failure
Date: Wed, 18 Nov 2026 15:13:39 +0100
Message-ID: <20261118150320.750900773@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit e95a0a309ca02bf26dc937cdeb3fe2a235c65f63 ]

Currently, if regcache_sync() fails after the enable GPIO has been
asserted, the driver returns with enable_gpio still set high and
regcache_cache_only() left disabled. This leaves the device state
inconsistent with the disabled state, where the enable GPIO is low and
cache_only is enabled.
On failure, restore the original state by setting cache_only back to
true and driving the enable GPIO low before returning the error.

Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260729100018.66577-1-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/rt6245-regulator.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/rt6245-regulator.c b/drivers/regulator/rt6245-regulator.c
index 1843ecec19229..5c0ee04e97ac7 100644
--- a/drivers/regulator/rt6245-regulator.c
+++ b/drivers/regulator/rt6245-regulator.c
@@ -49,8 +49,11 @@ static int rt6245_enable(struct regulator_dev *rdev)
 
 	regcache_cache_only(regmap, false);
 	ret = regcache_sync(regmap);
-	if (ret)
+	if (ret) {
+		regcache_cache_only(regmap, true);
+		gpiod_direction_output(priv->enable_gpio, 0);
 		return ret;
+	}
 
 	priv->enable_state = true;
 	return 0;
-- 
2.53.0



