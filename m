Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A75252917;
	Wed, 25 Feb 2026 01:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983966; cv=none; b=swZLDupBwsl7jYdvsJ8ih7KDEihbtqSiR9x3C+zA8FuRcKUntZn4MSSfN6NFsXAHDhYj++snSbnESZHVh51eT9ux4bJ/qrtnnNKgW3YeEOxCBTSG4YUPmiVh/47+Pzvx8JuHCQ8T+KJqYlMLN0bMHnWLLLu3mtW8gv8h8YikuKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983966; c=relaxed/simple;
	bh=IS7wjhEMOiWl4I7D72VxDSOwOji2CjSDLcHoM41SAF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c3uG9gx28RmsYGXUjxDaW6WzU1Rhx3jtDipjaE8KXNrZAVccX++9j/XQACOEX42jI3XdKvr+RyA1cxiFltDFD+OIMHP1icB66/0oOchBCGsU0dxk0gvN+5R7HYfd9qhBssJTf+4xGLSG/hFNyRR68BIPpdz8o8kEGv0RQBjWFPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k7p4DrK4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k7p4DrK4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8965DC116D0;
	Wed, 25 Feb 2026 01:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983966;
	bh=IS7wjhEMOiWl4I7D72VxDSOwOji2CjSDLcHoM41SAF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k7p4DrK4Jouw/fsX2cBWy1bEKBo2C6O/Lz1l7wmJcXMPFfJe16uoVLZiMzgecbbtv
	 hIG82B689wS4qV8p+W071UyshCQMupsQ6iedjy9HTGfDF6cVDC7eLydYEkKIDoQQeF
	 0hxuiUvHthDluXqt7zsAcxpZ6YS0orclOEYsA4lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gwendal Grignou <gwendal@google.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 222/641] platform/chrome: cros_ec_lightbar: Fix response size initialization
Date: Tue, 24 Feb 2026 17:19:08 -0800
Message-ID: <20260225012354.296768161@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 87634f6921b78..6b028615ee245 100644
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



