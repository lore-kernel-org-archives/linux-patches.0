Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585872;
	b=cosl7r+peHMgD47ShUiUFWoHwvj9gP4haVeQa9ZSFT4CAIRR8d/sR+zudV9I6bfH3Goe
	 OnxV3C8ljYWG7OCN3TpoAJD6/UAA+vqqUv9doxmIIAG4owcWyEu1qm8/Wsg0L1JJE7B3v
	 nRJZLzVmtLAQR10WcndU5z1LfWf0DgHA8hpBr2me1kC99tfXteglHPKKmJw/kI3zVGQMl
	 zF3UIfPEKWITjJHxfeUSvIsYr3zuoSt/e2zqsC9wpxxcrXQWALCkSy4+66c4ITjNUAy8C
	 NFXNSYie52PkvurZjFSLkdVCZTDQkuEDam8Bz+dexx5gcZ3t/T34g/+THkoEYD3e4TA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585872;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nk+4udmTvBJj6MggHnIJ/1u4HaCdAJuUaEWnbiEHJ7M=;
	b=vWCdHlch0yJfsOLzXBlap82fuGI6aaChtg7qNLHXV4LJd8Ju3/AmSnBWNRJpIx7MucwN
	 7J5GpwxWucIXHgFzL6q8V4Imbe3x+xQXgW0xyDRwXmCUi5+BGPSgxTnq3ECFHEyn5FDEc
	 OuppN9T5ymQCGs+DarQ/zyZgK2EJRg5KxRQltL3l5vYU6F8v+jEC4i/CiRLyQtkwnM7W6
	 CGScSe8Tt/rqaKreQiJFWUKBtMGkCaagNy7R53Tv2pOdpVpH9kU2SRg80WisMEeYdEXX6
	 SiwlllTQvTceUu43hfvmnkguf/wZIxWEmk32usKeursTCFlWMQcRpRoILj4Qo3NPL/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IG926vPK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C58606EA8D;
	Fri, 13 Nov 2026 16:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IG926vPK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 430EE1F000C4;
	Fri, 13 Nov 2026 16:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585872;
	bh=nk+4udmTvBJj6MggHnIJ/1u4HaCdAJuUaEWnbiEHJ7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IG926vPKx9FHdQHn9p3m3/u1M8wjAegSx/bXdpGlx7qIaB69Ttid4bf35QwKEnZ4L
	 5UPI3OqrC+vm67+JwNp+HnrJ83nroUOGL0fEadHHMkwwyoTFdT90lnREWWLzj0cWu/
	 IkmYaQeTbHUn4Sxt9ecIk/9+F52oHUb147t18DF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Ming Lin <chengminglin@mxic.com.tw>,
	Michael Walle <mwalle@kernel.org>,
	Russell Senior <russell@personaltelco.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 443/507] mtd: spi-nor: macronix: Restore fallback parameters for MX25L12805D
Date: Fri, 13 Nov 2026 10:52:27 -0500
Message-ID: <20261113153811.755398082@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Cheng Ming Lin <chengminglin@mxic.com.tw>

[ Upstream commit 01739ccea21b69818dc071096a249e6f84a6b13d ]

In a previous effort to drop flash_info fields and rely on SFDP, the
static size and no_sfdp_flags were removed from the MX25L12805D entry
(JEDEC ID 0xc22018).

At that time, the legacy MX25L12805D was already EOL and unavailable
for physical testing. Verification was inadvertently performed using
the newer MX25L12833F, which shares the same JEDEC ID but supports
SFDP. As a result, the probe succeeded during testing, leading to
the mistaken removal of the fallback parameters.

Since the actual MX25L12805D lacks SFDP support entirely, it strictly
requires these static parameters.

Restore .size = SZ_16M and .no_sfdp_flags = SECT_4K to this entry
to fix the probe failure for the legacy part.

Fixes: 947c86e481a0 ("mtd: spi-nor: macronix: Drop the redundant flash info fields")
Cc: stable@vger.kernel.org
Signed-off-by: Cheng Ming Lin <chengminglin@mxic.com.tw>
Reviewed-by: Michael Walle <mwalle@kernel.org>
Tested-by: Russell Senior <russell@personaltelco.net>
Signed-off-by: Michael Walle <mwalle@kernel.org>
[ sashal: Adjusted patch context to account for the absent mx25l12805d_4pp3b_fixups hook. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/macronix.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mtd/spi-nor/macronix.c b/drivers/mtd/spi-nor/macronix.c
index e97f5cbd9aad2..c854a1163a475 100644
--- a/drivers/mtd/spi-nor/macronix.c
+++ b/drivers/mtd/spi-nor/macronix.c
@@ -132,7 +132,9 @@ static const struct flash_info macronix_nor_parts[] = {
 	}, {
 		/* MX25L12805D */
 		.id = SNOR_ID(0xc2, 0x20, 0x18),
+		.size = SZ_16M,
 		.flags = SPI_NOR_HAS_LOCK | SPI_NOR_4BIT_BP,
+		.no_sfdp_flags = SECT_4K,
 	}, {
 		/* MX25L25635E, MX25L25645G */
 		.id = SNOR_ID(0xc2, 0x20, 0x19),
-- 
2.53.0



