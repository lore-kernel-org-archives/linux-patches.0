Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213518;
	b=wFdsNEVWedWhwX58iQH2ubdUNbwfuPasitSANEHuR9ur2NDJKtMuZqQJv6iNLIXYQuXt
	 UPoQZYaRATktxATeJOfwZrOQeqfSD4k430NNnO34EHIprNIi860k9OhpPe+lUsZjzXIIN
	 /kPgO4cGw5Wj8fVTE9+XtkOiwJVEUqXdTGSsvykpQYRqNcCJWDb3h98IAH9LNXyGdkeQB
	 3QPvuMVEMPb4Pf/CFjVHTr7TwZky5eojJ1lRq8ko1+VCWlKesaqx8LCFsFuudkU2PFJ1a
	 LYtcF1k4E0oJQuHB0NGYdfAjmNHOd+tFCwZPVmDrIutxuB92Io733QinkSFC4mSeP8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213518;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=a2+LCirXYDHnPX0k7UlogWHpBt5dK6i4wRucExcIDZ0=;
	b=MImm6eyLb+FORq+X7aDm+Iu8JPUFdmlJoXChmsHSkDyDl+o2d7S1X1hYDS8Nq9OdaTfX
	 Bha+WbWOtXM8+Q3/XxXBokiKQzsA41LvalUiqQqYtllbVI/luE7LLQTKxaXN0L14bi89e
	 eOTR6uQbu+kvhakwyCZsHUG4LvuYdAIoA0lOhwIMTZL268xcauAUsLpqEu60yMG0L9bEc
	 RAf5fmqrSRaJgrfeLTMl4PiZNqN6Pi4wMNkAGmX8hH4BUKns1WC6e685vll90fvy2vVN9
	 OnFrmWdm7U+DayZlqF7hGFQTBDEBi/hSEkCTXbTdmN+BI/g9o6rrYui+GfkF9JxIPsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hxi5nJpp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D07F606A31C;
	Wed, 28 Oct 2026 18:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hxi5nJpp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771B51F01825;
	Wed, 28 Oct 2026 18:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213518;
	bh=a2+LCirXYDHnPX0k7UlogWHpBt5dK6i4wRucExcIDZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hxi5nJppv6tIqqaKQsXEJ1EJUhXk80LeuPRo7dHN6aTfrj0wmp3fGBC6F5Qq5VZgF
	 ytaRPcMajbwxSBezc9lXDe5UpP7rY2zZwMsR6HX8asYqhbJqM35bqnmO337pRQ4kcg
	 LfT53cU1/3U/bcYAb9ap2PzJ+mmHFl0CEd0IyaXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin.sipraga@analog.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0491/1887] ASoC: adau1372: allow sleepy powerdown GPIOs
Date: Wed, 28 Oct 2026 17:43:07 +0100
Message-ID: <20261028170510.446694315@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alvin Šipraga <alvin.sipraga@analog.com>

[ Upstream commit 64dd172bbffe6135d79a06ddad53dd2da4d8bd62 ]

gpiod_set_value() emits a WARN when the GPIO provider indicates that it
can sleep, as is typical for I2C controlled GPIO expanders. Since the
powerdown GPIO is only manipulated in process context, use the _cansleep
variant instead. This lets the driver use sleepy GPIOs to power off the
chip.

Fixes: 6cd4c6459e47 ("ASoC: Add ADAU1372 audio CODEC support")
Signed-off-by: Alvin Šipraga <alvin.sipraga@analog.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://patch.msgid.link/20261006-asoc-adau1372-fixes-v1-1-599cc17fb5f6@analog.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/adau1372.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/adau1372.c b/sound/soc/codecs/adau1372.c
index 3e3b8955036d9..13673c96bc548 100644
--- a/sound/soc/codecs/adau1372.c
+++ b/sound/soc/codecs/adau1372.c
@@ -798,7 +798,7 @@ static int adau1372_set_power(struct adau1372 *adau1372, bool enable)
 		if (ret)
 			return ret;
 		if (adau1372->pd_gpio)
-			gpiod_set_value(adau1372->pd_gpio, 0);
+			gpiod_set_value_cansleep(adau1372->pd_gpio, 0);
 
 		if (adau1372->switch_mode)
 			adau1372->switch_mode(adau1372->dev);
@@ -818,8 +818,7 @@ static int adau1372_set_power(struct adau1372 *adau1372, bool enable)
 							   ADAU1372_CLK_CTRL_PLL_EN,
 							   0);
 				regcache_cache_only(adau1372->regmap, true);
-				if (adau1372->pd_gpio)
-					gpiod_set_value(adau1372->pd_gpio, 1);
+				gpiod_set_value_cansleep(adau1372->pd_gpio, 1);
 				clk_disable_unprepare(adau1372->mclk);
 				return ret;
 			}
@@ -836,7 +835,7 @@ static int adau1372_set_power(struct adau1372 *adau1372, bool enable)
 			 * map. No need to do any register writes to manually
 			 * turn things off.
 			 */
-			gpiod_set_value(adau1372->pd_gpio, 1);
+			gpiod_set_value_cansleep(adau1372->pd_gpio, 1);
 			regcache_mark_dirty(adau1372->regmap);
 		} else {
 			regmap_update_bits(adau1372->regmap, ADAU1372_REG_CLK_CTRL,
-- 
2.53.0



