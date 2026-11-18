Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031138;
	b=UHRefuiSkyBhP64SwraxHPAJ2kEV6Q1M2h475AiTMrD1F0w6aAg3wURwuIj3ICIXs506
	 cv4dzEodTcXTctAeS1KTtpJODfzQWE2U8ryd9m+gbtmEq+iGKr8o3HKwrQnrreaqQJeaP
	 VDZi9CvDXotwpvtKqrvhSm8BInD3c/j1gQ8Hm7Ii9doRmIB33FuQD9TrB8tipTD7mgSxt
	 TTItoO2533n4Nc5QY7bEmk+NYkB0Y16zA+2QQo30KHHRi9y9M3MVbXtjoshufmnkMhyBj
	 QdIkFXptd2hjw+GKXVALa6K06peB9w/cpESNB1rpU099ByElJlEKRNOMu8z0DNLxOvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031138;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lQvQT3c4vyZ6NtA+YMznSAMSxbbDzX5KbExjAbbtmG4=;
	b=Ltu5kEHlmRPwi4MNPYdRN3yTzwq2nYRyP5aDpmKz3JR2cN6lAAsKmd5zIpxDigi13ldv
	 ggFbztcS1QBEBJGBjyCgMtzD1Y0l+2BSVo85fMbnxbgTCWBicBaEhnl4sauQE5SbAsr80
	 E8X18tuteyUkCHjAoc3mFpVJlTfsyr4Ej+fE9SSBLQNo9GX+tme2UpQEjzRkRTGIxQBiJ
	 YsCVuzXPaljDHWJPUebaEO6COnvTPrGsmA5QSBZ8bpqYE83iTd/wuW/xg3MBPV2aitA76
	 Oww+2ZdZIAuJiuNe2bETEjxfBTsMpCJo62AE0/hTVaKMyk4twLlGrPVAiyckQImOQqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T1huREAd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4B0606A337;
	Wed, 18 Nov 2026 19:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T1huREAd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB2C1F000C5;
	Wed, 18 Nov 2026 19:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031137;
	bh=lQvQT3c4vyZ6NtA+YMznSAMSxbbDzX5KbExjAbbtmG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T1huREAdNK1mU7nPJo6xsLCGd1XLjjM0N3PtWPRq6Q6UJk8AHIJ1weWN3W1bjDAOX
	 0YPzzJ7xf5/wTn9L8drMpF60/uYHvu2FpjT0T0mrdkca1GVUdcxnwJSUCnFFQ5hdDq
	 vObA6TGLiSnTOuhHNcxasQH5Hq6C4+a98IwxwxzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0951/1756] wifi: mt76: mt7915: guard firmware memory dump write on disabled memdump
Date: Wed, 18 Nov 2026 15:51:18 +0100
Message-ID: <20261118150047.939726367@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit decf5142c2d4c295684da8644d4cb93dcf956c5d ]

mt7915_coredump_build()/mt7996_coredump_build() wrote dump_mem->len
unconditionally, but the allocation only reserves room for the memory
dump header when coredump_memdump is enabled and memdump_buf_len is
non-zero. In the default configuration the allocation ends right after
the fixed header, so the write landed one struct past the buffer. Only
populate the memory-dump section when it was actually allocated.

Fixes: 4dbcb9125cc3 ("wifi: mt76: mt7915: enable coredump support")
Fixes: 878161d5d4a4 ("wifi: mt76: mt7996: enable coredump support")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/coredump.c | 7 ++++---
 drivers/net/wireless/mediatek/mt76/mt7996/coredump.c | 7 ++++---
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/coredump.c b/drivers/net/wireless/mediatek/mt76/mt7915/coredump.c
index 5daf2258dfe6f..56d9b64ec6b06 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/coredump.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/coredump.c
@@ -345,11 +345,12 @@ static struct mt7915_coredump *mt7915_coredump_build(struct mt7915_dev *dev)
 	mt7915_coredump_fw_stack(dev, dump, exception);
 
 	/* gather memory content */
-	dump_mem = (struct mt7915_coredump_mem *)(buf + sofar);
-	dump_mem->len = crash_data->memdump_buf_len;
-	if (coredump_memdump && crash_data->memdump_buf_len)
+	if (coredump_memdump && crash_data->memdump_buf_len) {
+		dump_mem = (struct mt7915_coredump_mem *)(buf + sofar);
+		dump_mem->len = crash_data->memdump_buf_len;
 		memcpy(dump_mem->data, crash_data->memdump_buf,
 		       crash_data->memdump_buf_len);
+	}
 
 	mutex_unlock(&dev->dump_mutex);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/coredump.c b/drivers/net/wireless/mediatek/mt76/mt7996/coredump.c
index ccab0d7b9be47..d5ecac6b742a0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/coredump.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/coredump.c
@@ -202,11 +202,12 @@ static struct mt7996_coredump *mt7996_coredump_build(struct mt7996_dev *dev)
 	mt7996_coredump_fw_stack(dev, dump, exception);
 
 	/* gather memory content */
-	dump_mem = (struct mt7996_coredump_mem *)(buf + sofar);
-	dump_mem->len = crash_data->memdump_buf_len;
-	if (coredump_memdump && crash_data->memdump_buf_len)
+	if (coredump_memdump && crash_data->memdump_buf_len) {
+		dump_mem = (struct mt7996_coredump_mem *)(buf + sofar);
+		dump_mem->len = crash_data->memdump_buf_len;
 		memcpy(dump_mem->data, crash_data->memdump_buf,
 		       crash_data->memdump_buf_len);
+	}
 
 	mutex_unlock(&dev->dump_mutex);
 
-- 
2.53.0



