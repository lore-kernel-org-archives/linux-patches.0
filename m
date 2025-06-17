Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C35B02FA655;
	Tue, 17 Jun 2025 16:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178804; cv=none; b=hBcJMG4GGhxQMYIyYCaDXRkSIIuJcEk49feytnH/soBfEAcvLSOAqkbF71vFYWfNX4jwH5qO92ZkFG7RAz1WoP4NhuZjQ7e3iebXM37LIWLeZBSoeE9dqXEslhQaq3Bax6lESRazcCtdzgC7rSbeGZKDIzzOu7i91m+VjTO8EJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178804; c=relaxed/simple;
	bh=U6R99QvffGEIdpwje1eT6bRyOjIKgVt4fB+bgiaQAAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S269a8DjFf2QOiKXdQ2PmSgeqtc1WQYqbsQHuiRdEXEbZ9kXCAyXTPmT0afAlcZTWjMOW001puKXgEDBIxpumzTGaaXbtJz9ZANv9JxqOqs2zXcN5vqihlGbFsrDjoYE3gTLrssm3dNwPwI3PHJYAP9dFIjxYIg3p5Sv8P6JoXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rQiZBHts; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rQiZBHts"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423A9C4CEE3;
	Tue, 17 Jun 2025 16:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178804;
	bh=U6R99QvffGEIdpwje1eT6bRyOjIKgVt4fB+bgiaQAAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rQiZBHtsQ2h+GK9xNP8+UYllrYfXzCX/AxJG3Shxt4ZiTbN64Df4nVhgwzKNCQBA1
	 aYqJlhD5wPNEVmAcB/Da10XwxJ7Zs4FrSzD10aUzoiJsBmujEK1uEKp8TZINODrUJm
	 yhVAxHtN5G8u+/M+yQ4m2CZS/jS2ReRxezcO9l10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roxana Nicolescu <nicolescu.roxana@protonmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 542/780] char: tlclk: Fix correct sysfs directory path for tlclk
Date: Tue, 17 Jun 2025 17:24:10 +0200
Message-ID: <20250617152513.583758963@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roxana Nicolescu <nicolescu.roxana@protonmail.com>

[ Upstream commit 46a4d12a005c58317e89b5644774c683365dc2ca ]

The tlckl driver does not create a platform device anymore. It was
recently changed to use a faux device instead. Therefore the sysfs path
has changed from /sys/devices/platform/telco_clock to
/sys/devices/faux/telco_clock.

Fixes: 72239a78f9f5 ("tlclk: convert to use faux_device")
Signed-off-by: Roxana Nicolescu <nicolescu.roxana@protonmail.com>
Link: https://lore.kernel.org/r/20250501200457.18506-1-nicolescu.roxana@protonmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 8fb33c90482f7..ae61967605563 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -404,7 +404,7 @@ config TELCLOCK
 	  configuration of the telecom clock configuration settings.  This
 	  device is used for hardware synchronization across the ATCA backplane
 	  fabric.  Upon loading, the driver exports a sysfs directory,
-	  /sys/devices/platform/telco_clock, with a number of files for
+	  /sys/devices/faux/telco_clock, with a number of files for
 	  controlling the behavior of this hardware.
 
 source "drivers/s390/char/Kconfig"
-- 
2.39.5



