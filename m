Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98047261B6E;
	Tue, 11 Nov 2025 01:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822867; cv=none; b=ZUudv2G+zb1oGAYygy3OODemg50Ee2l7RCgRPsoUpqygwU8bNP6LjaXueqoqiG4cU3yZLRIABdk6+wbwMePoVVtBtyyCgWzyqIVfKE22n22AKNtydg4WcDRd8N9XwupzuWE93oUypQEwetBLEzL4t74A7fMF2i/nPD92cHzxB2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822867; c=relaxed/simple;
	bh=QQLOOvjKRHGG+hLVhJJdxdWMI6KqA4Px8DAJCS+pRKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B9x2GotjKa5cfj6BDKdVWrhEyHl+psWInPwDMRjrachy3Z0vJy5mKIfVtMJ4fbApVc8sMBjBUMSq8NQPTmJGWlCSpiItTKKbr9TYtF1JF3aWZ846rzkJFd68WuImwKIcnd9bbj99huRiUMWij+l8qe0CAv2w1dawI3/Cf5dkocs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XetU74a3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XetU74a3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F79C4AF0B;
	Tue, 11 Nov 2025 01:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822865;
	bh=QQLOOvjKRHGG+hLVhJJdxdWMI6KqA4Px8DAJCS+pRKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XetU74a3wKl+eFGzxLMMRJLWtXKAYqAyxZovgk3uk3nFUNmhOXyYNonQAtJADiyuI
	 ojXwMZOCWEKBBNf9bwCDRSmmSq3AGf5RQuEnGP46tYqk282Q7mUmrnOmpV3HUzQxlU
	 Cbc1mqZgvkijWtG5/CvL5l69AsTn/16b/p7i0jTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Kemnade <andreas@kemnade.info>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 123/565] hwmon: sy7636a: add alias
Date: Tue, 11 Nov 2025 09:39:39 +0900
Message-ID: <20251111004529.722931161@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Kemnade <andreas@kemnade.info>

[ Upstream commit 80038a758b7fc0cdb6987532cbbf3f75b13e0826 ]

Add module alias to have it autoloaded.

Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Link: https://lore.kernel.org/r/20250909080249.30656-1-andreas@kemnade.info
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/sy7636a-hwmon.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/sy7636a-hwmon.c b/drivers/hwmon/sy7636a-hwmon.c
index ed110884786b4..a12fc0ce70e76 100644
--- a/drivers/hwmon/sy7636a-hwmon.c
+++ b/drivers/hwmon/sy7636a-hwmon.c
@@ -104,3 +104,4 @@ module_platform_driver(sy7636a_sensor_driver);
 
 MODULE_DESCRIPTION("SY7636A sensor driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:sy7636a-temperature");
-- 
2.51.0



