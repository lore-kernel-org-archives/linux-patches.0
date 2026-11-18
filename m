Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045176;
	b=c0uz3wsklCYfcWOJMNKGFXyPqhtjJbbD+FPykFxvITtBE1TEG/0fpspVDYWXOFooXX+1
	 3qkhwZze3UrZIm4PUI+dHYT5/dkT2lOvWzUWkToaCCPyilmXAljOBTn074vXUHyWQC0PJ
	 lFuVXeWzwVYIMnJnM7/Vo8QTYuYGAnDcn9nM+icq2rOjIQYiLMLt0/fm2731XIA8KAIhZ
	 XSK/KhvIT94A5n417SimVC1d3CIDaEkhby90suk+xt1RcajeMvx4nEKvKVSuNt4dEqUYh
	 ZF7psAIx7ob9XA66g8jFhcpZiZQC0Hr0L3A+pB46Mi2vCIVK/Hx0XcYVxEyB0UmQ0wA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045176;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IaJT8IiRAaSOdQgZklbWroUHUDw4xQN1BQSb3AF1yb4=;
	b=VQNCO4DDpMyROUhSW3A8andBC1P8clGdqjcs+ytEZdPQ4dCQru8BzYRG8e5aEZSFalT7
	 ztodRMryNd96UhE1vKVEsz9fd+l4SK4I+shkLOrkQPcb7jWc1OczHmI3fem4hufLx5cTU
	 ddGK6lBQ0bRjGMd8k+h1HtD58Gks5IfNRfvCV+ADCQIt/J200SPUqAm43bdlmn7gJxnEi
	 NhTHEzRPhRZEf9XROzUC/aLi/xjLBvtuSyZgK65GNfEMH5j8Wig1mbORM9Upt7ikzKvS0
	 Tt44mBrnFSsIn5wF0VQgR0KmqQe9o5X7JsdquEkzhHt5QdOVQ55t+RCnMsSwjLJHqHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PkfGzhM+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB303606A31C;
	Wed, 18 Nov 2026 23:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PkfGzhM+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A4391F000C4;
	Wed, 18 Nov 2026 23:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045176;
	bh=IaJT8IiRAaSOdQgZklbWroUHUDw4xQN1BQSb3AF1yb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PkfGzhM+7BqFoRmodlsf2GxwUemlObCRYJrPwEC6ws0XWPvcm47p2lz6d8absCVX0
	 TVQ7XOeodp+pir0EVRUX76GwxO/ZnSbkXnwPXlfGe15EVkDjbCZdyY44SppyvY24pw
	 FwhJ2jHYXutbLyLxSRHSWDlWxfuOzdHefZqY6XjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Cemin <dcemin@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0828/2857] ASoC: sdw_utils: clear stale RT711 device reference on exit
Date: Wed, 18 Nov 2026 15:31:02 +0100
Message-ID: <20261118150231.384801145@linuxfoundation.org>
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

From: David Cemin <dcemin@nvidia.com>

[ Upstream commit 7c7df141dcabaa5370b5e52a9d64e2c1ea13a338 ]

asoc_sdw_rt711_exit() drops the reference held in ctx->headset_codec_dev
but leaves the pointer populated. If the card cleanup path reaches the
exit hook more than once after a failed or deferred probe, a later
invocation reuses the stale pointer and calls put_device() again,
underflowing the refcount and leading to oopses when later probe,
driver bind, or suspend paths walk the SoundWire bus after the device
reference was released. Observed as boot- and suspend-time oopses on an
arm64 platform with an RT712 headset codec, reproducible
deterministically by repeated machine-driver probe cycling with the
codec drivers unloaded.

Clear the pointer after put_device() so repeated cleanup becomes a
no-op, which also makes the existing NULL check at the top of the exit
hook effective. This matches what commit 046173b98de3 ("ASoC: sdw_utils:
fix double put_device() on aggregated amps") did for the aggregated amp
references.

Fixes: 811648340707 ("ASoC: Intel: sof_sdw: avoid oops in error handling")
Cc: stable@vger.kernel.org
Signed-off-by: David Cemin <dcemin@nvidia.com>
Link: https://patch.msgid.link/20260912182131.1156475-1-dcemin@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw_rt711.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/intel/boards/sof_sdw_rt711.c b/sound/soc/intel/boards/sof_sdw_rt711.c
index 8291967f23f30..cbc61988a0b5c 100644
--- a/sound/soc/intel/boards/sof_sdw_rt711.c
+++ b/sound/soc/intel/boards/sof_sdw_rt711.c
@@ -144,6 +144,7 @@ int sof_sdw_rt711_exit(struct snd_soc_card *card, struct snd_soc_dai_link *dai_l
 
 	device_remove_software_node(ctx->headset_codec_dev);
 	put_device(ctx->headset_codec_dev);
+	ctx->headset_codec_dev = NULL;
 
 	return 0;
 }
-- 
2.53.0



