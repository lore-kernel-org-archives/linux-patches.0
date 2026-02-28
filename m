Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76DA39B95A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302553; cv=none; b=aCVCtgJXM9IgttQCfKSkc3G4YjmIsb3R7sS0r05ds8wP7LNbk1Zf6qBm5KnPCZWr0hF6d08aBxVCYdsiX4ps9T0Z3rryMzRWKhSQQKwZd47GDx8Zpul+3UhRRzywbBYh76kAA8DuI2JBJWtR6ku6PaejbcknRHUwMURtK2yJ3tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302553; c=relaxed/simple;
	bh=1QL6Pcu6xYCUr82c1I+Edg0WJY/+5NxRguUtZhPT5zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XsgFeVBt5hjXxqs4kGGcikV3peZUoVf4fgplXbInsszWufImN+iOWl7mhB979nedpxLcJSGXdi72g5nuS95xw+Y4HyILamAtyyoSlrfYu6UnWgLdwJHW5ds96FyS+ueDGeK+TFIr2tB7LnqAJG77dqJyNX9tM001OhtHf77uZqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n1+yoi7w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n1+yoi7w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19BCCC2BC87;
	Sat, 28 Feb 2026 18:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302553;
	bh=1QL6Pcu6xYCUr82c1I+Edg0WJY/+5NxRguUtZhPT5zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n1+yoi7wForPbui+Hp0vnUhtQd0r1cCB+eAoK5yisGRqPiRw0I8T4g7CbL2Abqm7g
	 ZR7yaEmwWY399i0GwNOVxCyrZu80juGMK61aSElFowZ3hbUeEzGAiJodfVV/JJS2Sd
	 2fLzuxvN72ftr/KOCY+DQz+KAig8dRVuslwNxHcXOcjvbk9FxSKhG4FscEbETIx90M
	 xkL45mdcCQF6QwOqvP9wEvk6wS16vnGHOgZIAHz1wvAzNuA43SnsBHdbEBlyfwLEwo
	 xDmFeSllym50wcZ7XfjrnTkM5edKIcD9MLZEbASDi26V1DMaYdC/0kUa8vR4lJv9g4
	 zvTA1oPNm423w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Tzung-Bi Shih <tzungbi@kernel.org>,
	Gwendal Grignou <gwendal@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 057/164] platform/chrome: cros_ec_lightbar: Fix response size initialization
Date: Sat, 28 Feb 2026 13:13:16 -0500
Message-ID: <20260228181505.1600663-57-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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

