Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021805;
	b=f2G3zBQoIGvS9GWYQ/aeEB9/PvBPilJUsjpuB10bWWbt4l1V+2DsfKyhBqBQYl4N2ECr
	 /YEDBBB5VXFHbf7kEm6SEN9M1KtjC0t65Qj6734XpwHlxQOIMW/DkEkIML9KL+gF5IsEt
	 JiH0ys1jUOp5E3MLipMe6Kyw0oLB+rZPA9W7OWQvqbDKZElC0xyOT6FOFHJtZ8HD8yrSq
	 xZu5pjvxoEFY4eyvl+1/VJHfwmex2jx98MJ71gWYWC8ArFSS0lENj+OkS+SnGY8SrfrNz
	 VvEBSrqgZ7fQDvLX1Pd58Eg8wUcr3QJcDHPqUeU3l7FYqV/I4Xp+L8ZbrH/Lt9B8SIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021805;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uRfMnwx8xx9LCnew1X7JR84InWnEJXSrr5Prqa4SAMw=;
	b=g8IApYYUOoD8aYdiqpiZUoz7lVvlN8gwpTgHlr7CqP17Wehi28ADjsjPEhl1HBbc+xNI
	 68k6UNKngwiaqWlXd+qf46uR1viB55E6fKlkmbJS3tJJ2B90EqLtvVqUk6CSLz2TDa9Fx
	 I+qp+dg/mxiXSAmsXUDlsb/dAb0xvrFHevb+FQxYOEeeQuOyW9vyLliEcle3aPh3w/yas
	 zFNO6iR9pONbA1Io3TFF+vb0JL6mDFqoX2pG/gvkbX4ThAmgXO1M+z8LC9sDBHDkVzdao
	 41eVmOxvXBisS8oAcnQW/q5S8U4XTWQT4z9aSP5v0LmXQ0j0vo302cgY43smmy4K3WA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eklXmKrP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B293A606A334;
	Wed, 18 Nov 2026 17:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eklXmKrP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C851F000C9;
	Wed, 18 Nov 2026 17:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021805;
	bh=uRfMnwx8xx9LCnew1X7JR84InWnEJXSrr5Prqa4SAMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eklXmKrP4VuT54Fdv2LE11GPfBK1yJ0cPBksTzxqeZeFqB9z3QpABXVMdwCqMCqa1
	 98eQGXt7Fgi8JpAW9lM5xT2YEWdEjncb4wU4robeOExmokEj3Rl1RylwlLKdEEuS4r
	 Y5XHVwWrnz6s5SkFBKVXmr1qASC/1C8IoIoa+v6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2436/2651] ASoC: codecs: wsa884x: disable runtime PM on unbind
Date: Wed, 18 Nov 2026 16:01:16 +0100
Message-ID: <20261118150412.886814057@linuxfoundation.org>
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

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

[ Upstream commit 54c121eaeed8ee7751935db8100b6b5c57124db9 ]

Probe enables runtime PM but nothing disables it on unbind. The pending
autosuspend then runs wsa884x_runtime_suspend() after the devm-managed
regmap is freed, and dereferences NULL:

  Unable to handle kernel NULL pointer dereference at virtual address 0000000000000020
  pc : regcache_cache_only+0x18/0x80
  lr : wsa884x_runtime_suspend+0x24/0x40 [snd_soc_wsa884x]

Use devm_pm_runtime_enable() so runtime PM is disabled before the regmap
is freed.

Fixes: aa21a7d4f68a ("ASoC: codecs: wsa884x: Add WSA884x family of speakers")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20261023171316.819857-5-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wsa884x.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wsa884x.c b/sound/soc/codecs/wsa884x.c
index f0857c0588d51..3c008224d32e8 100644
--- a/sound/soc/codecs/wsa884x.c
+++ b/sound/soc/codecs/wsa884x.c
@@ -2125,7 +2125,9 @@ static int wsa884x_probe(struct sdw_slave *pdev,
 	pm_runtime_use_autosuspend(dev);
 	pm_runtime_mark_last_busy(dev);
 	pm_runtime_set_active(dev);
-	pm_runtime_enable(dev);
+	ret = devm_pm_runtime_enable(dev);
+	if (ret)
+		return ret;
 
 	return devm_snd_soc_register_component(dev,
 					       &wsa884x_component_drv,
-- 
2.53.0



