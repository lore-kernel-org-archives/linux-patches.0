Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B5318DB2A;
	Wed, 25 Feb 2026 01:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983137; cv=none; b=Da/WXscR3k2L1P95Ap9z8bucc0207KOZ55Gc2Pl69PVTHrGtbeYRVVaeF6apP8UpT9TRWDVqnV9aOL1ICdUARA0Noi66a7lLd453wiVkkpuNUZR/HrfTrMBJ4iWPYOGNVK5i5iOAZ3ugJE1ta1VJK+ooj76ZX1s7+/xFi9goqNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983137; c=relaxed/simple;
	bh=1cSqlXFF7WNR7GYjh1WcUJvVRg//dF8YAjmKD67qnXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tT/bNG+0U3ekqCP/R8QcHY34288HYT9GUdITbYouU4THnPKk0rn+ibqbeDFmvdLyWzsR3HVyR0AO9JvP2urcnJyzEt5nT5K2IDXj0/yF+74WYLseOeUlFODYMLnJ5JOhJfRnFylSF6RSnRPglhcMeWWvkqXo5Qwfu7tbniO8nBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wUHLAya2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wUHLAya2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F12C116D0;
	Wed, 25 Feb 2026 01:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983137;
	bh=1cSqlXFF7WNR7GYjh1WcUJvVRg//dF8YAjmKD67qnXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wUHLAya2LA+4XT/MLnYtgfKF1vfpBiLRw3xs/e2wNnKd3zHhdwpVIm/3azgNRIOQ9
	 2Zvhq1YIDAzKqWD47VFbEt/9RC8H0+R8ZZEpIgg7lGSwEIlnA3ovL/bNNdSo4my3Mk
	 /hMNLNo7IrrFWTB28rKchpXDnax0g2AjxbPyS3U8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gwendal Grignou <gwendal@google.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 292/781] platform/chrome: cros_ec_lightbar: Fix response size initialization
Date: Tue, 24 Feb 2026 17:16:41 -0800
Message-ID: <20260225012406.871079407@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 8352e97327911..3702baff5d4f1 100644
--- a/drivers/platform/chrome/cros_ec_lightbar.c
+++ b/drivers/platform/chrome/cros_ec_lightbar.c
@@ -126,7 +126,7 @@ static int get_lightbar_version(struct cros_ec_dev *ec,
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



