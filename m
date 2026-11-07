Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062601;
	b=lbE8cAi2AOXnr7qxg+F85RqEet9QZb2SFoFY/k7E2OWysMtjJewg1preKxivBkR1SQjp
	 h1bInwN9jesggfNT3r0EoJjMtsrLIWfCrsjmroQOnjktlAtdqmd4lsnBY2kh0SyYNSAZg
	 b0WZNXd/7wLs32K2hXfB94cSRsYhp7jCKpDB9d3xTylSqCEaj8KW+NpO6vstHLV53XdjY
	 mGfQ5zENfEh5q+ueqmlw+Jvh1qzMzgvQVd7VQ9epoEvL5dPD++CmJdGblemEqymK0R6Y0
	 Po9XycQ8UU6RMtf3DiSEnjFzlDX4wxi7Lys0lKrLFErm5r5tp1lsViVCLRG50u7HeDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062601;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WnXLrdAat4nTPgU6dAY7xyfUE0d9wTuh+fFnF2NnfG8=;
	b=Hnq7DKggySRi28YQLMiJlZETzIhLn0dl4j9Uuj/94fbhnHDmIvLZ2fw3jcqUg5FOJY10
	 XCxHMrCMNezc7m7y7qUOhmxvsiZ2C4yVi99fNfElWZJOSoWSbUZJds4WWs4p+nH90inHh
	 yQcnp+S8BjJSv5kiqOJ3bxetQ+ozLb529vAJ6u97POKupVgq+GLkU2JzvjFtar/qiTVkg
	 CltVBSHBHFdyF2XUsURLC62IF/ShKcy9pkyblWZsn3P/L9vQqJLn7HB5MxFNFqMG+K5dh
	 EEqfRLcFKtQ8s2g+IQAR3U2azRMrYfgWMeVDhDDT4a4ums5Qua7vltSsYcmS7EI2NSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XwvuBXND;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A526606D817;
	Sat,  7 Nov 2026 14:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XwvuBXND
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 381EE1F0089F;
	Sat,  7 Nov 2026 14:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062601;
	bh=WnXLrdAat4nTPgU6dAY7xyfUE0d9wTuh+fFnF2NnfG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XwvuBXNDlr1Os85CLiW9pEkA3vgZinvXmcHeezqawxIgd9RbzJbUDeKhdLVtiQhoo
	 67It9+yqSG1/ZFdzz0SM5obYifhUUF1NBwn8FimVTkyP3IsWcKt7ZE+0zezNtQCXPS
	 11pChbnpQee6gFE2FUZdKWDcYlLB4pAH1ryIh9ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1475/1536] ASoC: codecs: wsa884x: Accept temperatures across the full trim range
Date: Sat,  7 Nov 2026 08:58:11 -0500
Message-ID: <20261107135039.278822617@linuxfoundation.org>
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
index 951cb51d39f1d..1e42093849742 100644
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



