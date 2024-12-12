Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B772210DE;
	Thu, 12 Dec 2024 17:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023909; cv=none; b=E8s/4x9jZwrqoCpaMdN7CZFlWYat4JD4VHi+p50irI2Y9Zfmwr+ddSL7zzyT4jYVy+0AmArrV1eSJy5+yVIr5QWi+vtA0DmNcQ2FzXqMkjVXt5CMeO9k2CQ3eEu3+gYQcZ3rMOVrCPECa1Lee9TyYpmHWZZTE/RErdCFQOjJt1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023909; c=relaxed/simple;
	bh=4IiSklLf/KNdSUJ4yJnCqonEdtAE0I/3jGErD4RSggk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HU4jIXQ0RcCrw5NOmRm09e4wSMUM7rJFEGiGbirV2Nsg/REt4LuCzAk3UXqwz+Cp+XhaXmBb2A0pIAP2uALrfTp+Jg3iw77bR/fFaBd1GmSmvyLTLUnZwpBMwKIx+kAk4mFR+i4G2d20NhGXsBam7WLJGlodMsfel6PQhJx7Zdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P3VtoYxY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P3VtoYxY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BCF1C4CECE;
	Thu, 12 Dec 2024 17:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023908;
	bh=4IiSklLf/KNdSUJ4yJnCqonEdtAE0I/3jGErD4RSggk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P3VtoYxYDmzYFILvvcWevAq/HoV6TM6rC4n/hrCG/tmWXlJF1eKHUYJAXo9K7yFRo
	 +PEn5tEcfCoJwfz7F3x60/velGSrhdG3MLd8kGwpkzD8yOTgsl/K9w8rLPPoyZYvye
	 UOhBwxZb8VyBSaDlCY0nqiH4D15oaxo5/Ev07/58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Zekun <zhangzekun11@huawei.com>,
	Dhruva Gole <d-gole@ti.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 092/459] pmdomain: ti-sci: Add missing of_node_put() for args.np
Date: Thu, 12 Dec 2024 15:57:10 +0100
Message-ID: <20241212144257.145917573@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/soc/ti/ti_sci_pm_domains.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/soc/ti/ti_sci_pm_domains.c b/drivers/soc/ti/ti_sci_pm_domains.c
index 17984a7bffba5..b21b152ed5d0f 100644
--- a/drivers/soc/ti/ti_sci_pm_domains.c
+++ b/drivers/soc/ti/ti_sci_pm_domains.c
@@ -165,6 +165,7 @@ static int ti_sci_pm_domain_probe(struct platform_device *pdev)
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



