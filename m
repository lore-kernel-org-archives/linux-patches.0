Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62AE322F06;
	Thu, 18 Jan 2024 10:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575310; cv=none; b=AjFci+dNZON7cOOGA+ZRy3DvrM6ripdoFlTb0M/x/yC4ZbHhSvMPbXSv7ZufVW3moG2skIaU5QiuxrQXoPdPuhbdoBTRFOgGyC+lAZgUgCfVF9Z68plxe345zVsGsLTIGO/+dGPwfbI/XfJDURGLV8cqxOgosGCHAbvnSJ21BPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575310; c=relaxed/simple;
	bh=L9z71P5Pe9FVPIVzKq/tkm3reREjCStqyMJWJv5g3U8=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=udsCX9yZqpnEtskN2LlJkgMS/dp9FlW3r+dcc6qSAEZB5y3f7B/WF0Y7n5nXFI9BIuXnhg6K0hwRDBuHKnyvBHf1S1f0cia97eSqs7BBiaYuPQzobHXqJRdImjjRxk9a4zMTE+jw8Ei39dTjmqVf2rW08U3eg4XAtC/Wu1Qzmbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O70dj3CR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O70dj3CR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB1D5C433F1;
	Thu, 18 Jan 2024 10:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575310;
	bh=L9z71P5Pe9FVPIVzKq/tkm3reREjCStqyMJWJv5g3U8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O70dj3CRhyWH8IzlUm99xwRU2MUmpSPBUH7WXrDMfWyr5k2nChyrpedv8IhMwnZqx
	 k8+8hru9mMR7fGVH32vavwl4fUwofCaEbU2Jje1IIEYz7f4aM1N2ACKAVvoGwlWJRx
	 tUXfvwmFodlY9wJ4TXUcXXtV2TWc3nQMNjjDm84w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 086/150] reset: hisilicon: hi6220: fix Wvoid-pointer-to-enum-cast warning
Date: Thu, 18 Jan 2024 11:48:28 +0100
Message-ID: <20240118104323.938812274@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit b5ec294472794ed9ecba0cb4b8208372842e7e0d ]

'type' is an enum, thus cast of pointer on 64-bit compile test with W=1
causes:

  hi6220_reset.c:166:9: error: cast to smaller integer type 'enum hi6220_reset_ctrl_type' from 'const void *' [-Werror,-Wvoid-pointer-to-enum-cast]

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20230810091300.70197-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/reset/hisilicon/hi6220_reset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/reset/hisilicon/hi6220_reset.c b/drivers/reset/hisilicon/hi6220_reset.c
index 8d1fce18ded7..5c3267acd2b1 100644
--- a/drivers/reset/hisilicon/hi6220_reset.c
+++ b/drivers/reset/hisilicon/hi6220_reset.c
@@ -163,7 +163,7 @@ static int hi6220_reset_probe(struct platform_device *pdev)
 	if (!data)
 		return -ENOMEM;
 
-	type = (enum hi6220_reset_ctrl_type)of_device_get_match_data(dev);
+	type = (uintptr_t)of_device_get_match_data(dev);
 
 	regmap = syscon_node_to_regmap(np);
 	if (IS_ERR(regmap)) {
-- 
2.43.0



