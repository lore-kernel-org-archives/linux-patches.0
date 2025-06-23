Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9F1C2E0;
	Mon, 23 Jun 2025 21:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714311; cv=none; b=UvyZu4plbU2v4/+eso+Pg5iWlZHlR1D67kkgP2XT9TaUcnSeeark0VG+6hNkfuDCuairXaqJflJ+x7EF1FOGYlqYUZRMiCELMw1MxlWEOMErq2BkwJwSm6nf26WrTdmRF3THAtZPQEHfesy+7E8M0UO4MDiqsEHNx2/43olNvQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714311; c=relaxed/simple;
	bh=d5a/1oAZj19igkuc4nPknQidBIwy4GEiFgoeXSfnmoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QxeckRrVEnJ0ntbWrCilA0KjGJrULYD7CiCuWDXTqIB4p4x+0XhWzq7SP9wefxiwENjzidm4jkxQ9jonFpGvFeYYwXCN7+AKbAE4PJtR6LKsnXaut8rw626gjWPzcFccJ1t1fgMVSz8aauPsSaI/74P4cbpnhpjSpyKyieT8QxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lEi//xtr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lEi//xtr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2475FC4CEEA;
	Mon, 23 Jun 2025 21:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714311;
	bh=d5a/1oAZj19igkuc4nPknQidBIwy4GEiFgoeXSfnmoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lEi//xtr1zD97B9F7FiIzNaCp1NolbpKJTB/rHitkYExClx4FszrK6ykKD1Iff1Ss
	 7ho2ps53FpCIxvu6FrdtqVt6FrHPw/2ptS7BtlwvX61WzRwYIkVDGzpH0Q/SwIZsnI
	 33x0cXhFzk4hyAh/0p4tJ/A1F37MQ5g7lnPcGaU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanjun Gong <ruc_gongyuanjun@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 129/290] ASoC: tegra210_ahub: Add check to of_device_get_match_data()
Date: Mon, 23 Jun 2025 15:06:30 +0200
Message-ID: <20250623130630.805730784@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuanjun Gong <ruc_gongyuanjun@163.com>

[ Upstream commit 04cb269c204398763a620d426cbee43064854000 ]

In tegra_ahub_probe(), check the result of function
of_device_get_match_data(), return an error code in case it fails.

Signed-off-by: Yuanjun Gong <ruc_gongyuanjun@163.com>
Link: https://patch.msgid.link/20250513123744.3041724-1-ruc_gongyuanjun@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/tegra/tegra210_ahub.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/tegra/tegra210_ahub.c b/sound/soc/tegra/tegra210_ahub.c
index ab3c6b2544d20..140cb27f73287 100644
--- a/sound/soc/tegra/tegra210_ahub.c
+++ b/sound/soc/tegra/tegra210_ahub.c
@@ -1359,6 +1359,8 @@ static int tegra_ahub_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	ahub->soc_data = of_device_get_match_data(&pdev->dev);
+	if (!ahub->soc_data)
+		return -ENODEV;
 
 	platform_set_drvdata(pdev, ahub);
 
-- 
2.39.5



