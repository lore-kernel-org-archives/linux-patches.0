Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063868;
	b=vq/mRA7ZQCs1ibq9C20x/UxeEUMKo1LP3Sal+v7pSUlhugWiSV1dBACBJgmixCBw73kQ
	 +AB6VydNNalT4iJUftKhdBKm+st5yexLgUFNjau/kdYIwxcRb4IPdwfULtC+GzJdJ1n5+
	 sz7ilm2Ptu/3rrfl06vZVsUb555eszQK31OsDIU7/wUHST+aATaZxlN5erhzTLEa9AiTr
	 JwxnR+n6ncvfITOrIFFnVmejssE+JZSGMv/7igQDO6IC919BHn+OnOTiZAYCs2Xu5mRzf
	 V4l1U2XbBO8bsFeMv3gWFq2EUQTBBajFmvNKn8xnv6pyGmQG8gzgxqQKjM048uxLUUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063868;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4e8eWveKfWl1/WQrhm4+gMQO+g2THkHhc+NShKAFmgU=;
	b=jh1bt/E5AWp+65ux5IVPuES+2sTgsZvWL+ML1Ig1UflKTCY9+DxOFjEIP80M7gXLgom9
	 YXSy9nrXDa6qDHKJ2Jso2SreL+Uz4zkB9bFaSEuyeyZkVQf9Ne5qW01bLsI+QHX0EvLwQ
	 K7k1A2tjlrUCb/ru5lNm02Isb81kgEn9vBpEqIcJpT3ugpuKGKYsHOn1ZdA9+ckYXss4U
	 yNrJ6Cq0aNhNssGBbPqyRUOgag7S2uO90yyBDZq3KiTkgcfJffZSeZpM6Z6gsH7SYE2kK
	 1Ahre7tUypHEIeKYhuBrisUTD9Uc7QOOWdWH3ExOqo+LxUGHu07UqBfQYcNCV0WvBkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hjlljJ9+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812C7606A33E;
	Sat,  7 Nov 2026 15:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hjlljJ9+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC631F0089F;
	Sat,  7 Nov 2026 15:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063868;
	bh=4e8eWveKfWl1/WQrhm4+gMQO+g2THkHhc+NShKAFmgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hjlljJ9+evvp9LezbZEDOt1GTue1ssnEwzpVU63uy3B1nEd/3WVQE96jVQjpCCCEU
	 okCbab1dTR9dhtf41inLhwZYtqarnElV1X8jTifNOqM4+0r2qdeNMcHTh0P54NCmbf
	 vSQk1Zs1hZ2dHEzqXqRbbvIbFGQ2nq8vBL+Jtx1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Michael Walle <mwalle@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0073/1257] mtd: spi-nor: sfdp: check the length of the xSPI Profile 1.0 table
Date: Sat,  7 Nov 2026 08:39:29 -0500
Message-ID: <20261107134941.404405416@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit b9f34a95a81021fa1f3c9cb8cfd458e66824cad6 ]

The spi_nor_parse_profile1() sizes its buffer from the table length the
flash reports in the SFDP parameter header. But it then reads DWORD1,
DWORD4 and DWORD5 without ever checking the table is that long.

So if a flash reports a length of one, the buffer is only four bytes
while DWORD4 and DWORD5 sit at byte offsets 12 and 16. With a length of
zero kmalloc() returns ZERO_SIZE_PTR rather than an error, so the NULL
check doesn't catch it and the first read dereferences it. And the value
doesn't just get thrown away. It ends up as the dummy cycle count for
8D-8D-8D fast reads.

To fix this, reject a table that's too short for the highest DWORD the
parser reads, the way spi_nor_parse_4bait() already does. The table is
optional, so this isn't fatal. The spi_nor_parse_sfdp() warns and
carries on.

Fixes: fb27f198971a ("mtd: spi-nor: sfdp: parse xSPI Profile 1.0 table")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Signed-off-by: Michael Walle <mwalle@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/sfdp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mtd/spi-nor/sfdp.c b/drivers/mtd/spi-nor/sfdp.c
index 4600983cb5799..ece8bbd4bc47d 100644
--- a/drivers/mtd/spi-nor/sfdp.c
+++ b/drivers/mtd/spi-nor/sfdp.c
@@ -1175,6 +1175,7 @@ static int spi_nor_parse_4bait(struct spi_nor *nor,
 #define PROFILE1_DWORD5_DUMMY_166MHZ		GENMASK(31, 27)
 #define PROFILE1_DWORD5_DUMMY_133MHZ		GENMASK(21, 17)
 #define PROFILE1_DWORD5_DUMMY_100MHZ		GENMASK(11, 7)
+#define SFDP_PROFILE1_DWORD_MIN			5
 
 /**
  * spi_nor_parse_profile1() - parse the xSPI Profile 1.0 table
@@ -1192,6 +1193,9 @@ static int spi_nor_parse_profile1(struct spi_nor *nor,
 	int ret;
 	u8 dummy, opcode;
 
+	if (profile1_header->length < SFDP_PROFILE1_DWORD_MIN)
+		return -EINVAL;
+
 	len = profile1_header->length * sizeof(*dwords);
 	dwords = kmalloc(len, GFP_KERNEL);
 	if (!dwords)
-- 
2.53.0



