Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017608;
	b=J0zA9SdU8uv34w2g4EeXOvIAzJemPLQQ8vxStK6P9CVdb2QPW7W1j8rfArZ9rFocrH8o
	 ZLZK7zNBjVq3QZwhgLloR8y+e2DKAO4MietRldMh94kVgKG5lKQTYklVGdm9Vg9qgHi/s
	 rkjZIRNj/D4TNfnrapU+p8xYn227sgLo5MLp/UtIPB0kYaRnBAxFQ7XMocNMAfUdmBbnC
	 px1oWtzWhrm8AhZgF9babeEuzVWAuBzoc9r6M7dMJ3OY6mteQosTmBX85K+N8V/BR52TA
	 2x7zX0vR+HZeuC807Y4AFdf1hRR5o94j8gIl/0mgf+++YgRIFleUusSwZXsKjRNgTNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017608;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n/FPY4FhN3kYmXOa+sKdYa4TkEPNmqIBTP2tyBvb9OU=;
	b=0nXwuXIB5f3oEUJxIyQQotvbtvmt2Ex3MjQSHngVIiD+1wE7BBLaST9lvqyVKr9W68GY
	 EmqL9FdrMz84hcVwRpYaja52u+P5dp8zw8H0MNGV/4wjyUNfK7RXbroZd7ONhgDDbqilt
	 ujGx2EdBxjvLj7MjUz5hCj3qpvPxRNq7jfBPKsGeHrx8OJhmdl27D2IYxHgmASN+HVnyy
	 NbuSmH8FG0zCgj+XvfUfLOrG5QtnuiXS9gZB33ZmZ6QZqALQe6KncuxEVDIdShWJS1X5S
	 geBQ2UEa3fOSvX01wkgS9PURagVTmzIPNekExHHLbgGEomRLJ2d/rI6f345zYNAiwSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hTPe9HeJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456AB606A320;
	Wed, 18 Nov 2026 16:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hTPe9HeJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97F411F000C4;
	Wed, 18 Nov 2026 16:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017608;
	bh=n/FPY4FhN3kYmXOa+sKdYa4TkEPNmqIBTP2tyBvb9OU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hTPe9HeJAEykEh5+wm5eEj+ELr42Y7WGqyQMsNqe+v7ZcEJLdnoPm9vhk3HESh3QM
	 3hJgqPZQQkgJCU/ZdvV32Z9RtAivHU3/elyVKJPpjNS5yAns1Ohj/Mww42oCLVJKce
	 7A0Zy0BCA+NKuM7J7AW9kkwhtL/eVvYMwzkvLhdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yibo Tan <lhfff@tju.edu.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0944/2651] ASoC: amd: acp3x-es83xx: Keep an owned codec device reference
Date: Wed, 18 Nov 2026 15:36:24 +0100
Message-ID: <20261118150321.884096524@linuxfoundation.org>
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
index c522b421e1ec2..eb0e9a6af6ef1 100644
--- a/sound/soc/amd/acp/acp3x-es83xx/acp3x-es83xx.c
+++ b/sound/soc/amd/acp/acp3x-es83xx/acp3x-es83xx.c
@@ -10,6 +10,7 @@
 #include <sound/soc-dapm.h>
 #include <sound/jack.h>
 #include <sound/soc-acpi.h>
+#include <acpi/acpi_bus.h>
 #include <linux/clk.h>
 #include <linux/gpio/consumer.h>
 #include <linux/module.h>
@@ -41,6 +42,11 @@ struct acp3x_es83xx_private {
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
@@ -441,6 +447,12 @@ static int acp3x_es83xx_probe(struct snd_soc_card *card)
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



