Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A6533E36A;
	Sat, 30 May 2026 17:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161512; cv=none; b=gIqtK2qZydAfzqq6yYLCkax9BcAshbJZ+pAR0CUWwYH7Cbo0Ai/yBE4mtfhpJ8Wm3oZXYdOOlfDQ0Xsu6CkLFDUmQNT2DCHABWyx9ujBCAsQOYV23DK0UE3eXAuVmJnJ77w8OsjPmQ5I6ow2t+4k7pTkmI1yqzS34owkupgwoVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161512; c=relaxed/simple;
	bh=rYicNLW6mUkEwx3gD/4wERiL0tHb9u2OohsHdk8r6VY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e0RU7z5dXx34HanyAIOUMi+iHYQdursndDIZ+x3kPc3gD4QsaeOIcuFJlPMoRSt89GV5xWqbvfyBdom5jMOHYwECKfcaxL5uW/v7+It1PFUN9KoC1xH16DwSGTkzl2R3KLH0x/iRSEYKJkGfCH2//so+vWmbyBwXrmyeYsGvFGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vwjAk5t5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vwjAk5t5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 322791F00893;
	Sat, 30 May 2026 17:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161511;
	bh=cG9YNgww9462JJaFiOT7BRyR1YSNS9cJgKZEHEHXrEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vwjAk5t5a+4XwVE00zZ8auYfXmpATGEEuaX9q3BN1LQp1HDcDBXFVdZPzrRMoVYrh
	 LEj8IYHmsZJQn78Bu7LxVkITw63MCDapzUo8BRtXvxDI8gXolOhChy51RSSL5+ga+a
	 kjazOYCpmj3W8kcuvaiMutfe5LhI4T4I6CSuy0VM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 646/969] platform/x86: dell_rbu: avoid uninit value usage in packet_size_write()
Date: Sat, 30 May 2026 18:02:50 +0200
Message-ID: <20260530160318.299695775@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit f8fd138c2363c0e2d3235c32bfb4fb5c6474e4ae ]

Ensure the temp value has been properly parsed from the user-provided
buffer and initialized to be used in later operations.  While at it,
prefer a convenient kstrtoul() helper.

Found by Linux Verification Center (linuxtesting.org) with Svace static
analysis tool.

Fixes: ad6ce87e5bd4 ("[PATCH] dell_rbu: changes in packet update mechanism")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Link: https://patch.msgid.link/20260403134240.604837-1-pchelkin@ispras.ru
[ij: add include]
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell/dell_rbu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/dell/dell_rbu.c b/drivers/platform/x86/dell/dell_rbu.c
index fee20866b41e4..9039e494131fd 100644
--- a/drivers/platform/x86/dell/dell_rbu.c
+++ b/drivers/platform/x86/dell/dell_rbu.c
@@ -30,6 +30,7 @@
 #define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
 
 #include <linux/init.h>
+#include <linux/kstrtox.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/string.h>
@@ -617,9 +618,12 @@ static ssize_t packet_size_write(struct file *filp, struct kobject *kobj,
 				 char *buffer, loff_t pos, size_t count)
 {
 	unsigned long temp;
+
+	if (kstrtoul(buffer, 10, &temp))
+		return -EINVAL;
+
 	spin_lock(&rbu_data.lock);
 	packet_empty_list();
-	sscanf(buffer, "%lu", &temp);
 	if (temp < 0xffffffff)
 		rbu_data.packetsize = temp;
 
-- 
2.53.0



