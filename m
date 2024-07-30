Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60D5145A18;
	Tue, 30 Jul 2024 15:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354824; cv=none; b=H48bAkQDrRRRVZHYGZH/JKEVHwkpAGhX+guCnx4o38sJp74+yVlbqzK5GIG6s+7aBlgiiWkSyuE+Yt3mAK+7+FZ1gOlMrIpQ9n8M30FZIdDRUKktfCEWl3E4jYQdSAYr5l1a4syHEixKsDUVb+FdK9pvyw6ZBdCB7gJOUSGjnBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354824; c=relaxed/simple;
	bh=INPRe8yhjxzMxhUftT0sl2wIl8UlDVrRioRz5z0afPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p7YjjUUK3Z6MJErE/GvEcYpJEv9vw0PofeNudIMeU8mPVfV98iwBNETZyprVSDei+dLOdCSVcwdQ79b9VQDeMjFAvuXQpj/Lo97Uc7mPazDSLvHNeXJXPf/lW0M7bHEAbLcrfQSz/iKrCh6WJQWiQMLPGJAG7UQ15MVWz9WwLzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1EEPhcip; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1EEPhcip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF417C32782;
	Tue, 30 Jul 2024 15:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354824;
	bh=INPRe8yhjxzMxhUftT0sl2wIl8UlDVrRioRz5z0afPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1EEPhcipHX72uZ3ylhSt/zHxunW/WPYpj7QgKBcU7YUBGHJ0jXx/HqvpgCSsXv9h7
	 J/d1HBi7zC7ghZ6lSdwnzPlcHwwaBy7VHMVcRaavADCyFSAhBrjhQYp5gXZfRHZprb
	 MlleD5TuwCCkB1BwwCRugjdItdDWza3riUKkf3iQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <groeck@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 006/440] platform/chrome: cros_ec_debugfs: fix wrong EC message version
Date: Tue, 30 Jul 2024 17:43:59 +0200
Message-ID: <20240730151616.009391220@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4e63adf083ea1..b19207f3aecfe 100644
--- a/drivers/platform/chrome/cros_ec_debugfs.c
+++ b/drivers/platform/chrome/cros_ec_debugfs.c
@@ -326,6 +326,7 @@ static int ec_read_version_supported(struct cros_ec_dev *ec)
 	if (!msg)
 		return 0;
 
+	msg->version = 1;
 	msg->command = EC_CMD_GET_CMD_VERSIONS + ec->cmd_offset;
 	msg->outsize = sizeof(*params);
 	msg->insize = sizeof(*response);
-- 
2.43.0



