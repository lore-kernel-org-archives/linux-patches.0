Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023896;
	b=37CdHyXxw7WM344HdFVfjML6s3E3TMxxsCVVuKsF5cPIbFwH2+PNEschMDDeLev31gmk
	 Bsjk7xa8en4FejItPkySsdh61bGzCm/OvfFE8O7/tsFylmhd1lqTm/Q/g5iTQ1UQ3G/GN
	 oPocJvSbFaMuBz85QOsd/VjgPu8AwM0zOavEJeJH8SYb7DE+BOqhocRW+gDUrt0sgWJma
	 y9VBE75oPpGubeWWf0sLEJw9NSPyQbj01wrH21mF8MVwnDkQ4UKHbJaXHWlRlK8qXpFBd
	 DPYzYkWZf5SaPtzDE6ndQHVzF/35rmSs7yWARFkzEBnE2/skjJOmUGKLJY0hxMGNIpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023896;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bTcivYr/AlLHU+hDsLsrHhVBn2O8alwG3q4lhwnOejA=;
	b=STsD9YYbBBdAUQ4JwNdnay1Wgo08sQQMcX8ljZUM1iOBAugmFrRQxl5umDMnoHvWiMcr
	 mSKypz52GIRQLBzfFx6S31JCWPrpUQX7Et6cGRgME9lwCDvTtJ9gDuiSCgjIOfbD47rbo
	 b3fqjfrgu6mp0nbFGXouSJyp0QfvTAn/3Uw05gIvAmiyUSElsSAmPNdKC+Xt1r2A07yBY
	 bE3/9+CCmqEykjmagsY2dMOCocTkQx2NJvp/cij3lgTX6i8UCxkVExaXxC0Nb2vMyACXW
	 eW3OkhZmXvhmd3yfPyTOoin4FPR47wS1f5/F/Z/6M24w0n7bNrdioC/PhjHd29YdbRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P75ZVzJU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C67E606A31C;
	Wed, 18 Nov 2026 17:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P75ZVzJU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934F01F000C4;
	Wed, 18 Nov 2026 17:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023896;
	bh=bTcivYr/AlLHU+hDsLsrHhVBn2O8alwG3q4lhwnOejA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P75ZVzJUvy7MPkLzTJ+MXGYjLqLFqREiQk3eu0kqIe9+j1FfJEDkA7cnVxYmXYrLH
	 YrlAGkIt+Wcs6yy5eT67WuP2hwEYwF/wKkXu35Kn6WTjgT/FBhQLaGPRnNGhN2H6GN
	 xTGbqfHWwyjI611cDpFg85q/nctzhFadyTqEJ4b4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0533/2151] ASoC: codecs: ab8500: Use guard() for mutex locks
Date: Wed, 18 Nov 2026 15:37:48 +0100
Message-ID: <20261118150141.427379478@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 350b7eae8e8b2bd3885a3e2424381494d6bde038 ]

Clean up the code using guard() for mutex locks.
Merely code refactoring, and no behavior change.

Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260708125002.202515-2-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 0d46182a1be7 ("ASoC: ab8500: Skip digital microphone support on AB8505")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/ab8500-codec.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/sound/soc/codecs/ab8500-codec.c b/sound/soc/codecs/ab8500-codec.c
index 63b0d57341396..167f021c7ecbc 100644
--- a/sound/soc/codecs/ab8500-codec.c
+++ b/sound/soc/codecs/ab8500-codec.c
@@ -14,6 +14,7 @@
  *         for ST-Ericsson.
  */
 
+#include <linux/cleanup.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/device.h>
@@ -981,9 +982,8 @@ static int sid_status_control_get(struct snd_kcontrol *kcontrol,
 	struct snd_soc_component *component = snd_kcontrol_chip(kcontrol);
 	struct ab8500_codec_drvdata *drvdata = dev_get_drvdata(component->dev);
 
-	mutex_lock(&drvdata->ctrl_lock);
+	guard(mutex)(&drvdata->ctrl_lock);
 	ucontrol->value.enumerated.item[0] = drvdata->sid_status;
-	mutex_unlock(&drvdata->ctrl_lock);
 
 	return 0;
 }
@@ -1006,7 +1006,7 @@ static int sid_status_control_put(struct snd_kcontrol *kcontrol,
 		return -EIO;
 	}
 
-	mutex_lock(&drvdata->ctrl_lock);
+	guard(mutex)(&drvdata->ctrl_lock);
 
 	sidconf = snd_soc_component_read(component, AB8500_SIDFIRCONF);
 	if (((sidconf & BIT(AB8500_SIDFIRCONF_FIRSIDBUSY)) != 0)) {
@@ -1017,7 +1017,8 @@ static int sid_status_control_put(struct snd_kcontrol *kcontrol,
 		} else {
 			status = -EBUSY;
 		}
-		goto out;
+		dev_dbg(component->dev, "%s: Exit\n", __func__);
+		return status;
 	}
 
 	snd_soc_component_write(component, AB8500_SIDFIRADR, 0);
@@ -1035,9 +1036,6 @@ static int sid_status_control_put(struct snd_kcontrol *kcontrol,
 
 	drvdata->sid_status = SID_FIR_CONFIGURED;
 
-out:
-	mutex_unlock(&drvdata->ctrl_lock);
-
 	dev_dbg(component->dev, "%s: Exit\n", __func__);
 
 	return status;
-- 
2.53.0



