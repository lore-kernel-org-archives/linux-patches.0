Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5A91A76AE;
	Tue, 30 Jul 2024 17:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360029; cv=none; b=dr2xEudVW2qXqhFQJrQJqHcjLW21zCnu6FsH8gepsgFdaHMSoypkz3+Gen0WklUBaM/x9bN5fY6KajqYeqgvALQRrmYU0Wf4vqmKymyfQEq4Hw6/WzG8DV9yXQFM9ITP+CN7yVigQL97EeuVe6E2WG7K2T2vToN+U+ymwYh8qwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360029; c=relaxed/simple;
	bh=+VkjFeIcX6uTiPm23um3mE94zcppg3BVMUQfAQgTpXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sgqFgY0xXKhrDt+f5BYzj4YF9VMpIWWgCNP/v68KUPf+zNKl9tf5qTxAHT4UQrWq4eR+9T54C5ZT2RBsoWR8p0uN/0frN4764KgOJyR0scQcw/6+cSMknP4skMD5sDOZVY0qVXgBEK+Ua7LuAF0hdT5WCf+dbmm5PO9dykQVkok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wfPdVbSP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wfPdVbSP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D421C32782;
	Tue, 30 Jul 2024 17:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360029;
	bh=+VkjFeIcX6uTiPm23um3mE94zcppg3BVMUQfAQgTpXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wfPdVbSPX7kaa3fJad5VPj48rzLie5s2c0tOVOFNME98h8bpqRh813wEIeSrROEQW
	 jsYKwXWYhCZOxrHGLzaavWk9wKbT5DvVmuVijCmlT13Krk2wUuwpp4gMWcbp9Ai1yu
	 VHTZnuwygLjkYVOqP/ri/Wt7I7nqf0VlPa/mnc2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kory Maincent <kory.maincent@bootlin.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Paul Elder <paul.elder@ideasonboard.com>
Subject: [PATCH 6.10 575/809] media: i2c: Kconfig: Fix missing firmware upload config select
Date: Tue, 30 Jul 2024 17:47:31 +0200
Message-ID: <20240730151747.488785877@linuxfoundation.org>
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

From: Kory Maincent <kory.maincent@bootlin.com>

commit fea074e97886b7ee2fe04a17bd60fd41723da1b7 upstream.

FW_LOADER config only selects the firmware loader API, but we also need
the sysfs_upload symbols for firmware_upload_unregister() and
firmware_upload_register() to function properly.

Fixes: 7a52ab415b43 ("media: i2c: Add driver for THine THP7312")
Cc: stable@vger.kernel.org
Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Paul Elder <paul.elder@ideasonboard.com>
Link: https://lore.kernel.org/r/20240620102544.1918105-1-kory.maincent@bootlin.com
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -679,6 +679,7 @@ config VIDEO_THP7312
 	tristate "THine THP7312 support"
 	depends on I2C
 	select FW_LOADER
+	select FW_UPLOAD
 	select MEDIA_CONTROLLER
 	select V4L2_CCI_I2C
 	select V4L2_FWNODE


