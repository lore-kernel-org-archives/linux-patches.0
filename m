Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057699;
	b=edITWvXl9FHIoTjgGSj2eTtDLX5mN3/SLMW8ort0LMuFRSOwBIpLDvy6voMhyscZhNBK
	 1L1Md7bLgnQkdY/E/skyOSoXRUp5+j2fMSwRZ31VAL54dCyINRkPk5656XYOAfpPZyB2M
	 JXlYRla/FLuy1wrUK8qyZ4+/PA0hGN/FlCOmbevGoY2JcIQ1JZI8PWyFLCEBviI0+eMpX
	 3nYXHI4nTyuWJAv04kG8YuOGEzx4FSO6xXiELo9dffQnzLza7+IRfnXoZLkNOsqlSgqvj
	 9RsS8izG6yhgn7w9JIkUCHwisYcq1Gk+/BsxwlpSbNokFlzRT783eMVOS6uYcdnEVPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057699;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5Ke96w0/fR7YBlSJnUryh5dmjeWbDPLrq5xY7ijn6Zo=;
	b=hOddnjcTkqxYxSWN6NkBa3RgcwpfImB7Vnf2/NrL3yIReFcab42bvARMAOfOXoP5wKRU
	 u9H+EwWAxsV39JbFTdyFpQtL6fvcOQ+krQTVB/kdbfTV5/ljFbcPGZ6EEZHBINgcFTyYI
	 Mvqk+LHX3D+0riFhqByvGNynl+SCWAlbsoy6vZjSSD/mdWoM95XvVGrAGFrhItY8RZ2Mi
	 Q4Gs4XqJX/ZfhtF+Qa6dkqJ2WIYbyWWzcGI0xNOmSzG/5mnwVtcxSWptMa1+j9opgYRKB
	 w/XB++PHgTgm6u/KAEge0dJK5tFfKGuEm2VEpSbXsn1qi6T++ju/NBgEFqh24ROr4KQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W2Nmj13w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC586606A325;
	Thu, 19 Nov 2026 03:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W2Nmj13w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16AF11F000C4;
	Thu, 19 Nov 2026 03:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057699;
	bh=5Ke96w0/fR7YBlSJnUryh5dmjeWbDPLrq5xY7ijn6Zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W2Nmj13wzxXpTSktW2ksz/8hadh4pNNummLuAlIp0sMi7fYex8QZOJ5nA5nqpW81k
	 XFXsB70J0mneLvEs5MVFU1zh0nQzK65jMNjkBiBeGEc5oqDXAXnWlDTpqj3x/jzLqc
	 NCc/bBpCMXELDIEZaPY9Wi6qYDfxS+Duan5dE89U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0183/1848] fbdev: maxine: fix 64-bit build error
Date: Wed, 18 Nov 2026 15:37:01 +0100
Message-ID: <20261118145919.259243349@linuxfoundation.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 3adec5c640dc09dca5605043e138412fd5a0629d ]

The KSEG1ADDR() macro is only defined for non-64BIT builds.
Use the CKSEG1ADDR() macro instead.

In file included from ../drivers/video/fbdev/maxinefb.c:34:
../drivers/video/fbdev/maxinefb.c: In function 'maxinefb_ims332_write_register':
../include/video/maxinefb.h:16:41: error: implicit declaration of function 'KSEG1ADDR'; did you mean 'CKSEG1ADDR'? [-Wimplicit-function-declaration]
   16 | #define MAXINEFB_IMS332_ADDRESS         KSEG1ADDR(0x1c140000)
../drivers/video/fbdev/maxinefb.c:66:49: note: in expansion of macro 'MAXINEFB_IMS332_ADDRESS'
   66 |         register unsigned char *regs = (char *) MAXINEFB_IMS332_ADDRESS;
../drivers/video/fbdev/maxinefb.c:66:40: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
   66 |         register unsigned char *regs = (char *) MAXINEFB_IMS332_ADDRESS;

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/video/maxinefb.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/video/maxinefb.h b/include/video/maxinefb.h
index 6aeb4acca2bdb..2b66b32f355cf 100644
--- a/include/video/maxinefb.h
+++ b/include/video/maxinefb.h
@@ -13,13 +13,13 @@
 /*
  * IMS332 video controller register base address
  */
-#define MAXINEFB_IMS332_ADDRESS		KSEG1ADDR(0x1c140000)
+#define MAXINEFB_IMS332_ADDRESS		CKSEG1ADDR(0x1c140000)
 
 /*
  * Begin of DECstation 5000/xx onboard framebuffer memory, default resolution
  * is 1024x768x8
  */
-#define DS5000_xx_ONBOARD_FBMEM_START	KSEG1ADDR(0x0a000000)
+#define DS5000_xx_ONBOARD_FBMEM_START	CKSEG1ADDR(0x0a000000)
 
 /*
  *      The IMS 332 video controller used in the DECstation 5000/xx series
-- 
2.53.0



