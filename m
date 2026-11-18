Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015639;
	b=2EJKWn/83w8NZdOummeiiZkalqIB4LVL2XGOMw3ImoxQbLspLfZCMBB4Q9fb1lapXzrN
	 P26Ilhbli1Ipem7hOxYGQI6dPHp1i0yAGyTO4xzPigiObH27mb/zPNZUrzx5zxFMNXiXu
	 Z5l//JjC1XScM3QhszYzuqnlE+XDIdYo/bScs4CakqNFQMkMob06Qd3hpOcoLUjjzglYd
	 /zqxXBL1dxg6NLXAHfj+9aPuLKJIThexZcRaV8uLiWyTnhtU+BGk5NeRyZWYENoFnldsF
	 gu2PIeLq66GAJ1kb9JV9CpUSj0Rbx9NXbQAdMjE5ICg+Nl7ZJcEtE2RWrP+5iSc1O7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015639;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rdZRkdMpeAzWWw+kgZL456gCgtcH5idH84D307FEv8c=;
	b=rd9VLAKPWVByPPSVK1ufKiXk22NiGpfxJpSt0GfjFUHGPqSHmf9ZcGqm/JhpwGxtWcul
	 N2xUYS6CATOn3HmyUfy9BuUnGkYvAVSsC6ew5I7IK043G69RtdGZhxGD3jKM9GVWSqhZc
	 kNkmwSmBXt8I7S3+jzsX/TEVhNp0lBHYPHrKey0+qNlAW0gALsQBMFt9Umh+7rp2j/Hi5
	 fI/AjrONh0bjl/cbj+4Ckqi1ynXpnMdLkn+bncqhAdN066kZHXoSd58ax+mR5uGJYJPLt
	 pQA3x0QazIf0i0Y8IWUNAWWGc77c+iIW/PYdUcyF4M943wIa1yeTv3aOyBzn+E6PO7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QFx9h84E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E8DB606A337;
	Wed, 18 Nov 2026 15:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QFx9h84E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED28D1F000C4;
	Wed, 18 Nov 2026 15:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015639;
	bh=rdZRkdMpeAzWWw+kgZL456gCgtcH5idH84D307FEv8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QFx9h84E7edr1uLSFNTC1vBUYhlqfT/bYN1w3kcxlNmdlQdM89zq3OTRv92Tq9TcC
	 CCJ9pbuLVZodPwdKLmPC+KajE0kJZFO8j6uAfMp4aVccCZhpKoS/NYffeHWKtu/P+v
	 e/MRrnAPo2T/nTnIOPIJu+/kBsevPu8g5dZmLR6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0243/2651] spi: mtk-nor: fix runtime PM usage count leak in probe error path
Date: Wed, 18 Nov 2026 15:24:43 +0100
Message-ID: <20261118150256.606532750@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 4cee1ed13e2687f1a9fec7dd50e31eb179506d75 ]

mtk_nor_probe() takes a runtime PM reference with
pm_runtime_get_noresume() before registering the controller, but the
error path never drops it.

Balance the get with pm_runtime_put_noidle() in the error path.

Fixes: 3bfd9103c7af ("spi: spi-mtk-nor: Add power management support")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Link: https://patch.msgid.link/20260904-mtk-nor-v1-1-cefdca098f83@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mtk-nor.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-mtk-nor.c b/drivers/spi/spi-mtk-nor.c
index 63f5139176c8d..6b6e55d68048b 100644
--- a/drivers/spi/spi-mtk-nor.c
+++ b/drivers/spi/spi-mtk-nor.c
@@ -929,6 +929,7 @@ static int mtk_nor_probe(struct platform_device *pdev)
 	return 0;
 
 err_probe:
+	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
-- 
2.53.0



