Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9042B36F421;
	Wed, 20 May 2026 17:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298100; cv=none; b=c50GcpUREK2sx8MVgDo+Sju9BKldzaH7PfXQKjRQ7YStMDiuAVxoek4j3yEsBy8SeD2gGOWjmFbDn7MiEw+ofrKSO9cRFO/o/PCTz5e3sOeZIHqh4J2VNjZ+liMktruhGDEI/rEjSM72/LmPJNf4o5JPRpB5mreEhQzsi7V/6MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298100; c=relaxed/simple;
	bh=6bORIgttPQM6s/R4zy93f3dqKDO5LMH+MjS0WCKEyrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=irpUXCgWOafzKpvrIy4jamjtpQlxMxLntQbC9g6nwLJj9ABx9UgP1cuajnMQLd7hyN7lv0NSVujnFYRgFsdHU3a5IFCB87humeUDVz9qpCkmjSnMdmqmaekKvgka844Xj2+tjEnT6T70yd9G9mpCuAV/oHKrQ3zvSGkBoR76MGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y9rQHbDu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y9rQHbDu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDC361F00893;
	Wed, 20 May 2026 17:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298099;
	bh=Vki3s5WV08TAEhGO3tXPCTfRgHM/7I9CzufmupTKxzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y9rQHbDupyr8MyQY/xGxiPy5C06DtziDW//CxZevPdMQFz/6jXPeM2zzkn0Kcm2qV
	 JwFZ1W5uY4DtY/lZdIuXB31lqogdqPOLTGPIza6vw+eXqRbZFILmKDnNeB0oPjUSWT
	 MlPOwYgtbE0qZvuvu8GNWlQ/gMm/qN2pkedWxfEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 282/957] PM: domains: De-constify fields in struct dev_pm_domain_attach_data
Date: Wed, 20 May 2026 18:12:45 +0200
Message-ID: <20260520162140.656382280@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f67a2cb7d7814..5ed1753a7cb47 100644
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



