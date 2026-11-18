Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060698;
	b=tgfLRrWIrQ4M74DbO3eqJ74tUeZ5kb18IiQvJRvFy+961iujLgTxY63PrYmPDDq+iL7M
	 oVyvxaZ+xqk12laqmLPMo49wPDkL6o/8N5JNJ/XwDZhYp9XNeez25BqxOgvbLox8Od9k8
	 yGC29QQOorDTlc4OPGtiBAevgU+LBm51LzlA7a9KcT4EuKRVsn+vlsueUVMMRD0TguToU
	 YR692sdLji5S3BXJ8I/UJiJ0hPVrAdeJ++9jSruhkf/stLHsUQlknuwqP2SyBqqiR6p7w
	 FWmKEpelITsjZm++1HVCsnZKJtRr4c3OT9ryP1xRwYXxDOxmsnhKFi0P6LZpw4IJ77w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060698;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g6LqmJ4/7oF86yfHuc22JJ/PRIvS0LnGzb5IxqJJUPw=;
	b=XU0bnduyh0Ku2VKApnKCe/0uVHGLsw0cOBh6Aco+sCpedq+xdtMWR3xh1MmzyQAVzY5H
	 PclEaIreZ/MjEPV5fwq3Qp4UHiPzAFsY5maWDVO6qVwUaIuLeRntlmSKtT88N5kfhdX6I
	 9bcjDnb0jrjx6mKd3OQL3QK+1m15I7Ic0CVsVnu09IoosQhHxtNPnJJS4NOxN0IdwLSUs
	 3cKtWVCZwBjNDiS2pdbUDWmIpyWfVwy34IxkInMEAiEchOTxdUcLGuxGE/FjTof6xtAJf
	 iFpdWJ9Vcm2o4+AVWMKqv2E8Qvo6Ls1a6u4cyJHe1ryAhnAtsAyN8NUuU5fAHnr+zqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rBnj36TZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D02606A320;
	Thu, 19 Nov 2026 03:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rBnj36TZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 451141F000C4;
	Thu, 19 Nov 2026 03:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060697;
	bh=g6LqmJ4/7oF86yfHuc22JJ/PRIvS0LnGzb5IxqJJUPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rBnj36TZoVQQITPgIsLH4vSSj0tKunFruZiO99j5W2c2RfoMRyigzoD7BMR11avoZ
	 28fThf+PCjAPI9sqt3KH/D9sPF0+jIDaiYjyjMIztXBde6iwsFkRzi0fw8cfjggHe9
	 /clGfcBggWvEqUEmd+vrvnL0j0JmOK0XhZZ+730g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1285/1848] pmdomain: imx: Propagate SCU provider registration failures
Date: Wed, 18 Nov 2026 15:55:23 +0100
Message-ID: <20261118150013.383503399@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/firmware/imx/scu-pd.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/imx/scu-pd.c b/drivers/firmware/imx/scu-pd.c
index 946eea292b52f..c3b8122b9034d 100644
--- a/drivers/firmware/imx/scu-pd.c
+++ b/drivers/firmware/imx/scu-pd.c
@@ -304,7 +304,7 @@ static int imx_scu_init_pm_domains(struct device *dev,
 	struct genpd_onecell_data *pd_data;
 	struct imx_sc_pm_domain *sc_pd;
 	u32 count = 0;
-	int i, j;
+	int i, j, ret;
 
 	for (i = 0; i < pd_soc->num_ranges; i++)
 		count += pd_ranges[i].num;
@@ -333,7 +333,13 @@ static int imx_scu_init_pm_domains(struct device *dev,
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



