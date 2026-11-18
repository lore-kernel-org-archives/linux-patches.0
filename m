Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027936;
	b=DvcHz2zHTEwMAq2NOyVo3N8wtCEEIwxj2GakitV8YKZh3iz3M6sy9IJ/qteBQ3bbvvIA
	 QEWJTB98wGfyDJjVq1dOhKgpJgopVfoe+8fD8h5PO9qt5ThcC6/oeUj19QbVkliAm7w3V
	 byRwUlIOXfOer9hn5mzG+vmbX6NmMlc0ATmX9qUVah2jIu0UxaS2nAuOqU6hhCLob9nMp
	 T2ELQ0IgbZjGN4Xx+TNtKKI+Y9Lq8wSOUP8FhWPeJtK436NYZgcSYO/eqaf4Y6DvKc1Wu
	 LjDUab0z5ZK/FQNm1eBi0PEDYw9TIRTHvcsfjprv5AuHgzVUjUPvLgOPaWXtXkqnChA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027936;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C0SfRPbGRa1402mY4kBAPiR0svico/u3cVA0iGOGW0M=;
	b=w0ksOL/VNSvTBJoI5BqjdMUnlqUmTmaZHxPbZEt6Mr+IbF44dCE600MUOXtq6uaY46K2
	 zqe2w7TImbIvipAo4F+csC5P8z3cFVwllLGFnmnD5rYLD4L1I4OLlW4F4J8If1DqkR00k
	 BbinyjPtPCLKSG0vSErndMEvsF32KaF9QwjqjOyCA5VCcEKyXvZttD/bGNCS2YA73S5X6
	 U1ShX80RvEcMkhIESD8KctAIcb2GaPzXIWPL25PhkvSURCMnR5jmVIT7q25hyhapAGTwz
	 ROwTkDrI6GpYQVBdEUH63dtsuZ8dm4umbFB84o+IYfIkWc08LZyDaAJfef5f/V6G3zQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r78KWkOb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84F0606A31C;
	Wed, 18 Nov 2026 18:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r78KWkOb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B4191F000C4;
	Wed, 18 Nov 2026 18:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027936;
	bh=C0SfRPbGRa1402mY4kBAPiR0svico/u3cVA0iGOGW0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r78KWkOb5vRv3BecNHNuDolxLOuYtXXUZ/oQq3wPP/MZyh+C+nvlNaNH1DROpqsFA
	 3f2hqG2nm9BC1RDG1DmQTIU48UcnFIgyq0+wwK62hsXjNFaYv5Mhv8dVhnty5bN207
	 9h4H6zZ97cw/Kvro0Zl+1BCrTmtpzXujN7PHYgHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1967/2151] ASoC: codecs: wsa883x: disable runtime PM on unbind
Date: Wed, 18 Nov 2026 16:01:42 +0100
Message-ID: <20261118150233.403031919@linuxfoundation.org>
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

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

[ Upstream commit ea63182d71956dc33c6f08dc4171f1052f8409a9 ]

Probe enables runtime PM but nothing disables it on unbind, or when
registering the component fails. A pending autosuspend can then run
wsa883x_runtime_suspend() after the devm-managed regmap is freed, and
dereference NULL, as seen on wsa884x.

Use devm_pm_runtime_enable() so runtime PM is disabled before the regmap
is freed.

Fixes: 43b8c7dc85a1 ("ASoC: codecs: add wsa883x amplifier support")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20261023171316.819857-6-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wsa883x.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wsa883x.c b/sound/soc/codecs/wsa883x.c
index 6fb50b6e5e188..479085658bde2 100644
--- a/sound/soc/codecs/wsa883x.c
+++ b/sound/soc/codecs/wsa883x.c
@@ -1672,7 +1672,9 @@ static int wsa883x_probe(struct sdw_slave *pdev,
 	pm_runtime_use_autosuspend(dev);
 	pm_runtime_mark_last_busy(dev);
 	pm_runtime_set_active(dev);
-	pm_runtime_enable(dev);
+	ret = devm_pm_runtime_enable(dev);
+	if (ret)
+		goto err;
 
 	ret = devm_snd_soc_register_component(dev,
 					      &wsa883x_component_drv,
-- 
2.53.0



