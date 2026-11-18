Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042919;
	b=1rKfhnt+dPGhUbvQmrcskuKjbmgwsR3Y8TFhmm20kTMFwA23+wiw/ReXLg60450Xo4dW
	 N3/iLRca/LXF7iwlrcmp80P5gfaKNl2Jx1VxnomCPBp/JTwpUzNt9/YWGYaZ95Bw5gE5S
	 ze7NYjwzjIESKJg8c1VwLLDUam1XbfyC4HbWTcqkY9XDG+TUZsKUmQ8DHKiQRM2BB3lG/
	 56hXFkpeCUk4hDGKjCeU76WJDkCF/VG+vbNEM2nHByolsKEN3ZmTpHyDx7jRTC20RlIYA
	 o9AkccKoWaygndZgwuAShM7Ky/xy4uexytfKI47/YHYpsvJTibqC+5sdYQ3Zk3wzPsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042919;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L8G20A4QmkYdTFB/L+PfnLLVb/sZmyjKtPMG1vplKB8=;
	b=L0aVtt9QbnV4hcdiqbvim2IgoTNvm3Z7DgQSLBoYWmxIsxoGkY2WAQz5PemLCaLDo3wW
	 Buo0d57d6pFtWkr25MugD8LTJrEg1acrrzhb5vRS4/JMU780AKZthwFfbE2S6E74mgrJK
	 Dsr/01OpxMaH9oeNsEx8eSmlTiQTtujRaz6dRqOWXyZMPxqfeRs0DBiiEvPhwG0WmT0Sy
	 odTI87Bzu4s0RK2Lr2bGSzEhCVjsrxS9KjI0Nsn5KR5E4aj00U+eUC3wjMa5ZOOOdjRHI
	 2AzN7h6Lr4X3FkZAY8PcAvn2BJVKRfNnKesy9YbW3Jk/6gOKzEZXMaAl9SN9uG7AcFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YK5auSC6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4264C606A320;
	Wed, 18 Nov 2026 23:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YK5auSC6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 942001F000C5;
	Wed, 18 Nov 2026 23:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042919;
	bh=L8G20A4QmkYdTFB/L+PfnLLVb/sZmyjKtPMG1vplKB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YK5auSC6q61BshD/12BHlb8r97HHrQupPXuc2t/iUksEQNj4pMhVQlKkfbY3HkW6Z
	 uQA+Qp8FxZ+m1Z1V9sx8m+UJ1Ae4QvyNX9KpLnAwbJI0FQcEVyoTq4Zz7oi2INU5p9
	 SCGsqMoCcpndNkrwaK/hTzxHPJHawJD8otVbj8MU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0027/2857] ASoC: tlv320aic26: remove keyclick sysfs file
Date: Wed, 18 Nov 2026 15:17:41 +0100
Message-ID: <20261118150202.333092955@linuxfoundation.org>
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
index e5dfb3d752a3a..84e954311c1b2 100644
--- a/sound/soc/codecs/tlv320aic26.c
+++ b/sound/soc/codecs/tlv320aic26.c
@@ -320,8 +320,14 @@ static int aic26_probe(struct snd_soc_component *component)
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



