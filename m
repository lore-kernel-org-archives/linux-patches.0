Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057168;
	b=nHa3ciXhCKZlerrMSjJUqDCSxwZsMUSYuBa0YmrRj5UpvLux80PrdyRIFA60s8FBN7rD
	 ccZgVjqXzYDcAE1FwQhib2xDOpponZjT/4n0WeWoaUXoXviJ/7o3g0DCNQVxXckm9e6rq
	 cTgBVlaLc1Ku3ZlvBpTDN8pB3Q6xnVUxXctgCFCiaffEMwlBa4OuTBW73GpR4LbA30dRZ
	 zeNpPs+0y7H5TOF3PCnKB3OmXan3grz52rRblbILXt93i7hEOywatdrpCWiRkHIENQoS2
	 5EFYcXttoOEgfEKN3r3istDxunE/H4eh3ALfJ1xj1JgnyUlLOAdYWplk4lajMgaBBYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057168;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Stz7yLmAHCzej3QBGF1TI3QHGc0oLAX7IZ/+D6ZGFEc=;
	b=JikoMZmmLVQOamXm+MRg40Z3FABQ4x0YAtnQWtFXmkgTmLu56VIbyk2EfNggR98DoWbf
	 e2i67BmDwmpNQSJxhuBqVecxKJl8HNKiKUYmTkJZStnPvniLFsRLhiWMEm6TaBC1IusYR
	 CoPk7AIX7s6u0UexLLTXPnWjgCJlJhIGZIMqXPeWb6SbTHW9gbyEq/EOriQoTrRsqhtKz
	 ZX2ulJNaIaeGhmKyT4j5/8dXy1TXQ7yCagf3PvIEo+KyzYYg7pk2oPRy4sP7OeVeStX2p
	 B+aY2LVm87AKhULGYGDkj5NEgfNKd4btB3jPj1d2QZUSwjXfD+LRTheaanhWcLagmVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LI4VpfJn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98BBF606A325;
	Thu, 19 Nov 2026 02:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LI4VpfJn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A59B61F000C5;
	Thu, 19 Nov 2026 02:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057168;
	bh=Stz7yLmAHCzej3QBGF1TI3QHGc0oLAX7IZ/+D6ZGFEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LI4VpfJnS7g3HsLIrb7Jz2nt4DI/1O7PBKxytSMTv7bVVqnY8uhCkksg4VsSNkDm1
	 aO2dygaSuFEAdaGZEZNvAyMfVLh6QFi9xg7Am3AjrkPVfJvK4cW9BIh8sBNEYBsWbL
	 HDlgCx3p62a8julmpSMswYnOAEMF+N+a8JRs5X3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0034/1848] ASoC: tlv320aic26: remove keyclick sysfs file
Date: Wed, 18 Nov 2026 15:34:32 +0100
Message-ID: <20261118145912.591079091@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit ae375f8d063d71e598c0d7e14fc056154c84d7a7 ]

aic26_probe() creates the keyclick sysfs file on the component device.
The file callback uses the ASoC component pointer stored in the driver
private data.

There is no matching remove callback, so the sysfs file can remain after
the component is removed while its backing component state is gone.

Add a component remove callback that removes the keyclick file.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260615064549.34110-1-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tlv320aic26.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/soc/codecs/tlv320aic26.c b/sound/soc/codecs/tlv320aic26.c
index c7baef8948d47..9b4304071b086 100644
--- a/sound/soc/codecs/tlv320aic26.c
+++ b/sound/soc/codecs/tlv320aic26.c
@@ -321,8 +321,14 @@ static int aic26_probe(struct snd_soc_component *component)
 	return 0;
 }
 
+static void aic26_remove(struct snd_soc_component *component)
+{
+	device_remove_file(component->dev, &dev_attr_keyclick);
+}
+
 static const struct snd_soc_component_driver aic26_soc_component_dev = {
 	.probe			= aic26_probe,
+	.remove			= aic26_remove,
 	.controls		= aic26_snd_controls,
 	.num_controls		= ARRAY_SIZE(aic26_snd_controls),
 	.dapm_widgets		= tlv320aic26_dapm_widgets,
-- 
2.53.0



