Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060587;
	b=x2MmAhtsQRRS382B/FC7OGyeAczR+VESGrFtdQico8TTTw21PfA5vxcgiPf0iRQZTw8V
	 WMIEKJ9X8n+lJauvhAa2QKd350WZFXl6A870Km66lF9Xt/z3af7ILCyNcyQq1SJbKPDW2
	 4OE6YKdFlRA7RzLuX3q1IMd0ITmJ+IW5qh+k5SM8A4K16SS+J9jC4hk3yh02ObO3BCL11
	 a8AXceSJ/LJnndlfNK3q3+7N7Y13Mt1S9e34mdoKr3bkB1QmXIh/jGcyH5TacWGLzqyNT
	 3KYLVuIOiOuliKw+Ky182RnNjPV0ZP6/DwVNEIi66Igx5D2qC8fhsm8UCfXStmDTgZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060587;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TVRquaKNh7vlxoLTSvf9mPiKZE4jDbZuOCGG2wWMZ/U=;
	b=UwfC2gMnbFeCXvOxWII6dDDBbTkUDIy2KDlUa8ng+Zln9gw+XPuFbnl+h4Ix3JNMIapM
	 Y49X6A6Vj4Jw8uNWC8Mg9UBtyDY1WBvzhlousXtrNqgimf8dQRK6aPDGoCJoQ+gU7ZJ8j
	 ngPJNStQwpJkMmzS6nzKNWUpxMV63JSMwlg/dxsN1gtWO1A6w9MZK9Kw0RXgnmJorZZP1
	 vMUg5id8TfkeozJg68m7qRkG+5HWyxM+z50Rf8ej8DWVxAKuOXoS+nXVWYNjJyJ5zOPmf
	 NGCxmOtiqVcmmqb4ylGqjKV/Q1t6sIlVtKBV2BXGmlHQM9uF1kc5Y+8PGL/Uon0+N1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VNADDg3Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9FF606A32C;
	Sat,  7 Nov 2026 14:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VNADDg3Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BF8C1F0089F;
	Sat,  7 Nov 2026 14:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060587;
	bh=TVRquaKNh7vlxoLTSvf9mPiKZE4jDbZuOCGG2wWMZ/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VNADDg3ZOvXazDhY/qsfl0STYIAXIoQs5YIt8CCowbxv3Qp+x2Ae9Nd0f1eHNounu
	 sYJfvlbtpcP8p77cR+fslcu/9osAzuwSX25Qu0DRs3rAbQ3GvUF4YGtPOzAWKDIcpZ
	 OHIE9mg1sX1u3xCUOQ42+1i/7aGqYoCWAKEHsQPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0037/1536] ASoC: tlv320aic26: remove keyclick sysfs file
Date: Sat,  7 Nov 2026 08:34:13 -0500
Message-ID: <20261107134958.706763474@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



