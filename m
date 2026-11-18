Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024659;
	b=20roUb9/SMqM/YR6Yz78jXYgmJMBpRr14dbgazO/8SIh5FZz1FPwiCSTGzg+iP7fPRYA
	 1/uwplW0NnCiTUPhA1iELSumQbPfSoGe5exps7hd7cA5eP9CObS3MxXAnodIvF31w/huY
	 LJ8WzdcC6rVps82bznhhMBKWvmuQtdb9+lptVsZq+ixrgIXHo0cVQM+sSqcZ604DsXiUN
	 jpXBuHIBrmJwouJWFH5DAyTTTeUbhXOL8Mha1Gt/eAhuK1vszNcljftOFoSRalvNYYjlw
	 mwWTwjo363pOBT1Fd3cbPa6NcGFob+lqPERYX9erRemPDw+9KLpMyf/7XuvFiOnT3Iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024659;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QhMypyvDvqK/vceb6iP8PdxvsTIRLJ+bdfIIEP+2vec=;
	b=R6tC0CiWUM/bekMMxlS99k0LDlMGm9tnORaFqWXXsMN1onf5nHmR0hFD/XVDy81kgKXH
	 LtGG5bP3ICoD0n0QT0PSErbFJGITmU/p/8UNdDqRANryMcd3nR8JyFZJiWevPIbucPUsT
	 cIhUBHMYiER+AAHjMamU7nyCctvTxWf0WcvJsSqKvFpiOA/EjVw43y/yjWioOxn4vtvtY
	 MJDwXTnmIVhJlOBmzEFtmZx9d6TgM5tWmnN3YQz2AVjw5vytSkGcEv6xor6+tT7SFxbS5
	 lZOB4CQTJsxVtTazhxRcrOr8LBXA1JMDohg6gtq7C5bRx73gPbLJOPDvcu11cNn3wfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sguU89UO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9482606A320;
	Wed, 18 Nov 2026 17:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sguU89UO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E28C1F000C4;
	Wed, 18 Nov 2026 17:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024659;
	bh=QhMypyvDvqK/vceb6iP8PdxvsTIRLJ+bdfIIEP+2vec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sguU89UOZdxa3v7I5YFMQFubSdpdFtQfR3woBgH0UJgksTIPC8koBekRyNnc65cKP
	 hykmF5bQkGJmN1384ozJ4ezslyGwoAQTNiTcaolmSh5QXkHfdFIk9q7HnyoH3mmjA1
	 xt3y4+LjWhrOFoD5+/l9lZ7u+lnof+fbT4AtIZM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yibo Tan <lhfff@tju.edu.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0804/2151] ASoC: amd: acp3x-es83xx: Keep an owned codec device reference
Date: Wed, 18 Nov 2026 15:42:19 +0100
Message-ID: <20261118150151.352727200@linuxfoundation.org>
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

From: Yibo Tan <lhfff@tju.edu.cn>

[ Upstream commit 095025078dc3a1b4f0fcdc8b8d9dcb4d192a2a14 ]

acpi_get_first_physical_node() returns a borrowed device pointer. The
private data allocation failure path in acp3x_es83xx_probe() puts that
pointer despite not owning a reference. The successful path also saves the
borrowed pointer for later card operations.

This was reproduced on current mainline with failslab restricted to the
real static callback. The rejected devm_kzalloc() returned -ENOMEM, and
normal codec platform-device unregister then produced a KASAN
slab-use-after-free in device_del(), with allocation in
acpi_create_platform_device() and release in acpi_unbind_one().

Use acpi_bus_get_primary_device() to acquire the reference while the
physical-node lock is held. After allocating private data, register a
devres put action before publishing the pointer. This balances action
allocation and later probe failures, keeps the saved pointer alive during
card use, and drops the reference after ASoC card unregister during
successful teardown. The existing OOM put now correctly balances the owned
lookup.

The same filtered KASAN guest with this change reached the same -ENOMEM and
unregister path without KASAN, WARNING, Oops or panic. The test directly
invoked the production callback and did not emulate a complete ACP/ASoC
card or physical Huawei hardware.

Fixes: 54fcd9dd44b2 ("ASoC: amd: acp: Add machine driver that enables sound for systems with a ES8336 codec")
Signed-off-by: Yibo Tan <lhfff@tju.edu.cn>
Link: https://patch.msgid.link/20260922185057.954150-3-lhfff@tju.edu.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp3x-es83xx/acp3x-es83xx.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/sound/soc/amd/acp/acp3x-es83xx/acp3x-es83xx.c b/sound/soc/amd/acp/acp3x-es83xx/acp3x-es83xx.c
index 7197c1d21d955..8f65720b153f4 100644
--- a/sound/soc/amd/acp/acp3x-es83xx/acp3x-es83xx.c
+++ b/sound/soc/amd/acp/acp3x-es83xx/acp3x-es83xx.c
@@ -10,6 +10,7 @@
 #include <sound/soc-dapm.h>
 #include <sound/jack.h>
 #include <sound/soc-acpi.h>
+#include <acpi/acpi_bus.h>
 #include <linux/clk.h>
 #include <linux/gpio.h>
 #include <linux/gpio/consumer.h>
@@ -42,6 +43,11 @@ struct acp3x_es83xx_private {
 	struct snd_soc_dapm_route mic_map[2];
 };
 
+static void acp3x_es83xx_put_codec_device(void *data)
+{
+	put_device(data);
+}
+
 static const unsigned int channels[] = {
 	DUAL_CHANNEL,
 };
@@ -438,6 +444,12 @@ static int acp3x_es83xx_probe(struct snd_soc_card *card)
 			return -ENOMEM;
 		}
 
+		ret = devm_add_action_or_reset(dev,
+					       acp3x_es83xx_put_codec_device,
+					       codec_dev);
+		if (ret)
+			return ret;
+
 		priv->codec_dev = codec_dev;
 		priv->quirk = (unsigned long)dmi_id->driver_data;
 		acp_drvdata->mach_priv = priv;
-- 
2.53.0



