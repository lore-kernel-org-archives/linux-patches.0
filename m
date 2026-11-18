Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051396;
	b=cwYq5l+t2T/WZWA9paargooiXmWyrC3EL17ODVTSIlmCjjtKOKSw8GRmCe+6MLwZI+Bo
	 hyAsmVbeJer4C92mvxZcpz25vb3sF8FYsXv6PALTtAnOMwdOp1iJM6zdL/If84NYQSaPk
	 ZP/BB11E+4ugci4lG3bvbitiv+EQy+Ugb9ZbtCKHx1yaJ8v9x5F0ZWWKNhyDCqk45vHU/
	 aQc91QDploo0uL9ptnBTRTZCPDAm60bN+xapxW9V9vJCZKlKhb/SdHfHmlbtGkY557dw4
	 Ss1NYlDWlvzCgHXjefZbP2rfj1y13GnBFd6a7fN0IORY5UV+xESN6mp5/P9nY6ZCT7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051396;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bkLRPQ4EDHi4ngcU8snOpvc4ht+XkNleEuHfrD8FRRQ=;
	b=tSsWcXzdry9R3Uhm2McPiRZOcmCVDOqHcu3mYGT4h9KrMvaexoqtMxVvFKMK0TDOzNpx
	 GQo3n7lQ7tlB+l0rAPikDUPDsBjKADl19xUc+5IpaamNfdoQIoxwZ3pPJvaCTu7CIFnkV
	 ixACbL/vTYRM1XDtXsU1UocSSj61PpHBx6bjwt0edbI3zK87LMSPFq7Dl579NnFZpOkuj
	 XL3ktAk1vIIq24BfCs1UO734GMKh9rsJhCstpgfpc8+KUv0m5QM/LGnkWEIU1QGIVAgiG
	 BmEEKuDa5zImaSnoMDzwyOCCyGcce2jTbQoEASNIb2wYiIzE4H4LN4EYkgeDA5FMhBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kfbO8C3N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8986F606A325;
	Thu, 19 Nov 2026 01:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kfbO8C3N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D060F1F000C4;
	Thu, 19 Nov 2026 01:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051396;
	bh=bkLRPQ4EDHi4ngcU8snOpvc4ht+XkNleEuHfrD8FRRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kfbO8C3Nd2UCzw4DSUHSyqiNW73b2u3FnB4UP2lQfKhN1G5l6gZIMM/zpoBC7V4gf
	 ynur9ZnUYE3K1zi0vujNIP5C16yCjsNEV3BTLgRnPnut45IDtR6pJggLhM6nEQDQKA
	 Kbu98ouHFTiw9L4RDHOhJEgfWEtC33Lj76c1BqLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0193/2214] fbdev: udlfb: validate vendor descriptor items
Date: Wed, 18 Nov 2026 15:31:09 +0100
Message-ID: <20261118150017.916366229@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3c17049de9540..acb8071308c81 100644
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



