Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C04413C8E8;
	Mon, 18 Aug 2025 13:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525385; cv=none; b=V5/2nFkTJ3npUatVlAjXZnyY2AbE9F1505jN95iFv8LDp96IlB7nr8p+/StZJu0oUUgb8aCYCgumo7OzVPBUPSwQzpdOsXkwJkh/qKjblRXUN4/on2j+a5afSZo2RFxPYbq9XLTxtg/B0ifKrOoR4tpeBN8LXTMhLrm7NmOTcjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525385; c=relaxed/simple;
	bh=duaxUwLPm/j+CgBK3OlQLm06yV91zVTV2MbmmPQytXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ctuxkzH30X0ildqjGncYfB68f2+M8dhhVOja4OZthZi95Re2qeoiHW8FC70O/Cm65H5No9Xivlpd8WVnR3vu5+VGB2p4gI96wlkwch4PtbXrluKv6E1/JMt4bLFC3Na31BTo320iFFnugQow3w2rJlB9NJs1Cn7USzP+4SxC7wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nK0DArTh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nK0DArTh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA1AC4CEEB;
	Mon, 18 Aug 2025 13:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525385;
	bh=duaxUwLPm/j+CgBK3OlQLm06yV91zVTV2MbmmPQytXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nK0DArThaPVrDmrBBgojYVxvw/8K/5DNJ7+LLbZm8s+F8Swn4VAiDy3WVee1Q6abH
	 buX4zoiy8ZbxH6cNdy/h1ZDc222FZTa9N0YebWonioaajAtRr6iuHK/p/fR6IwxVx4
	 BB0i6yyE9D9gtaocTsISxUOoGslybLJo7eLfop4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 247/570] perf/cxlpmu: Remove unintended newline from IRQ name format string
Date: Mon, 18 Aug 2025 14:43:54 +0200
Message-ID: <20250818124515.332621192@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 3e870815ccf5bc75274158f0b5e234fce6f93229 ]

The IRQ name format string used in devm_kasprintf() mistakenly included
a newline character "\n".
This could lead to confusing log output or misformatted names in sysfs
or debug messages.

This fix removes the newline to ensure proper IRQ naming.

Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Link: https://lore.kernel.org/r/20250624194350.109790-3-alok.a.tiwari@oracle.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/cxl_pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/perf/cxl_pmu.c b/drivers/perf/cxl_pmu.c
index d6693519eaee..948e7c067dd2 100644
--- a/drivers/perf/cxl_pmu.c
+++ b/drivers/perf/cxl_pmu.c
@@ -873,7 +873,7 @@ static int cxl_pmu_probe(struct device *dev)
 		return rc;
 	irq = rc;
 
-	irq_name = devm_kasprintf(dev, GFP_KERNEL, "%s_overflow\n", dev_name);
+	irq_name = devm_kasprintf(dev, GFP_KERNEL, "%s_overflow", dev_name);
 	if (!irq_name)
 		return -ENOMEM;
 
-- 
2.39.5



