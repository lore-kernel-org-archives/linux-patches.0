Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24E0189BB0;
	Sun,  7 Sep 2025 20:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276488; cv=none; b=FG43HF+sl3JHWe/opoLYC45ynHJZqRXUnad2jwS7whizeP302g+r6In1wxLe4ONhGH0cTEBY4H4b33mLxWM8GWIVDcJnvJE0wRc69WyE61rqye+F+vio5U61MoFnd57W4Fy/E2SQDJilgo0Uhy7w4KbGZ59oxZQFMDnuc5IqFL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276488; c=relaxed/simple;
	bh=WrMU+g0Cmlu7qYMA9qa1KP4iFc4a8TmHvDYjKQ7buY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bDm+Zn+SsP3svAIKb0qaGkURV01LE//miHOYuJxIomMOV1zIprFcmLsHm3AwVM05LSnkKzXKYID01QJ7hT856PnEkOP5e7MjhwvDCOfI7Dt+syMqz3qaXwansQDmK0dVdUawNxlyb6uSlaqn807K47teN/0JFXDK9dQ1zrmVFL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ouWhGpzc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ouWhGpzc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D05C4CEF0;
	Sun,  7 Sep 2025 20:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276487;
	bh=WrMU+g0Cmlu7qYMA9qa1KP4iFc4a8TmHvDYjKQ7buY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ouWhGpzchlYKp+SbiAlKLdsEVgOM+Q9RofowlDZ0mksbs6reFXtKSYPSmIfLfzQ5J
	 PfTVJC1cdsBe+r05Tq8cEtCem8jidX59+Ceg6O2XmcnEhNSp/nKO5TIixMuFGoR/bE
	 Ecu87GEXLMQCXGtEbF82Unz8rduyN76Srn7ynS1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sungbae Yoo <sungbaey@nvidia.com>,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Jens Wiklander <jens.wiklander@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 016/121] tee: optee: ffa: fix a typo of "optee_ffa_api_is_compatible"
Date: Sun,  7 Sep 2025 21:57:32 +0200
Message-ID: <20250907195610.230653075@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sungbae Yoo <sungbaey@nvidia.com>

[ Upstream commit 75dbd4304afe574fcfc4118a5b78776a9f48fdc4 ]

Fixes optee_ffa_api_is_compatbile() to optee_ffa_api_is_compatible()
because compatbile is a typo of compatible.

Fixes: 4615e5a34b95 ("optee: add FF-A support")
Signed-off-by: Sungbae Yoo <sungbaey@nvidia.com>
Reviewed-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tee/optee/ffa_abi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tee/optee/ffa_abi.c b/drivers/tee/optee/ffa_abi.c
index b8ba360e863ed..927c3d7947f9c 100644
--- a/drivers/tee/optee/ffa_abi.c
+++ b/drivers/tee/optee/ffa_abi.c
@@ -653,7 +653,7 @@ static int optee_ffa_do_call_with_arg(struct tee_context *ctx,
  * with a matching configuration.
  */
 
-static bool optee_ffa_api_is_compatbile(struct ffa_device *ffa_dev,
+static bool optee_ffa_api_is_compatible(struct ffa_device *ffa_dev,
 					const struct ffa_ops *ops)
 {
 	const struct ffa_msg_ops *msg_ops = ops->msg_ops;
@@ -804,7 +804,7 @@ static int optee_ffa_probe(struct ffa_device *ffa_dev)
 
 	ffa_ops = ffa_dev->ops;
 
-	if (!optee_ffa_api_is_compatbile(ffa_dev, ffa_ops))
+	if (!optee_ffa_api_is_compatible(ffa_dev, ffa_ops))
 		return -EINVAL;
 
 	if (!optee_ffa_exchange_caps(ffa_dev, ffa_ops, &sec_caps,
-- 
2.50.1



