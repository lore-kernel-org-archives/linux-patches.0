Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033505;
	b=otN4dhXw3nVUKdWVD8hO7DjFnrVnhXcVdkK05GwvBjW3CHNHc5EDn1UGcDtPyHl5q7KJ
	 SuWUF+aGwV1oZEd8cZdB/OOuxlHKS7k3eL+kEnt2LvxPGyBSxpVu6d7pfrLIWCcEHtY46
	 1KQYLeGOSeBTzRPrjVYZgmy57ZzY2WYGXEEJ3f1DIeibgaoqkSQ+oBo5sPTY+pTvJzuh8
	 a3tqHYdf5NO4Ev1msjv5zj70EbP+YskZxRvrGeW/a51BAlj6WN+dhqoS/sN78OF6KdUru
	 466PmpiCzDUAJbSwQ8O4OP+B5e+yiTwhGnOHxK0IIHJ5UjwhS5DCT4mAiTsI4gpQz/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033505;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Xj7XyC9vljNmRMmSOy9ueKuwR2MlELwchH/ATO71iOo=;
	b=gYQkb0Itjq1V5sgjwPM9YsfUJRq6ffiOuaoGYIHYzekflv0qTa4irlRxlLsAnjxHCdt0
	 jYS/k69Pg71+OKlTS3WXNAF+J45V4/eJMr4fVAEKRtviFISxa+T+Qx0SVofnjW9gih+5/
	 KT3wtN8W2xLfur49nmbq8EgdXk9Yx58dF0wPpn80FP04s08dDckLIKKzpM8KHS8Ml9aLj
	 6wUKRVIZvgXUrMt43gQmm4SjYyxx9goaB05J+Z3rNJ5ytS729Lk96Cr+75qAzBzQIkXPf
	 2T+1PZq87yDgUvSLwlVgVa7TBx6c+DsQQ1VnjQ/IDGrLb/yej2o6rIcB1V+7WHpS26Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BjKcc62+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBFD5606A333;
	Wed, 18 Nov 2026 20:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BjKcc62+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 467EF1F000C6;
	Wed, 18 Nov 2026 20:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033504;
	bh=Xj7XyC9vljNmRMmSOy9ueKuwR2MlELwchH/ATO71iOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BjKcc62+Ul4m6NdPCLPr9ZyNRo/U4PLbKcUAfUWIAVWOxifKjUywEl78s0fs31Jpa
	 aPCsl0uw8dE56gTvFwurpEdNNE60KL436ixJjeTVIuLLa2MvDUW5vV+ngJouUc1nD9
	 U79SlONpQKHOyAmXOb+y14Uvpv7aeP71Rp5Xtjjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Liu <1298662399@qq.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0039/3318] spi: bcm63xx: return error from failed controller suspend
Date: Wed, 18 Nov 2026 15:11:01 +0100
Message-ID: <20261118150315.024100204@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawen Liu <1298662399@qq.com>

[ Upstream commit bbbc1ef5b35341c5122418a14f8924688a4bb954 ]

spi_controller_suspend() can fail if the SPI core cannot stop the
controller. bcm63xx_spi_suspend() ignored that error, disabled the
controller clock, and returned success.

Return the suspend error before tearing down the clock.

Signed-off-by: Jiawen Liu <1298662399@qq.com>
Link: https://patch.msgid.link/tencent_0BD7D4091B90EC17A8B2BA5EBA8803725905@qq.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm63xx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-bcm63xx.c b/drivers/spi/spi-bcm63xx.c
index 6f7c4ab0057de..3d3a4a8804579 100644
--- a/drivers/spi/spi-bcm63xx.c
+++ b/drivers/spi/spi-bcm63xx.c
@@ -643,8 +643,11 @@ static int bcm63xx_spi_suspend(struct device *dev)
 {
 	struct spi_controller *host = dev_get_drvdata(dev);
 	struct bcm63xx_spi *bs = spi_controller_get_devdata(host);
+	int ret;
 
-	spi_controller_suspend(host);
+	ret = spi_controller_suspend(host);
+	if (ret)
+		return ret;
 
 	clk_disable_unprepare(bs->clk);
 
-- 
2.53.0



