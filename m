Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831397;
	b=hqq7FxgHR29FKv1t7gkHKK3Rap9sV+2QI2mh/8s9WIrtsdQHG0N9Xxx/GQHPhXx21Ja3
	 tZHAfbus/QeNUvtr7JnPIFIcrmxMcXELpxb9riK8cmHDGzce8krL4oxqN0e2VUcjrxYnt
	 eqjpCUUr/RTjxQp8Upm5W5sbHuwnWItbrLMcf66MYpL29tpqT3yJPhCVJdVlHIY5vYvHI
	 AoJNtNAvYlQ8I4zbPiV9CYkpagmQo/4kXXyqpj16pc2gM6JQltIGt+YyE/i0pqmtB1Fme
	 TE0xTh91msnj97RMkawHkZU9Fo4XOouZ+L+n7FRfrKKgI9TRp6UplBHJfZV7tmXbf6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831397;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GmbndzdZ9R1R8i7GMzt8aNhmaitnqMYuVbKcE2Egngw=;
	b=ppCBCbJja4HfiWONulQH7Q1gad82Dm5HfAMNUCIZk61oppd+mj8QzLV+oHoa61bCOauM
	 ZlluBbg+Jy6r/YfoNPh9Vs9hoAKhZKsDZH4itWeZ1D1tfHGx4FPYu427SzAfCKsKZ0foY
	 lYT0f52TjbavR15/vdFh2hWMK72/lKAeZ9qq611DjYPgGS0TwITpMHEmmeNbvaM2cDEFT
	 J5aZRJK5/10+6HBPeexBV2dqeKWq1x3I/ymdnoXP07Ws4bPuMiUSrXpU8ZSDRF2A/EgGa
	 eRzt3jYoNaTL5f9XFZhp3szO+acc1ExGLP40RBXTG7VmAIgJyrgNZdz1JuLSjxLkO3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cktkmivj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B110606AB10;
	Wed,  4 Nov 2026 22:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cktkmivj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7AB41F000C1;
	Wed,  4 Nov 2026 22:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831397;
	bh=GmbndzdZ9R1R8i7GMzt8aNhmaitnqMYuVbKcE2Egngw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cktkmivjlXlh+en8G810lEipk1K/H0KwOaYqLnI0/dP4mNZeHYk0XZr+3/LR9nPok
	 TG96WmZlDc3PdcfWsYwZxBVT0JUW1zxTT9nJi+79Dgbvxm8iPhEqSq5UeK7/Fxxbb7
	 cJlyQmHRajaIFlJcUY1G1NMqIg7IMVykNWnbE5iQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 0681/1005] ASoC: audio-graph-card2: Fix use-after-free in audio_graph2_link_c2c()
Date: Wed,  4 Nov 2026 16:06:54 -0500
Message-ID: <20261104211102.705924209@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

commit 5ea495bccfd746b063bc6702064f167467717b41 upstream.

of_graph_get_next_port() consumes the reference of its prev argument.
port0 is only borrowed from the caller's iterator, so the call drops a
reference the function does not own, and port0 is dereferenced again
afterwards. Pass an extra reference, as graph_count_c2c() does, so the
reference the callee consumes is the one taken here.

Fixes: 5f281c3e82b1 ("ASoC: audio-graph-card2: use __free(device_node) for device node")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Acked-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://patch.msgid.link/20260917165851.2163548-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/generic/audio-graph-card2.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/soc/generic/audio-graph-card2.c
+++ b/sound/soc/generic/audio-graph-card2.c
@@ -969,7 +969,8 @@ int audio_graph2_link_c2c(struct simple_
 	struct snd_soc_dai_link *dai_link = simple_priv_to_link(priv, li->link);
 	struct device_node *port0 = lnk;
 	struct device_node *ports __free(device_node) = port_to_ports(port0);
-	struct device_node *port1 __free(device_node) = of_graph_get_next_port(ports, port0);
+	struct device_node *port1 __free(device_node) =
+		of_graph_get_next_port(ports, of_node_get(port0));
 	u32 val = 0;
 	int ret = -EINVAL;
 


