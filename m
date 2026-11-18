Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061476;
	b=WfuCZHrMpC82F3IFUsDW8kd/jPRlaLCB43ghMFrzoK0Qnek/Zt4t/l8puigEtAoQGHsP
	 AHpoOM8yG7Cz20iIBgISsKXqY7o3fysoDhUTCnW/vlrATbFnFRoUYjcRQwoVAfL6d7v4E
	 3kzIO84C3W77I5R1uQuPPESqLO+z4JiPs/+ERTp7ZQfxVMI5/Hcq15DmKYg+1JK5xHTXf
	 LaW2A8LXoOmswMSzAXFaPof20E8my9gvB3tmRzF1//rHs2jqKxPcr2UZCwbU6TCPXpr0j
	 5i2g3GtPFlRChZhMew7WRDt9yjgivX4wOUcHzB/1BdYT7Li2fIWeb+uXwHUMzi3Lp8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061476;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=RmD+mLd92LXWJnOdYm38fbYHX9ARft3MI1FKGcKtalM=;
	b=sbbYtqvpRjREjtjchgVlTXN9GgzIjLPgcE9AGjUDMWaNoR6Gjme3uHYRFRUIAKS6yxJk
	 HCl5MQOcl1+pT/eldU4n1EQRJvjWslLpTSPY/qEOiWrsi0xg5HrUAarg9/kOsTB7S49v+
	 WEpsbxNMBqxwcBMs1A/lvcNYkc/0NqE7Rl1BK/rcTOcGnvVbb53DjEeXcqxpnFubsbpPt
	 yORqvO/Lq7Myb+I8Y/qnwyVe6In6w1kJslDvBMAsYwzApc9nVRwr6bTCVaz3babrJCOI6
	 IsRdma4zPflBwPhTna/ex3mjWBjdwcfuiUTFXuJxOsq1yV1wY114XTqOTjhuI6nMWrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FMpSsfEX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0016960A2602;
	Thu, 19 Nov 2026 04:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FMpSsfEX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 538741F000C4;
	Thu, 19 Nov 2026 04:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061475;
	bh=RmD+mLd92LXWJnOdYm38fbYHX9ARft3MI1FKGcKtalM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FMpSsfEXaOsnszpbhAsQK7Eg96I+terRF5OqXOer9BAtK9s5FW3AsF8H1XcZZP0b1
	 pV8pgKXYRVe8gxD3T13iK5LXDm4AbS73aB01looADDq48Y8SpK2uJ+Mdd2WplejG73
	 2IoV4gx/PDM5JeSmHS6kyvXVJbkIl7XlgypUuBWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	=?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin.sipraga@analog.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1567/1848] ASoC: codecs: rt5659: propagate GPIO errors
Date: Wed, 18 Nov 2026 16:00:05 +0100
Message-ID: <20261118150025.172035950@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit c1e321bd5ce6ae3702db65837cfe0c792634d603 ]

devm_gpiod_get_optional() may return an error pointer, including
-EPROBE_DEFER, but rt5659_i2c_probe() does not handle these errors
for the ldo1-en GPIO and does not check for errors for the reset GPIO.

Check the return values and propagate GPIO lookup errors.

Fixes: d3cb2de2479b ("ASoC: rt5659: add rt5659 codec driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Reviewed-by: Alvin Šipraga <alvin.sipraga@analog.com>
Link: https://patch.msgid.link/20261009112204.33199-2-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5659.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt5659.c b/sound/soc/codecs/rt5659.c
index ae6091498d5bd..ca141e0f49bcb 100644
--- a/sound/soc/codecs/rt5659.c
+++ b/sound/soc/codecs/rt5659.c
@@ -4115,10 +4115,14 @@ static int rt5659_i2c_probe(struct i2c_client *i2c,
 	rt5659->gpiod_ldo1_en = devm_gpiod_get_optional(&i2c->dev, "ldo1-en",
 							GPIOD_OUT_HIGH);
 	if (IS_ERR(rt5659->gpiod_ldo1_en))
-		dev_warn(&i2c->dev, "Request ldo1-en GPIO failed\n");
+		return dev_err_probe(&i2c->dev, PTR_ERR(rt5659->gpiod_ldo1_en),
+				     "failed to get ldo1-en GPIO\n");
 
 	rt5659->gpiod_reset = devm_gpiod_get_optional(&i2c->dev, "reset",
 							GPIOD_OUT_HIGH);
+	if (IS_ERR(rt5659->gpiod_reset))
+		return dev_err_probe(&i2c->dev, PTR_ERR(rt5659->gpiod_reset),
+				     "failed to get reset GPIO\n");
 
 	/* Sleep for 300 ms miniumum */
 	msleep(300);
-- 
2.53.0



