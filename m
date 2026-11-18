Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023370;
	b=f16fjgrg0w23Ldec4tq6B+sCWvU7y2yVESTcBlZYMxm39VYt2xIp3bnadh/mSdFJA/Ez
	 7+YrjvwBW2SoY2wMNzBTdMzU9z5HAv+Vj2aeAQsbQUpnWK7R1MrQfquq+gXAKkZgkY++B
	 UFDGUB3un2OIOSZxnTFcgIiciybQORY1PTnI6zpWTuQcCinY/mZ6JPmGOws/VPbc7sdFC
	 tHRDdgSJnzwbYNnNa+JCgG5QRKxhurQBZCpb791ciIIZZZo9EhQh4lfsu7ILvNCfOgGhr
	 Q/WKSeccNltx1vMBV5v3TC63SFwTzM2PgvY45Yid/3wP9CCrQsM8Kk9R3COSn+3jF1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023370;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lrI3rqx4DJPa2JfCs2hNT5Ba7S1WZKfKmxhAFSOeaa4=;
	b=z/tMiUGJEb3IdbkwWAQn1iTT0aukVCO6BHF0zjuBmHjW7Z9GWwAo/0xLly8R+DMDgEnu
	 lQWKJgzU/zGefa0KFYrHAU95gt6w4fDWM2AqjrRs7rojF8oUO+VW0BCKbnbqeHP/kHi2L
	 iFAfdipaebK+owp7ge/00fKHNCS4tF0aPFSOjLO8A4DIDRSHGUFiJo9FpwRgJTAJ1rd8g
	 RuF8y+Hzm2UKt8HloHugxYnUf52KK4w8wgk0v68s9OFJKZgCGr0SlaQm7BUham8Kyyk/9
	 jVelzhi+/xnA78uRG9lBUukgu8Va9vy5FR4wjPqTgCOYIwc/Vo78pPQn5V7L+eLqHIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wJHE6wTv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3E3606A33E;
	Wed, 18 Nov 2026 17:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wJHE6wTv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5B01F000C7;
	Wed, 18 Nov 2026 17:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023370;
	bh=lrI3rqx4DJPa2JfCs2hNT5Ba7S1WZKfKmxhAFSOeaa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wJHE6wTvpxRBUwh4weTzTinMl6r+CMCgxxbc8P3O7yJdbBbeVZMWtcs8sTfnRGjDr
	 5OAPdenjTcGFHM3CUOeCRdlTgBwBE3XfKi5dFwQBGbfQXrkIzcYFb9vjIqnhzElyUS
	 wM6jyFGyAHFmUre7GZ9djqMpUCVPGg5O9hcBXgXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0292/2151] ASoC: codecs: sma1307: validate setting firmware layout
Date: Wed, 18 Nov 2026 15:33:47 +0100
Message-ID: <20261118150132.543027586@linuxfoundation.org>
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
index c6b6cbadf202b..1bc7c6915ec9a 100644
--- a/sound/soc/codecs/sma1307.c
+++ b/sound/soc/codecs/sma1307.c
@@ -1721,7 +1721,9 @@ static void sma1307_setting_loaded(struct sma1307_priv *sma1307, const char *fil
 			__func__, setting_file, ERR_PTR(ret));
 		sma1307->set.status = false;
 		return;
-	} else if ((fw->size) < SMA1307_SETTING_HEADER_SIZE) {
+	} else if (fw->size % sizeof(int) ||
+		   fw->size < (SMA1307_SETTING_HEADER_SIZE +
+				       SMA1307_SETTING_DEFAULT_SIZE) * sizeof(int)) {
 		dev_err(sma1307->dev, "%s: Invalid file\n", __func__);
 		release_firmware(fw);
 		sma1307->set.status = false;
@@ -1744,6 +1746,10 @@ static void sma1307_setting_loaded(struct sma1307_priv *sma1307, const char *fil
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
@@ -1779,7 +1785,11 @@ static void sma1307_setting_loaded(struct sma1307_priv *sma1307, const char *fil
 
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



