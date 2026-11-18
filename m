Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021816;
	b=oiTWTEduTkVA7+i+9e5apsA6ikUs9gDJjAIPPMyAfsBDdKfaB1Ri8/vZ8jbOyHp32aQa
	 SaRQ8pRT4o8sAojPQ44Ht7CuT6+QnvX/LDXEzDEy2ALBOo7SZGd9WKnsemnaewodrxczl
	 BwprUtyf5n32NFVHRp6rA5qgw4DT0pgl3KNCruEaECso2LnjILlzSQtkvWgTe0OM9jMyq
	 LN6kmlmC/i6VOFFv8aXODuIBlmFourJX9HH/EpHjQe5kToWlTIBn3qYXLn8MrEQvN/IwS
	 /yPdu2YXS7wP7ntmPOgUSkwV2hqRmR0t1KTK/y/taL7CwvNltcL8O1C9c8/2MADupKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021816;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AdupU9nFVYykFkfD395wXNsWJcBJ/FrRBwH+mO8q7co=;
	b=Nc0k2FtNQ8FoNN8ySiVepFcW+zl6pTzS0/LynotA2r1YrvzBuBV6GitEoYUzY8f8WJQA
	 /ZrGL4REwpG4mvDd8soUU2Ek24FqDawIBj3y1LtZDtQjH/Ur6ss6K8K6V27HcyNZAPIr5
	 UGDHjXkoiT/eYpkvF6okbATi+yYmJVHhnnwNBmF35VPRs8L0q+x6/kMK3zB/hNx7Cg8Yi
	 7AwkaLZgBjx+aVXcNr+eSxYnFEBl5pxTyOOavEdBRfhH/WiEKu3gSHVppbf3dL7xWtJO3
	 2y+f51UZ4k7LMuubkE1KsR+jgFL0HLLWFscs7WlMZbeqcP4ynhkYGffcEfFDtkIBaLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="0Hp0qtX/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF6D606A31C;
	Wed, 18 Nov 2026 17:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Hp0qtX/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB1FE1F000C6;
	Wed, 18 Nov 2026 17:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021816;
	bh=AdupU9nFVYykFkfD395wXNsWJcBJ/FrRBwH+mO8q7co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Hp0qtX/2D08FGv8lZik0xySUG2/oNoksSLEuq+4tsMrk+6wsWWf60vEFWCpgF57o
	 5YikooFcB7UwJ+2NohsHJg6DvJOzmsDTk9bNP7e+jMVuVAzamEX0hD16vTSc8KFnWx
	 11u2s1AuYmt7MBo9aWO6cFVXz6puQEflb2HtRjSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2440/2651] ASoC: codecs: wsa881x: Fix shared powerdown GPIO handling
Date: Wed, 18 Nov 2026 16:01:20 +0100
Message-ID: <20261118150413.014430442@linuxfoundation.org>
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

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit c80f86ed857e21dcdd389559d3e62bf53ff39f9a ]

On Qualcomm RB5 both WSA8815 speaker amplifiers share a single powerdown
GPIO (TLMM 130), which is handled by the shared GPIO proxy. Since commit
b30973e8c392 ("gpio: shared: make the voting mechanism adaptable") the
proxy treats the value set by the first user on request as the default
and lets any single user vote for the opposite value.

The driver requests the GPIO de-asserted (GPIOD_OUT_LOW), so powering the
amplifier up became the default and asserting powerdown became the
winning vote. Once both amplifiers are runtime suspended, resuming them
deadlocks: the first one releases its powerdown vote and waits for
SoundWire enumeration, but the line stays asserted, because the second
amplifier is still suspended and votes for powerdown. The wait times out
and playback fails:

  wsa881x-codec sdw:1:0:0217:2110:00:3: Initialization not complete
  wsa881x-codec sdw:1:0:0217:2110:00:3: ASoC error (-110): at snd_soc_pcm_component_pm_runtime_get() on sdw:1:0:0217:2110:00:3

Request the GPIO asserted, so that powerdown is the default state and
the line is de-asserted as long as any amplifier needs to be powered,
then de-assert it to power up the amplifier as before.

Also use gpiod_set_value_cansleep() instead of gpiod_direction_output()
in the runtime PM callbacks. The line is already configured as an output
and the proxy resets its default value when the direction is set while
it has only a single user, which can happen if the other amplifiers have
not been probed yet.

Fixes: bfa336cee332 ("ASoC: wsa881x: Move custom workaround to gpiolib-of")
Fixes: b30973e8c392 ("gpio: shared: make the voting mechanism adaptable")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://patch.msgid.link/20261022090923.769464-1-m.szyprowski@samsung.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wsa881x.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/sound/soc/codecs/wsa881x.c b/sound/soc/codecs/wsa881x.c
index 47ac3e4985a56..4f3e6bc29c7ec 100644
--- a/sound/soc/codecs/wsa881x.c
+++ b/sound/soc/codecs/wsa881x.c
@@ -1115,11 +1115,19 @@ static int wsa881x_probe(struct sdw_slave *pdev,
 	if (!wsa881x)
 		return -ENOMEM;
 
-	wsa881x->sd_n = devm_gpiod_get_optional(dev, "powerdown", GPIOD_OUT_LOW);
+	/*
+	 * The powerdown GPIO may be shared between several amplifiers. Request
+	 * it asserted, so the shared GPIO proxy treats powerdown as the default
+	 * state and keeps the line de-asserted as long as any amplifier needs
+	 * it, then power up this amplifier.
+	 */
+	wsa881x->sd_n = devm_gpiod_get_optional(dev, "powerdown", GPIOD_OUT_HIGH);
 	if (IS_ERR(wsa881x->sd_n))
 		return dev_err_probe(dev, PTR_ERR(wsa881x->sd_n),
 				     "Shutdown Control GPIO not found\n");
 
+	gpiod_set_value_cansleep(wsa881x->sd_n, 0);
+
 	dev_set_drvdata(dev, wsa881x);
 	wsa881x->slave = pdev;
 	wsa881x->dev = dev;
@@ -1154,7 +1162,7 @@ static int wsa881x_runtime_suspend(struct device *dev)
 	struct regmap *regmap = dev_get_regmap(dev, NULL);
 	struct wsa881x_priv *wsa881x = dev_get_drvdata(dev);
 
-	gpiod_direction_output(wsa881x->sd_n, 1);
+	gpiod_set_value_cansleep(wsa881x->sd_n, 1);
 
 	regcache_cache_only(regmap, true);
 	regcache_mark_dirty(regmap);
@@ -1169,11 +1177,11 @@ static int wsa881x_runtime_resume(struct device *dev)
 	struct wsa881x_priv *wsa881x = dev_get_drvdata(dev);
 	int ret;
 
-	gpiod_direction_output(wsa881x->sd_n, 0);
+	gpiod_set_value_cansleep(wsa881x->sd_n, 0);
 
 	ret = sdw_slave_wait_for_init(slave, WSA881X_PROBE_TIMEOUT);
 	if (ret) {
-		gpiod_direction_output(wsa881x->sd_n, 1);
+		gpiod_set_value_cansleep(wsa881x->sd_n, 1);
 		return ret;
 	}
 
@@ -1182,7 +1190,7 @@ static int wsa881x_runtime_resume(struct device *dev)
 	if (ret) {
 		regcache_cache_only(regmap, true);
 		regcache_mark_dirty(regmap);
-		gpiod_direction_output(wsa881x->sd_n, 1);
+		gpiod_set_value_cansleep(wsa881x->sd_n, 1);
 		return ret;
 	}
 
-- 
2.53.0



