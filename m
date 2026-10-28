Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216646;
	b=1E2uVQlk2WAVaILs6UMjiLCcnutRtpQ3GXzku+Tl9UBdPjde5BY3FnGjr+4Ul+NyPDZR
	 gcdemhawc5mBW1OjbOVOYQxbdzEUDH3hrrYAD0/OKJsr+PNH5T2zcYn2M/8E7ASo9HBCA
	 VpWIH/gGupLs5cok7XtQE73wpWXYiaEFFwPqbeLdKGL8NDpPDncElpxOmC+Y3YVA3rI5n
	 pD72AKwIMnPGdLimcTCcu8juYgBQ0puPEHx3e4qcU4Ylez2tRWbOLK1bAvNvnFUhmmSRp
	 2Gy+Mre/fw5BB/9y+0pyR2IcinPUIlA7BgaSr5lO+dzO1SotuajaULUH7XfFuCViUBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216646;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=77hOZfKEdG+OBpNE8lbkW/KIr3XvKeU2frcFed7FjXo=;
	b=KoQxLGw/5vJcOfwPo06pTMAN4UJEAyoSNU7v+mChwSSCmeZ2TiMMkVsjlDBj2IArvFuy
	 jEeeDps61BDr5x3lUZwQOqBgP5c7ANt9iEPWRuQWObfwLZFOfFsy5cdaOgrft7cYdtKQ4
	 RMcT6TRyG8Mar+Y9+glLqUNI8VSkXFbCKeQcTU4xpIqVlooQnEQS9agBXSTUuz2r1gY05
	 7i5s5kBpGe85o5OjXEwkIHxsIz8LOd64QcaW9+WB6ZoP2DopD49ULcfPSv5oebtPNeeqh
	 bW31boRJWSCL4bTSlOVWB5PVX3f9evs8V0mK+14hbjiEx6OxBN6KFtg8jLWms03xs8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g5F5pJe4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4307606A31E;
	Wed, 28 Oct 2026 19:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g5F5pJe4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D80A1F01825;
	Wed, 28 Oct 2026 19:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216645;
	bh=77hOZfKEdG+OBpNE8lbkW/KIr3XvKeU2frcFed7FjXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g5F5pJe4Ipwfy14nCtXRqx5cCYWK1XYW9nR4uDjZLY/yDyUIHvO7keCTILI9TtViV
	 Fxr7K2qyyXaJO1XT7dE9mJwfTOxFfUebjl6Lp6LJ9PWzdoRaJcYMQ/iLZXyuobdpUy
	 JAywNVehKqjD+PbR1kVzgaAroLgaOdKEgi24Yno8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qing Ming <a0yami@mailbox.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1628/1887] usb: gadget: uac: validate rate list length before storing
Date: Wed, 28 Oct 2026 18:02:04 +0100
Message-ID: <20261028170536.515371621@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qing Ming <a0yami@mailbox.org>

[ Upstream commit 844d83d5964b87919b958ff48405188c6ddae9cc ]

UAC1 and UAC2 configfs rate-list attributes parse a comma-separated
list of sampling rates and store each parsed value in fixed-size arrays.
The arrays have UAC_MAX_RATES entries, but the store paths do not check
that the input contains at most that many tokens before writing through
opts->name##s[i++].

Writing more than ten rates therefore writes past the end of the
p_srates[] or c_srates[] array in struct f_uac1_opts or struct
f_uac2_opts.

With CONFIG_UBSAN_BOUNDS enabled, writing an 11-entry rate list to the
UAC1 p_srate attribute reports:

  UBSAN: array-index-out-of-bounds
  drivers/usb/gadget/function/f_uac1.c:1669:1
  index 10 is out of range for type 'int [10]'
  __ubsan_handle_out_of_bounds.cold
  f_uac1_opts_p_srate_store
  configfs_write_iter
  vfs_write
  ksys_write
  do_syscall_64

The same reproducer against the UAC2 p_srate attribute reports:

  UBSAN: array-index-out-of-bounds
  drivers/usb/gadget/function/f_uac2.c:2087:1
  index 10 is out of range for type 'int [10]'
  __ubsan_handle_out_of_bounds.cold
  f_uac2_opts_p_srate_store
  configfs_write_iter
  vfs_write
  ksys_write
  do_syscall_64

Reject additional tokens once UAC_MAX_RATES entries have been parsed.
Also keep the original kstrdup() pointer for kfree(), because strsep()
advances the parsing cursor. Freeing the advanced cursor leaks the
original buffer on successful parses and can free an interior pointer on
some error paths.

Fixes: 695d39ffc2b5 ("usb: gadget: f_uac1: Support multiple sampling rates")
Fixes: a7339e4f5788 ("usb: gadget: f_uac2: Support multiple sampling rates")
Signed-off-by: Qing Ming <a0yami@mailbox.org>
Link: https://patch.msgid.link/20260519143319.147494-1-a0yami@mailbox.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_uac1.c | 13 +++++++++----
 drivers/usb/gadget/function/f_uac2.c | 13 +++++++++----
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/gadget/function/f_uac1.c b/drivers/usb/gadget/function/f_uac1.c
index 6f0e1d803dc24..7939dadd52a5a 100644
--- a/drivers/usb/gadget/function/f_uac1.c
+++ b/drivers/usb/gadget/function/f_uac1.c
@@ -1521,7 +1521,8 @@ static ssize_t f_uac1_opts_##name##_store(struct config_item *item,	\
 					  const char *page, size_t len)	\
 {									\
 	struct f_uac1_opts *opts = to_f_uac1_opts(item);		\
-	char *split_page = NULL;					\
+	char *buf = NULL;						\
+	char *split_page;						\
 	int ret = -EINVAL;						\
 	char *token;							\
 	u32 num;							\
@@ -1535,18 +1536,22 @@ static ssize_t f_uac1_opts_##name##_store(struct config_item *item,	\
 									\
 	i = 0;								\
 	memset(opts->name##s, 0x00, sizeof(opts->name##s));		\
-	split_page = kstrdup(page, GFP_KERNEL);				\
+	buf = kstrdup(page, GFP_KERNEL);				\
+	split_page = buf;						\
 	while ((token = strsep(&split_page, ",")) != NULL) {		\
 		ret = kstrtou32(token, 0, &num);			\
 		if (ret)						\
 			goto end;					\
-									\
+		if (i >= UAC_MAX_RATES) {				\
+			ret = -EINVAL;					\
+			goto end;					\
+		}							\
 		opts->name##s[i++] = num;				\
 		ret = len;						\
 	};								\
 									\
 end:									\
-	kfree(split_page);						\
+	kfree(buf);							\
 	mutex_unlock(&opts->lock);					\
 	return ret;							\
 }									\
diff --git a/drivers/usb/gadget/function/f_uac2.c b/drivers/usb/gadget/function/f_uac2.c
index eabd10817e1e7..b7d3988caa9c0 100644
--- a/drivers/usb/gadget/function/f_uac2.c
+++ b/drivers/usb/gadget/function/f_uac2.c
@@ -2003,7 +2003,8 @@ static ssize_t f_uac2_opts_##name##_store(struct config_item *item,	\
 					  const char *page, size_t len)	\
 {									\
 	struct f_uac2_opts *opts = to_f_uac2_opts(item);		\
-	char *split_page = NULL;					\
+	char *buf = NULL;						\
+	char *split_page;						\
 	int ret = -EINVAL;						\
 	char *token;							\
 	u32 num;							\
@@ -2017,18 +2018,22 @@ static ssize_t f_uac2_opts_##name##_store(struct config_item *item,	\
 									\
 	i = 0;								\
 	memset(opts->name##s, 0x00, sizeof(opts->name##s));		\
-	split_page = kstrdup(page, GFP_KERNEL);				\
+	buf = kstrdup(page, GFP_KERNEL);				\
+	split_page = buf;						\
 	while ((token = strsep(&split_page, ",")) != NULL) {		\
 		ret = kstrtou32(token, 0, &num);			\
 		if (ret)						\
 			goto end;					\
-									\
+		if (i >= UAC_MAX_RATES) {				\
+			ret = -EINVAL;					\
+			goto end;					\
+		}							\
 		opts->name##s[i++] = num;				\
 		ret = len;						\
 	};								\
 									\
 end:									\
-	kfree(split_page);						\
+	kfree(buf);							\
 	mutex_unlock(&opts->lock);					\
 	return ret;							\
 }									\
-- 
2.53.0



