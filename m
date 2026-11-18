Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029799;
	b=gKUHfYwNmFCZGzrx27s+6MjqqEvyMF1g7we7gL8rWky/1nAW3KJscfLfSQAe3pphkWZZ
	 v+wPb+YY8fjRL1IVSeCB4DF2TgF+0A4efbj8TogCJ1ySrjQz/cqEEcqoAuXRd6PQ6s+LM
	 ESiQpdqfB9nEXdDMxMI7212Xy421x3JcwFlqeJG8H12sIvafb9TMjwpPksrxwjDHGOhrt
	 QEoznyQudJfZPzP8kIQqSjJxo5JSkMNT9TVj2g+RfjLihWs+kAYS+fLwM8we8k9n1AAxK
	 yjDR5tF/wuFGltbXRGbYuJHA9yeecMPMjpQPrf6MLzp2VI5Ui+BKeb038a979dbI6xA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029799;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/rVM7152VBVUhDLc46Oo/6pr1ykCWAVSHLxaHPSf6dc=;
	b=e3NZj+RIHITw8iXSpNXM/7V3yzUUo8mJw+8KxLnhqwE1isaGJOLwb2fwWtjD5fuLeFBd
	 g44gECSxzq46qD/hl9O+vtkb4CTK7Z+qqdb26+y0C7eQ88L2VpD19Fydo2QXSPqI3gFFh
	 QzT1BeM620wrcLpzVtk9wEX9wdfabHVr8oDFkrtmh+w9B+UrD3GmrxIc0CA71koyvJzr/
	 Df0g3Cokjx39BisqXdZDLSvKQNYGggAe6KFKQJ9Y/Dcgx/3nHkwRxrGtJQDn+v7JkqnYL
	 +4bqdoJw9Zq9JMgI6yREcZt4tHvvjfjVh9h4rRbCayATydVFNAD4M7aWDhfjL+XE9Tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GRIVyLoy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C0A606A31C;
	Wed, 18 Nov 2026 19:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GRIVyLoy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6690A1F000C4;
	Wed, 18 Nov 2026 19:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029798;
	bh=/rVM7152VBVUhDLc46Oo/6pr1ykCWAVSHLxaHPSf6dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GRIVyLoylShcQykBT7BmB6jS6DsAuMDkU0j0AggC96r0VM163Tv2EoTK0s+7KiyTd
	 b7ZsE0ZIr0tpAFaCjwialj3wM7okt5nQAtJwBVqdMcj5rQAeG2XsfPcrXmqW6u89N6
	 x1HusXUxvCw5SKygpK7i/1NwNzeLhvbGt+meqyx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0479/1756] pmdomain: imx: Propagate SCU provider registration failures
Date: Wed, 18 Nov 2026 15:43:26 +0100
Message-ID: <20261118150027.969594538@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



