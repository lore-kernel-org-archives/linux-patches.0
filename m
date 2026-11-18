Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034115;
	b=4hauin86pJgNK0rypRh7ebfB7kaY0TaMACA0SO5jCC0IjuMitZ1pSSiXBCIwmCPPK7mS
	 DApEPBoVLFugDAutbE1Rx3MEEqo4RAfpc/5bJe3t/wSbfamr8z4GDgcvV1rqNwdRBDm4j
	 2jXQUClWMAQbAccwkKgdJiHGlUa+FgLcO3A7bQHDo+61y0U8Mc6v3i+woZtpqdM+Y7wno
	 cXMj3eLZFquJzdWHNQJhyjfiGbTbtdMNXvC4pn7wN00VzU95iWK5ikcTNG9urrVgX6Jfw
	 ljBTS2d/15aaDAyDKHe7Ibe+rGTCNunTbFu72Lf4nxiXGs6bQPjYUNFWxxj2xhGJPIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034115;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8v/AHxfpf8MjlSEKnu5aHUOb+XGchoyP68BFB0hojrc=;
	b=zYr9hw53VBj6RvZjuIzwmE/rYw3Sa2uoq75m8q4xJDs9d3A/FD2wNvZ81Thn0VPVxZPq
	 Tpxmd9hCIwT90khYLRIC5s/ciXx4Iyjp2KpBaOQ8jfLbEA0eFMHshQWkeJsW321GwRm9d
	 WxuMapZUMtUJPHqUT5tiy+tCB+ysGWJr/jJnlFtyh2IJX3tNHNWgXyQWFMkkfm87+3YzU
	 C6+CB8Elh+LOpY2Kq1JL4pcxrCF/UAoJ0JYKNCHz0c50A6ADlXtHZxZ4Rlg8WR9At1o9V
	 MINs6iSJvs5wHxIpG21EIJQzkH9pJ5tPXKvGPtRSyzhX1A+7xzzosCsULcn3BbBsKcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CN6bxwMC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CFB8606A31C;
	Wed, 18 Nov 2026 20:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CN6bxwMC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC741F000C4;
	Wed, 18 Nov 2026 20:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034115;
	bh=8v/AHxfpf8MjlSEKnu5aHUOb+XGchoyP68BFB0hojrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CN6bxwMChWdXaJ2lGWWdK4OX4/wTnqlUBuWigtDpZxv1kmfVzIP4dDVUzFaZva5Pk
	 r2g8/LYGpbhxM351oHqQ+Ylnjz9Q8hryn9twU9/V0akitiYDxcGpVbXmWwwvCfOD9n
	 5NxK873t57GHuxhujSXre+spbkBEGFr6IeBycAgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0256/3318] fbdev: udlfb: validate vendor descriptor items
Date: Wed, 18 Nov 2026 15:14:38 +0100
Message-ID: <20261118150323.022040984@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 80b36f4caf0cf..0175869e58e54 100644
--- a/drivers/video/fbdev/udlfb.c
+++ b/drivers/video/fbdev/udlfb.c
@@ -1629,19 +1629,29 @@ static int dlfb_parse_vendor_descriptor(struct dlfb_data *dlfb,
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



