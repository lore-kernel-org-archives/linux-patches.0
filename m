Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016253;
	b=EE6ZjJ6eg+meb8WlIbFGwTMw0HSUJlpRoWWVv3khIe2eXogsiUvnjGHd4TvRZdYJzIyg
	 49CBFAib/0UmNTA953+odSYGKNvbr6SzLn8sZbGnCEsP9leMbLP+R+2cMDVR4VtjVr1pi
	 C/ezooHskkLiL0q2SA6KIUuijboC7O0oSUclYS9XVvrKTHCtSB3QX4TMNQirrVxtDoKdu
	 ov3+DgUrGoSv/TBa8qGhVCs5S8nAU5d1pVCxQo2ODm4j9yXwMMFqPvxbb1jQWQv0C5W+J
	 OWnF8wKM/Azqm+ecS/bnia+n6gKvLV77G+0VEFPZPkiZTr/22w8JG/JXVLt+CsMdboA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016253;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xB48FqC9Xc9bsAx4QrrD6vuujYXizHcy93ropbiHqAE=;
	b=lqtMNl36dsBRoxBvvSMQC6wnQ5Rfa6s96ErM1W2bd4bHXZ5qhPvD06PQkiGpyOkC7NY/
	 RfkDyt6Jt/cO9GhsMv4/jj/qOeCFgg9bWlwbO74KW1srL1iVsKJNJqlsDVTsuIrZx4Jc8
	 Tm1K7otWcooCagNYDJsy7UKziyW52T6NcxcZDsYx5cmDbOVckDwUl+aoBeExkPytxLk6Y
	 9WaNTuT+vRnZMOY98BYpe2miuTR5XQoTKI33PvQtkJq4ac3onPqzlAr1a0gVBTdsfQvo6
	 wpTjbCHj79BNku6ncTAnjRsNaUF+sHEa+GUyC0RLM6iYSxKje7HaDVMri+Vrvcq5hvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OJvPmthy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2CC606A320;
	Wed, 18 Nov 2026 15:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OJvPmthy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C31B41F000C8;
	Wed, 18 Nov 2026 15:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016253;
	bh=xB48FqC9Xc9bsAx4QrrD6vuujYXizHcy93ropbiHqAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OJvPmthy9ASGWjqoQAr+96aI34UUKQF0C1CB+lgVvvAHV0/7PbRTVjEjcu7/GkBby
	 LA9pt4Qjdy57R24jnxDEA95QV8xdDvPlSwToSvCbSGc/7I4sm8apg/PWQa+Bfp4DrL
	 B4aQcwVh97O9HjpASmsm0AQ/pbr16m88pRIiZFfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takahiro Kuwano <takahiro.kuwano@infineon.com>,
	Michael Walle <mwalle@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0462/2651] mtd: spi-nor: spansion: Remove s25fs256s0
Date: Wed, 18 Nov 2026 15:28:22 +0100
Message-ID: <20261118150304.434112966@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 65227d989de13..db9b5416fcf12 100644
--- a/drivers/mtd/spi-nor/spansion.c
+++ b/drivers/mtd/spi-nor/spansion.c
@@ -870,13 +870,6 @@ static const struct flash_info spansion_nor_parts[] = {
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



