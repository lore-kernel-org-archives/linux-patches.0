Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541FB1DA4E;
	Tue,  3 Dec 2024 15:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238187; cv=none; b=k10uvXU1qOCXx7y6Jk0jBtLQa0tAP0Av263YPJLMQbjXHYEbgcWj3oXzm8jF1I78718FyuXMSeXC2WmSRGXggWIBNTCjrfy9HVOLMyu5nVjEPgMnBrN7GgS3Jr/fZxxH4NBRKW/+kqe2NcgqtFc0HLqoMIKqPc0pa2bvhn4IDQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238187; c=relaxed/simple;
	bh=n6xo+MItrTH0yV/3xEIQZJLeAoNSRijSH33blhMD+RU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YjUF7J+gM4tdQzr4VougG8busw7uXpqmqQb7LvlIi7C5qIoPcj/XXa0VDz1E0zv+z0Ljjwv3XgxoB/8Dm0dXTam+cPWXzZae30/71NKXGxdPHv2RR9zD4RBFb6g1YG1DOTwqBWThUuwXX1pfJnoZz9CoY25ufQbokkNUIck2T0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=banQid8t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="banQid8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B935C4CED6;
	Tue,  3 Dec 2024 15:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238186;
	bh=n6xo+MItrTH0yV/3xEIQZJLeAoNSRijSH33blhMD+RU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=banQid8txFfslcFeO/DWWs7f+BGyOdmgfdL1vVRbSZFk8eG2O9afoDoAGAYFfIbVj
	 eQcndhdqjpj8V6qjKfjvKM2DN27IDS/pWHpV2Bs+FKDCzUT8VzClcDyyKiIdpMaEey
	 keVsk+Q30AiTuqMDlPZUxBlfUAlImuok+FCrsai4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Zekun <zhangzekun11@huawei.com>,
	Dhruva Gole <d-gole@ti.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 191/817] pmdomain: ti-sci: Add missing of_node_put() for args.np
Date: Tue,  3 Dec 2024 15:36:03 +0100
Message-ID: <20241203144003.192762786@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Zekun <zhangzekun11@huawei.com>

[ Upstream commit afc2331ef81657493c074592c409dac7c3cb8ccc ]

of_parse_phandle_with_args() needs to call of_node_put() to decrement
the refcount of args.np. So, Add the missing of_node_put() in the loop.

Fixes: efa5c01cd7ee ("soc: ti: ti_sci_pm_domains: switch to use multiple genpds instead of one")
Signed-off-by: Zhang Zekun <zhangzekun11@huawei.com>
Reviewed-by: Dhruva Gole <d-gole@ti.com>
Message-ID: <20241024030442.119506-2-zhangzekun11@huawei.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pmdomain/ti/ti_sci_pm_domains.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pmdomain/ti/ti_sci_pm_domains.c b/drivers/pmdomain/ti/ti_sci_pm_domains.c
index 1510d5ddae3de..0df3eb7ff09a3 100644
--- a/drivers/pmdomain/ti/ti_sci_pm_domains.c
+++ b/drivers/pmdomain/ti/ti_sci_pm_domains.c
@@ -161,6 +161,7 @@ static int ti_sci_pm_domain_probe(struct platform_device *pdev)
 				break;
 
 			if (args.args_count >= 1 && args.np == dev->of_node) {
+				of_node_put(args.np);
 				if (args.args[0] > max_id) {
 					max_id = args.args[0];
 				} else {
@@ -192,7 +193,10 @@ static int ti_sci_pm_domain_probe(struct platform_device *pdev)
 				pm_genpd_init(&pd->pd, NULL, true);
 
 				list_add(&pd->node, &pd_provider->pd_list);
+			} else {
+				of_node_put(args.np);
 			}
+
 			index++;
 		}
 	}
-- 
2.43.0



