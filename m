Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4095B33A702
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302110; cv=none; b=OhB7nHmjMGQnIGdMZxnkEPXb5iTfxs11agsyx82bCCBz2I/ZbE35nbfwU7Kdo3tgIq8qGBJsx3LhDX3sLKEn8zoj0/SKI7djCnL+cK4rz7nUH028nSRnm342Smm++6ta8H4Erbi2ArWpZvIiGJVecKpoqZe2AupZRZ+sfxS5H8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302110; c=relaxed/simple;
	bh=H4UCCgJZctGSipSCWcDb993tuy/UQLO0w7akcdlPPTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SUPhchKo2kZKgI+tNj9lL0+hIjPuE4B5truttWzc+8Gi79MJ3a+LqlxcDHw9VRqIZU1Nck6SSsfEmutdPPmCxFoxy6CEvLTUg7bzixC1Rh75/RA5kyS3ghQGdVliVHxvfY6uw/aPK3a0gQXm2eAJMpiq9GRe/v8lSVo4wmwbyto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YSiVTwyQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YSiVTwyQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6103C19423;
	Sat, 28 Feb 2026 18:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302110;
	bh=H4UCCgJZctGSipSCWcDb993tuy/UQLO0w7akcdlPPTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YSiVTwyQyNFfVv2CsSWxtIHpinZexz/pR2l8dhZvQCNSGgW92WTcS/+gTTYYtGBWc
	 holflsdWvix7hXBuuINpi0/+5CxJfM/YNWr0fFyNlv8wWRrPISYlLTXf+fjpajs1bl
	 0pXF7wVq1ZJL+6V2fyQ7cPTzovHCbFQlxQrFkSeIHGWwakhfGhJYsyLobwMyq76juD
	 JLBpCcijnhQyLvHpewnlEanYPkwxZXSyBMJDcW43SnHKj77s/bzHlRFmRL6VN6g1bu
	 5JmGJGBrDTHXdHtUxgI6BpuKleG9tyf9IfNNsTmUTwiGLquDG1xAsuMFcNqNPZS1A8
	 9PzVWvlO+SBhA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Tzung-Bi Shih <tzungbi@kernel.org>,
	Gwendal Grignou <gwendal@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 098/283] platform/chrome: cros_ec_lightbar: Fix response size initialization
Date: Sat, 28 Feb 2026 13:04:00 -0500
Message-ID: <20260228180709.1583486-98-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 376425bbd8ffb..0f185b4b6f655 100644
--- a/drivers/platform/chrome/cros_ec_lightbar.c
+++ b/drivers/platform/chrome/cros_ec_lightbar.c
@@ -118,7 +118,7 @@ static int get_lightbar_version(struct cros_ec_dev *ec,
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

