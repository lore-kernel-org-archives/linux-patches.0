Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0A6223DD1;
	Mon,  2 Jun 2025 15:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876576; cv=none; b=ZJiPa035sQc67Uoq6M+815JMHZMj3RKiQvDbzNOD7i3FOZLaLkTYIx0VfdAneQZQGA3JYMJBMkEFfNrzX2DVbV4OSC1sYbiLS61LXhSF3KftPjoKqgk0oizKNXP5qw9DUOfHqDXK5LSAuU0O6Y4F7fkIJX3F7WzU8awdLEbKOto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876576; c=relaxed/simple;
	bh=eKKR/IDrvZboDhiEKnhidrP6e14d+BE2MmuZF7KllRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AYjWwY+3TYgfVWtfxduaaVfKZ6XLJb81zRUXHanwKWYz4b4G9YmWIQbLW00E8gcFtFD0CWjTCh+fZFq2Sd1NDASPvkbFgLrxtBVvQBADeT5xUVngFYl0IoKqJVw1fHU3GCjIt+SACWn5dyxYXdYwWlh8wl93SF5RdY3v+h4IoWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gwpKKDLz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gwpKKDLz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F067BC4CEEB;
	Mon,  2 Jun 2025 15:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876576;
	bh=eKKR/IDrvZboDhiEKnhidrP6e14d+BE2MmuZF7KllRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gwpKKDLzJkLhSwa929cf7DzemZx2UjKT4y8KPBcT7wiI3975NIUQlMhigrQSbLFLH
	 bDloezx+1aqDXQH0e3l6fyaSJdYzTp4XHX9M0o0ydup4TWYvK9ZjSdbQDo2Eoy7RGr
	 p/9naJ0SBS7E23GD4am0RJ0rAL6vJXsuWwl8GRHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 001/325] gpio: pca953x: Add missing header(s)
Date: Mon,  2 Jun 2025 15:44:37 +0200
Message-ID: <20250602134319.787894318@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit c20a395f9bf939ef0587ce5fa14316ac26252e9b ]

Do not imply that some of the generic headers may be always included.
Instead, include explicitly what we are direct user of.

While at it, sort headers alphabetically.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Stable-dep-of: 3e38f946062b ("gpio: pca953x: fix IRQ storm on system wake up")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca953x.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 262b3d276df78..caf3bb6cb6b9f 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -10,8 +10,8 @@
 
 #include <linux/acpi.h>
 #include <linux/bitmap.h>
-#include <linux/gpio/driver.h>
 #include <linux/gpio/consumer.h>
+#include <linux/gpio/driver.h>
 #include <linux/i2c.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
@@ -20,6 +20,7 @@
 #include <linux/platform_data/pca953x.h>
 #include <linux/regmap.h>
 #include <linux/regulator/consumer.h>
+#include <linux/seq_file.h>
 #include <linux/slab.h>
 
 #include <asm/unaligned.h>
-- 
2.39.5



