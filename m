Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935E03451A7
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301760; cv=none; b=F4HwxTH/bqnOST1tDWbjvvzDyh+PMt2X/OvEVbcHfBL6l+VvH3pYCzx+5EZG1yV7n04Bl5/vdt9kglfJkLMw5DJGWzrX3an0Vase5/AhjqNx7kb9JJz5YpTJh3QGsc5BUOPlzJkXFU463v/3n5EVSrqacNBqQNe9mwUu/sZAHSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301760; c=relaxed/simple;
	bh=B3IuouuHtcupOFY9O0phpCGQkEjBFSJcf1Ue/Xe64Tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PDGSTEEhsUYe2HS7c0c1YM7RhlG0FbXs6ZR8/X8B38vKMBhgOSFbSwBNaPLeGRkQgfD2hOkuugsRcovwYAlIdtkuiUSNFUnD/ssBBENxiGIWbEyP4uelYMiXy2w3GA9aURSP6XhwGZ0Tt/VW6rTnYhfLLGopoNGpqX93ym0hxW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pPA77Xnq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pPA77Xnq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04EA8C116D0;
	Sat, 28 Feb 2026 18:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301760;
	bh=B3IuouuHtcupOFY9O0phpCGQkEjBFSJcf1Ue/Xe64Tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pPA77XnqLH752ttOvEuxhHAFWbBN5CktYL+AAZy83aBi7NBkb0MEHjFgjTuwMLvQr
	 ZczjmW3+/gws9hC4ZkoWHZWVGliRVrZEpnWaMGmI6ImXbQ3jCJhADils4RMoiTkHTC
	 WmfEsPSIafMZ6k/Y2MW7mIwvOeDE19ebXyN3Cr7PluIjeWxak4fSjBtVxong6ui7TW
	 mz3IIw38aJetX1pb34pfif/bf2MPPnGscB5TcVTRTvFGd2GWEjWqfznNrQ/nQexMUm
	 cRvCN3dw+j0AVhnmrYVAoXp0eJTydEAId7L8Vx7WT/XwnTR/1yAJKnWayTc055fdRf
	 cR6jZ3iKUADwA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Tzung-Bi Shih <tzungbi@kernel.org>,
	Gwendal Grignou <gwendal@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 165/385] platform/chrome: cros_ec_lightbar: Fix response size initialization
Date: Sat, 28 Feb 2026 12:56:27 -0500
Message-ID: <20260228180011.1568201-165-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index 1e69f61115a4d..de64292faa24e 100644
--- a/drivers/platform/chrome/cros_ec_lightbar.c
+++ b/drivers/platform/chrome/cros_ec_lightbar.c
@@ -119,7 +119,7 @@ static int get_lightbar_version(struct cros_ec_dev *ec,
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

