Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033602;
	b=F/LeDyM3BPRT+ag20hOq7fM/lDF9VNvYq15ojNpzoL0Ad8kYIrZpTJMUNn8JuHYOmu+7
	 8wfDqMR+OT6vdsKTQ265a7jcC/fwU+p4/cA2c56L3G2Cr0fp/ErwnIh7K3loJqJgbasVz
	 dpecKJcORQr0L0JyOuY1FgR6heopmmv7IVXchGAyHwJw4UULJfNaunsU3HYvt3Y5S2EHS
	 XR4Z0Jw7ZCc4z7MdQEFx3/dt5ehiiuC3LSi9185JREvfI5t02A9q5/L41Fh7Sqx4uDEkA
	 R68rdfBU2yWzDm5y8adsc9EIifZzU/AGLLTbyyjvVtkXCmaGIQ/s6Jb/XYGLVPx7SXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033602;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gN4FnHeq2d0YKFonta1tXUIARDfxP5KcpZgdW0Abt4Y=;
	b=ZkLZwk6fZ7Vz02lwbZebtt8VGmgfC5WpMF0OA2bn+puqNsMWDEdchydh6b9NNQeIBHpj
	 UltwMv+Ht3w6+/nC9wylbwE/Fv5sSAuEX+sgUkJn+/uObYignqlNrO1eQuteAIPmwshxY
	 Y9RqwkXl7h+lEEvy0wyk6/YP+YYb+JGs9m1iBfM8/wGQDIVZL2uM/9t4Vkf/pBGxoPb5w
	 vHBqiJIkIl9eTM9Nupa59NOqDR0g0jbYs+AqeEw3V8aIxL347ofgMkkxoHOT8KBoLmt5H
	 V2/qqm+G5jMECDmAPOoYzhmLD2onfsX4VXz/JhjgoIor2r5npVvvym8YmGoD812uJCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CPYXa7ZX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B217E606A31C;
	Wed, 18 Nov 2026 20:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CPYXa7ZX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8951F000C4;
	Wed, 18 Nov 2026 20:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033602;
	bh=gN4FnHeq2d0YKFonta1tXUIARDfxP5KcpZgdW0Abt4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CPYXa7ZX/7a/1Eb247Si3aqlNJYmbhrzJ3RfyZLWXemY/1lmXsPLBpxwEmahaDnHZ
	 b+y6qUMZGQnEX2Pb7kSK3n4MNeK6QMwQI037/EKFxc8GHCEmavP38goRM1c9Mmid2q
	 wsFtyF7oXWTjrrZQIXl/OSRd9v4c695D7a7PFmWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0031/3318] ASoC: tlv320aic26: remove keyclick sysfs file
Date: Wed, 18 Nov 2026 15:10:53 +0100
Message-ID: <20261118150314.730870142@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



