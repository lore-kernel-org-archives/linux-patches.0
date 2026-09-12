Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2F9331203;
	Sat, 12 Sep 2026 16:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230125; cv=none; b=b0EIzyl4ootsxGdaXpR5BmormMsBTBcvm+erx0woP5yyaevPFpz1n9AzMCpeduiJcyhG580YT4RE0c6Spf5U+Iru3bMT348mSD7F4DvfnMuVYLdr3VbVGtiP26WEtioL0UiYuGqOXK1qjr6LMEUFDX2Q4Pquun/Sa+ABykZ+TC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230125; c=relaxed/simple;
	bh=nSQ9HK8Tf0P5idTlQ78xH4f9M48ZzSE2ky2e27gD6eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kFmKVm9XPVISzf3pgIdIfi0Vi2HuLJM66IJM25ZfUOHtPKt/pDoUisG9eYq6PkWcbXfcNZAEtv0U5YY9cUQdDkyZY4JeqMhzWTQI/Zk2sd8szA8JPMUAKhU86fG2hxyZtWclS0vu+/0RvLqs4AUjxGHQn8WMKlhdKXw0jJ6sKaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kcj7/EWP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kcj7/EWP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74E151F00893;
	Sat, 12 Sep 2026 16:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230124;
	bh=esP+MQSFv2OsrS+e56SIcXxRcHWkhoieqWL90xbscso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kcj7/EWP4MJE/SsYHIyfefLX2UOJ3/dvX/J+bWydJ1foBRzOc5E+Rit7Emc2j3O93
	 jVSZW/lCUXpjV5OD/6CFgGfALq553iew35mLG3WzeHF3WqvmXjrWwp0sXZbVZdrhyV
	 PPwuOecAl+uY9YYjIC5M9oGEnZ2vqUS8bYJe5r04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Andrew Davis <afd@ti.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0729/1191] remoteproc: core: Drop redundant initialization of ret in rproc_shutdown()
Date: Sat, 12 Sep 2026 08:57:37 +0200
Message-ID: <20260912065604.653702618@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 99682903f9379..277637a57c766 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -1987,7 +1987,7 @@ EXPORT_SYMBOL(rproc_boot);
 int rproc_shutdown(struct rproc *rproc)
 {
 	struct device *dev = &rproc->dev;
-	int ret = 0;
+	int ret;
 
 	ret = mutex_lock_interruptible(&rproc->lock);
 	if (ret) {
-- 
2.53.0



