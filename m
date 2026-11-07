Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063871;
	b=hdqldozVBOPYtfV9RnUnszByywWz9EOCRElHwMdSMyDLFpuft+y6hfIggvshL8LsdsAs
	 O3bHVjRLqc9GrKffO6HaAF7jhA0bKCXSGTp7yzfYpD3lJxp9B5knaYvwdEYyvOadoShWJ
	 KWtt40jZJx9B6vMUBdIlJalWl9KHnhPGnIMje1NZTbA8i58zHZg3XcgQCW6IOki+Eb3zt
	 ZzUHqXh2sQDGD4InlaMSssZOy3/y0w8Ky+lJQQdBaOXboachDhxVk+fZzvtAI4Nnlx71R
	 dDrE8tCW6sxQVxuwYlQpZHF4+MiDepNYKDTDQmEClT0kGPTJ1Hcprv81BYzH5WZnxBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063871;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8AwCLxlaDpqP3Kfvs53wrC4JT2Hja2i9Ns9yrCtahTE=;
	b=Y4GVZX9rUo8hwgDYflQgkZAo/M8Q/0Bj9Qz8x4sVjD87ctuRKus+ZEw7JcFjbf3eoHrd
	 cU4LI8CGBrBOFpPLcm5eMbgtar+BezezMPPXT7FAH1qYFNHF22Y44D3H13IyqbokzZ/ER
	 EkPsK3z7X3doeA5PzkQp4seX7pCbcIdcXKyrqWLB7ZM0fQBWvwRNibyK+PfIBdnYYx9L4
	 rKbTlVBvbKwjXXmnN2O9/c5kaWEyOzLuNT7Rs//RZ8HlK37KIWJuRvPwzkuq44SOwv8Qo
	 mezjPWUeS6dFdxEMRkh/09x1wWqtIaZ97cWuy9qEPcP+kYfArbcCWnYf2jZXH8hACRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xhti0Ycu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27901606E8D5;
	Sat,  7 Nov 2026 15:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xhti0Ycu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A0D1F0089F;
	Sat,  7 Nov 2026 15:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063870;
	bh=8AwCLxlaDpqP3Kfvs53wrC4JT2Hja2i9Ns9yrCtahTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xhti0YcuKhqOBNi/l2moe9GKCiWbTEB9EaotE9D3tOImsr3x+HphxVBfiJ82SwQ1c
	 f6MhGBlj8TkRKF5m6VHCEm7ZDKqhRKcF6MGfn9cKcm7pf4b5UNqS/5kD9XXhI5fNf8
	 MqBEM7EQLVTZsaYLIMq86CG6AjNYRwg+Ejo2mz+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Michael Walle <mwalle@kernel.org>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0075/1257] mtd: spi-nor: Unprepare legacy controllers upon RWW wait interruption
Date: Sat,  7 Nov 2026 08:39:31 -0500
Message-ID: <20261107134941.456730301@linuxfoundation.org>
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
index 8bc117b46e028..250e996284f96 100644
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -1346,6 +1346,9 @@ int spi_nor_prep_and_lock(struct spi_nor *nor)
 		ret = wait_event_killable(nor->rww.wait,
 					  spi_nor_rww_start_exclusive(nor));
 
+	if (ret)
+		spi_nor_unprep(nor);
+
 	return ret;
 }
 
@@ -1417,6 +1420,9 @@ static int spi_nor_prep_and_lock_pe(struct spi_nor *nor, loff_t start, size_t le
 		ret = wait_event_killable(nor->rww.wait,
 					  spi_nor_rww_start_pe(nor, start, len));
 
+	if (ret)
+		spi_nor_unprep(nor);
+
 	return ret;
 }
 
@@ -1490,6 +1496,9 @@ static int spi_nor_prep_and_lock_rd(struct spi_nor *nor, loff_t start, size_t le
 		ret = wait_event_killable(nor->rww.wait,
 					  spi_nor_rww_start_rd(nor, start, len));
 
+	if (ret)
+		spi_nor_unprep(nor);
+
 	return ret;
 }
 
-- 
2.53.0



