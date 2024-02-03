Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494211BC3C;
	Sat,  3 Feb 2024 04:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933762; cv=none; b=l2uyvcoLMRoguozQIHcxL6yx+5Tt3/WJ1B4d8k3URRGGeAyTX51t7ceUw+TgC6YdOsSUMvwBgAfst+TLXSZ+bhlZKQf7RznimQW1ksMciNO/gyUkqppGJFm4gQR2mPmsOm0TdmsiLckCW0exh5JsB+trG61P9Ve7uyQhH3Zx34E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933762; c=relaxed/simple;
	bh=OO5MwZ/Y3HM0w26tXUe+5kl0xyI/+JS4aLTqeeCREZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aiMI/Y+FbwhY5eiXfioW6WMKVUMc6g5+1DT+ha7hAuDIIUeXlI7f0czKqFkBfsy06cXjio0GQULfk5JQ5phSbwrVVLHoeeQjYJh/TSEZT2aow64n1YpRKMO7KXs0JtnnCjHG/AvdfAKTD90vR1revy7L9Qdihpp0jeyRLErE95I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UcI9j7o6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UcI9j7o6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 124D2C43399;
	Sat,  3 Feb 2024 04:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933762;
	bh=OO5MwZ/Y3HM0w26tXUe+5kl0xyI/+JS4aLTqeeCREZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UcI9j7o6//KqpAp1VJzal2TlBxb9HSXum7WncJCsC2mpKgWtJJEcUc3qwUTiXPqbh
	 TBK9o2+HxqP5VOct8j+uxNHoPm+qZhm5TZQSNhRXJ84wkTOyfS1gyO7co41xxcOGP1
	 q00aJIiex6lAfhhLFk5dHjKeMqKgnF1GAXEA+FaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jie Ho <jiajie.ho@starfivetech.com>,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 035/353] hwrng: starfive - Fix dev_err_probe return error
Date: Fri,  2 Feb 2024 20:02:33 -0800
Message-ID: <20240203035404.907407683@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

From: Jia Jie Ho <jiajie.ho@starfivetech.com>

[ Upstream commit 2d37b3649c412b3bcecfea932cb677f7a5775b15 ]

Current dev_err_probe will return 0 instead of proper error code if
driver failed to get irq number. Fix the return err code.

Signed-off-by: Jia Jie Ho <jiajie.ho@starfivetech.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202311160649.3GhKCfhd-lkp@intel.com/
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/jh7110-trng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/jh7110-trng.c b/drivers/char/hw_random/jh7110-trng.c
index 38474d48a25e..b1f94e3c0c6a 100644
--- a/drivers/char/hw_random/jh7110-trng.c
+++ b/drivers/char/hw_random/jh7110-trng.c
@@ -300,7 +300,7 @@ static int starfive_trng_probe(struct platform_device *pdev)
 	ret = devm_request_irq(&pdev->dev, irq, starfive_trng_irq, 0, pdev->name,
 			       (void *)trng);
 	if (ret)
-		return dev_err_probe(&pdev->dev, irq,
+		return dev_err_probe(&pdev->dev, ret,
 				     "Failed to register interrupt handler\n");
 
 	trng->hclk = devm_clk_get(&pdev->dev, "hclk");
-- 
2.43.0



