Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063680;
	b=LU2VHMO5x7l1DPZMgtCs7vfp7s0MDxSsjkOkIcJ1vywTzKGVB7fvLjzesB0zLHkrJKZ0
	 R1QkrWR8Kit91Mz236znWsmjJBkJ0aUJUet7urAecWDFbjZxDdm76UMzd8MsDM6XYebQO
	 AY6yNwwwo+6N87E9LRuCOlP2QE27mHodb0nfPwJr2F9ziXaFR7Y0MoB/0q0D+FdnPj9rM
	 WBfbF6CKva6mJHvhaMMvK/KhJ/FjvjzDfbhvICBbYZXsFQb2wyKChU/u7tKBLcE8Rmxq1
	 6SBpbyOFiVQHdte4Owf0mtpMEDPSAKqwav9ZUSP8YTxJZDF59Fo13uotRi4SZBzY3UQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063680;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ohYh3cVu8JtYGc9AoOTjLiyUimwhImGPPwYaJINJcq4=;
	b=uNu/8AS8NiWePaTWAsh2Sv+UuiDXUUnzPsKZmSVo4HwELP3x6hXyaQUcJuAohuD7ufQF
	 Z3MQJ5tKNJGFkpniloPZLVKKaCk2VLiI3C8wPOA7ypbcR3W+HQ8N4LUEfhNI+ph7hshjw
	 krKDTxIg9WYdz5nmFQ5qGI/k7Jh/8EfiOofL5tXVOyIlI7tY3O1nkLSf+AAmIY161kVgD
	 KmJDZ4wSR3utI0wGOXr8BnElhZ87piqXCfCitAhGj2pe4SAVyBL9Oh5NtPCL78eVd4yer
	 pRXJ3WFR9QURdAzYssANMe887+KwcotSTZO4+JzXzS+2AFl0iNXvNHbuw/Qf8yTytRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IvQp+dOL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45AEC606A336;
	Sat,  7 Nov 2026 15:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IvQp+dOL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3BB11F0089F;
	Sat,  7 Nov 2026 15:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063680;
	bh=ohYh3cVu8JtYGc9AoOTjLiyUimwhImGPPwYaJINJcq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IvQp+dOLiZBPA5WqSIWTCn2gPx+d22stIPNo6Qfe5+JfhvvNYAaBNwa1+fNO1VQ1F
	 5/3oFJtcWuj6lk/WmU4GjuvAoruDTzjAII2dMtFo/qhF6ipnabv7n5UzMoTZLnW9L+
	 qkldBCRD7dLQqwDq77xdtx3ITozSdEdzzMNlT/H8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 789/869] ASoC: codecs: wsa884x: Accept temperatures across the full trim range
Date: Sat,  7 Nov 2026 08:57:51 -0500
Message-ID: <20261107134919.490270275@linuxfoundation.org>
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
index 5ecd7962d77ae..d941e9826ba00 100644
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
@@ -1931,8 +1932,8 @@ static int wsa884x_get_temp(struct wsa884x_priv *wsa884x, long *temp)
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



