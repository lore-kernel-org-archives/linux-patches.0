Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95BFE1EE001;
	Tue,  3 Dec 2024 15:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240506; cv=none; b=TU8xl6GXml78Piu2Wy21UgWLepTIMc7tHkJ3/jcMG338LYRjHK0hkqpI4oeTTukz3k4nEwrrK+hgh1GXGhj9BEYiXqjFglEiaem/jtkb2aJQG7x+8U3CyeiIMtq/LJkINZPIeJ1id4AwyHMcknTjV6RDUF+X+gZ9j1PWkkzqlow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240506; c=relaxed/simple;
	bh=Qk4mqn/Kqaa/uBo9FxGaTLTXa+GIQDLwzv7oIHKTLDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s2HFZOaOzfG4qqdwje++lG30TloRkA/3g2+iiVu2FRrGx68GP0Y/4lPe8Q2K7uqYvugQxqyFGtf3NOftW0oT2ZM6c4+Enat8DCQtR9mbFfRQ17245tWt7CKOmOWZJMGfCiQt0O82sNQKDRt0HU7JigZM+IkvvsMkIT3YJgkICqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cR+7q8N/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cR+7q8N/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7ED7C4CED8;
	Tue,  3 Dec 2024 15:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240506;
	bh=Qk4mqn/Kqaa/uBo9FxGaTLTXa+GIQDLwzv7oIHKTLDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cR+7q8N/WqvyaU0HR8Qplt35Q0KqrLb4XErvJOOpuS3Xf7EQ+SibpWY9IZ/aTWq3u
	 Ch/hY/HzUyJr+/y0GHdswDIqFkePWH9lZJ4rD/XiI2b21kifBFwJiNQuBwOtoOxwGo
	 kxozd3M6Cpi/jgkn/E5nGfpKNTFXxVph1qk4vY9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Zekun <zhangzekun11@huawei.com>,
	Dhruva Gole <d-gole@ti.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 155/826] pmdomain: ti-sci: Add missing of_node_put() for args.np
Date: Tue,  3 Dec 2024 15:38:02 +0100
Message-ID: <20241203144749.789671921@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



