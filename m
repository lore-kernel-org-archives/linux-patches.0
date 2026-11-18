Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055191;
	b=vDvnRo9VcAlgpgzJAe+MNAcKMFo59QDeuyanOf/8x/IS3eLCA8oLnA9hVKgI7Bsd65lz
	 LE59+UwR6Zuwr3Boh7+gmVPi38GyrFN5V4V50dThc3Sx5Cw7ApnfUJ4i4zlOUw+BOaodS
	 wYOhdtU9AygfYMwVpeAyVV9VLK2Gg7Fzz08exeHkaYTa1U4Tduek/N/5HI8mKXl5ran5P
	 GWnzgGEfO3rV0b8k3mbEeHqlHLAGtAUn4YLdfqh0M3yHW27lNPiJvoJ7KEcXZS0Pb68FC
	 G59TQbog1ZYyZATt1i2UrnJkSGWtJsuajEQY1wJkph/c2hn2tRAmzehSIf0gobHVgqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055191;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mwtHV3/cwyvvv1W5+VhLxWV3mFOvByrIJMWtsAn/RdY=;
	b=RfHCdYLdemS+UmnDVF7/+agzNf/rwCzf9jn07numx5m96vHg8ySaybL3NkJqBhH5E6kJ
	 WNyZUAlTRh27wwsxnqgE5K0ErKd6BNIhCpnzGNGOr25G2xBuDu6BsrewEQPstau7hymOI
	 XHjSpKAlkoCu3QFk0Bsb3n24vBfIliqZt1VZRgTXrwXVPf+0piWnlIBmNHO8LbeuC9EVx
	 IPctb8ktRTVYfdJd6zNR/a3H1SfQZC6edR4Bjje9KMUOiAFGD/deJ1JR5/fwZPO6sO8Pb
	 WOsasBZMh3cdeD68l7uqUdlQG/QQbHaT8E0IhdZciWrBP+iko2/DW6mBK/hKOZxeteg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OVPaBQKr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DED6606A32F;
	Thu, 19 Nov 2026 02:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OVPaBQKr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B33C01F000C4;
	Thu, 19 Nov 2026 02:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055191;
	bh=mwtHV3/cwyvvv1W5+VhLxWV3mFOvByrIJMWtsAn/RdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OVPaBQKr8k/c9Pnf+Nb148bUrTGuDaGu06N1W6fgXQ3O+XG+bSHXj9Gurk3tVXmAf
	 Te4sukHSvmPwhA7p9tAZEx0+frBjIWTxoOeAcdR9j/McCoPuQyRQElAb/t6mnXrZvv
	 EEJEZmAeUgTenF+SlieOn6TPfnex8F0KAgjTEdv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1542/2214] pmdomain: imx: Propagate SCU provider registration failures
Date: Wed, 18 Nov 2026 15:53:38 +0100
Message-ID: <20261118150113.831091079@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a0fc352a79936..f684168a14bd2 100644
--- a/drivers/firmware/imx/scu-pd.c
+++ b/drivers/firmware/imx/scu-pd.c
@@ -348,7 +348,7 @@ static int imx_scu_init_pm_domains(struct device *dev,
 	struct genpd_onecell_data *pd_data;
 	struct imx_sc_pm_domain *sc_pd;
 	u32 count = 0;
-	int i, j;
+	int i, j, ret;
 
 	for (i = 0; i < pd_soc->num_ranges; i++)
 		count += pd_ranges[i].num;
@@ -377,7 +377,13 @@ static int imx_scu_init_pm_domains(struct device *dev,
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



