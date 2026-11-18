Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023640;
	b=pl2P5D2B+dSojtHBgRLVbzZkWqd746jfYnN9ZVMZnn63meIrvSC7MSXBFPs5tLN3nl8+
	 FG1IRoZAeOJRh/iU3S4LUajlTTDYDD+14H0EMbOywWhzMfgVOMAokisw4napB91Uz708I
	 0iC1HtQn1ZR5gNDsVPEPfTBaktF59HeFJwaogMJnx7mJZjVsqL6yUfxwJ0cicwUXPSAd2
	 C6MhTEkSNo2TWYv81bRbkwiiXgZNbF3WzaXXfyO3tzIfeRw0Nk9YoXicYZ7DJgRqAEX7p
	 7GH6QKRf9t5SXEoEvuBFFPdBtZz7hxHLLbN0LKBeRZZ4F2qjHnLKZgauPF1PhkHVBaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023640;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=My6C4oUPCzFe8s22iuYxxy84lc69LuZRgL7743STx2k=;
	b=nJ70qaK9242OWNwYTuuRTn7onoZlIl+VVmsxsuWSxkCE5JQKCwbOvSGZyiOZw2gnO7hP
	 R2X1V08tAiCQ3WY1AuuamXyYjgmvOldOob5W6fbwnNqN1lIrK7uQ/9y1QZaGPtSDX0/WS
	 ziJiD/c8bbrjlnrAEzJTBfqRSQT5QO/mEhgi+jM8J5FzvGQeKMSieXEbDrPN1Ap8Ne39i
	 nWQsaCZ4fKT3ZnSFkD0oCVwdMhDiwpCd2Fzw+iDiheGyiHhXMV0OW7dinPR6ZkH10cJJk
	 ooyi63+5aZO6Yez8ljaZWUG1JBK+teRLfpRCGMPnTiZN9/aqDZDFQ4PNa6m5XrI4RpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qknn49Xu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C62606A31C;
	Wed, 18 Nov 2026 17:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qknn49Xu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4151C1F000C4;
	Wed, 18 Nov 2026 17:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023639;
	bh=My6C4oUPCzFe8s22iuYxxy84lc69LuZRgL7743STx2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qknn49XuCxQUlGKddBDHBxLvqelTWY/f6WN2l+kkPhilYeuG3LqPM21EaqVI0VKFX
	 2P+/wH56w4EWJjyZhsm/pf6n/cmI9VuY/To8d4W8V6L3QkWPCf5RVsXFGbSjpjhc/v
	 a8GexpHfQdC9Tz286oM0NlUYPM24Jo6jSZpEg9y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takahiro Kuwano <takahiro.kuwano@infineon.com>,
	Michael Walle <mwalle@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0442/2151] mtd: spi-nor: spansion: Remove s25fs256s0
Date: Wed, 18 Nov 2026 15:36:17 +0100
Message-ID: <20261118150138.143537925@linuxfoundation.org>
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

From: Takahiro Kuwano <takahiro.kuwano@infineon.com>

[ Upstream commit f917d9edf54c3dd578efc231b8fbcd35744f99cd ]

The Spansion ID table lists s25fs256s0 and s25fs256s1 as variants
distinguished by id[4] (0x00 for 256 KB sectors and 0x01 for 64 KB
sectors), following an incorrect statement in the datasheet.

The sector size of s25fs256s is configurable between 256 KB and 64 KB.
The factory default is 64 KB, and id[4] is always 0x01 regardless of the
configured sector size. Remove the invalid s25fs256s0 entry from the ID
table.

Fixes: 075fd6dff24a ("mtd: spi-nor: spansion: Differentiate between s25fl256s and s25fs256s")
Signed-off-by: Takahiro Kuwano <takahiro.kuwano@infineon.com>
Signed-off-by: Michael Walle <mwalle@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/spansion.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/mtd/spi-nor/spansion.c b/drivers/mtd/spi-nor/spansion.c
index 3ba7dcc39032e..d807cbd63bfb8 100644
--- a/drivers/mtd/spi-nor/spansion.c
+++ b/drivers/mtd/spi-nor/spansion.c
@@ -829,13 +829,6 @@ static const struct flash_info spansion_nor_parts[] = {
 		.sector_size = SZ_256K,
 		.no_sfdp_flags = SPI_NOR_SKIP_SFDP | SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ,
 		.mfr_flags = USE_CLSR,
-	}, {
-		.id = SNOR_ID(0x01, 0x02, 0x19, 0x4d, 0x00, 0x81),
-		.name = "s25fs256s0",
-		.size = SZ_32M,
-		.sector_size = SZ_256K,
-		.no_sfdp_flags = SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ,
-		.mfr_flags = USE_CLSR,
 	}, {
 		.id = SNOR_ID(0x01, 0x02, 0x19, 0x4d, 0x01, 0x80),
 		.name = "s25fl256s1",
-- 
2.53.0



