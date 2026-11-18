Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016785;
	b=LnTCwlWD1A13xw2A5pHKX65nAHNFyOvpCiv1SRwG+UInTzWSyK8HRVP+vz5A3XCWuSNs
	 UzMKQP0XLKXOOID4UdGNrOuQQIMnjvAYwkqC+yrcGyCcK39q9qduaLYb7uHJXKL5TNVMt
	 gU0bA7Z3OdgV2aqyg8qrYAXD/LE4GxNCVBrXydQgO+7av2+4S11PoYaTLWWSYgd52G9Xi
	 BQTCJjIa5ODlWwAbaDIKwyHAOvpbOHY2qxuxAw6qtz2m9b7MfdbID3OR2QTDNvZjH0DaR
	 ELeX/+rud7C4FEpKsdchZANTHqdDIh+ubGo50Xp7ML6AjpenTo5QQv1EaF3aKs4LlWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016785;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r+/fcaA3z2fmTvDDXa5gkXgJYwTCDVxWI1ghK80/goA=;
	b=E7qNadsCTOM0PfbwbSAJcvTBnEPCtHM8SHOW6Vnn4ap2mu6RZARYVVzw4dikfYo22FRi
	 WHrA+VkVPDijBxhdXQrEaTNwEvAnxjRktq8ogQvhbZ2zsha0JZ9s1w3wu53CXzlnx501j
	 aKY0HrC8d4gtrNjXa7hkewibg0sahLeyaJgcBa/EIGmBqEDVHX5u0KXwAdD6hjdX8AbsU
	 eWNGJPMZwat56eUEJxoPgPhFdj8NGQYyyI7Mf12BQ2OhATfchcDhmpSs7TmzXkyfJ5CdM
	 RsKW58azD0d17lzkER5FXEPSdNwdsJG2nmg4GHJg3Kj/in1QAkXR20OtC021M6FaGQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="TjkNbql/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273B4606A31C;
	Wed, 18 Nov 2026 15:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TjkNbql/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75C7F1F000C4;
	Wed, 18 Nov 2026 15:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016785;
	bh=r+/fcaA3z2fmTvDDXa5gkXgJYwTCDVxWI1ghK80/goA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TjkNbql/lmTk8kQj29BZBil0ZkBdi8LOclUwvFp+lsYU5HvcA7L6z8vMgLpvfMG+4
	 w7kkVQVN35Gak22x9ppN+pV8WdraKAaOj8Fq8u6k5ORa4wpv0UpWGqFMVeYGVnE0oE
	 WyBKiW09ge5PV82hqiHybi/nVxEl68sNZ/G9iW5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0611/2651] pmdomain: imx: Propagate SCU provider registration failures
Date: Wed, 18 Nov 2026 15:30:51 +0100
Message-ID: <20261118150309.714082214@linuxfoundation.org>
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
index e3f9e741daf76..05d4364f34be9 100644
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



