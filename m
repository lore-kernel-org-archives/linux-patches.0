Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86ABB1AC8AE;
	Thu, 15 Aug 2024 14:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731118; cv=none; b=dHma4j0P0DeVWh/B2oQpdK8r5rbv3teFBuPI02ZbEpeiXmSGDl0sKdkCMensGVstPIupMxxsOSjiZkK1fseVPX2IeA0fcvzmAEv2SUVhe2a3mYALSW+XJiU5M1zX9KlG6ixlvFE2yxylsmWOyWT3pKvnuXHpJv7tYYaGNnLFWlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731118; c=relaxed/simple;
	bh=LM1w1MJ8y3MarX2uPv2kmqwwQV8m5CZTAaNlZt4S67M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jBOfB2usP2+XKjg1/eydfB4i+S7HRIs5DvcaDFCw2c6Prof4lJP22+90iCWuzOiJJ3rQy9j32pWKLhGIi79WsW7d76R6lhSalFi55pwn7hbtL7SoAjqupM2AM9OVoAjZmc5ShSW4vJzKq11EhPJ1KvfKrbXiQ1tUUNcM3R3cjsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vqGAYWUo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vqGAYWUo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E91A2C32786;
	Thu, 15 Aug 2024 14:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731118;
	bh=LM1w1MJ8y3MarX2uPv2kmqwwQV8m5CZTAaNlZt4S67M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vqGAYWUor7F22WLxdyZ1NPHX53JvaKxHCkn4B9GbzUDGDdkPqzbFCbpzN7H/7hRPu
	 /61e7rpCTDn9t65al9CKjFUMbMnkdcylER7BCrl3+XtSsLxzj/geUArcU3/b7x6Usu
	 fGmqxp+zEla7Lx/3w2mE4fq2ytXLo0m1d4hz5fik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <groeck@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 005/259] platform/chrome: cros_ec_debugfs: fix wrong EC message version
Date: Thu, 15 Aug 2024 15:22:18 +0200
Message-ID: <20240815131902.997127844@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tzung-Bi Shih <tzungbi@kernel.org>

[ Upstream commit c2a28647bbb4e0894e8824362410f72b06ac57a4 ]

ec_read_version_supported() uses ec_params_get_cmd_versions_v1 but it
wrongly uses message version 0.

Fix it.

Fixes: e86264595225 ("mfd: cros_ec: add debugfs, console log file")
Reviewed-by: Guenter Roeck <groeck@chromium.org>
Link: https://lore.kernel.org/r/20240611113110.16955-1-tzungbi@kernel.org
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/chrome/cros_ec_debugfs.c b/drivers/platform/chrome/cros_ec_debugfs.c
index c4b57e1df192a..704086ca1dd20 100644
--- a/drivers/platform/chrome/cros_ec_debugfs.c
+++ b/drivers/platform/chrome/cros_ec_debugfs.c
@@ -308,6 +308,7 @@ static int ec_read_version_supported(struct cros_ec_dev *ec)
 	if (!msg)
 		return 0;
 
+	msg->version = 1;
 	msg->command = EC_CMD_GET_CMD_VERSIONS + ec->cmd_offset;
 	msg->outsize = sizeof(*params);
 	msg->insize = sizeof(*response);
-- 
2.43.0



