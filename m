Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023963;
	b=d/thTUGDSsjlr6viXbZfac3jvIEQT2sHrN25T5MuoreoY2BVM2KQ8EmbflY3I3QPTeRx
	 a47OTddCuQU/Em+Zwmot4kl9gy4oavJa6bT3w8MkJelu82kohzinDsRpC3qIo8BbZpbJ7
	 fih9H9W5d64jlRHebLblGB/3Kn8VP4xtbAHAxHZ6U08bhiQLX4Ig6UiZhAev68WcSkk5r
	 W9rBrl3RPwauLfNSJF9g+UgnvtuNhZz7PouZvyfX1+40UnYLdm1zxmSxhD2aE2KIHwqVK
	 SnFcrAF+GNXVW2OgOL8QBFdanKUfQRb6dKyu+ieTaCflHbTD7pVccqGY0FioVa3dpeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023963;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pFlqhdTR9Ra3G5B3cqB47jBxdCYR0ofOLIXEDcLzEvU=;
	b=Y9kAvwh8XIE4ZfDxxzeM7M2lzYX0mpDy5h1NEuvvd9rdEZs8PxvRSGdAZE1HpqcuOWne
	 Miou+mVsLWA/X+D1SlVmV05R2GUuLWVauvAQus4bt8YP258qyvoxToQ8P2ebZWTLUSmhE
	 0IXFU8py3b7aNh4avdtsNrR54RnvaR1Hjhu8oUKiEQ3PDC/6wQjs3ZN8fd1hMDPIEiS/6
	 sOzx+4iNMrXASW2F0Q2aQxRRa3IGz9ZzNa2rP3t7zDuGg0jmwqRESeRno5Bonw6Av+QLU
	 wvtd+G9s3CVvUBXVFT9CMvyQGXGFZq2kyv5LInUFJ66ZUn2GBhnn0FW7TSJQc4gYfEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oJrrFrwg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 372A3606A320;
	Wed, 18 Nov 2026 17:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oJrrFrwg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91AEB1F000C4;
	Wed, 18 Nov 2026 17:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023963;
	bh=pFlqhdTR9Ra3G5B3cqB47jBxdCYR0ofOLIXEDcLzEvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oJrrFrwgOXUJY4gUoncOm3CvKlPKxHxICBZVva+gV/QigBhzz34bQNEnhHrqsq8Fq
	 q+pVH1oKqBYSC95/9MZBqNElY5LVe62oC6yMQalGv8mN72/CI2FL2vRGYz+0dxlPhE
	 coh5MGm9Ty8rBB9aKYrTdkD003Dw/2ZxSfOflY0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0554/2151] pmdomain: imx: Propagate SCU provider registration failures
Date: Wed, 18 Nov 2026 15:38:09 +0100
Message-ID: <20261118150142.142722009@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <hppiscas@163.com>

[ Upstream commit d3efba7921f3ebebd91fc481910a428c78414fd8 ]

imx_scu_init_pm_domains() ignores of_genpd_add_provider_onecell() and
returns success even when none of the initialized domains are published to
DT consumers.

Return the provider error and remove the initialized domains in reverse
order before devm releases their backing storage on probe failure.

The issue was found by our static-analysis tool and manually reviewed.

Fixes: c800cd7824bd ("firmware: imx: add SCU power domain driver")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <hppiscas@163.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pmdomain/imx/scu-pd.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/pmdomain/imx/scu-pd.c b/drivers/pmdomain/imx/scu-pd.c
index 3ec33667a308c..41dd45b48a762 100644
--- a/drivers/pmdomain/imx/scu-pd.c
+++ b/drivers/pmdomain/imx/scu-pd.c
@@ -474,7 +474,7 @@ static int imx_scu_init_pm_domains(struct device *dev,
 	struct genpd_onecell_data *pd_data;
 	struct imx_sc_pm_domain *sc_pd;
 	u32 count = 0;
-	int i, j;
+	int i, j, ret;
 
 	for (i = 0; i < pd_soc->num_ranges; i++)
 		count += pd_ranges[i].num;
@@ -503,7 +503,13 @@ static int imx_scu_init_pm_domains(struct device *dev,
 	pd_data->num_domains = count;
 	pd_data->xlate = imx_scu_pd_xlate;
 
-	of_genpd_add_provider_onecell(dev->of_node, pd_data);
+	ret = of_genpd_add_provider_onecell(dev->of_node, pd_data);
+	if (ret) {
+		while (count)
+			pm_genpd_remove(domains[--count]);
+
+		return ret;
+	}
 
 	return 0;
 }
-- 
2.53.0



