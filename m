Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064434;
	b=yisPzPzlKdY2hVeCnz0zfxJXpKC6FzLTghZtWPtQGuzv/kLEfj062nKS3PNPZlNRYCaY
	 AlYtETeSTXbOsqp1VIDQaK28GZoAiallth/h621aTTTXUZb0b375FUjNWIVRLaAS8bmJ4
	 0hsrzxBRN/sSUnBbKx4xq8LaBXRYXRdAQQ4qmtzuhFEgG+a1P4pQt8gwkgV1JXN7Fipm3
	 DZMcYKeRDTF6xNBlbRCEWTkUBk6gUVFhMg6MQTheN4ECTnipcT/eCopl/4dFhxZC3C/DM
	 eNXnvpOOT3R8DlvrPJ6S4kDZ7xzOpd30zWfYJHX67IuKAFhhJvCGwt9nn/RpQ0VOgXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064434;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=70EVWd5uc6hu7QH4yOYSXgFHU0LlIqlm7embz+Xfo1I=;
	b=rU8FiKNlNMdFOIr/tLUJkIIwk85vwetaj/kikTu5fIwfSoi0vAcZwfK8+CYMNdauXLI3
	 yHIgZfilGhZE2QF2XcltaUcGMuttoy1QwOWVNQgUXCAkR6xf+jq+4SkuM+xXal0cX38xG
	 QelbOofXreyCrPAzRr0LsuLJXDrh3GPBXRuRGbwc2Lupxt30GIIuj53jBOSKEyW/WKeIy
	 Y2oFs3B2UIDVOU2V2b+lcqtHFu/ixj/bFO5ROzyrcxAlhXl9oVI4V6dbTKOyQnqvNpeB8
	 nAwjr1PfyCWOBYKkqM5VdBJkaWLoSPmru2vxL68+JkBpyCbfNZ/oVdh/Argd4XDWYTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TTXfwFCn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027FB606EE9E;
	Sat,  7 Nov 2026 15:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TTXfwFCn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A32431F008A1;
	Sat,  7 Nov 2026 15:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064433;
	bh=70EVWd5uc6hu7QH4yOYSXgFHU0LlIqlm7embz+Xfo1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TTXfwFCn/QN6+5i0AtJZ14A0K0bjyrlUp4g+o+I63P9C0d3ZbyxUD3+sh7Jxrk+oG
	 F1oHaMpe/DTedNxj79Y8N2BdOwiNadgWz3LUbtysvLDLCcrrNhvhIlP6VLTr43s6rS
	 jsZEY3l9K4CngX0pbxzFYP6Pq9vkTUgHNgT4EXd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0481/1257] ASoC: codecs: rt5682s: disable jack detection work on shutdown
Date: Sat,  7 Nov 2026 08:46:17 -0500
Message-ID: <20261107134952.732029857@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit ca552e3140e736ed6704fe5d47439d8f2d40b42e ]

The jack detection and button check works can queue each other. The
shutdown path cancels jack_detect_work first, but jd_check_work can
queue it again after that cancellation returns. Canceling jd_check_work
then leaves jack_detect_work pending or running while the device is
reset and, on removal, its managed resources are released.

Disable and drain both delayed works so neither callback can revive the
other after its cancellation. The I2C remove callback uses the same
shutdown path.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: c07ac3ee76e5 ("ASoC: rt5682s: Fix the wrong jack type detected")
Cc: stable@vger.kernel.org # 6.10+
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Link: https://patch.msgid.link/20261003041045.650207-1-mhun512@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5682s.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt5682s.c b/sound/soc/codecs/rt5682s.c
index 34997cfb465b6..7a196fab623a9 100644
--- a/sound/soc/codecs/rt5682s.c
+++ b/sound/soc/codecs/rt5682s.c
@@ -3294,8 +3294,8 @@ static void rt5682s_i2c_shutdown(struct i2c_client *client)
 	struct rt5682s_priv *rt5682s = i2c_get_clientdata(client);
 
 	disable_irq(client->irq);
-	cancel_delayed_work_sync(&rt5682s->jack_detect_work);
-	cancel_delayed_work_sync(&rt5682s->jd_check_work);
+	disable_delayed_work_sync(&rt5682s->jack_detect_work);
+	disable_delayed_work_sync(&rt5682s->jd_check_work);
 
 	rt5682s_reset(rt5682s);
 }
-- 
2.53.0



