Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F5836C9E9
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302359; cv=none; b=t3xCuxl6VMaPRbml218DHJCxXoot9U7FZ/WG13tPhzq7/0OXZxeVY8AuyuhUpsctGR50T6UdMRxmpmFwWBuFAPwdRs5nrBTjHYRcEDxu6tz1A8pCk71XvxcuF3ZHkRAtOWfiefxPNMwnMGUgOZ7L0IdwQY9AC0gC9FoZEPnLRSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302359; c=relaxed/simple;
	bh=1QL6Pcu6xYCUr82c1I+Edg0WJY/+5NxRguUtZhPT5zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QZ85xePbE/mYu0IZQ8r4Exac0mxCAz920LbP6YhnPMT2tfSmk/yDsVpnlDxzJ+dTzcS+Kv/9FUDf4FES17ljG8f6+T32IFnvRcQnjGG2A3kVTFOYifbOufC2hefAyNGHpJdpZDdHPnn8wjs3Noj5xvD5bF6qMqWaMzCBv0umq3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fAKfI/xe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fAKfI/xe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9649AC19424;
	Sat, 28 Feb 2026 18:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302359;
	bh=1QL6Pcu6xYCUr82c1I+Edg0WJY/+5NxRguUtZhPT5zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fAKfI/xebn0YZ4LFIf/X9cIPGqsCDAbH4wtOoCfTmTjrKMbs4Sfctp45KXf6aJhke
	 nCzb5Ok0LRnJryKhm0Mc92Kf337xaZxp94HdFeRWDAbkcG/lY1L51eZVrfEu7AA0q3
	 VWjcljpi+jVJBDzQUNbtNjWlA4aPkwgZQ72iqsuWsvxO1Gr5839bbZ3nGGyaLxZZyV
	 ZJSOI0rE/3wHFyYC032e5WQ4YmpTuH/gZatu0xo23rHvcyxwCDoj6pvg39bFwbYhfR
	 eehi9Wk+C40PkLk9QRke/gWDRHqe8/0vMQ4gDXl45eA7IiQBr3Pu4+Koiv3IBowJgM
	 TG3j1G2wlHn3g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Tzung-Bi Shih <tzungbi@kernel.org>,
	Gwendal Grignou <gwendal@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 085/232] platform/chrome: cros_ec_lightbar: Fix response size initialization
Date: Sat, 28 Feb 2026 13:08:58 -0500
Message-ID: <20260228181127.1592657-85-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Tzung-Bi Shih <tzungbi@kernel.org>

[ Upstream commit ec0dd36dbf8b0b209e63d0cd795451fa2203c736 ]

Commit 1e7913ff5f9f ("platform/chrome: cros_ec_lightbar: Reduce
ligthbar get version command") meant to set smaller values for both
request and response sizes.

However, it incorrectly assigned the response size to the `result` field
instead of `insize`.  Fix it.

Reported-by: Gwendal Grignou <gwendal@google.com>
Closes: https://lore.kernel.org/chrome-platform/CAMHSBOVrrYaB=1nEqZk09VkczCrj=6B-P8Fe29TpPdSDgT2CCQ@mail.gmail.com
Fixes: 1e7913ff5f9f ("platform/chrome: cros_ec_lightbar: Reduce ligthbar get version command")
Link: https://lore.kernel.org/r/20260130040335.361997-1-tzungbi@kernel.org
Reviewed-by: Gwendal Grignou <gwendal@google.com>
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_lightbar.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/chrome/cros_ec_lightbar.c b/drivers/platform/chrome/cros_ec_lightbar.c
index 469dfc7a4a030..e2365788d4590 100644
--- a/drivers/platform/chrome/cros_ec_lightbar.c
+++ b/drivers/platform/chrome/cros_ec_lightbar.c
@@ -117,7 +117,7 @@ static int get_lightbar_version(struct cros_ec_dev *ec,
 	param = (struct ec_params_lightbar *)msg->data;
 	param->cmd = LIGHTBAR_CMD_VERSION;
 	msg->outsize = sizeof(param->cmd);
-	msg->result = sizeof(resp->version);
+	msg->insize = sizeof(resp->version);
 	ret = cros_ec_cmd_xfer_status(ec->ec_dev, msg);
 	if (ret < 0 && ret != -EINVAL) {
 		ret = 0;
-- 
2.51.0

