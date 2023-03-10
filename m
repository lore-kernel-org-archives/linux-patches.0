Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB7D848D
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:29:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57115C433D2;
	Fri, 10 Mar 2023 14:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458586;
	bh=orieMbNCaWkVcJPqUAvB+E4NkQt97v0A3lmv1koK+hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aYk0UNKVz1ESMfruAEO86bJ8rfh3kJ4BpQVpvKRAXdZCezaM/lhsjK9kMEOYOv77G
	 vUsyVcs0YiZFsIRm9dNKXMLflKq3Lo7CXb2v7ZtDLgUgSTbtrYYMFK7u/gcMMBL068
	 DzGXO/txJfgnPiZgAOI2GtsDpSp7a6DDgYsql97s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 076/357] OPP: fix error checking in opp_migrate_dentry()
Date: Fri, 10 Mar 2023 14:36:05 +0100
Message-Id: <20230310133737.344336608@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Qi Zheng <zhengqi.arch@bytedance.com>

[ Upstream commit eca4c0eea53432ec4b711b2a8ad282cbad231b4f ]

Since commit ff9fb72bc077 ("debugfs: return error values,
not NULL") changed return value of debugfs_rename() in
error cases from %NULL to %ERR_PTR(-ERROR), we should
also check error values instead of NULL.

Fixes: ff9fb72bc077 ("debugfs: return error values, not NULL")
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/opp/debugfs.c b/drivers/opp/debugfs.c
index 609665e339b6b..c7647410316e6 100644
--- a/drivers/opp/debugfs.c
+++ b/drivers/opp/debugfs.c
@@ -162,7 +162,7 @@ static void opp_migrate_dentry(struct opp_device *opp_dev,
 
 	dentry = debugfs_rename(rootdir, opp_dev->dentry, rootdir,
 				opp_table->dentry_name);
-	if (!dentry) {
+	if (IS_ERR(dentry)) {
 		dev_err(dev, "%s: Failed to rename link from: %s to %s\n",
 			__func__, dev_name(opp_dev->dev), dev_name(dev));
 		return;
-- 
2.39.2



