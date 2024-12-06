Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CE91442E8;
	Fri,  6 Dec 2024 14:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497043; cv=none; b=P1HVELSFI6/88VPpM029f34AF/2PlhOT4/CkiQ06YSbDy14R4fotKwsdcFj9VXu4cQ8L6MWHHvblak7YZBJRLQpP1tFOHENhBOWSyhS5jwvyRyvs2Yt6oeHzv5j0zq+QEsciZgQbdUZ1sbsVmxZzHOqu95EnK0dVUzlhgAht8No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497043; c=relaxed/simple;
	bh=DudA1rsLdBo1Dv1FMUA24V5BNk+uBOOt9vfoMFFbk9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EIKBueMcoVDbSl+HXnYFTQflEOenOCvks80Xl+QoJug1pwRRhY4AijQ7WOghb+8qt7ndaozxzyjVn6cutAnY00Z7K0RQVhQHdmqgi0nitBW13ZAkUhY0W5lQy/+bNUYEuN42y5elC6xNi+5byHiZdmJ1VQOelJzKgXFUp+tUPy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eWj7u85V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eWj7u85V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7932BC4CED1;
	Fri,  6 Dec 2024 14:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497043;
	bh=DudA1rsLdBo1Dv1FMUA24V5BNk+uBOOt9vfoMFFbk9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eWj7u85VA5RKxooeMz0nJt0An6VZ8LPYraoPQPZQ+VS9KQvT+0T0yRkGFIsnil8mX
	 OG0Yaw/mRdMFTPy01TV03PX9f+PGo9RvuByTyJk0irCvLuGN4x5rgE6jepuouJvkoZ
	 U7yNsAi6KYwcdSQuoxr2Zm2CLuusvtIzusIwYwmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Zekun <zhangzekun11@huawei.com>,
	Dhruva Gole <d-gole@ti.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 146/676] pmdomain: ti-sci: Add missing of_node_put() for args.np
Date: Fri,  6 Dec 2024 15:29:25 +0100
Message-ID: <20241206143659.053826324@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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
index f520228e1b6ae..4449d36042c22 100644
--- a/drivers/pmdomain/ti/ti_sci_pm_domains.c
+++ b/drivers/pmdomain/ti/ti_sci_pm_domains.c
@@ -161,6 +161,7 @@ static int ti_sci_pm_domain_probe(struct platform_device *pdev)
 				break;
 
 			if (args.args_count >= 1 && args.np == dev->of_node) {
+				of_node_put(args.np);
 				if (args.args[0] > max_id) {
 					max_id = args.args[0];
 				} else {
@@ -188,7 +189,10 @@ static int ti_sci_pm_domain_probe(struct platform_device *pdev)
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



