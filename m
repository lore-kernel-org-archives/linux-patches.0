Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70CF52236FC;
	Tue,  8 Apr 2025 12:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116164; cv=none; b=mz3b+WjTFHdzQZ10vtcVQj0wN5JRWaUY7qANOi+BBpiTW0NPTFD1l9eQFwYHT/8PUTpDInMiDx8xLi+/egSxWojTGb0W/BGD/KcN4ISQ3N5u6MTJmMHw0O+5Lyd/8kpKHPcGggWwoRyVXJrdrw2xKScPXd+E+ZygPWT9w5mCA0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116164; c=relaxed/simple;
	bh=zUv/OUhsGlzXoUywdTqu3ekuMe6HgRZ6r6KIYhPUXZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KC4jeQs3PqOZUqMUcfMRijv8Hsh6vXeCOU15qkxMjKHCS+Im+/HUkS4C8M5RqzM4niextlecMmL2Y1lEi5T1jLxnY54xcshbUmTYn5L7j2sr7QLSvd1jzsE8KGGZsVV2Li99xGzwlHGchAw5uF+0vok1en43kuqVX07NB49NXLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nmgHZXE+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nmgHZXE+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F25C4CEE5;
	Tue,  8 Apr 2025 12:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116164;
	bh=zUv/OUhsGlzXoUywdTqu3ekuMe6HgRZ6r6KIYhPUXZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nmgHZXE+xShKkK7dqvsaG8n8PRoydqXV6FDG7PyaP9ftz9MQkYuXq+nUEdy+7TGQ/
	 zx5TzX2Hx3DB5vDuovMMKGsi/J8USJIONGTnOUJiyb6u3/SmFBW5R99IiNbn9+ItCe
	 3WXNGZgyIsuhKf8t3MuPg8OFNq0Md8zSIKr+p7D4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <maroi.limonciello@amd.com>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 038/423] platform/x86: dell-uart-backlight: Make dell_uart_bl_serdev_driver static
Date: Tue,  8 Apr 2025 12:46:04 +0200
Message-ID: <20250408104846.637667463@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c45bc332af7a0..e4868584cde2d 100644
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



