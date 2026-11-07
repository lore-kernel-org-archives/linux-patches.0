Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061058;
	b=A6Jwj4aluGLz1cK51ql/OC+2OP6p9eE2dW3dMgubEbpx0yumrLPWxfrsiQ6XyoXFp8iZ
	 mH2xp9ngasRm4CoQYjRgXkZuKkvRznhKdZL8nupP5pB0ApzfCrxydJ7P9nM8ZrLTUTP6o
	 8Mj+BimpDVmXlRF9Ta0Sl4AXyiu41eX332hm3MXOor7zBI2PXhRe6L45KtU2n5tVY2Ijh
	 kjaNPHOyrJ99/zX3Q9f5azFjB1hpe1277uEZQaWeW2k6n1AagexjeyDJ/Z3SApFj+zp4Z
	 OvseZBTr+8fxKxljSEGmVoizDP402BVFi/OztQ+NnlMRa1WT5WzjiUO7Sh+jXYiJN+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061058;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1PAQgp4x9e/+fUNFtHZx15J3E1Eme6hI6lBZZBTTHJc=;
	b=MWTFurpEeVuN/HyTUm0YwqP9XOYgKI5SXbau3i/T+nrB1A/Z3YCpuoIB8J0UrvxXWjXL
	 eu0va8Cwv4CdWChSyYZn1Z4jEZjPgP5c91HRK/zHmYRa6BRVHkl59vKlh4I6SBf3v2N62
	 iUPDcHPjVcS941URdKVci1E4aYhRspnGMwziMDnldEI1nDXo1uEUby33FwzeBDYYn1QbI
	 FlKT34jBhUf9/NT7AWK71CQZ2MCk/j3wFw+hcXdoRiKoRmDurDr/ZakJJt6WkgAAGQ35q
	 cedoiamWdI5cICb7BS6fwhiFoNLGgNYg4N89xh3x3zaSj48sj1QPAh/BHkD+P8PLy1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IuwzztR9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF486082BC0;
	Sat,  7 Nov 2026 14:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IuwzztR9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 198C81F0089F;
	Sat,  7 Nov 2026 14:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061058;
	bh=1PAQgp4x9e/+fUNFtHZx15J3E1Eme6hI6lBZZBTTHJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IuwzztR9VZmN0O9FP6sLgtl+aGQZO2WwgwnbO6nTPGyvdfzbREP1GUHDE8Rd3SLhw
	 2vtQseSFCBTBIG4lX1ALAGW/xIpe1dTVBWUaTU4185KpJXjX7p/42jIMGlV6o0MBU8
	 NNk8jXx2Zo5eXvo01Y0/SWthuHP76uLwGXQSxlu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Yu <jack.yu@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0371/1536] ASoC: rt712-sdca: Pull high JD2 to prevent from entering TV mode
Date: Sat,  7 Nov 2026 08:39:47 -0500
Message-ID: <20261107135008.065787200@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Jack Yu <jack.yu@realtek.com>

[ Upstream commit dfb8bc1d286fd97b7cf47e3af5df84cfb068d214 ]

Add a patch setting to prevent ALC712 from entering TV mode which
may cause unexpected issues.

Signed-off-by: Jack Yu <jack.yu@realtek.com>
Link: https://patch.msgid.link/20260820092415.2979641-1-jack.yu@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt712-sdca.c | 1 +
 sound/soc/codecs/rt712-sdca.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/sound/soc/codecs/rt712-sdca.c b/sound/soc/codecs/rt712-sdca.c
index 7a214d4a9105f..f48ebdf6b6226 100644
--- a/sound/soc/codecs/rt712-sdca.c
+++ b/sound/soc/codecs/rt712-sdca.c
@@ -1733,6 +1733,7 @@ static void rt712_sdca_vb_io_init(struct rt712_sdca_priv *rt712)
 	dev_dbg(dev, "%s jack/mic/amp func_status=0x%x, 0x%x, 0x%x\n",
 		__func__, jack_func_status, mic_func_status, amp_func_status);
 
+	rt712_sdca_index_write(rt712, RT712_VENDOR_REG, RT712_JD_CTL3, 0x7778);
 	/* DMIC */
 	if ((mic_func_status & FUNCTION_NEEDS_INITIALIZATION) || (!rt712->first_hw_init)) {
 		rt712_sdca_index_write(rt712, RT712_VENDOR_HDA_CTL, RT712_DMIC2_FU_IT_FLOAT_CTL, 0x1526);
diff --git a/sound/soc/codecs/rt712-sdca.h b/sound/soc/codecs/rt712-sdca.h
index 2169f2f726b9f..ebe81d68135bd 100644
--- a/sound/soc/codecs/rt712-sdca.h
+++ b/sound/soc/codecs/rt712-sdca.h
@@ -70,6 +70,7 @@ struct rt712_dmic_kctrl_priv {
 #define RT712_JD_PRODUCT_NUM			0x00
 #define RT712_ANALOG_BIAS_CTL3			0x04
 #define RT712_JD_CTL1				0x09
+#define RT712_JD_CTL3				0x0b
 #define RT712_IO_CTL				0x0c
 #define RT712_LDO2_3_CTL1			0x0e
 #define RT712_PARA_VERB_CTL			0x1a
-- 
2.53.0



