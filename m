Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062757;
	b=QhCoXx8DtDWAUW8qzEFUC3Brk0TNOgpkMMW4ayG0iTe1GqiH4bnKW1OlhpHZqRH78Mdm
	 n/X+DxiOfY+J/+R3/ZIqBV49yk3+hUbmZxCrgt4s3y2Kf5I/PhOIhA6NSxfB9Hs5RXi6q
	 H4H0/3yv46ukHdS4hQ08rDJkhyKruPk0Cc/ZTST3LhNHle08B/H5GXfuQwgYO6Ic+bng8
	 5HV9foIF6SLIf2hg24nB97Aizw0CvGLleNNrylk2XRIqFSRO0E6HruQLPJfWx9epDPbwi
	 GJai/3v+0tq8R3ZeGgkRp2lxG0Icq1Xy9FP+Aa6RV4OcD+l6Cek9JwRTuFkAYPly8kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062757;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GKQC6Jc4JkSMxuTdad6rSSSpg08g9LMz24vHa3qQzDQ=;
	b=jcV1FpVr/C0uR/BvBDQIno1dIsSJcqO0xjKrXi8ywQmcNo8jilEBP3DcDi0CmBn5DiTA
	 i+t6hC0zoe32xQKpGfGXHwuuwV8noES46CpJEZWrxevjvmBhGQyp6fq2GumQOfQgioytp
	 F3HVGJFmZTqe5jeF22un4Q4eVEqtFj2+iCnCHJPjZskGL6xT67vZKBhE39216bjsYHAzQ
	 sN2STJDlMtLBZb2FOlVf9WVuNjfzePoPMh5wgPkgpN76RXUnAgGHxvd3DlGb8IxVsfLT4
	 RD1vBn2Im8ngGnWijlZzm3AYs4suaZ2VIC65fTWT0B4FDURzCbkuUJIDEUTfbaCLaqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YU5PoP1+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35911606A326;
	Sat,  7 Nov 2026 14:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YU5PoP1+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6A971F0089F;
	Sat,  7 Nov 2026 14:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062757;
	bh=GKQC6Jc4JkSMxuTdad6rSSSpg08g9LMz24vHa3qQzDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YU5PoP1+fzExVkGBYl3YS/Dc3P3Dx/8N9u/ne7F8kGUYVUf8RIUbfzL2d96Sx8IcZ
	 /p4H8JmjK2mIJw3mgZXkLgqDMeOWRUHAqPUdyOpV82ErNwNLEuh8eER1yFHa5xG34a
	 iEunvXjJLYlp0/IJc5uGRma9+ddIPMdBFUu+PnO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Michael Walle <mwalle@kernel.org>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 069/869] mtd: spi-nor: Unprepare legacy controllers upon RWW wait interruption
Date: Sat,  7 Nov 2026 08:45:51 -0500
Message-ID: <20261107134854.794889653@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit f594a33f9721f08facd98d0a31adc14ff6da9d70 ]

All the parallel locking helpers (spi_nor_prep_and_lock(),
spi_nor_prep_and_lock_pe() and spi_nor_prep_and_lock_rd()) call
spi_nor_prep() then wait with a killable sleep. If the sleep gets
killed, we leave the controller in its prepared state.

Call ->unprepare() in these cases.

Fixes: 74df43b3f626 ("mtd: spi-nor: Enhance locking to support reads while writes")
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Michael Walle <mwalle@kernel.org>
Acked-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Michael Walle <mwalle@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/core.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
index 037407fc2e113..512d0e4e3b1f6 100644
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -1281,6 +1281,9 @@ int spi_nor_prep_and_lock(struct spi_nor *nor)
 		ret = wait_event_killable(nor->rww.wait,
 					  spi_nor_rww_start_exclusive(nor));
 
+	if (ret)
+		spi_nor_unprep(nor);
+
 	return ret;
 }
 
@@ -1352,6 +1355,9 @@ static int spi_nor_prep_and_lock_pe(struct spi_nor *nor, loff_t start, size_t le
 		ret = wait_event_killable(nor->rww.wait,
 					  spi_nor_rww_start_pe(nor, start, len));
 
+	if (ret)
+		spi_nor_unprep(nor);
+
 	return ret;
 }
 
@@ -1425,6 +1431,9 @@ static int spi_nor_prep_and_lock_rd(struct spi_nor *nor, loff_t start, size_t le
 		ret = wait_event_killable(nor->rww.wait,
 					  spi_nor_rww_start_rd(nor, start, len));
 
+	if (ret)
+		spi_nor_unprep(nor);
+
 	return ret;
 }
 
-- 
2.53.0



