Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030233;
	b=nw5pkMa8jFY2dHaQe2JtOlJtbTNarAB3XA9JB6kbJ89qcff6lvC/VUCWjc1SkPbLHRj5
	 ksxNb0l7s9y+3W1uX+jHuhybHctZEtwx7ZcJD/ctHUJcA0eSI1VZChqnLvsIPEZ2JdRza
	 7zIpoo8T/Mz6AOElyVOIeSZzGozVvPRJ0vEmjJiF7VhS7TUf7/sYf2lVIF5dNhLCr186E
	 jgAJ1W5I6rn0qeJG2xFrJCUfRYxA/2CI2YZLfJGxaOt0I6Cs6Ndaxw/kxs58wmFd/4ur8
	 79dGlPg31TmLWmXA07OMh5xSlEueLVojglwyApW7ndbr0RPYqftmEeKRIglk1i7z26Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030233;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lS21HVxFEFOuBrc7a6wm1hgJqPp19KmfcVL5t1S3N+s=;
	b=hYpKlyjZhl7hZ0Mc0g1qApQ4JRbD+BDqRx481F86rRfwFJBtIwNcwNd3NxisHXvL8fgi
	 nw2qVA1vSRGuqaKnzJh+7bMMcGm24w25zLQHrh9R8EKeokEGhahUmH/GFwrXoog0j7oQv
	 lMmIwWxkeyo4cksbIl8zttA/a4emVl8pTgEFBMVzxii76HFR052NLa5Ks7wgBMKYaBUsr
	 rEEfW+68Vn100Dv8I3g5URlayn+jb2LNH/ig3JxJgJ6oajnYny5ZEX6cDyTELPstt/5MV
	 KPp2JZtHKdKlsRv2c7UjwhYxkKVfV/pKG190xUU5GWN3ZhatbBon7EMHFeRDTeH29zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZIdusSC9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F328607F203;
	Wed, 18 Nov 2026 19:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZIdusSC9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 033491F000C8;
	Wed, 18 Nov 2026 19:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030233;
	bh=lS21HVxFEFOuBrc7a6wm1hgJqPp19KmfcVL5t1S3N+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZIdusSC91F//oi8Ytl95Ck1Y9fZh2TWe6zX06s5VE3lwkS2AZcJg5PwB4lcSnfR7j
	 TlkHXS6uqZtuvP8qHbVTpx58ZfQuAdFO4W5mQtMWO3fzUgPMNQGZEwSn+RUXpXgGPk
	 l0bOrxU6TbIelaFGtEJzi/B/qJjmXhC3eR8Jo1pE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yibo Tan <lhfff@tju.edu.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0631/1756] ASoC: amd: acp3x-es83xx: Keep an owned codec device reference
Date: Wed, 18 Nov 2026 15:45:58 +0100
Message-ID: <20261118150033.987901271@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index ca62761ea247d..d39907b65afd2 100644
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
@@ -437,6 +443,12 @@ static int acp3x_es83xx_probe(struct snd_soc_card *card)
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



