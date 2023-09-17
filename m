Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3163D7469
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:22:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AF4DC433CB;
	Sun, 17 Sep 2023 20:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982178;
	bh=dryLdZsjr9zvMo+KQpWWFnWAx8sIsoR9f4yWvonCFaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DvHs4hC7LvknVsZxDbLmABFM+1DDY8Fvos6ZMk//YCQE2P15zVjyWD/1M6E1soFN5
	 76APo0yA/tIBd6inHm+NsrnYuBrTHtNmy8Ew1jIDFWuDn95h1NdIg9W1QIebr8qX9J
	 06gDgv0zcieIkNXGABpr+FyFDmXP6hZNnN5ER32s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Shurong <zhang_shurong@foxmail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 174/511] firmware: meson_sm: fix to avoid potential NULL pointer dereference
Date: Sun, 17 Sep 2023 21:10:01 +0200
Message-ID: <20230917191118.035815382@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Shurong <zhang_shurong@foxmail.com>

[ Upstream commit f2ed165619c16577c02b703a114a1f6b52026df4 ]

of_match_device() may fail and returns a NULL pointer.

Fix this by checking the return value of of_match_device.

Fixes: 8cde3c2153e8 ("firmware: meson_sm: Rework driver as a proper platform driver")
Signed-off-by: Zhang Shurong <zhang_shurong@foxmail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/tencent_AA08AAA6C4F34D53ADCE962E188A879B8206@qq.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/meson/meson_sm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/firmware/meson/meson_sm.c b/drivers/firmware/meson/meson_sm.c
index 77aa5c6398aa6..d081a6312627b 100644
--- a/drivers/firmware/meson/meson_sm.c
+++ b/drivers/firmware/meson/meson_sm.c
@@ -292,6 +292,8 @@ static int __init meson_sm_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	chip = of_match_device(meson_sm_ids, dev)->data;
+	if (!chip)
+		return -EINVAL;
 
 	if (chip->cmd_shmem_in_base) {
 		fw->sm_shmem_in_base = meson_sm_map_shmem(chip->cmd_shmem_in_base,
-- 
2.40.1



