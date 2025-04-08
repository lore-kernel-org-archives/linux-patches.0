Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11FCB268691;
	Tue,  8 Apr 2025 11:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110437; cv=none; b=R9wYLdCVluWt+JWaYFwWuw80W1tnvV75GSG4My6wKlqJqKwrtlPm9a8R3mEduohgaa6TlHUh1dy+9iUYJS2zHw5HLNDtnc5P27hHWeuGLQsYRrKoYRoaUp1ET0mKeidut+rrpRYC/vEylrTfFwgw3D1t+4jIXOGu6ti+rOj1lc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110437; c=relaxed/simple;
	bh=QmMxLLd6QjxXWfpNNn2ictto6cN9rzwMcJnD8Krbau4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QMqqJKd9CNB9G1Nw03KhnK8tqGg7eFcuQpP3b9uUH2LMkddb5+65Bfes3DI+XoSeR/OJsFs3OVekWmBGH3nEDfonJHsvxiUhFr/uz0PdIv+Q3A530b1Ald96N7pc/TUKmWJHnuYo+sm4Qq42d2Cko+yjqyC5C4+8fqtiESPTrfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ORM4rHY+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ORM4rHY+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96627C4CEE5;
	Tue,  8 Apr 2025 11:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110436;
	bh=QmMxLLd6QjxXWfpNNn2ictto6cN9rzwMcJnD8Krbau4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ORM4rHY+x2QC8AZ4ZiX7jgpxlu3R4gHh0M89oy/2Whnw/u7Lvj9m+1FUDEQlWT6Q9
	 1VLp6pPg7Slok32jnxSWw0kSocXoxKnenhFcuSGsNn5iwH/jp95xAr6L4sTHyEFgmR
	 acZ2i6k3kpyCXBMVJdTx2SedkYP+AUo2sYGD4IyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <maroi.limonciello@amd.com>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 063/731] platform/x86: dell-uart-backlight: Make dell_uart_bl_serdev_driver static
Date: Tue,  8 Apr 2025 12:39:20 +0200
Message-ID: <20250408104915.738575725@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 4878e0b14c3e31a87ab147bd2dae443394cb5a2c ]

Sparse reports:

dell-uart-backlight.c:328:29: warning: symbol
'dell_uart_bl_serdev_driver' was not declared. Should it be static?

Fix it by making the symbol static.

Fixes: 484bae9e4d6ac ("platform/x86: Add new Dell UART backlight driver")
Reviewed-by: Mario Limonciello <maroi.limonciello@amd.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20250304160639.4295-2-ilpo.jarvinen@linux.intel.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell/dell-uart-backlight.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/dell/dell-uart-backlight.c b/drivers/platform/x86/dell/dell-uart-backlight.c
index 50002ef13d5d4..8f868f845350a 100644
--- a/drivers/platform/x86/dell/dell-uart-backlight.c
+++ b/drivers/platform/x86/dell/dell-uart-backlight.c
@@ -325,7 +325,7 @@ static int dell_uart_bl_serdev_probe(struct serdev_device *serdev)
 	return PTR_ERR_OR_ZERO(dell_bl->bl);
 }
 
-struct serdev_device_driver dell_uart_bl_serdev_driver = {
+static struct serdev_device_driver dell_uart_bl_serdev_driver = {
 	.probe = dell_uart_bl_serdev_probe,
 	.driver = {
 		.name = KBUILD_MODNAME,
-- 
2.39.5



