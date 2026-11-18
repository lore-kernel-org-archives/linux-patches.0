Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015775;
	b=yHT6KARt/gUrdAoNEvQYGadF4BogEGdemvmyfhOqhAZ3zmOqikL9NBOjlg0Ml1AJPNEF
	 rV9FdS/bNoMBlH4w2mjTPYLJ49+22kq0Hq+iGVh2yEFbwl10dKAy3cZpUH/du2h92oovl
	 HEeVwi7CUgNQXWQT2P2x8VeY3GlFtdh7xtCYYi6vCeEDOkFNdauYA7Gk5aBaR2LcUrR3C
	 nx1guivdD2z4PmdLE6Rrpg9oqyTrkKqyZ7jxFKUYMnDyBZGEQl3wsaPSStCgfdnht9ny2
	 KzyUA1mqi7d5KK0l6x1NUg1DdvD+f7/u3ximfsem9HmE2igGHFCvmd+EnEuR6f63whg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015775;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=byGTAGSApRM3QmOsu+563QZzIa22alxFx0mvAoHfcLc=;
	b=ZrDdandDUj/bXVhnGh3cqTVCU2giH0l0snEkE46jkm+rZZv3WLAnN2jpcQEBqtzgL0p7
	 1/YjohSwdg+MM6pi4L6zSQH4pJvczLDn7hvKqcxAboHd99ycm3lq14St3FtFnF9q+Y7gG
	 wh6uSQCOMBUwOnp4i2ziS46tae5BAt0v1Y8qKRy6iRMiZHxILTuFbkezBSYKaypfc+3Qj
	 qiDNGJC8c35kiayhcwzFUAUFubpHDBBdYZSVB8lc/2XU4kNyxdP/HKPqGtfWSb2ZHo0fa
	 KM8wEcV8o+LWlTbNu3DvKmhXSxjQHKxMDAuyZLK6g3OHPMq1bATwZpYTIX6zvPQtmOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GyLTMGzv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B6D606A31C;
	Wed, 18 Nov 2026 15:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GyLTMGzv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84A791F000C4;
	Wed, 18 Nov 2026 15:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015775;
	bh=byGTAGSApRM3QmOsu+563QZzIa22alxFx0mvAoHfcLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GyLTMGzvtFJVRZXA3O4GVCJiEEKOdr8ssi9FNeKEEqF+IwKk7nL6AEk1hq3bOx5t4
	 7gBtWVNtIdL8GzC3KRsw2D2kvzyAQ9OqmOILFK+1wtS3KG56TWmh5Aubls9WRCzEE9
	 sar0K6Kq0hHXBDhRYZvMAqFYtjp13np1b8qPO448=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0291/2651] ASoC: codecs: sma1307: validate setting firmware layout
Date: Wed, 18 Nov 2026 15:25:31 +0100
Message-ID: <20261118150258.383784761@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit af0f4f7a042e39bf70fa7406351b26efead18dff ]

sma1307_setting_loaded() checks a byte count against an element count, then
reads an eight-int header and a fixed default table from the firmware. It
also trusts the mode count while indexing a five-entry mode_set array.

Validate the byte-to-int conversion, fixed header/default extent, mode
count, and exact mode table layout before parsing the setting file.

Fixes: 576c57e6b4c1 ("ASoC: sma1307: Add driver for Iron Device SMA1307")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260830134428.9550-1-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/sma1307.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/sma1307.c b/sound/soc/codecs/sma1307.c
index adb369a29b9d3..653cbafee23ec 100644
--- a/sound/soc/codecs/sma1307.c
+++ b/sound/soc/codecs/sma1307.c
@@ -1701,7 +1701,9 @@ static void sma1307_setting_loaded(struct sma1307_priv *sma1307, const char *fil
 			__func__, setting_file, ERR_PTR(ret));
 		sma1307->set.status = false;
 		return;
-	} else if ((fw->size) < SMA1307_SETTING_HEADER_SIZE) {
+	} else if (fw->size % sizeof(int) ||
+		   fw->size < (SMA1307_SETTING_HEADER_SIZE +
+				       SMA1307_SETTING_DEFAULT_SIZE) * sizeof(int)) {
 		dev_err(sma1307->dev, "%s: Invalid file\n", __func__);
 		sma1307->set.status = false;
 		return;
@@ -1720,6 +1722,10 @@ static void sma1307_setting_loaded(struct sma1307_priv *sma1307, const char *fil
 	sma1307->set.checksum = data[sma1307->set.header_size - 2];
 	sma1307->set.num_mode = data[sma1307->set.header_size - 1];
 	num_mode = sma1307->set.num_mode;
+	if (num_mode < 0 || num_mode > ARRAY_SIZE(sma1307->set.mode_set)) {
+		sma1307->set.status = false;
+		return;
+	}
 	sma1307->set.header = devm_kmalloc_array(sma1307->dev,
 						 sma1307->set.header_size,
 						 sizeof(int),
@@ -1755,7 +1761,11 @@ static void sma1307_setting_loaded(struct sma1307_priv *sma1307, const char *fil
 
 	/* MODE */
 	offset = sma1307->set.header_size + sma1307->set.def_size;
-	sma1307->set.mode_size = DIV_ROUND_CLOSEST(size - offset, num_mode + 1);
+	if ((size - offset) % (num_mode + 1)) {
+		sma1307->set.status = false;
+		return;
+	}
+	sma1307->set.mode_size = (size - offset) / (num_mode + 1);
 	for (int i = 0; i < num_mode; i++) {
 		sma1307->set.mode_set[i]
 		    = devm_kzalloc(sma1307->dev,
-- 
2.53.0



