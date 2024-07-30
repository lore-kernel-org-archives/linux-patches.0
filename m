Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B671E29A2;
	Tue, 30 Jul 2024 15:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354988; cv=none; b=VhbaaYwHL/o/xJhP5nrdn/zk35fHTtcgsKosbzUVsspX6MIAr4lA2G+4XxennIvn/iNCevME6X8/G963fL/HqgKtVlWDC6hVqKGkEuoN3CcheguFuwFy/u6N9PTLZ7YGrb/qGf28IjNSvmEeS+0XXLRqCXZJVoAHcxjTQWbnouk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354988; c=relaxed/simple;
	bh=z3fIHwPMVGC3J3W+RrQ0wpE6e3m6c17+NvUfszEZLZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=maj5QZHI4O95m8qZCIgqF6jKuUMdypy13D/bLGYnXnRfzw3PiyXliuCHQok6BQvLr+JEFPpgPIA48xXHykea78pl47xSlz/LdpqxsjTcYnXTcoQCla53OsHKe15E6Zel2ezKRFrOBOLFWQxML1PESpqyzEFHzyBz9NHfK4+RiZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DYYshR4y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DYYshR4y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0FEFC32782;
	Tue, 30 Jul 2024 15:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354988;
	bh=z3fIHwPMVGC3J3W+RrQ0wpE6e3m6c17+NvUfszEZLZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DYYshR4y0OIz1VFOB/IDoL9DZc2PkrtMa5kcgBRdxl6PTHG4n3muRWEoo2uxpHvZO
	 deeI0sP70CIE/V+buqWfccmZqrX/lsW+mYgk1DNNgWGr2BN+z/Z8D5kwjodgbYDZRp
	 9pxkI+Guu1uBxV47Yu1xnAk9UEmpGhrDLHEaHP7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <groeck@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 008/809] platform/chrome: cros_ec_debugfs: fix wrong EC message version
Date: Tue, 30 Jul 2024 17:38:04 +0200
Message-ID: <20240730151724.985370102@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index e1d313246beb5..5996e9d53c387 100644
--- a/drivers/platform/chrome/cros_ec_debugfs.c
+++ b/drivers/platform/chrome/cros_ec_debugfs.c
@@ -330,6 +330,7 @@ static int ec_read_version_supported(struct cros_ec_dev *ec)
 	if (!msg)
 		return 0;
 
+	msg->version = 1;
 	msg->command = EC_CMD_GET_CMD_VERSIONS + ec->cmd_offset;
 	msg->outsize = sizeof(*params);
 	msg->insize = sizeof(*response);
-- 
2.43.0



