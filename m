Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2093B372B31;
	Wed, 20 May 2026 16:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295302; cv=none; b=JKKOcWiS/T3EvCxIKloUftRviEjT+NJMMKbrah/iIDIkhj3X5EtOUzr+BKutUE4pQiRYjIn2rL0BtSPjP6GMpPCFigT7gtUibGVraGTT3VejsPV6asndoms2zPlGC8gTH8QZUKbR3Fm8YrL9sNt2L0YDdoCIi5ZqP3cAnn1DswY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295302; c=relaxed/simple;
	bh=YxEOQOa4RXeY+T+j6TnTqE9DcfazC/DXAleTkog/Zyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NJr9FGYYDNq4XOuj9/j9yUxRkUeaElVGunQViGr+vTMT5ynx02siUHBntVdC22JChK9RZGB0xnjwZWI1IarBlwFuLdQO5ZfJJmmasYN8TqsPL2OdUyvSYGZBTiJZptHv830FzIRayjFcTeMda1xpCcpr8ZMq1aOnONOCYfQg3E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DC1CcrDV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DC1CcrDV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856CB1F000E9;
	Wed, 20 May 2026 16:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295301;
	bh=SiFLcBE92zEM0RKj3TSDU/N/MulLnyBnRhY3R0Hbp+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DC1CcrDVyFQCI/SzTX6iwB3QYR+lv4mSh8k5fVqr2yCpzOgfBOYiILPiFanBu4Tyx
	 5h3cQQBk2J6fIn8QtSmoUiPfDfXAg7HSuOB71BIFz8JN0NArw9qYIK5F1A31IU4HTt
	 1gkFLlMPKRVceKBY8038xMFAym4XawXrJaw9lNNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0367/1146] PM: domains: De-constify fields in struct dev_pm_domain_attach_data
Date: Wed, 20 May 2026 18:10:17 +0200
Message-ID: <20260520162156.506665171@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 1877d3f258cbb57d64e275754fb9b18b089ce72d ]

It doesn't really make sense to keep u32 fields to be marked as const.
Having the const fields prevents their modification in the driver. Instead
the whole struct can be defined as const, if it is constant.

Fixes: 161e16a5e50a ("PM: domains: Add helper functions to attach/detach multiple PM domains")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pm_domain.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/pm_domain.h b/include/linux/pm_domain.h
index 93ba0143ca476..38d1814ab8a5e 100644
--- a/include/linux/pm_domain.h
+++ b/include/linux/pm_domain.h
@@ -49,8 +49,8 @@
 
 struct dev_pm_domain_attach_data {
 	const char * const *pd_names;
-	const u32 num_pd_names;
-	const u32 pd_flags;
+	u32 num_pd_names;
+	u32 pd_flags;
 };
 
 struct dev_pm_domain_list {
-- 
2.53.0



