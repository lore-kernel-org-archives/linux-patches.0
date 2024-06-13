Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1286881ABF;
	Thu, 13 Jun 2024 12:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281128; cv=none; b=YSFNhnnDb9bPhvEZR3lIYTTyfoJhi+8kvwfH444fHxzBXTbKjhq32WDniRA1Ftj9pVtxH9b7VYD/JFC+5mvhmAVhr+CKWNaEOXKWx1V9nYV8IVD9LboSDmVO4YbPvvgcd6YQ4CEGYdwpDEND1cNIcIuVl8CkB2GbEYDJs5A1TY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281128; c=relaxed/simple;
	bh=QNL6vnXSI/NUxB4KBsTVQUsEH7agik+jAmg8E3H3T0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h5/GPJunQNHuuwKuIPs5VUiFXzACQvqVFyhTseo/CzVC/iR7cG38A2NEG8TbabCAzxUsct68n/TPPWZ5O8AzMgHKfOgK9eNcqFZc0Sx6CvBqBTvp+kMwKejuOYGjCBa//I32urVbj6HMhY8DMVPmPuDKPWQj2i4Z59q82hwTspc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZmqHjA1L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZmqHjA1L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE58C4AF1A;
	Thu, 13 Jun 2024 12:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281127;
	bh=QNL6vnXSI/NUxB4KBsTVQUsEH7agik+jAmg8E3H3T0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZmqHjA1Lzg1Dbq3bUIEp6OX6xMChKTRLNX4ZxlYTnEq+UG4mzSHtn3j3kV1yGzREc
	 KC4HzxnxPQqGTPSaQwhCepPQTnOBf0sT7ZTapf4Li3LUSGT5OQATCLNPaGxmvu33ee
	 J998BdVEbVPQq99aMt6YaTWTxGx7s/9pZl/38PHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 149/317] serial: sc16is7xx: add proper sched.h include for sched_set_fifo()
Date: Thu, 13 Jun 2024 13:32:47 +0200
Message-ID: <20240613113253.332043580@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

[ Upstream commit 2a8e4ab0c93fad30769479f86849e22d63cd0e12 ]

Replace incorrect include with the proper one for sched_set_fifo()
declaration.

Fixes: 28d2f209cd16 ("sched,serial: Convert to sched_set_fifo()")
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20240409154253.3043822-2-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sc16is7xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index 29f05db0d49ba..d751f8ce5cf6d 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 #include <linux/property.h>
 #include <linux/regmap.h>
+#include <linux/sched.h>
 #include <linux/serial_core.h>
 #include <linux/serial.h>
 #include <linux/tty.h>
@@ -25,7 +26,6 @@
 #include <linux/spi/spi.h>
 #include <linux/uaccess.h>
 #include <linux/units.h>
-#include <uapi/linux/sched/types.h>
 
 #define SC16IS7XX_NAME			"sc16is7xx"
 #define SC16IS7XX_MAX_DEVS		8
-- 
2.43.0



