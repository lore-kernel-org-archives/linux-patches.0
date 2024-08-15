Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C2714AD0A;
	Thu, 15 Aug 2024 14:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731897; cv=none; b=aScXFUunfvw7IhCLlhh/6kHqVOA3pLctJXCdvx/Of6HR1+xbpGvqGDdlH7IR8f2uSyF6AA2R7RHdcMKuF4MYAQCuyioI4I3XY108o2Tz+Rsnboyx3l0r7otnpDQpQSN82WCM9BCfungM5Wz16tT8ZSVCmjZX2omAwFdH+80QGJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731897; c=relaxed/simple;
	bh=tpT2oMD+470+Msekfb2mjR+7MWNv1yj5IIt4qOKwsrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XWOOSin7qtV8pAN2qYJp5SEw2GtmeRvsC5ni4mAksAs3A7wNvNEmvRnRDc/vnuwYHJ+yk/j+YcRQY8RFR2JXQtoOcxkgTlUN+xravpPcmswHhWiC5pXPSUfGTT75fi1keP2Oun57V20Yrd1kmKwF4IZSIwzyh1R4Ln2Fg8EiaR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HqhKasB0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HqhKasB0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B94C32786;
	Thu, 15 Aug 2024 14:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731897;
	bh=tpT2oMD+470+Msekfb2mjR+7MWNv1yj5IIt4qOKwsrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HqhKasB0gTicA3m8Om6uv5k3dyU+Abmg1QGjxHfPBHdx7kHqmfh140dEKrLykao6/
	 P8iKPQ1jVy60OGkgLATqn9+66OCXiKi66+7rsbvW3+ygCL3QbSxsowSJ4DnfF6w1wC
	 bNcAjk/zq1KJ11yMNDWdvCkfql3/tmjIWHbBf2Fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <groeck@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 003/352] platform/chrome: cros_ec_debugfs: fix wrong EC message version
Date: Thu, 15 Aug 2024 15:21:09 +0200
Message-ID: <20240815131919.333966204@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



