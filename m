Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF0C130E42;
	Tue, 23 Jan 2024 00:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969082; cv=none; b=bzaquNIzOfXG6qsjJjoJIvvbLViQ/LsWLIeUEeuLUa7smvBYeZzJMCr5nVeyTRQwMG8RbHpPMHzacefwjhxmlj30jp/WGltNR6h8szqjT9cDUBM+HguODdkxgH0Qi8rmC24LGuqgeBab2FJngyw8m/wxPpi9pTkM1onNtLDPu7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969082; c=relaxed/simple;
	bh=kBwcOSatiIZlS4RHESWmoQMQstnt+Slc85vhdnPTuyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uMx1Khn+FX0M95cXOl7mq5QqvwrMLiaSkpmXQLPD/Nk2XJxdnovrrcLIQ2dzUg4hGnC0gsLPB5Ci+TzEysLl+WCAKHo11U+rbclDuQNVW2620qdjdgs8fwxDRtxAMO6jxX9nyOlHgCYhI81+BOXYWvQS8JjFPHWxCt8qjIdPo5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J3OnXHJN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J3OnXHJN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105C2C433F1;
	Tue, 23 Jan 2024 00:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969082;
	bh=kBwcOSatiIZlS4RHESWmoQMQstnt+Slc85vhdnPTuyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J3OnXHJNq3gUq50bRBEQv4QyH9E+Jgs/6o8TywTKBkd9rJ7oPeZ/tlfk5yTFVvyNE
	 jljUXgEMtU05nr+fZNl1SV4wGgwPglY/mG9AdsMysq/9NR6/8SvQ1k7HtYRVLZNePb
	 sHWOuzt1EJinRYUpgU4/G/oXElLGy9DhwYKuOEoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jing Zhang <renyu.zj@linux.alibaba.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 010/641] perf/arm-cmn: Fix HN-F class_occup_id events
Date: Mon, 22 Jan 2024 15:48:34 -0800
Message-ID: <20240122235818.436732683@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit 590f23b092401f29e410fd4ca67128fcc45192fc ]

A subtle copy-paste error managed to slip through the reorganisation
of these patches in development, and not only give some HN-F events
the wrong type, but use that wrong type before the subsequent patch
defined it. Too late to fix history, but we can at least fix the bug.

Fixes: b1b7dc38e482 ("perf/arm-cmn: Refactor HN-F event selector macros")
Reported-by: Jing Zhang <renyu.zj@linux.alibaba.com>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/5a22439de84ff188ef76674798052448eb03a3e1.1700740693.git.robin.murphy@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm-cmn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/perf/arm-cmn.c b/drivers/perf/arm-cmn.c
index 847b0dc41293..c584165b13ba 100644
--- a/drivers/perf/arm-cmn.c
+++ b/drivers/perf/arm-cmn.c
@@ -811,7 +811,7 @@ static umode_t arm_cmn_event_attr_is_visible(struct kobject *kobj,
 #define CMN_EVENT_HNF_OCC(_model, _name, _event)			\
 	CMN_EVENT_HN_OCC(_model, hnf_##_name, CMN_TYPE_HNF, _event)
 #define CMN_EVENT_HNF_CLS(_model, _name, _event)			\
-	CMN_EVENT_HN_CLS(_model, hnf_##_name, CMN_TYPE_HNS, _event)
+	CMN_EVENT_HN_CLS(_model, hnf_##_name, CMN_TYPE_HNF, _event)
 #define CMN_EVENT_HNF_SNT(_model, _name, _event)			\
 	CMN_EVENT_HN_SNT(_model, hnf_##_name, CMN_TYPE_HNF, _event)
 
-- 
2.43.0



