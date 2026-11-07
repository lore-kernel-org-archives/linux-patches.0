Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062256;
	b=RtXT3GF7i59d309CQKqaQbCKZwQ/djl96DhXWWAleYhPmJ4cjyy+0kawTqt8bpdNslpH
	 4KfD5Gd2/LXcWhnR3aPSXwc/ng5gXpb+y0oLnd2ZzOHq9Z60aXE+PbCJFov5WcXIR4FAN
	 BJDrsBAGMXN+PSt/JDdraJkOTgGhwtVk3/9ykt+cvaIFbFuEI7+3n0Sksez/xuT69qsVa
	 nfInwOZ3xNVUmya/sAwXDKPRK6AJXWxAjCDQ53rXVahD+kkPH7FHqy/IhxdBe5yUvcg8P
	 INSzZKy7KwfoU4t6bOzt0ZVp8kCENz1cYjuxKb9g6Aj0QRMVJfjGrSim4d9iSBEYhyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062256;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/wcgMWDtRXJGWct+SIHQO6teMKBuzjeqz3i5yyHL5Fo=;
	b=DVF96oSL5ifghUTkE3Cd9Q5NS4ZZdMjD1Roz968DxpOF0SDtBQOwHfC+7m8nlcFf6qt2
	 MxetU5+kFRbfYmHrEMbU0WGnOAdIMdz5VvvzbEDlUTdWZhQPyI4kVjnG5AEpOM12wh/oI
	 rI4KZAsxwvkd5iEAtVIXyqG3tqsVbjMobEJkifwLWXAi2jtH2v8KFuWUfcVt05eQUx8LK
	 OwgDKxQjGKP2zaL9IiB/VlSmw7HB0aF9rLJpxMXZ0ibOaqRvVRd3AoJGsSmyDfSWDECB1
	 c2L9SbbStXOv81TvoTxYcCoBckFT+NmZauWG/WX6V6j6vVjdovQgFmlN15QN+boQmkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tflXbLtW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A18606EE82;
	Sat,  7 Nov 2026 14:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tflXbLtW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45FF41F008A2;
	Sat,  7 Nov 2026 14:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062256;
	bh=/wcgMWDtRXJGWct+SIHQO6teMKBuzjeqz3i5yyHL5Fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tflXbLtWgD9pYRAj0WfiMxv/6ZEWBPvJvafivzlHd5xmDdBucN8OMpS8R/YldBly1
	 ZleKWgSPZViQ3cwAmpgpcN7yvJ7oIr4dO89DXpVRmHqaUbSaYAmUGjG/CBMdHv5BTd
	 /boppyaYy1Ch9SGN/iYxgziEKezvVqZuKfQWDUuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1161/1536] ASoC: codecs: rt5682s: disable jack detection work on shutdown
Date: Sat,  7 Nov 2026 08:52:57 -0500
Message-ID: <20261107135030.339955688@linuxfoundation.org>
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
index d773c96e2543c..d45fa9d2cd2d0 100644
--- a/sound/soc/codecs/rt5682s.c
+++ b/sound/soc/codecs/rt5682s.c
@@ -3298,8 +3298,8 @@ static void rt5682s_i2c_shutdown(struct i2c_client *client)
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



