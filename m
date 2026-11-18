Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025869;
	b=V+5y2nvRMV9hROnYKucyReiVNUdlGfbIvjCYRMvJi6wjjqlRqYHdh8eF8yqemzwcTV8E
	 aDtl6VVKU/VHYlePgskqhHIEytVov8/iH40ZHvEBGmg3bg246q2jrHxHjuiSqECLFWiqR
	 xUyFam2CJhL6LWnv4awcqvWoepkB3RgBLWeAXhu8ZTORkE7U0O9OclKBEkMjNMBlK/8Kf
	 bwza8yBKm8K6VQQstHbzv5DA0cZzeRJtOGv2zCEdlQboRxH2eDuHDIuvcGQ0jCUEoAMe+
	 CteGKxokzb/+9kClQL1mN3GXi3QXLV9ot2HPRy4FguI8cHmVShJm9bYb80C15vFuEEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025869;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3dVy0tvNtfXoF69ajfQPCQAfuxR9ccC9kMXe7I9zBSc=;
	b=CWC3EPT7Y+4pDw8Aqlh4An17nuevgF0wq3/a2v+V6/SyyYUS0YQAGGjapkasZpItAUjO
	 qQZZlhllPNRFzlo0z++5Z/a8PqZVi+CwMcyYMkNSsMkzY/+d5TEhjx00SxwgJfM83/qFS
	 0YlwXho7MARpMhqL42nQ7mH3MflljuGEqFP2iGzssYCIRbD2KgEq8iqkfaxkGx+txHxMO
	 Laf+sNJG39/cLPtsQEshk5tGYvvUJJ34m26qXhslnxF3tcl9EwiyHHdLToCqs5AOyhpKj
	 MnHOmKl7D3+azPvTU0RLlLVjkpPFahD2Nm5WvECz71lUQBZlcTYlIadzLp25DjotGdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eOxEQYxv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3722606A31C;
	Wed, 18 Nov 2026 18:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eOxEQYxv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9721F000C4;
	Wed, 18 Nov 2026 18:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025868;
	bh=3dVy0tvNtfXoF69ajfQPCQAfuxR9ccC9kMXe7I9zBSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eOxEQYxvdvxg9AFety4ld/j2C5fLZuTjgvVrJ3WD+L4cOSLn+ubaObxDqXnsWwKDp
	 z95Bwr1iwXoWPToNH2egeSWhbJszYhF0qVDdBoUNXEeBb2o2lhFt7cFHMcUaH8KhM7
	 cvN6E9gUkk/OJ2cN0kjkLY900vdZmXKdlr5ooubY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1231/2151] wifi: mt76: mt7996: fix PLE free page and AC queue register offsets
Date: Wed, 18 Nov 2026 15:49:26 +0100
Message-ID: <20261118150207.027945134@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit c33af2e4622baafc56c565a13823f6b89d3f50db ]

The PLE register map in the MediaTek vendor driver places the free
page counter, the free page head and tail, and the HIF group page status
at 0x3a0, 0x3a4 and 0x3a8. The driver reads them at 0x380, 0x384 and
0x388, and the vendor map has the band 1 TXCMD queue empty status at
0x388. The same map has 0x100 bytes per AC for the station queue empty
bitmaps, with the MT7992 extension register at offset 0x80. The driver
uses 0x80, which cannot hold the 34 registers per AC of MT7996, so the
hw-queues file reads AC1 to AC3 of a station from the wrong register.

Use the offsets of the vendor register map.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Link: https://patch.msgid.link/20261006205936.669125-25-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/regs.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/regs.h b/drivers/net/wireless/mediatek/mt76/mt7996/regs.h
index a46c790550c62..3ad233e255dcd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/regs.h
@@ -155,12 +155,12 @@ enum offs_rev {
 #define MT_FL_Q2_CTRL				MT_PLE(0x3e8)
 #define MT_FL_Q3_CTRL				MT_PLE(0x3ec)
 
-#define MT_PLE_FREEPG_CNT			MT_PLE(0x380)
-#define MT_PLE_FREEPG_HEAD_TAIL			MT_PLE(0x384)
+#define MT_PLE_FREEPG_CNT			MT_PLE(0x3a0)
+#define MT_PLE_FREEPG_HEAD_TAIL			MT_PLE(0x3a4)
 #define MT_PLE_PG_HIF_GROUP			MT_PLE(0x00c)
-#define MT_PLE_HIF_PG_INFO			MT_PLE(0x388)
+#define MT_PLE_HIF_PG_INFO			MT_PLE(0x3a8)
 
-#define MT_PLE_AC_QEMPTY(ac, n)			MT_PLE(0x600 +	0x80 * (ac) + ((n) << 2))
+#define MT_PLE_AC_QEMPTY(ac, n)			MT_PLE(0x600 + 0x100 * (ac) + ((n) << 2))
 #define MT_PLE_AMSDU_PACK_MSDU_CNT(n)		MT_PLE(0x10e0 + ((n) << 2))
 
 /* WF MDP TOP */
-- 
2.53.0



