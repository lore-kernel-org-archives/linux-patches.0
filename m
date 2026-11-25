Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624507;
	b=hjF/MhTCJUN1fFayqEJ1XsxNu8Cyh/GDT3itV3m5KnZ74vCMaTP7XjcN5tqv5H1a6zYT
	 JBnsuOsYOM0gCqoWL0zln1xAJxFHx5dnmtwCyq8jcUBhEQpjGpe5omrhL9Z+uoAX5VKlY
	 3hrBE7iJBgPNpGkvUokzF7bjH0nSKTzCjQSHikGDwcfhW/Nxhce0xkrQtJkKoyopANLym
	 sMGXqajPLeqzF/2xOOWU2l4O0wwUyegsp2/Pg76hLIhpsNgX8y1EVX2+DAKSuJMnZPPFq
	 FraNh+kYTiIOqvW2MlprzPaVcfXr+h5zT2TGXf5UU8JRjOb3YrDiE3hhMQfhbbtQ1iA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624507;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m0PSde0UKM58KqnJeJszYgR4YGda40DKdXYR6dgkqr4=;
	b=U/y1t/INplPmf+Y5iCRMAIPCfnIWGv420PhMcuSspzLQmlMWRct9UCRDMHdqb+ximMh6
	 dmLI3w3I0njx+9sanuFSrUmLR7SY6Yvwy28ABlLdphyoQoNQW87qz1n5JUdD3JSb4EEX6
	 tFE+/JDI9eQ2OCFVbmPVFGsAzimo0owsg5o6fwSqi4usLbaIZObCF1Mq2XRaGjSeYuKlE
	 3kDWe31CIHSj2z/WFlVx3Ws9FcGfXFUldC9cfwMT12qw5ec6i692m3sVKqC0xoAxLz5BF
	 O7U7997o6mANcuWIALA1mfmDvnjJy/d4CIElkEqI37yMvNf/QftGbSv/AYLOzNybLmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=03EB7WN8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24730606A33B;
	Wed, 25 Nov 2026 16:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=03EB7WN8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 591361F000C0;
	Wed, 25 Nov 2026 16:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624506;
	bh=m0PSde0UKM58KqnJeJszYgR4YGda40DKdXYR6dgkqr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=03EB7WN800IQG3oVFBACXhOizSE5Z3gbbsczJQ9dcQlGSo0vUVPJAlKVPARgPkrSk
	 r9ki1jd27uMrUfildofjBdg/Sku/CrigEgbgIFNTmKA8XvGYmMk8tE79ZSuJp8HkRT
	 qLJcuihSColFmFvRlKmfxcdfIYVRhPC2AeXrp0p4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 214/816] ASoC: wm_adsp: Prevent negative string length in wm_adsp_control_add()
Date: Wed, 25 Nov 2026 15:29:22 +0100
Message-ID: <20261125143854.155777606@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 4d07af76ca41cc1a03240cd3b5f44dc428856214 ]

Check that avail does not become < 1 in wm_adsp_control_add(). This
prevents overflows during subsequent operations.

The main aim is to trap a negative value in avail, but a zero length
would mean that the control ends up without a name, so 1 is the smallest
valid value.

Fixes: b7ede5af62ab6 ("ASoC: wm_adsp: Take prefix into account in control name length")
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20261104133322.1085061-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm_adsp.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/soc/codecs/wm_adsp.c b/sound/soc/codecs/wm_adsp.c
index 5d5d1c0c9b936..594f9892440fc 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -43,6 +43,9 @@
 #define adsp_dbg(_dsp, fmt, ...) \
 	dev_dbg(_dsp->cs_dsp.dev, "%s: " fmt, _dsp->cs_dsp.name, ##__VA_ARGS__)
 
+#define adsp_warn_once(_dsp, fmt, ...) \
+	dev_warn_once(_dsp->cs_dsp.dev, "%s: " fmt, _dsp->cs_dsp.name, ##__VA_ARGS__)
+
 #define compr_err(_obj, fmt, ...) \
 	adsp_err(_obj->dsp, "%s: " fmt, _obj->name ? _obj->name : "legacy", \
 		 ##__VA_ARGS__)
@@ -627,6 +630,13 @@ int wm_adsp_control_add(struct cs_dsp_coeff_ctl *cs_ctl)
 		if (dsp->component->name_prefix)
 			avail -= strlen(dsp->component->name_prefix) + 1;
 
+		if (avail < 1) {
+			adsp_warn_once(dsp,
+				       "%.*s: ALSA prefix too long: control not created\n",
+				       cs_ctl->subname_len, cs_ctl->subname);
+			return -EINVAL;
+		}
+
 		/* Truncate the subname from the start if it is too long */
 		if (cs_ctl->subname_len > avail)
 			skip = cs_ctl->subname_len - avail;
-- 
2.53.0



