Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040048;
	b=f9NBzHuDQUznkw6azhw2WvJlpX61syEyn4xF/YMz097uvILgQRIpnu9TFLy2apEhYfeA
	 MhHDlU3oSnOYp9dUIOzfUDHPNHlZRLUMwiXuzeMK+JG0qQahM63sdq4Os79eCrF8YRsiF
	 AzXBsFk8oXz0shictXnMrl8JA5qVlUcH+ecylnPLeuue6Ey6kHA1w6bUykgyyCyjVs7cm
	 lsIr5sD6H4/7uiHp9TzmiVNdTpfvXSViIN6DJSjIZe3ExGJYX4yb2d73ukllBOxZedYSA
	 a03w7vUKHlQ38cb1c1gujuVvhHC/GJCL+KAgBbLJfvRM7u2t2Zs+6xFy+iLt3S/E3dQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040048;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FBtsm2Y/znwV0Y/S61zg1bfhZLi2bPU3myF4+BWZbBo=;
	b=zjKhRiY0D7cN3Oz9kOL9FTs44LMwNQX39YVDqDBYDoO4yiFvkY3/x15i2SliqU5tfLEc
	 bn/sJPb/AQV/4sqgZgm+AqYS19gu2wvweMcQRJ3uQ/PZSeUxXHkqzQi7Ipn84HswheQy2
	 +KCkKWPUGcbV3fnTGU8HgWkgqQQZySXSdvjsaT8jG6YUujFGIrx0Gxto9widlvcPYcGim
	 VApCq7b4lBlXVN64uerX2+ufEMh+TAZ6pzClD6+2usnEriBSAgUVaQyUW3YqLufXYviPP
	 VXF9sDskRXPIshMVs3oAetZWBu1ojufKTbqfgMawcI6L9/z6Nl2j4EFkLJ839rMWGmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LLCtrd70;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96045606A32C;
	Wed, 18 Nov 2026 22:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LLCtrd70
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB5671F000C4;
	Wed, 18 Nov 2026 22:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040048;
	bh=FBtsm2Y/znwV0Y/S61zg1bfhZLi2bPU3myF4+BWZbBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LLCtrd703zUtZoZ9U6rBTE9SA2f/uDCE1QF4F85ExKif+cQ1hC10uA+b4hITE3tuN
	 4ps7X3EcOm2D7fkCDfoP3m/co61c84eyCTpa62jmpTDfliL15Nm/dKvmGPkRl0eFSU
	 GKMoE6ePg/HEMEVnh04GgP83N3AnPuIKSg97z+ZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2278/3318] pmdomain: imx: Propagate SCU provider registration failures
Date: Wed, 18 Nov 2026 15:48:20 +0100
Message-ID: <20261118150430.117950222@linuxfoundation.org>
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
index 606d6bdccf94a..33d9f0a963081 100644
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



