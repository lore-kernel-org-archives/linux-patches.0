Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063922;
	b=EnXyMLzUU6jCgKciN0kahu0YR3SmT4LyTfVShtO/JI7oiJlOC5vaN30R0p0EDyLAUYv4
	 SVz/CJ1QNJUITcS5GV5p8vBPBWSrxkEzmy+dHGYvxvNlxp+JL2jBhes3VdXrxXGWKdTfO
	 CRNQTs47GVrveeLeFbS9o7y66xyoLrXTafZhyNVXeXAFGAVWuHrdWbsZQLs9g9qbwnMC5
	 SJkLQwuncxHtXDNsuHnPQ1HSBmvYtot8xccsaiCw5lC1s0bq3JehjuR4oTrk1V+vA3dx3
	 eCAkAAI6Hen1j41Bcwx0oyNFEzXkse+vmhlWseI38/5SlEpL82tw7N+1iwMVY+Q3n2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063922;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+f3UUGfAqxOIKJ96Dza6RAwqVdF3D9Cl5w2x3UVpAts=;
	b=Y6JMybgbgkoSAKtxlS6QPJl61Jee9Mm5aXTbBGLZiRh2lxvhZWa3F2UxSd4OjWtzQxE4
	 DDNJpkWs88/nOc2swXwnss7AKZkfAK5PBQZorUMClkChQG/E7SR2cuOyM0kuY8ejUvMaQ
	 cSgcCxAW7/XMuK7XElome3dmj1zuIt1C+OMDZOZpHOPb6PWXQyTuHIj6jZXmw93WLBlYR
	 7Vy+rxKRhzilIhjNH2h5kuNoFpW7faRxu4g5u0PvJzzRyr+34buLVKBnhiBEt6ynF8p8U
	 kruBxMu8hMOLHTT+ybuVsOdVphH45rGXxB7fWxAw8er1+URaHiD2aGC4krp3LPdvZFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BdUWMD5e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB7C606E8E9;
	Sat,  7 Nov 2026 15:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BdUWMD5e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5C21F0089F;
	Sat,  7 Nov 2026 15:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063921;
	bh=+f3UUGfAqxOIKJ96Dza6RAwqVdF3D9Cl5w2x3UVpAts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BdUWMD5e5EHKNurMxSr89BFt7PphOQTBnKNSsTFkVTh0KgaTwfOCYCMsXCWRVyZj6
	 lzStBMd7J4b2ZQ+tDWdBc7K+sh3Z5YA9qAITUeKhz00sIPICDaLZdVr83PuwhASQYE
	 lvIHy9tNrJTLXMkF9pvT04IFJisd9JV4W/+66IWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Hilliard <james.hilliard1@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0117/1257] mtd: rawnand: sunxi: fix free OOB section offsets
Date: Sat,  7 Nov 2026 08:40:13 -0500
Message-ID: <20261107134942.573642698@linuxfoundation.org>
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

From: James Hilliard <james.hilliard1@gmail.com>

[ Upstream commit c56d52865624ca236c44838ef9366a8597b6af6c ]

The sunxi hardware ECC OOB layout places protected user data before the
ECC bytes for every step. Since variable user-data lengths were
introduced, free sections after the first use sunxi_get_ecc_offset(),
which skips the protected user data and points at the ECC bytes instead.

As a result, the MTD free-OOB interface addresses ECC bytes rather than
the protected user data for those sections. Use sunxi_get_oob_offset() to
point each free section at the beginning of its protected user data. Keep
the special two-byte offset for section zero to reserve the bad block
marker.

Fixes: 54dcd6aa69db ("mtd: rawnand: sunxi: introduce maximize variable user data length")
Cc: stable@vger.kernel.org
Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/sunxi_nand.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/sunxi_nand.c b/drivers/mtd/nand/raw/sunxi_nand.c
index 4f9c229c34bc0..89fe3c0379f74 100644
--- a/drivers/mtd/nand/raw/sunxi_nand.c
+++ b/drivers/mtd/nand/raw/sunxi_nand.c
@@ -2012,7 +2012,7 @@ static int sunxi_nand_ooblayout_free(struct mtd_info *mtd, int section,
 		return 0;
 	}
 
-	oobregion->offset = sunxi_get_ecc_offset(sunxi_nand, ecc, section);
+	oobregion->offset = sunxi_get_oob_offset(sunxi_nand, ecc, section);
 	oobregion->length = user_data_sz;
 
 	return 0;
-- 
2.53.0



