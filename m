Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3EC1714A8;
	Thu, 15 Aug 2024 13:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729216; cv=none; b=J7HK4x0EjRDV15XPohTICMhThSKhqJBNvx3dHqgvN70SNstr72XrZTO+7sOx0YqMNtdzQ7pjxb/ZgjutFlOSI0zVEpsrReUQ8TBcT+wBKkFzubvtR4zfIar9+HUTN/jfaM20cUdO9+Ph+e8YB5e8l28iqN6sayXfiFcn2Y5pSsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729216; c=relaxed/simple;
	bh=7MweDqZkshe9Plotrs1ju4jUS58dUJHWJyFDD3CTals=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NSDCE9rJMHW79IRnt+QpSZSIiYMhxaZAx/ppDiua7XZPt8teYvDmK6oReCvwxemTATZpP6QrR89qVu/senr33o9GOsBh3LwA9w79M5k0NinV93AlefDOYdxqpltiuVegrRYnFN9S2X6SwDDEjhEl+6Do2OArxlvHd418NSLsE94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i/6yF+ds; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i/6yF+ds"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F59C32786;
	Thu, 15 Aug 2024 13:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729215;
	bh=7MweDqZkshe9Plotrs1ju4jUS58dUJHWJyFDD3CTals=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i/6yF+dsNEyjXK5O1I0mGeUWEWqnmBtBYn1Q+ENLkPGAzbxm/+g3XN5HlComRoEvL
	 7yKzqG9b9k3cgXf0ylmJg9uSL8VtUvhqLcT5Y6+QApDk6SCB8qiLHmUs9AGVHO7TTq
	 RzPLPBw1tYOeo8UyFDmMbKMzGQkqkS3zKhaVfutQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <groeck@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 004/484] platform/chrome: cros_ec_debugfs: fix wrong EC message version
Date: Thu, 15 Aug 2024 15:17:42 +0200
Message-ID: <20240815131941.434099617@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0dbceee87a4b1..2928c3cb37854 100644
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



