Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830988;
	b=IQb+KVTxbbgcGPq+Q6vI9mun8yfc+4VpvPFoxfQ+Thg5XHJ9bDDlb9OMgcjlC5cPL4qv
	 oZXv9fLpMjqLAfuKUjVtC8geZZv1SUpp6n/nZxfbq6t/XMcmUtUyTDsjoc1pmQ9PuRoJ/
	 mjbGGfOK6hl/Eutri8hEP3gumF5xK651O+n+muvFGPMB7EYudivqz49fUL3NcZy/45bTO
	 ccMk9JmO62nJG6AuWM/PkjWPSV3s+x7llczC2v9argO2u0FxMbGxnmAfe81iLoHA4WTwN
	 V23bUVxgO807xqF3inVhnt0A0M1hMjWvJ2vDXIwhQ7d5BAkVVFaFOezqfTnH0HJ6/2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830988;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MV+DieMH2ElY35EAPwJxFtErl6YB5tHdz+CXxPXzkq8=;
	b=UGHQaV8BcIwpkrTLEq76bHThsNLy4a4Zz0UlEoQrXg2Q7PX0gyF2Ddl+Bn+ifpcfu/bb
	 QH/2KtR7HgT8jd5LEFFA9rxd0HvNb7AHeD4IuHAif0dtR10kKLQw4hPTFJJ0F3cFBhKTT
	 OYZzqlPp7xdmKFEApd1UOKKGxMgOmddZk1dpxVCA8Ry2Lf/G3VJ3QzLBOme4ZtYlfqMd3
	 rMhDDXefEVh1Vafcc/R2tvltqIJXd52sguDWeEBssaG4s3JP47cI+lyFV9njf0SmG7Q8P
	 uImKZ5sgZYC8gt5FSON8ovyb0fJXPsnrCwuHRW5j/i3t3pJJVNiM55hkcBT/2n0iX7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aBwPYZfq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F78606AB19;
	Wed,  4 Nov 2026 22:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aBwPYZfq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA7261F000C1;
	Wed,  4 Nov 2026 22:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830988;
	bh=MV+DieMH2ElY35EAPwJxFtErl6YB5tHdz+CXxPXzkq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aBwPYZfqMhKPHgDHEftpmQSS9vs3CFAnjCWZwqsJ5fca7KDkljUt94E/K5BkoJlMu
	 2StgO1kR4pjS2RlsPC7hnduqMLEAe2lraMHknmj/pTWk1QLen1y4u6gSViC/YTDG+L
	 N+2vgWy4BCFrIdRNUt27z1liL/rBIrqbVg2oHeLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Yu <jack.yu@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0441/1005] ASoC: rt712-sdca: Pull high JD2 to prevent from entering TV mode
Date: Wed,  4 Nov 2026 16:02:54 -0500
Message-ID: <20261104211056.428615695@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index d8b40663fa92f..a799b8aab73aa 100644
--- a/sound/soc/codecs/rt712-sdca.c
+++ b/sound/soc/codecs/rt712-sdca.c
@@ -1786,6 +1786,7 @@ static void rt712_sdca_vb_io_init(struct rt712_sdca_priv *rt712)
 	dev_dbg(dev, "%s jack/mic/amp func_status=0x%x, 0x%x, 0x%x\n",
 		__func__, jack_func_status, mic_func_status, amp_func_status);
 
+	rt712_sdca_index_write(rt712, RT712_VENDOR_REG, RT712_JD_CTL3, 0x7778);
 	/* DMIC */
 	if ((mic_func_status & FUNCTION_NEEDS_INITIALIZATION) || (!rt712->first_hw_init)) {
 		rt712_sdca_index_write(rt712, RT712_VENDOR_HDA_CTL, RT712_DMIC2_FU_IT_FLOAT_CTL, 0x1526);
diff --git a/sound/soc/codecs/rt712-sdca.h b/sound/soc/codecs/rt712-sdca.h
index 7ab7d5feb50a2..46740281a5c17 100644
--- a/sound/soc/codecs/rt712-sdca.h
+++ b/sound/soc/codecs/rt712-sdca.h
@@ -74,6 +74,7 @@ struct rt712_dmic_kctrl_priv {
 #define RT712_JD_PRODUCT_NUM			0x00
 #define RT712_ANALOG_BIAS_CTL3			0x04
 #define RT712_JD_CTL1				0x09
+#define RT712_JD_CTL3				0x0b
 #define RT712_IO_CTL				0x0c
 #define RT712_LDO2_3_CTL1			0x0e
 #define RT712_PARA_VERB_CTL			0x1a
-- 
2.53.0



