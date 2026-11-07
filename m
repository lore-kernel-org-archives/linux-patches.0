Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061915;
	b=GGtIdsfTLazsdrchiNi0534BV5GcnMhg0nNBXqHrnWel2z29y1kUKrtR6ZPdN//N7lxB
	 T7pUBggA67dFVPzELlCNlRfNNp4QRbYta1UfzohKw2iLxQnlVv1OeAhrVpRjjluhFMGAl
	 upZTAqSaLqjNWQdSShqZyfo1c7vjIgB0srLe2ghSYz5LF1Z5gMDF9DHzpSn+e8E6UcY65
	 7aog4EE9UCjbtd2eh9B1xcH2IwAlWEYBhzpykhGIPTSkViDUt4qtqLaxcP2V+83tO75nN
	 4Y++oj69U2mrE45I2INtbNf+RGmUHqDxDZlAI9FXPfnDaYdbH/Ba8mDEoA89Y7bFlWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061915;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t9SSQlusRO2ltdti4q+zcbLA/MfRHqXttyjw3PG1RQc=;
	b=tNapsjEhyhhGs25E9Auq4q/6cgG4oJ8PHEeZKXuTmKNqXcOdNEG5vh5LibTTefFWUJ5v
	 MLgQGpueGQVwFGx+m1AucUBYTdEuM42vyDbu9aRg5IRlwUM+93pCXfd1lGm5VlSuRQgS8
	 /T/BUsIHR/k+x1YFwhsDNcz3RZw8tvkL9CmHJ16QPmdTAYBxyWc3dxKElF5r7BQe+sE+X
	 UBZ8TwGYjMgslzwqtuIJjpZ4zk+Yjmvl/VMXYUO4c9MwFdfcEjKijiybKB0ELiZvdbpzC
	 7G7O73nZo2BAKWVRezUjB/vG3CPHmQKlvf9uF3jGI3Mi9+VwEVer1cst3epe01KMdMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zUlK6FAZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4012F606A326;
	Sat,  7 Nov 2026 14:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zUlK6FAZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D7C1F0089F;
	Sat,  7 Nov 2026 14:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061915;
	bh=t9SSQlusRO2ltdti4q+zcbLA/MfRHqXttyjw3PG1RQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zUlK6FAZe1qzmzD/igH9j4n9yId50JiBPod8lDfuIPYVHWVNaoFkcP6Beke2PlPUC
	 CVvfT/FePTCHB6lS2T6g3ujE99LjfjaRtPW8msmMcTv8oawYdCH4NZ05d5DUZXWgIQ
	 nnes5VBRGTsyjLPT1FG/vLc8IoI0gH3sOr/Gg7mA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Michael Walle <mwalle@kernel.org>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0923/1536] mtd: spi-nor: Unprepare legacy controllers upon RWW wait interruption
Date: Sat,  7 Nov 2026 08:48:59 -0500
Message-ID: <20261107135023.566155351@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index d666e044b0c4d..2476fcae8dea0 100644
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -1292,6 +1292,9 @@ int spi_nor_prep_and_lock(struct spi_nor *nor)
 		ret = wait_event_killable(nor->rww.wait,
 					  spi_nor_rww_start_exclusive(nor));
 
+	if (ret)
+		spi_nor_unprep(nor);
+
 	return ret;
 }
 
@@ -1369,6 +1372,9 @@ static int spi_nor_prep_and_lock_pe(struct spi_nor *nor, loff_t start, size_t le
 		ret = wait_event_killable(nor->rww.wait,
 					  spi_nor_rww_start_pe(nor, start, len));
 
+	if (ret)
+		spi_nor_unprep(nor);
+
 	return ret;
 }
 
@@ -1448,6 +1454,9 @@ static int spi_nor_prep_and_lock_rd(struct spi_nor *nor, loff_t start, size_t le
 		ret = wait_event_killable(nor->rww.wait,
 					  spi_nor_rww_start_rd(nor, start, len));
 
+	if (ret)
+		spi_nor_unprep(nor);
+
 	return ret;
 }
 
-- 
2.53.0



