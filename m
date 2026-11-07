Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060664;
	b=h4U4Eoxztx/roCIc6FE6f1X0SXHftbtpvnL4oX2DmiuftQsdj7y+xPm8Q/ZqPEaFbIV5
	 cgPb6YKjAfIrLnKtRX6oSJOHRtjek3BWXVPjOPOpJQy3/kNR9TSZaQ+7UKMDOWGEYoxmj
	 Xr48n/VR696czElTaIFZ5V6hjBoTqsXo+YVavnY87kdPsCDlE3DGB5cHPA/w9ULZUhpxp
	 zZdWkiRi7DqBwT+TFz55DpvtwNwaYdLVKaCP01iJgmyySLEtHUiAQXxUvCHOwJNCm2m84
	 NFklO5oLaSPyOmoD57QYdcXqguMiUqizeV6FOYgAYG2HMoWuKjSHnZDE9xBi964ag8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060664;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PYPAV2bXUNCiU/hvN0UdlWcL2Z/28JFO1Tf4qfKb0Gk=;
	b=NNn9N/jSbZQ5lg5vkGwfrEFXLBv6/xbvwrGJvjZ8S6QagHGY/L0VkhSUyh7R2ER2rSNN
	 ID8sLE30ceLKyFB4YZKgQ2YWnxdCXgmfkiQ127j6qHQpVwpkbx76tyP8CzQdOxFXthEmr
	 T0jiko/IqQIipQuHW3TXDSJs529LMq4egRcLaf/rG1pmCHubBh/gHM9iJ+Zt32AMp08kD
	 F1rPWOkwzMe+nhRFB5FNo0YwR+O4YQgVOOVAWkzJNmL9tv7uPbLFt33TAuhYIJ2jbgLbb
	 xQcbOmQP9AzZ2+LJO0/GH3IsVHMzqPTIdCAPNdahVKmqdCIwyDMg6936NordrPmXIOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zQZRQLm5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E119D606A32D;
	Sat,  7 Nov 2026 14:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zQZRQLm5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BB9A1F0089F;
	Sat,  7 Nov 2026 14:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060663;
	bh=PYPAV2bXUNCiU/hvN0UdlWcL2Z/28JFO1Tf4qfKb0Gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zQZRQLm5y/Eri+WeIRHW4j6x7fcuy3Zfv6Z+F4FrWZBwMbo7xoZYmbTNNnLYBaRV5
	 +Ml1OHbPiJFRap35TZRCmj/Qc2BZSkA+zwBufk1ut9M7hF+zacZZv5q4bNZN1E8WdV
	 9AAoNBffw6xGjgTrykjwDxywqbOVaN2obwcUAIOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0101/1536] ASoC: codecs: max98396: Unwind supplies on resume failure
Date: Sat,  7 Nov 2026 08:35:17 -0500
Message-ID: <20261107135000.506464192@linuxfoundation.org>
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

[ Upstream commit d20de7409dfa8e3341af7f157cd42130bd4ba3a7 ]

max98396_resume() enables the core, pvdd, and vbat supplies before
leaving cache-only mode, resetting the device, and replaying cached
register state. The function currently ignores regcache_sync() failures,
and the optional pvdd/vbat enable failures return without unwinding
supplies that were already enabled in this resume attempt.

Rework the function to use common error labels. This propagates sync
failures, restores cache-only/dirty state on failed cache replay, and
disables each supply acquired by this resume path before returning the
error.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260704040651.47558-1-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/max98396.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/max98396.c b/sound/soc/codecs/max98396.c
index e52bb2266fa16..d4a739273861f 100644
--- a/sound/soc/codecs/max98396.c
+++ b/sound/soc/codecs/max98396.c
@@ -1602,19 +1602,37 @@ static int max98396_resume(struct device *dev)
 	if (max98396->pvdd) {
 		ret = regulator_enable(max98396->pvdd);
 		if (ret < 0)
-			return ret;
+			goto err_core_supplies;
 	}
 
 	if (max98396->vbat) {
 		ret = regulator_enable(max98396->vbat);
 		if (ret < 0)
-			return ret;
+			goto err_pvdd;
 	}
 
 	regcache_cache_only(max98396->regmap, false);
 	max98396_reset(max98396, dev);
-	regcache_sync(max98396->regmap);
+	ret = regcache_sync(max98396->regmap);
+	if (ret < 0) {
+		regcache_cache_only(max98396->regmap, true);
+		regcache_mark_dirty(max98396->regmap);
+		goto err_vbat;
+	}
+
 	return 0;
+
+err_vbat:
+	if (max98396->vbat)
+		regulator_disable(max98396->vbat);
+err_pvdd:
+	if (max98396->pvdd)
+		regulator_disable(max98396->pvdd);
+err_core_supplies:
+	regulator_bulk_disable(MAX98396_NUM_CORE_SUPPLIES,
+			       max98396->core_supplies);
+
+	return ret;
 }
 #endif
 
-- 
2.53.0



