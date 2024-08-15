Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEAFB1EB44;
	Thu, 15 Aug 2024 13:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728464; cv=none; b=SBP1laA7E0MsrEZL7DpQOPCBj9xW3rMjn3z7tg8zervmb5GYM1HCQ/MyNeXMfnnn8bcoJkEqArNVEhDkautYGG+AoQIDXPJwbNaxYVo77o8B0qRWpIn1eSuaJBDBhYGLYLXO09lwyeSwY8kuOxzAXdSdkCe7L3rScxQpfFu76nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728464; c=relaxed/simple;
	bh=vYlab+8dQFwv6sM0k5+1kv1q56dEpKGrrSy9GoVaulA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XipJWm0hucaLEdo7RCi8M4F145kv5U8+qJNxlyJGA5NfsgFg5xARThwqOz0ryje5beR9aJiyY3AMnTHnyBv96cI4P21vZu4CYgZjXAfPCEhfXqXM34L1M2wyQKnN+u4bP8P2I6W2FaS1s5kcqs9xtIkGuXyGhOEbGZdKg77mqL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tux6XfXL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tux6XfXL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83DC9C32786;
	Thu, 15 Aug 2024 13:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728464;
	bh=vYlab+8dQFwv6sM0k5+1kv1q56dEpKGrrSy9GoVaulA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tux6XfXL+UAEPA9YjJWgtFCyuWQFUr4DapKxB5oJyT2rsIIkFp5UxtiBBHl1Ukz1g
	 H3FZTC77/Ntxy8TkSGTrlIe0OKY41kwsGlMpbWHa8SDp47akL32wQyxlZkc8hIVrg6
	 Op3EyAifPk1A0Yqns/s9d4W/4gqC+ljQI/j1LQ80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <groeck@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 001/196] platform/chrome: cros_ec_debugfs: fix wrong EC message version
Date: Thu, 15 Aug 2024 15:21:58 +0200
Message-ID: <20240815131852.124828489@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index c62ee8e610a0f..5aed088371a72 100644
--- a/drivers/platform/chrome/cros_ec_debugfs.c
+++ b/drivers/platform/chrome/cros_ec_debugfs.c
@@ -292,6 +292,7 @@ static int ec_read_version_supported(struct cros_ec_dev *ec)
 	if (!msg)
 		return 0;
 
+	msg->version = 1;
 	msg->command = EC_CMD_GET_CMD_VERSIONS + ec->cmd_offset;
 	msg->outsize = sizeof(*params);
 	msg->insize = sizeof(*response);
-- 
2.43.0



