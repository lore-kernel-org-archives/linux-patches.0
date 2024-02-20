Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C937214A4D2;
	Tue, 20 Feb 2024 21:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464683; cv=none; b=rGECtApHJCQDx3qUItE9kWGv0JapjPKPo3cV8zn/xbTX6rKz2UNY2Sr47azevxmIJ5bpOrj2OiHwKomNf6U/qeTMlL4BYEh+PHukAk8REc/Jc4lyIDyOTQ8gZfvP4iKPJrLMSUo1Sto2vhNfCPjMVKAw7iGF2Oxh7iriQSQe3pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464683; c=relaxed/simple;
	bh=2bSrAPKqteJsqx91EyFOHtnYG5V4s26YimudmUrkPMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LqSNsOgA5F9m13DrmBaR2oXyfE+oy5eFf9y7c0WK3O6pqxaKX40zPkijgEelzGj+v6FzvUYQ43G02+2txUqko+dIvzr1UXHFBdxm7siErPFJvUeD5oGtheVCD+/a5Tv8F76E69JuHZkjTEG+j2ck5mgVcz4P5TkPCZGVg4WgbfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TsbkiXHG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TsbkiXHG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4834FC433F1;
	Tue, 20 Feb 2024 21:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464683;
	bh=2bSrAPKqteJsqx91EyFOHtnYG5V4s26YimudmUrkPMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TsbkiXHGJYWw44mkSLzZSiUBw/0MoBnciP/q+601N1kTCeS2dB2kCxpx2IbEDkIKZ
	 SJRCKR4pQ0ETBlBHCVlqsROoVAuKmS/RhgBqZkcUNZVVSQj3OAbd0VbYKaGbU35d6t
	 NeygrUIzhhuJoQ89VS5SlKEVwuGQUErJmFbm1MaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Tanislav <demonsingur@gmail.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 104/309] iio: adc: ad4130: zero-initialize clock init data
Date: Tue, 20 Feb 2024 21:54:23 +0100
Message-ID: <20240220205636.438717589@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cosmin Tanislav <demonsingur@gmail.com>

[ Upstream commit a22b0a2be69a36511cb5b37d948b651ddf7debf3 ]

The clk_init_data struct does not have all its members
initialized, causing issues when trying to expose the internal
clock on the CLK pin.

Fix this by zero-initializing the clk_init_data struct.

Fixes: 62094060cf3a ("iio: adc: ad4130: add AD4130 driver")
Signed-off-by: Cosmin Tanislav <demonsingur@gmail.com>
Reviewed-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20240207132007.253768-1-demonsingur@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad4130.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ad4130.c b/drivers/iio/adc/ad4130.c
index feb86fe6c422..9daeac16499b 100644
--- a/drivers/iio/adc/ad4130.c
+++ b/drivers/iio/adc/ad4130.c
@@ -1821,7 +1821,7 @@ static int ad4130_setup_int_clk(struct ad4130_state *st)
 {
 	struct device *dev = &st->spi->dev;
 	struct device_node *of_node = dev_of_node(dev);
-	struct clk_init_data init;
+	struct clk_init_data init = {};
 	const char *clk_name;
 	int ret;
 
-- 
2.43.0



