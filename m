Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043468;
	b=0kEw5kY+E8j2eEY7TlBOC73XqiGHElacMD5ts+HyyYScP5/g0QJswr/kzx3uG8M0IdsQ
	 ENnph0/h6vRzVka/kIRARFUG7FrB4/puGP//H9gwmli5CnDDhSCkGK0q4EaU9jpH+9kFg
	 EQnP/4vu/JTMWl619xZlykKlmx2Ajb5IgGKyzVCZrkgd0Qctlv9OFvCzkAwegc8FQOIDY
	 7qSoxjKJFz7ddoBVG9Wb6tIBAu/KoOGi0w3QyfkMiOK4XNzeMXW+zxPCQLmgZWMNtEu+R
	 nRFCO9hNTUNSH2lr/sxs/JJntRZIkbXDznP40e4J8tdXufVJuSUkksHZdkP/fJkVuLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043468;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Si7I3+6fwAkkosIH2fjGCsBuRmJ+jr71MRSdjJRHuvA=;
	b=MUxmoR8jjCKSuqY+c9uciobp0AcF15TxwJEoYenITltZ0qwGfwe9PW/E5B+W55ox2Sfj
	 zj0se85MWWX6xoS6/JYc5RaSa88hjcmILIIYtZX4XioK8FSIG23n4Swycl1nD0u5qb3B7
	 UUIl1turoJQaqhdkaoGqHGmIEJeWSmn4IHpI8rr6K8NU8hi6WiBySnTVbNi0XLaNT1BXO
	 Q5DOSNdGKHHFdL5IdWxUCJIxF8MLNwK2Ic4adS642Ur2a5y8ZcfI4J6Q/XzsYlBEkmy+N
	 OOl5OQMp0Fr5Ae3VWApsAOj9yVlucMhpcnOPibozl8Nze7ozKggrM/LyzW6Lg204L4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JFeaayAn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F12606A320;
	Wed, 18 Nov 2026 23:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JFeaayAn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B48FC1F000C4;
	Wed, 18 Nov 2026 23:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043468;
	bh=Si7I3+6fwAkkosIH2fjGCsBuRmJ+jr71MRSdjJRHuvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JFeaayAnVkvj+HVBBc0B/wRGQXnOeE2w2Huo74Z3vhWAhR3WvA5tBYToHKqHOZeqk
	 7/17S5fWezz6BWNPpo4CZqUhhV1YaqbccZ6D15pq65Ylj5iXCO0wNntvaP8EejGhvl
	 sEhzEtND2ej7XaQ6QYkbYlJ048v7RPcUajFcc0K8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0221/2857] fbdev: udlfb: validate vendor descriptor items
Date: Wed, 18 Nov 2026 15:20:55 +0100
Message-ID: <20261118150209.420048508@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 3cc2fad376ac7360b4518277aa923752624db59c ]

dlfb_parse_vendor_descriptor() walks key-length-value items inside the
DisplayLink vendor descriptor.

Require each item to contain its key, length and declared value bytes
before reading item-specific fields such as max_area.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/udlfb.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/video/fbdev/udlfb.c b/drivers/video/fbdev/udlfb.c
index 33c42a766e5b1..a04554fbf701a 100644
--- a/drivers/video/fbdev/udlfb.c
+++ b/drivers/video/fbdev/udlfb.c
@@ -1637,19 +1637,29 @@ static int dlfb_parse_vendor_descriptor(struct dlfb_data *dlfb,
 		desc += 5; /* the fixed header we've already parsed */
 
 		while (desc < desc_end) {
+			char *value;
 			u8 length;
 			u16 key;
 
-			key = *desc++;
-			key |= (u16)*desc++ << 8;
+			if (desc_end - desc < sizeof(key) + sizeof(length))
+				goto unrecognized;
+
+			key = get_unaligned_le16(desc);
+			desc += sizeof(key);
 			length = *desc++;
 
+			if (length > desc_end - desc)
+				goto unrecognized;
+
+			value = desc;
 			switch (key) {
 			case 0x0200: { /* max_area */
-				u32 max_area = *desc++;
-				max_area |= (u32)*desc++ << 8;
-				max_area |= (u32)*desc++ << 16;
-				max_area |= (u32)*desc++ << 24;
+				u32 max_area;
+
+				if (length < sizeof(max_area))
+					goto unrecognized;
+
+				max_area = get_unaligned_le32(value);
 				dev_warn(&intf->dev,
 					 "DL chip limited to %d pixel modes\n",
 					 max_area);
-- 
2.53.0



