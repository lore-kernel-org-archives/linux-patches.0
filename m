Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057535;
	b=Zl0thB7qDWorRXUodFPJdxEyXUSRoc0l4ory3RmCao996ggtpVw1eCbIPWgizqRMVSWM
	 cZ47QUmzcLdDtPcpgSIWk0RBWGtpxZl5Q/Djurl52NqHXJjzXfeT+XrjR3eobM4dp4vmD
	 +z1yXijM2VmX8LTp3FV7QH1HxYQaFtMRFJ9xGY+NzjmcfkpChn/31PDnlJL0IKS7/7eiH
	 A/xIJx2JknsPafSBs2/5Ldzbm0v6o3B7AMhmvaVy0hfCDsmcAM/FeUvgV5K4lVw0YhtiC
	 rnstOY01cehMEYK9jc/63nPBWKgr0nwQ+6EH//tOb9zoM51aQKA8AjVg3rN9rbXuWpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057535;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rTxj8gdU7YzHWf9Z3LeZeR+W0bDWpde5JVFyuYxLcjs=;
	b=rznkoiCzPU012l/PAHz6ssCr4Db9hGcv8hvYorUCKntt2K68irLbJQFHF7L7YS58dAs4
	 22N0ERb4SZC9XYSJ7iNSLzpPE1g5FuGzaDSXgQIn45BZ6a8hDZuvNDhjprYT1J2yynGEk
	 jgJje2bpFPeobUIpml/Tglvqi2I6Kefv1tdmoHncpkwZorU3P2dUPy8CfSBvMT/+useL2
	 KaJldC/qP86MJ5q9pFMtjvZ2vPQqpR5mMeDzDDdpxqYU4bfZFGSILjwBvwQUMhXBk1ckL
	 RKMYoIX10VmwG4ss4UzEvmoYtFBJhadeVGXptQSnRtwS8YR+qSU3z08txQQ4Vdybdiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eriBvBJJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F56A60A260A;
	Thu, 19 Nov 2026 03:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eriBvBJJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 802411F000C4;
	Thu, 19 Nov 2026 03:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057535;
	bh=rTxj8gdU7YzHWf9Z3LeZeR+W0bDWpde5JVFyuYxLcjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eriBvBJJEaIaA6Ah79+QwhQ0XVLeP+YFj5scLoAGFldD5V/VAH6BF5qJtT0MqN8u6
	 cZ8/2DGfPZH+/103RbCdTXRJ7xSwLXWf2936MTM3brXAZ/PzgIlkwqQlOFjH1BHU3o
	 /cQlMNf0fv6rN204TIox5U1Bcsz/zdRIVLmNAo1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0164/1848] fbdev: udlfb: validate vendor descriptor items
Date: Wed, 18 Nov 2026 15:36:42 +0100
Message-ID: <20261118145918.511083282@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 917c218644acd..c8acf35e6177a 100644
--- a/drivers/video/fbdev/udlfb.c
+++ b/drivers/video/fbdev/udlfb.c
@@ -1636,19 +1636,29 @@ static int dlfb_parse_vendor_descriptor(struct dlfb_data *dlfb,
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



