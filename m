Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065436;
	b=k8oziQhQy1N/BO0IkLbgSiZddqaM//WbTPrn4ogJlrbbUjWIJU/v3hM4MWxl4y6gZ2f7
	 OU9XiILVlOAKsmjaZlg4nwVyGpRbCs610faOIzuvcgYcnC20wNyKlTQJ5M4C5eEzA3upx
	 kWXywnsS32TP149H9QpmC5cCyL+w24C5LVMhls+ColXEAcEa9sUNXNsEPL2IvQLkFVQ74
	 cakHeIE4nT7mbVpBZV1PwGZ9jjaiypmO/BY5jlyi8hUJRS6NLdZ6ZlUA7hw4Sjx7awuOL
	 rnXIxy08NO6C/TVsf/gjuQMrF0H/E2hME1RgbMjJRQzuRZtMNPEYkrWRC64z8XJHM0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065436;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cXXKjjvCPU7uch8MUZezMXmikiZTtSzALBLxBcsxeEk=;
	b=CmbedILlzp5BYyAYuuTY6VjBulsdc3wj2vX4zENOsdstfuxclwlEGq2QT9EER/QoyNFR
	 EaHh+vwBpvRTU0cxQB+UUHw38gEhuXj1sKXMy0NyYgZAQWngjYfBYPM7aMftyr2Hdy1Ax
	 g3u+7eABFtiMwF+6HbZYrP7Cs54rpwwxc+7eEBi3LayX1B6bLlrM5iscgSN2Fw0G+aljZ
	 2ZnbwNqljGEge+q51bdxBytTbMb3wmGVlMjvZ0r6DT6kOuy2mqw/Z4+J6iq2Ap3/FmiTy
	 4nIlxGFIb82Q2ig4ej+sjPza7jtqGr6CvFuTuZIyLD4D/IuqRQITnwIqVQ30EEL45PQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IRZYpAXT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269C3606A330;
	Sat,  7 Nov 2026 15:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IRZYpAXT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DCA31F0089F;
	Sat,  7 Nov 2026 15:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065435;
	bh=cXXKjjvCPU7uch8MUZezMXmikiZTtSzALBLxBcsxeEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IRZYpAXTOPTFzJc4zh0oShFeT19e5OFc4jrv2ZapJnglZXDH35X7h71eHbGjIX8Rn
	 capk35zuWYqxpQSAI9X+GpiuXGsYtcnv9U9DQ/vJnsAfM0U3eOL2oeJXOfTlIbZgwk
	 +ITSKsyHAycqJ3nBYfZNpPtiI4v69zKVhznWNsmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1143/1257] ASoC: codecs: wsa884x: Accept temperatures across the full trim range
Date: Sat,  7 Nov 2026 08:57:19 -0500
Message-ID: <20261107135010.790717583@linuxfoundation.org>
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

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

[ Upstream commit 00535515e3c14fbee20de4a1aa61cfb3390f0f50 ]

wsa884x_get_temp() rejects any reading outside 5..45 degC with -EAGAIN.
A speaker that has been playing, or sits in a warm laptop, easily runs
above 45 degC, so its temperature becomes unreadable when it matters.

The check only needs to drop bogus conversions, such as the all-zero
reading before the PA is first enabled. Bound it by the -10..150 degC
two-point trim range instead.

Fixes: 6b99dc62d940 ("ASoC: codecs: wsa884x: Implement temperature reading and hwmon")
Cc: stable@vger.kernel.org
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20261023171316.819857-3-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wsa884x.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/sound/soc/codecs/wsa884x.c b/sound/soc/codecs/wsa884x.c
index a367c94bfb4d6..f0857c0588d51 100644
--- a/sound/soc/codecs/wsa884x.c
+++ b/sound/soc/codecs/wsa884x.c
@@ -720,10 +720,11 @@
 
 /*
  * Device will report senseless data in many cases, so discard any measurements
- * outside of valid range.
+ * outside of the two-point trim range. Do not narrow this to ambient: a
+ * speaker that has been playing easily runs well above 45 degC.
  */
-#define WSA884X_LOW_TEMP_THRESHOLD	5
-#define WSA884X_HIGH_TEMP_THRESHOLD	45
+#define WSA884X_LOW_TEMP_THRESHOLD	WSA884X_T1_TEMP
+#define WSA884X_HIGH_TEMP_THRESHOLD	WSA884X_T2_TEMP
 
 struct wsa884x_priv {
 	struct regmap *regmap;
@@ -1929,8 +1930,8 @@ static int wsa884x_get_temp(struct wsa884x_priv *wsa884x, long *temp)
 	dev_dbg(wsa884x->dev, "Measured temp %ld (dmeas=%d, d1=%d, d2=%d)\n",
 		val, dmeas, d1, d2);
 
-	if ((val > WSA884X_LOW_TEMP_THRESHOLD) &&
-	    (val < WSA884X_HIGH_TEMP_THRESHOLD)) {
+	if (val >= WSA884X_LOW_TEMP_THRESHOLD &&
+	    val <= WSA884X_HIGH_TEMP_THRESHOLD) {
 		wsa884x->temperature = val;
 		*temp = val * 1000;
 		ret = 0;
-- 
2.53.0



