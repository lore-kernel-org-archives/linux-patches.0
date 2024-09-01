Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCA71E87B;
	Sun,  1 Sep 2024 16:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209324; cv=none; b=FsAQwFvWKPcJK7LrxYGK9IiA4TIJfd25MFpg2gIl/an2ppV7BhsdLSrgUaw+RNJoYwAUFq0ePq8HYUW3xNsEanZxLMt4sYtc/mruSdi11EDh8Sfb9ceQLPpHQBd87XrCcFmiUiaaAvwraxRRk8MKjkklxiloq52XbJAeO5IFGuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209324; c=relaxed/simple;
	bh=hAAHoHASLDOIeMowJ0hfxGD0mIAHVdpbi+i5C9/KUp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EgaL0VK53iK6Hc7OTnzQyIAQYjiPAd7E3sX/tM4YTWts8K3CCKd9OxedvBX5HvHXW4hUyNnhYKUOCEdgt7KepiEX30zYb/AQbxXarXY3PjXKrt/wT6rTG8N/RO0BKm28nMdGQ8LZ8xn0I0OncdTV8Fm5QBNXtIXntwWmoL9EIhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FjnKRsvc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FjnKRsvc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 650EEC4CEC3;
	Sun,  1 Sep 2024 16:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209323;
	bh=hAAHoHASLDOIeMowJ0hfxGD0mIAHVdpbi+i5C9/KUp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FjnKRsvcAerv6XeDvCub8YMNNX4TM250XfhPua1mdaxwTZAs0sj6KMXI3bDWjDYbO
	 yk/qHyIvypW/ThBqucoYyduwN2BVXCDIQz8SvDoHn7KGWvw8M6jaF/4VglpwiI48pX
	 uFIjGyILyXk8MfBAP5z8zTdx25SQjDf6q6/FLmWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Julia Lawall <julia.lawall@inria.fr>,
	Abdulrasaq Lawani <abdulrasaqolawani@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 71/71] fbdev: offb: fix up missing cleanup.h
Date: Sun,  1 Sep 2024 18:18:16 +0200
Message-ID: <20240901160804.567921379@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160801.879647959@linuxfoundation.org>
References: <20240901160801.879647959@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

In commit 96ee5c5712ef ("fbdev: offb: replace of_node_put with
__free(device_node)"), __free() was added, but not cleanup.h so it broke
the build.  Fix this up.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/4f4ac35e-e31c-4f67-b809-a5de4d4b273a@roeck-us.net
Fixes: 96ee5c5712ef ("fbdev: offb: replace of_node_put with __free(device_node)")
Cc: Julia Lawall <julia.lawall@inria.fr>
Cc: Abdulrasaq Lawani <abdulrasaqolawani@gmail.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/offb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/video/fbdev/offb.c
+++ b/drivers/video/fbdev/offb.c
@@ -27,6 +27,7 @@
 #include <linux/ioport.h>
 #include <linux/pci.h>
 #include <linux/platform_device.h>
+#include <linux/cleanup.h>
 #include <asm/io.h>
 
 #ifdef CONFIG_PPC32


