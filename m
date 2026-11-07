Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061909;
	b=GmqEYqbHrOJ8Ys3D7TKsmH/yTxKJdKdE+VTNPFDZ9TKkYHHFd/aCehH+SsOGXFux9cHP
	 01EyBRafzZt94D3pNCNSX36DvStq/Zx7MzYUnuizbhna5ZhiXPiunnB9scITdQeM8uRwr
	 W29UXb9XijoVx8woMt1llnHQRjQLTiHZk4QSilqHpfFORR/fICIwOV+a6ApcW8AUFTlV7
	 GQbR0AOxcD7UZ4ChkJPi/rp2ivsp+TuD38hG0XvWT4z9GYjF0gMURYjTsru8RxJylvFP1
	 QnSp9CeoDU2WJz7JgfTHPzKG2EAjb+EIwCtJ0NkUUbGAnif/IFFCHWaEHp8QQ5cLQnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061909;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9bXcXdvqlD4wsDB0V8h9UPaL0BZ2F6+1Nqf0OmbDdLQ=;
	b=1kItZWELly300o1Bzdz+ohRt8U9GyCLfeb1XaqF0TpPktb+qJdTJb+grI/SsBs4+BicB
	 LQWQkAHWeiLC0JJUTx9UM/e2emhrcWEg/MVj1pRxSfwkejJWO1bNS99YiZAK0+TMcfoaJ
	 O5C1WOaYgLEEUyjoCEzjgD7i8wP94hofswiJhwSZnyHcMPTotDj//NkSt03KmQAjKpVvF
	 I2CJAnvCmtaeAJQw2Iw6lyxTiYMfFEnk96MfRsSek13UZTUIuC9vPxOo1RoLeG53WQXcY
	 ELR00Ld/lIY6a7PLtSMGIRrhvUVNCNj0NtUX5h5FBXwiQLBBMattoxbLWbfKTtwyvQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yW0MnRN0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E265606A330;
	Sat,  7 Nov 2026 14:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yW0MnRN0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA691F0089F;
	Sat,  7 Nov 2026 14:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061909;
	bh=9bXcXdvqlD4wsDB0V8h9UPaL0BZ2F6+1Nqf0OmbDdLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yW0MnRN0UQRsp2qgHMbDk3nkt/QCyVcwafimotHn8J4x7eLqZe52jkyG2TXIZCHIX
	 gBWW6W+MASDkBHJILW+Gvbz+ONaZE0ouh5FWW9DLyA6LIdnKMe2MXtPiAXkq/WUdOM
	 YS8kQDF4IQg7ILuKVY2v4h8jUocS4x+aDjz9btms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Dipen Patel <dipenp@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0918/1536] hte: tegra194: Initialize slice locks before registering chip
Date: Sat,  7 Nov 2026 08:48:54 -0500
Message-ID: <20261107135023.425736508@linuxfoundation.org>
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
index 690eb9be30fb8..4644677370022 100644
--- a/drivers/hte/hte-tegra194.c
+++ b/drivers/hte/hte-tegra194.c
@@ -787,17 +787,17 @@ static int tegra_hte_probe(struct platform_device *pdev)
 
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



