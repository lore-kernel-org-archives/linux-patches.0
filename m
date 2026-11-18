Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044898;
	b=JjvFylSeMBE8GUZFGe5WW7CJ5Gk0SQ3KS0XhkmDGBedcUT+rdPjYz0JyIoFNUv+B/7cz
	 1ub6zZ7x5vgKtFKBFBWzIUG+VZPntCavq36GMxl8DqYH7arr3Tyr/X/+LKUjSNEZOuTsv
	 5IvG1igUv3PU+Xag04fJwKlKfwjVIByA6VbX7vAHCrrGeGxhOtg99ubwOhbvbxZWiUY2h
	 g0epz38WersrSJpHoQYLwpM67cJEnSsJkW8YGwdxu0sH8Zl44ZS+jBF1F2IHqkf9/3ct+
	 9rjBQYT2kB1Mp+N8LlQpVyyyaWFcOGOEwNzuwmdqQFez0873D8lGNOleVZNeAdLCxRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044898;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Lwv7Jt48HEAoVB5fT5AI2HFqypT+9xu5OTuDt2lRJZs=;
	b=WcsrFLXH18ePObRgZFH90BCzNZN4GA6Q2hcpdupToFp/NJbT1g3cg7ISVYBdq70BhZl4
	 gzc01FVjtKk+pQR7B1Gu7zMr7Y1M192uMuOzH5XhW1LXRpJpNLDC+76TdxOCJKGmgmncb
	 3gWJMACjgaOFIYtqAsNJfeAsga+Wx6weIxzbZWkiCaSCUZBIbH8nWmjjJwQQ6zmS4CDZF
	 XtG1i4qzZ3AVIstpU8TbMuncXgpK4sjELqDc8vsxaBDG+PBIhsov5RRJd8YobIBssVZFv
	 9InO5cL1Cvw7UEpEGKwpGtdQYH7+K2V5eahhZe4Cu1kOd1ttIvw2fzJzcHViueekYqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IB5Uv2AL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A2D606A31C;
	Wed, 18 Nov 2026 23:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IB5Uv2AL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2311A1F000C4;
	Wed, 18 Nov 2026 23:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044898;
	bh=Lwv7Jt48HEAoVB5fT5AI2HFqypT+9xu5OTuDt2lRJZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IB5Uv2ALj38rykXa92F9zcvvrD1TjJXN/Qz/rM8NwoQ0r6WLg5gzEl9bTI8Cu/Ehz
	 iGOh3mz3HETeDcbwXNYQEdbXog3MtAYJbVVD0sp3aB+dkyhH795y4vtBqXPhgCjgvW
	 aBMYLS5Eiqdp6kThOOEtMij4Az6AMVYrfKK2Skxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Dipen Patel <dipenp@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0728/2857] hte: tegra194: Initialize slice locks before registering chip
Date: Wed, 18 Nov 2026 15:29:22 +0100
Message-ID: <20261118150227.760977412@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 1329abe1bae416ab2cff89c3312d33f745d341c7 ]

Registering the HTE chip publishes its request callbacks to consumers.
Initialize every slice lock before registration so a concurrent HTE
request cannot use an uninitialized lock.

Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Fixes: 09574cca6ad6 ("hte: Add Tegra194 HTE kernel provider")
Cc: stable@vger.kernel.org
Acked-by: Dipen Patel <dipenp@nvidia.com>
Signed-off-by: Dipen Patel <dipenp@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hte/hte-tegra194.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/hte/hte-tegra194.c b/drivers/hte/hte-tegra194.c
index d1b579c822797..80cd4e1749d38 100644
--- a/drivers/hte/hte-tegra194.c
+++ b/drivers/hte/hte-tegra194.c
@@ -644,17 +644,17 @@ static int tegra_hte_probe(struct platform_device *pdev)
 
 	hte_dev->chip = gc;
 
+	for (i = 0; i < slices; i++) {
+		hte_dev->sl[i].flags = 0;
+		spin_lock_init(&hte_dev->sl[i].s_lock);
+	}
+
 	ret = devm_hte_register_chip(hte_dev->chip);
 	if (ret) {
 		dev_err(gc->dev, "hte chip register failed");
 		return ret;
 	}
 
-	for (i = 0; i < slices; i++) {
-		hte_dev->sl[i].flags = 0;
-		spin_lock_init(&hte_dev->sl[i].s_lock);
-	}
-
 	val = HTE_TECTRL_ENABLE_ENABLE |
 	      (HTE_TECTRL_INTR_ENABLE << HTE_TECTRL_INTR_SHIFT) |
 	      (hte_dev->itr_thrshld << HTE_TECTRL_OCCU_SHIFT);
-- 
2.53.0



