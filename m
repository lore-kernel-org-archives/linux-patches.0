Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378E3370D47;
	Sat, 12 Sep 2026 10:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208338; cv=none; b=H6e16qotFrzYo/GR4zkS6YDdK872mMPFm4ovnBY0Cn2F3Ljmm7jixdxbur5xs5s/vFJ48JFCmEtEf/HNLuvuD4nxQf4jWFkrTziMV0nr620MyqPIT1IUW0WHwYs0ibzBrsKtEIF81jUPHInlDcWbhaaQls9ipR8kEEY+2y2iioE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208338; c=relaxed/simple;
	bh=LHpGtaHxMF+rCQ1vsf2wm60Fs/Y6T3JG4cm3e1pUaYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N1JJnD7i7McKhmVk0vp7lPCsOKaDd5f4e02/n1bAmNbzLqP1zaeNTAkglboTsKJD3pJTHctQ80j7YbO3/5UR/ezPtaTmo3tfHhRf50pplDmfI/h7Ud9fLSXx55OGSeL41+jjmTGbZRVRbzeewMpFG3Qo6BIHqCboPJtfdFYcOk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aEXesIwH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aEXesIwH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02FA21F00893;
	Sat, 12 Sep 2026 10:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208333;
	bh=kuzSN2LSNc35gKucZ5zMmzP7OdlAPWWkArYvwV+a4ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aEXesIwHkFuf4oGfVm3QYr5rRR0JzAll2Z8I9Uukpn+u8B/CEr+DXbRuppCOoC5zk
	 68VTjI2X1ikyvB115FlCRm6rKvyDWQPsCCbqIa7Yil+rUXFnlLgBS5rV+h/5/tlxwI
	 e0uXSLRv7/5b9lz5j6PggI1fClZxYV9RjnM9Z4mU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Andrew Davis <afd@ti.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0594/1518] remoteproc: core: Drop redundant initialization of ret in rproc_shutdown()
Date: Sat, 12 Sep 2026 08:46:03 +0200
Message-ID: <20260912065636.863275160@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 4531b6bad5af669511c348ad5225d9f697af221b ]

The variable ret is immediately assigned the return value of
mutex_lock_interruptible(), making its prior initialization to zero
unnecessary. Remove the redundant assignment

No functional changes.

Signed-off-by: Peng Fan <peng.fan@nxp.com>
Acked-by: Andrew Davis <afd@ti.com>
Link: https://lore.kernel.org/r/20251016-rproc-cleanup-v3-v3-1-774083716e8a@nxp.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Stable-dep-of: 2482ca875ef5 ("remoteproc: Allow shutdown of crashed processors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/remoteproc_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 8256721005289..29bbaa349e340 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -1989,7 +1989,7 @@ EXPORT_SYMBOL(rproc_boot);
 int rproc_shutdown(struct rproc *rproc)
 {
 	struct device *dev = &rproc->dev;
-	int ret = 0;
+	int ret;
 
 	ret = mutex_lock_interruptible(&rproc->lock);
 	if (ret) {
-- 
2.53.0



