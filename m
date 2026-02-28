Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BEA035AC3F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302701; cv=none; b=Yxa/5lxwx0MPG+PKaik2a62d9bnk5RQhTEAprDRJgtU1vKoJ4kBLLNzaB6lY3t1VDE6iFEj28avIupX0ObPO3uEphXTOfGGA7BFswvgdhDMkAdRZjxWBitd17E5OyJdvPF3GnRcJ6mgB33lh8uZDquqihmJ7aVIIDSHFiLxwETk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302701; c=relaxed/simple;
	bh=cqYE1KI4rxz1FuX3xq9VTD92hqkNKtLjFtOVn0Gy8GM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N77g4qhzZ0SFjXwU7jK0Aj50L8/wkPLY8fUdnDzYo2vEArHoKxt1vwCP7L+mqouYxyj2pndddBENypN0qf596MGt2mtk+8X/MRUBH4Y5k44BzLF35WmPfXhk7iEJawqGCjVH7XBmg9JjKW4Fgc/nNRJSQnQ1DiO0iYVa5SJco4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JPg2ODA9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JPg2ODA9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F20C19424;
	Sat, 28 Feb 2026 18:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302701;
	bh=cqYE1KI4rxz1FuX3xq9VTD92hqkNKtLjFtOVn0Gy8GM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JPg2ODA9dKTyWmzxO6Q4Yr7PaLOfUjYITVbmeERtlUvHIm7MhcUoWX5ywIV4WwaLT
	 s/XTS1Q/VLpX5CVnOJmLW9pEFxccg2Rb3DjmClNIWPBPWfOTTI0rRi18zT4QBhub9J
	 OzxcLKep9muGiaXCnwWEFzpudiGKqy8dGdVgGnFbeG3no2laiLEERdrTNsfwl1/mmg
	 NVPYLq2vaQWyIsP2qozZ6ngOwrHfznprUnJzGEB/oC1ZvPEpm78KjTWM6ol9AwZr8i
	 GE+9/7xLxEckfVxyUiJJcAjyfB+KyYmehaKfFLv2haXnLVasF9NBvVlc5AXNil27TZ
	 z7oU82wxO4PKA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Tzung-Bi Shih <tzungbi@kernel.org>,
	Gwendal Grignou <gwendal@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 057/147] platform/chrome: cros_ec_lightbar: Fix response size initialization
Date: Sat, 28 Feb 2026 13:16:05 -0500
Message-ID: <20260228181736.1605592-57-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index de8dfb12e4863..235326f217a48 100644
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

