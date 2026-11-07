Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063681;
	b=hxx/ZXCBikVkpmfcYMYsCjvgo9IbGkqefhRKLUZb2lpVH3E3AxImt8j+YJOl/VZGSZYJ
	 b8jasm5mt4mNfmwJCvAj/Blm6u1EzCBeElXCENDSP1CWQtkFCJ5BGIrd1s+I+XgEpV0lp
	 jeehtLV7kppO6AyVL8zSrvyvUl3hXmwFhD31BQGfdF+qLkPb0ZASGBdA6wp/8P2OTvz6k
	 8j0IvTh/kxyvZqEO7ScsUnV2KMHYYMePaSykqiMJGmuI7W7Gaveal8pANWZZKVdFWCd4X
	 x//H43uxRWc14u3Ef0yE7bQ6HdpD4MmwHZloIZx2sdPh4h/N/RTYMQPpg00y2AHa8BQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063681;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QyxaOKH7L6JtAyOjNEGoHnxO8cHAJY3Y0smlpThTXm8=;
	b=oWA+xIhBmw5zZYU9i1WKeAO7JN9pJ7084A2dUvUxlCOOtR5umTTVjhqHnddwE+huZggB
	 oy73hiEDmpdMClg06m6Sje3Ttgk8D0/1AaGUBgcQY+Loxj0ZIiUsi+TNjpHH9+DjacjKr
	 +Cb0mFGyiXsxZYGlXAV1n8+/p0h/Gu2UEA+H/lqYotaZ5ThMI/RAi7kYFrq1rrbafp7kI
	 TM1wD6Kvww0C4Bb++xOqxXu6XcOyn0pMxWlVrasICVfxFv4uZOmiUXsoYGcgrsLIww47i
	 xd5Y0y6Z+Ew14RwpNqEHvLy8+oOPJEOMn0dYEVsQH2Mx6lSOSmU/One/XdV0Yznjp8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f2dpgzjm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F15A606A32C;
	Sat,  7 Nov 2026 15:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f2dpgzjm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B06F1F0089F;
	Sat,  7 Nov 2026 15:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063681;
	bh=QyxaOKH7L6JtAyOjNEGoHnxO8cHAJY3Y0smlpThTXm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f2dpgzjmEjF4a95oUZxudx/xn7fCrUpCfngs+xFJMe64+cAAomfcgakbh01s/kvtw
	 N9MPN87BQOSmFbBfSttzoa5YHvAhRLrrHzBpft8hOBqT1SqKEEx3/SSfGnf+T72nG8
	 pSM8uM1rkWtV16mHtX1mFsz6E6Yq9V2ejaV5FZV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 790/869] ASoC: codecs: wsa883x: Accept temperatures across the full trim range
Date: Sat,  7 Nov 2026 08:57:52 -0500
Message-ID: <20261107134919.524541748@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

[ Upstream commit 6a55cf0d9dd2e2493a5030a4f7b0413d31165e45 ]

wsa883x_get_temp() rejects any reading outside 5..45 degC with -EAGAIN,
so a speaker that has been playing, or sits in a warm chassis, becomes
unreadable above 45 degC.

Bound the check by the -10..150 degC two-point trim range instead, and
use inclusive comparisons, as in_range() excludes the upper bound.

Fixes: a02c42d41af7 ("ASoC: codecs: wsa883x: Implement temperature reading and hwmon")
Cc: stable@vger.kernel.org
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20261023171316.819857-4-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wsa883x.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/wsa883x.c b/sound/soc/codecs/wsa883x.c
index 5f2ced650dcc8..6fb50b6e5e188 100644
--- a/sound/soc/codecs/wsa883x.c
+++ b/sound/soc/codecs/wsa883x.c
@@ -455,10 +455,11 @@
 
 /*
  * Device will report senseless data in many cases, so discard any measurements
- * outside of valid range.
+ * outside of the two-point trim range. Do not narrow this to ambient: a
+ * speaker that has been playing easily runs well above 45 degC.
  */
-#define WSA883X_LOW_TEMP_THRESHOLD	5
-#define WSA883X_HIGH_TEMP_THRESHOLD	45
+#define WSA883X_LOW_TEMP_THRESHOLD	WSA883X_T1_TEMP
+#define WSA883X_HIGH_TEMP_THRESHOLD	WSA883X_T2_TEMP
 
 struct wsa883x_priv {
 	struct regmap *regmap;
@@ -1430,7 +1431,7 @@ static int wsa883x_get_temp(struct wsa883x_priv *wsa883x, long *temp)
 	unsigned int dmeas_msb = 0, dmeas_lsb = 0;
 	int d1, d2, dmeas;
 	unsigned int mask;
-	int ret, range;
+	int ret;
 	long val;
 
 	guard(mutex)(&wsa883x->sp_lock);
@@ -1493,8 +1494,8 @@ static int wsa883x_get_temp(struct wsa883x_priv *wsa883x, long *temp)
 	}
 
 	val = WSA883X_T1_TEMP + (((dmeas - d1) * (WSA883X_T2_TEMP - WSA883X_T1_TEMP)) / (d2 - d1));
-	range = WSA883X_HIGH_TEMP_THRESHOLD - WSA883X_LOW_TEMP_THRESHOLD;
-	if (in_range(val, WSA883X_LOW_TEMP_THRESHOLD, range)) {
+	if (val >= WSA883X_LOW_TEMP_THRESHOLD &&
+	    val <= WSA883X_HIGH_TEMP_THRESHOLD) {
 		wsa883x->temperature = val;
 		*temp = val * 1000;
 		ret = 0;
-- 
2.53.0



