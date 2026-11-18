Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016443;
	b=F3matSMbOTWgamPN9pe32fctnUxOSQ9/lbxCyrCqXnEze2f2o0c70NWXRoFPEbjMwpVc
	 g28yXO0ykyj69AMYUdk0ovcddZxWZf7in5Oi4tCaqTXSg+7L+6X4+CxxvM3gZ/jbZ6GeZ
	 u4BunsrP2St/sd9pUtdkdNvOFvAmBE5WNBDhJFfxU7h9Fvq8OvpUDIRnBbsumJflKUq/1
	 0u6xMFtO+RY50KHvAghMFdFFwWf20Szpu0M8LYGMrh77BVGuOY0uuLMP7MfCJgSYpXkN+
	 QaijbjVZAoeIc9uNGo2OHgADVi2TQlZbOl3zc6kl9NnOKk7UxgeunvAbQfvsvMMTQlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016443;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V1ytJMFOs9rvi9Se3h9oL6hHPr0qCPg8MaUiKVo90E0=;
	b=uoPYwFaPr6X02bW0O0wGpgEMfIJwBB+F6kYTzt9lqGtk/mu/SQEeiX0c1Hjdpd6qmeG5
	 SvbQG4Bc39mZQBdhOXs5iOH0Ugcbh91QxjEpfm2MuCyMBroqpfStun6JZETtNrPDL4UX/
	 TbYyYrcqz9aQsWUgur1RdFdkDcTicX/ED3U/z/dAu3YwqZ1/vmNXOWixXbJ9VFZsc9xkI
	 BPhd/wVSXtAnaEUb8wG9367uchcKsyh5u4tr1sZr/prwQ2hXKhpcY974wkK6EjhujfuiJ
	 GC3qwFjzzMqIr3QGcAPbENaslrKjCez16Q2FElaYMZMpyNGvd8hRoV6UXQW2wOiyNkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f0w1EoJg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB9E606A31C;
	Wed, 18 Nov 2026 15:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f0w1EoJg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 294DE1F000C4;
	Wed, 18 Nov 2026 15:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016443;
	bh=V1ytJMFOs9rvi9Se3h9oL6hHPr0qCPg8MaUiKVo90E0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f0w1EoJgCsn/A5VQnvROSibTefIB+3BTrId8Sa4MWD4JsILOF3B5RwrFqkBiXWiwY
	 im87TcKLw1y2Yr8Te28aZ6Qbve1ppgh9DtOD6cCK8/Gmw7vSTJdFvBFYgG6q9PPdge
	 bfVN62R6lYKmYo3vpAlQ+Ym5QEoZTIXnLCUdlrmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0532/2651] ASoC: mediatek: mt8189: Validate sysclk frequency
Date: Wed, 18 Nov 2026 15:29:32 +0100
Message-ID: <20261118150306.916303471@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 9c73b5a43c99f905ebeab4744a8ba0b28232b189 ]

A zero frequency causes a modulo-by-zero error when validating the
I2S clock frequency. Reject it before performing the validation.

Fixes: 7eb153585598 ("ASoC: mediatek: mt8189: add platform driver")
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260916050020.14575-11-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8189/mt8189-dai-i2s.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/mediatek/mt8189/mt8189-dai-i2s.c b/sound/soc/mediatek/mt8189/mt8189-dai-i2s.c
index 8cd5ddf62d467..c9e80ef42f608 100644
--- a/sound/soc/mediatek/mt8189/mt8189-dai-i2s.c
+++ b/sound/soc/mediatek/mt8189/mt8189-dai-i2s.c
@@ -1287,6 +1287,9 @@ static int mtk_dai_i2s_set_sysclk(struct snd_soc_dai *dai,
 	    dir != SND_SOC_CLOCK_OUT)
 		return -EINVAL;
 
+	if (!freq)
+		return -EINVAL;
+
 	i2s_priv = afe_priv->dai_priv[dai->id];
 	if (!i2s_priv)
 		return -EINVAL;
-- 
2.53.0



