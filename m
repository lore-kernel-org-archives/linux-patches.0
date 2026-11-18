Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045156;
	b=3m7yQeZowCv6JYSD33+ctklcgLCdyvcrs9a2v+LLPuX58BBtxXQ/FbSlFrxtm+TPCNzz
	 pOp56InOSpz0AM6DEhAJpTP1TokgCCmiJigmq/M6hzf3H7D8sX5SiGzSQfYg51AzgHmJJ
	 spFNyADFDHdLqS4SHketecrG72Ng1B70lYheOK0rFFAmUPMtJygmTm3dTu3Lhvy/lzS2L
	 r/L5iDzWfPj07JqjBUCXN9KRW1OZaPQM9r7Q9k9RgGP6aqRwTDokV6zgbpgi/g4O8UqCb
	 coJuKUMpgPsyqMUCwyJfCTSKPRLi8Xd8uSYeCtgPBxq+Ga0hyilsEYRPsi3lLtcKbkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045156;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XJjnhXp7n8fQzNkIQZorh4uPAdqH/FNqzCU1I+EQi+8=;
	b=iFc6nqdFVSGZG3VUhXd7Sv0dnSDh246znA9sa8nCFZu4QBkYdpTJtUCSJVnSlUHdlFbV
	 li4/Ggj0pg/MwhMwFec/w0TLe9kKZR9DCRVgH8XWVvx71wqfk81wpyVyHsmj/c/KxOKjK
	 EwNfnELC8t0TSEBHPXr6a3kYXfz8j29/SzEExIOk3oPKwyGQffi8mcAg1upGmwyStFz6d
	 Xxpnt+6oNFjgLjwticUVpvFoMmOTrYWBwoEKsriD9Qfj3AvUMmNVAdGaur1XrdyZmF08N
	 NI0mKp+0mqCiN9P61FDQ9KySRVEnbzb3/D0r7Blr1r3sYy01wyfbe3QNyFaxTIy9fhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xUkA2q6X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A98F606A31C;
	Wed, 18 Nov 2026 23:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xUkA2q6X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A701F000C4;
	Wed, 18 Nov 2026 23:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045156;
	bh=XJjnhXp7n8fQzNkIQZorh4uPAdqH/FNqzCU1I+EQi+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xUkA2q6XqOZADJGqQjFb/GeskpBtkEypccoVo7pZLqxhlJ5NVvSyQhEaza35XFLYD
	 RBVVeo6WwsgWoPxGSoP3LOa2gP/WbT3pdACFUS5eD2T+UT4/xw4jc/9Wzi6bpUnmwM
	 HJ7bgoO5LjEZdxXER25yzS8FlVCqloyZqSL68N1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0786/2857] ASoC: codecs: wm8994: Fix runtime PM leak in wm8994_mic_detect()
Date: Wed, 18 Nov 2026 15:30:20 +0100
Message-ID: <20261118150229.868342495@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 09e6a2ad506f2..bb8e311f33d2f 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -3533,6 +3533,7 @@ int wm8994_mic_detect(struct snd_soc_component *component, struct snd_soc_jack *
 		break;
 	default:
 		dev_warn(component->dev, "Invalid MICBIAS %d\n", micbias);
+		pm_runtime_put(component->dev);
 		return -EINVAL;
 	}
 
-- 
2.53.0



