Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015080;
	b=J4hWW/EcrxCzsfq7HrFym36+tyfXBw2+LlzQ83DefdMFlcGTR882d1/uVrFjlMsGVIEj
	 S+kOhfhxIV7Y9evnvNblbaJtF1O7IuG+ACYfG9kujP8KLhChXKT+2OCPWCOO0voWUKTrg
	 DCImRdAE+ynUhVjP2iSzFOjxzvcheBU8/CA8Jp0WFeuzx0V8MC3olA5leN6gGNIEqRv1+
	 ITql6trwIariP+pP4uAMacwwFmmpPC+kD/lCjWfx1nZyAlXPJpYd44Z4o9mHVrF9gUjZ7
	 JmwFLQhLtR5JuL5Pq/O+qD9aliDNQJEQKsu+lxJuQ7MPz1bJwBUDl328zIBpCVrtRsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015080;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3+X66afHC88H82BDCCxd1DAU5ShxRlcc6APhmHC8IhU=;
	b=U3fpJm/ud3apw8U/qpArP7O4aOoZPfFYRwMdbgbfwaBKFjMvETHFgeIbql4318+rIBdT
	 zWN35RaelgUgstKaHqbDG7A5NTysq1btYVIVrvde0v+cv1Gt53BNYBsCNYPqpf42uLuRP
	 Bcc+R8xTFwFXfl70Fo5c4Vilt/TWEnjMsA5B2cpZy20glDhiP+jcpvMYcq4SHpzwz7czc
	 PgD4217vznr0qQhceXBaVcnwRp8PdxLzXKq3bnKMwM2o3F0znFe7IB70ZVF/Z3hcMuAIL
	 ry9+MpX1Z6XuXLVsP/M0/gafymu3LX+dcP/5gOSC4fFkrHqQrLz9B3jAx14LlMw92mA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZNyLNsGr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C391606A32F;
	Wed, 18 Nov 2026 15:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZNyLNsGr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986041F000C4;
	Wed, 18 Nov 2026 15:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015080;
	bh=3+X66afHC88H82BDCCxd1DAU5ShxRlcc6APhmHC8IhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZNyLNsGrVJFaGVSvj6PalD+rNHKqEtjJa7B7pZhMRpvQwIk7P+UjTaDfSTyjCnnv6
	 E7YS9iilZ7AqmiRXamczXljbbRInUIYXBKap9GSiXTB0/aCZReWej2mDSh1rlnbqzo
	 LnFmEVik8FWrQ3CMBGxdVoQYL0fnSboVqfp0BSHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0045/2651] ASoC: SDCA: re-enable IRQ on pm_runtime_force_suspend failure
Date: Wed, 18 Nov 2026 15:21:25 +0100
Message-ID: <20261118150249.583675616@linuxfoundation.org>
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

[ Upstream commit d34a818a331f7e270fa9dc3db3d96f6a0d4fa7ab ]

The SoundWire IRQ was disabled before pm_runtime_force_suspend() but
never re-enabled when the force suspend failed, leaving the codec
unable to receive interrupts.

Fixes: 2d877d0659cb ("ASoC: SDCA: Add basic SDCA class driver")
Cc: stable@vger.kernel.org
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Assisted-by: LLM
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20261020073856.1177749-4-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdca/sdca_class.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/sdca/sdca_class.c b/sound/soc/sdca/sdca_class.c
index c5d6cf9896545..3cabed663008c 100644
--- a/sound/soc/sdca/sdca_class.c
+++ b/sound/soc/sdca/sdca_class.c
@@ -216,6 +216,7 @@ int sdca_class_system_suspend(struct sdca_class_drv *drv)
 	ret = pm_runtime_force_suspend(drv->dev);
 	if (ret) {
 		dev_err(drv->dev, "failed to force suspend: %d\n", ret);
+		enable_irq(drv->sdw->irq);
 		return ret;
 	}
 
-- 
2.53.0



