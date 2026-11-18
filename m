Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029593;
	b=oYAds6dCaRvZuODhrX/KzqXj3eKGEnv6VswOvMNQmXtMAUuPmbrfcun+xmXUqOZTMe8+
	 EqKuDoy2FJX92DlB3vqsWUv0dxY+UL88+IbWEODiU/uj+W5w/ggjHRIPo0+XK0V3IlVcU
	 daPd+pqtZrusZTvh+IEtZWP/rQ/DV6YHnFdQ8q5bfYFBRjIPCk3EGVEmewB+L5YKt/Ks/
	 AcDbM2Z4UPt6B5cMi2KKMespFNOOFMLSX22ucXp8BDoNxpV+CUhfqu0K9hYopSrsLYOUJ
	 qKE2W0Bcwl8xGUOaGtiXXj+VcuHVs1WDid3FbTZF1b/QIWLvZXo5kf5oh+kbk1FRIWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029593;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uMayhFx4ZlwhHVKoErAfI2+JgJZU3l+t+t0AVx+wjV8=;
	b=eIEEpijdcZhvTJ9LEC7nlSIDxg8j5JzY4ZwPg+PNg0x+QE23ls0WLwwNWj0HviBJ8HkG
	 OtQWerdyd8ZdLZ4Hg5bzJS7BAj6vupZKWwAihnlQDSHQjivqZnJC7j7fLnGp66gGifRhF
	 N3weX297VL1md58Xwv+WACLHjUF3yAWHxYXIgJ3EZpI1MzCXOYeJSLViGfuykuvtDcFpm
	 j+DM7dGElSEKOd0Bq3u7v/ysG0rA34qysie4HFR9jOneExgX/2rRgFwB9fylB7+oppEwt
	 SDmZJ70CV7NeHS5zNSY8xRago6XkQemJtCOrYmh4sxPXfn6P4eml4Z+dhiJCxWwM/kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ualUFYi5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E34B606A320;
	Wed, 18 Nov 2026 19:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ualUFYi5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A821F000C4;
	Wed, 18 Nov 2026 19:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029593;
	bh=uMayhFx4ZlwhHVKoErAfI2+JgJZU3l+t+t0AVx+wjV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ualUFYi5fah/L8nNd3maVgjDfZwl08tFql99rdcNwfR1Z9ce73LMBo4A4bzzkeLVj
	 2Prc4zY3wYgqhUdcqTdofxhdLuLIVVcWi8ihGDb1PGj8/BWpYFkGWixq1e+1RA4ZC+
	 V/+/qm1pz0XfZ5xI/2VuNJHjnijvMhoas9Tu5FD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takahiro Kuwano <takahiro.kuwano@infineon.com>,
	Michael Walle <mwalle@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0404/1756] mtd: spi-nor: spansion: Remove s25fs256s0
Date: Wed, 18 Nov 2026 15:42:11 +0100
Message-ID: <20261118150024.848385431@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 36407ea90f924..041c0dcaf4b7c 100644
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



