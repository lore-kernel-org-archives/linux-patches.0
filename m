Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590546;
	b=4/RUAynsrRY9hyPWNPQl5KzaAPeBbF29yysSZmDZioLCKE7Y++VMQ3MzHhYGU0nGhYaX
	 Lei8l/q0yDwpmMVuC/uOdlac6VI5zwDXYTkpso3y2u20j6gEqY3O76e9Y1BPDM0v/vwU8
	 Jkaw8UTA1G/Im7aGAU6gsBtQWELROQWwlfX+VKOKZ57BVQCfytJGaexMplS2Hq2OPyJt5
	 zrIJcrUiXoq8iHxHqmto5RiIBlkF098siUo3HaY/MPXXpgpGWP28x/JOolHy+Z86DHges
	 YWzUsoh3Fl2V9OuOt2nTusJp0ajVT5ra/U8B6hIHKop2Z/AzqXz4AijYzpGXmHytRwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590546;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OjwUOZKWK6+p03XEqAzRbxys1KhELHD2ABNqkBx+rJk=;
	b=mEYR5qBclxrmSKqbLJONxcmb0c4DN5vUxzfL9yqdNsPXrfdYpLz0Aqwr9PseIdcdSeTj
	 jLj8AKf1hP4JpsiWmu2De7OvOBhVtCfzH+irKewMx3jPRVLikcIgZNJilBYJXDXRUkiIo
	 zS0BO+921fzrd4nMBJNASOY8dYShuv90rJ7r/2gFiUFwH1sZs6ZhBk3RT/48d6a4lYVS5
	 VvdOS8zgmrLhC3ocZwtItwcQusQrAaE7u2VRXynsDP2UNV9eafTL1kqix9c0VjlSwDb6R
	 4Oql7k5HDZs178OCe4JPewiMmA0Q/viH42a/HDf3HTfjneNvj7t8XMUNdkAdb7UOeUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cJ2AfFGh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A636074B1B;
	Fri, 13 Nov 2026 17:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cJ2AfFGh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96951F000C7;
	Fri, 13 Nov 2026 17:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590546;
	bh=OjwUOZKWK6+p03XEqAzRbxys1KhELHD2ABNqkBx+rJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cJ2AfFGh3K6/51PF9LVC9jylXgIYSWxHWUoJ1m8QdJHdRxNrkzi9H1JBaTPel0JYa
	 YG+bAPax0b0WTeC7cHlKVRRGFOwa6TKlyrF95rYA2URi8pWqftI2mzDrJPbAygT+ES
	 vEpOSBaJEkLJ37HoYbzEppaJctF/190n2CGG5QMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Ming Lin <chengminglin@mxic.com.tw>,
	Michael Walle <mwalle@kernel.org>,
	Russell Senior <russell@personaltelco.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 484/686] mtd: spi-nor: macronix: Restore fallback parameters for MX25L12805D
Date: Fri, 13 Nov 2026 10:50:17 -0500
Message-ID: <20261113153837.356765646@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
[ sashal: adjusted context for the MX25L12805D entry because the upstream fixups assignment is absent ]
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



