Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064094;
	b=OtSUbVIFwA1q0Jlr/5KqewK2n5Hgl2+yuYLW19TzjNgAUKzAJWmiTd7rYaLebc0+0pot
	 J1M6EQ8fitWnLipTUaJXRtUOl2RttnVll8fJNYo//Ai4K5hmNFNCR3PnmlxfV7Dfc0ZCq
	 MlMWnSrRUoJ0y80Oh2Dl7W4SBLlbQ3UZ24PlLVEzbu4vo+I3dcjvFKSvp/+cUBx6uLWlp
	 +v8fixQ+KcttsEkQ/JonSrgObducm1JHrnaT2uNPpe3DhNnMsQn7BHclnihnbD1TxLjx4
	 S5cS5+JrAJ67Q5sToJtswpQZoPX99CFQvXO/eXYU1sJ3lC5ivzCm05X2bStVXgOxeqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064094;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xuFzjf8z4/qnvLqpdm/tvqx1HaQizl7biRM8xfscFuc=;
	b=V1WSp/NUJTxWsgJ2TZ+yU80NUMEvehV2BlwXhGUombmaWZueiCx4DuG8Six9wxuKmse3
	 3nDIYUyFGsC/74g7mWzK8Lw5RT2jDb4ICPJx45e5Od5A8tWWbstHtjfSBHWmbGpIlYsWI
	 n7CUpggUVt5oEjP73tJt4E2SZmYRi71AV/boN3Zh0+NeHlVWiGaXjonYqVqiJ50sa01/k
	 3EyIGgZfGJVpfiomhOgiXTF9MiM6Vj4FkyBS0D0o0w4HsPMkRSnwm3IPq9HSqx5AiPHyW
	 eIcBaZr8+z7vz/V3gpwfQ2ldd81BFXg379pDKQKruuIqn0Q3VO23kYu2vIGAnPbdsUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kTnJcpsZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B96606CE56;
	Sat,  7 Nov 2026 15:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kTnJcpsZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020C71F0089F;
	Sat,  7 Nov 2026 15:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064094;
	bh=xuFzjf8z4/qnvLqpdm/tvqx1HaQizl7biRM8xfscFuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kTnJcpsZFjpdC4+Spjk8jwZmUKwE9ElEm7DFYESZBrA2GlK590aP1u2yQAAdZlVXq
	 Eu/64udnGX4O/yD0L5PoadIxa6X6amZ3y4ro4gb6OBIRT0zGv0FYaX5D0K46u7uXFL
	 gwjj096m8avwVToPufXURJf2CwygMdLgJKXEMa9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0207/1257] ASoC: codecs: wm8994: Fix runtime PM leak in wm8994_mic_detect()
Date: Sat,  7 Nov 2026 08:41:43 -0500
Message-ID: <20261107134945.260600260@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit b2c0e5bf750e33b0e1dcdfbb2df8103a06c7caab ]

wm8994_mic_detect() resumes the component before configuring the MICBIAS
pins, but the default case of the micbias switch returns -EINVAL right
after taking that reference, skipping the pm_runtime_put() on the
success path. This leaks a runtime PM reference on every call with an
invalid micbias.

Release the reference before returning -EINVAL.

Fixes: f5a2cda4f1db ("ASoC: wm8994: Ensure the device is resumed in wm89xx_mic_detect functions")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260917165130.2163278-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8994.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index 0d1b4b1fcecda..58cfdd60d8ab1 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -3532,6 +3532,7 @@ int wm8994_mic_detect(struct snd_soc_component *component, struct snd_soc_jack *
 		break;
 	default:
 		dev_warn(component->dev, "Invalid MICBIAS %d\n", micbias);
+		pm_runtime_put(component->dev);
 		return -EINVAL;
 	}
 
-- 
2.53.0



