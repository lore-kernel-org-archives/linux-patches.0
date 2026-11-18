Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025483;
	b=RUpUpNFLsr53gF/Tcjg5EtoQq8Xx/iPZOsb/LXNad802L1IWuAPsgJgk/spfVDo5qz+w
	 Ms9x7ZOz9Dy3CDDi1CxQq7J2SZTFU6WtWYL/zvQTKDtt26kpRqP54t6OZjzZ8/YSWN78m
	 H8zXbLHIrfzBY0aO+1oJ1L3S+oeLMX6ZiiNjUdQpVu/QrsXKr1fJczTF16GZMOsCqdgLb
	 Ao3YdqRQH0JgyLO6Tm+nzfYPklewYTlm24d95YunRrGFJ+/dVIMY3KV8kdjGDfSK+COFW
	 67f0GLzRK7u9wMHTPMjvf6FU6pVdtSyXXom7T0mxfjaUATSvh88EoSKWYO65QIvKWRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025483;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p3B7+/+zajn/jJf/reK6OiIOsp05zESrN3cqlswlHeU=;
	b=KUijzSYfjQLXtRSQmnGphSyKvnpkuWIWFP380oIRUnNC7enIkYLbhXI4u2Fgs16aq9ar
	 ad/kLBX4Z289lsw8UBVzZehgDcgwSWjbpPSlg4KOa7cfysJ/CzKt0nD6X3OfAOOSFEe5Y
	 IEqld9uHeLkZ3pXIjVzFlu/NC3ANAe62Jqxu5tXs39634eoPDGxrdxZk5z4KNfK6Inm8B
	 uhYMUraJcjlk3h1RweKkm3LDCW4jMHjQzkgHMbOQ62nrAjcMUt//HG6X89XzzIIT83ix8
	 IZoW8+4qrtP1SZb5QUNSEN46689/jiubOOP0yDwZ5dm3EIzf+SoL1zoIyQphuiLZxuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wl0r61ED;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4294B606A330;
	Wed, 18 Nov 2026 18:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wl0r61ED
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9240B1F000C4;
	Wed, 18 Nov 2026 18:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025483;
	bh=p3B7+/+zajn/jJf/reK6OiIOsp05zESrN3cqlswlHeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wl0r61ED/auevTphg1bmM7Xb0sWGEyIfgMDode38p0Oj6YVduHMu/HDOKokWsrzUc
	 DtOY4xUHkfEO/XHeZ9E+BHibgsK/SAFitYFcFVx/cO5mJ4rU6xpmAMvMkZGjCaPVyM
	 ju9KyzRutsBFhg1e8TmzUoBAdA5NbyL70pCxhupc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1094/2151] ASoC: codecs: es8375: use devm_clk_get_optional() for mclk
Date: Wed, 18 Nov 2026 15:47:09 +0100
Message-ID: <20261118150202.123198981@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 58e7bca5cf264e910ad9199cfc40246e0a2834f4 ]

es8375_read_device_properities() gets "mclk" with devm_clk_get() and
then tests the result for NULL to print "assuming static mclk". A
missing clock makes devm_clk_get() return -ENOENT, so the probe fails
before that test can match.

The binding does not require clocks, its example has none, and
everest,mclk-src lets the codec run from SCLK instead of MCLK. Use
devm_clk_get_optional(), as es8311, es8316, es8323, es8326 and es8389
do for the same clock.

Found with an experimental clang warning about NULL tests on functions
that return error pointers. Tested only in QEMU with i2c-stub in place
of the codec, not on real hardware.

Fixes: de2b3119f9f7 ("ASoC: codecs: add support for ES8375")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20261003190738.77564-1-kmehltretter@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8375.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/es8375.c b/sound/soc/codecs/es8375.c
index c235f91929b31..7c09b51aa24f8 100644
--- a/sound/soc/codecs/es8375.c
+++ b/sound/soc/codecs/es8375.c
@@ -667,7 +667,7 @@ static int es8375_read_device_properities(struct device *dev, struct es8375_priv
 		return ret;
 	}
 
-	es8375->mclk = devm_clk_get(dev, "mclk");
+	es8375->mclk = devm_clk_get_optional(dev, "mclk");
 	if (IS_ERR(es8375->mclk))
 		return dev_err_probe(dev, PTR_ERR(es8375->mclk), "unable to get mclk\n");
 
-- 
2.53.0



