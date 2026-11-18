Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034747;
	b=pJ0vhiN2qQi2Zw1LDtiHjDrU49mIP4CO3l4ZZ4PgGo/23jPIkh0ORIKsufqmjdFVLdjJ
	 3qPnnOCIZ+nOuTJ1VsPNNrqSd/mNCNtnM1XMAJvS2hJBxVOH3Q6bvIqOyC9cidoqlDj4a
	 HzYInKctAkTj6cmvk8zgiqMS9wCZxhxQMEuyQzxt1M0e7r12JRnAVeR+o+elIUd36BpzK
	 bGht917SRoE8VPrs9tFlLZaiqnY++TYs1/QBomH2oFlDXjsCLP1J4ro8MC7JIOeB4eYNS
	 b6wtZm5pigOt8z3IthLrGG0x8ii0jGTwPgW5hIIJFVPyh6ZzzrtEjWxfzGZOYMKtujA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034747;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ABp/ln+jzwEMoZE0uxjlaF+gULOsAmfk2EuPakfxyao=;
	b=jCH+zNj+3GnuVBwME31QHxOpr3g4AK7t9IlTd5y+Nwc61ISaOoH7D+qfneUII11iKJWM
	 1VYrKOBQjIyTkk3V5dyzyBqSmY8ebzDAZIy2xzLt8gLDB5LiUW+O3trykT6ZJyFbaxdp1
	 5Wa4PFfCBPCaBCSBxpC7NGY90qC3cGnBAmhcsCo7B8uNfjCp1kEvpVpY3cECes6OfFk3h
	 u+8F/MRQPmklKbXFYTSdIK2p0eiAf9bLp/wLk9MQhTpGcus7tFqQnCGQS+oB+gKPDubqH
	 soQVLLoJTFgku3CnDl3UxpGXzDwAkNgBwZmwa07om5OnuDHrvoVmGBzrn9Uh6USvLiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C3K7LLzP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9B9606A334;
	Wed, 18 Nov 2026 20:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C3K7LLzP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB4F41F000C4;
	Wed, 18 Nov 2026 20:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034747;
	bh=ABp/ln+jzwEMoZE0uxjlaF+gULOsAmfk2EuPakfxyao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C3K7LLzPGhLCcYnwx7Ylm2nbsHqzmJFZYQllNkuBm3KdWGbc6jleEOvSZgO/wvRG9
	 UNPN25PNuFeo/3etJQnl9uOBWTtKuWMLwnh6XhwzU5IxZruI/k0RkN/OEdYHD3su2M
	 xbYDltva6QVmqPxxb82GI8RAa1yA3RQrJTw1riGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Helge Deller <deller@gmx.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0477/3318] Input: hp_sdc - shut down kicker timer on module exit
Date: Wed, 18 Nov 2026 15:18:19 +0100
Message-ID: <20261118150331.246804803@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 309731e95917125bbd13626a7a5600490a5bf44f ]

hp_sdc_kicker() rearms hp_sdc.kicker with mod_timer() after scheduling the
tasklet.  The module exit path uses timer_delete_sync().  That waits for a
callback already running but can still leave the timer rearmed.

A callback can therefore leave the timer pending while hp_sdc_exit() tears
down the driver, allowing timer activity to access dismantled driver state.

Use timer_shutdown_sync() for final teardown.  It waits for a running
callback and prevents rearming after module exit begins.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Acked-by: Helge Deller <deller@gmx.de>
Link: https://patch.msgid.link/20260902154004.3595416-1-runyu.xiao@seu.edu.cn
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
[ sashal: Used the older del_timer_sync() name in the context line, since this tree predates the rename to timer_delete_sync(), while the added timer_shutdown_sync() line is unchanged. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/serio/hp_sdc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/serio/hp_sdc.c b/drivers/input/serio/hp_sdc.c
index 13eacf6ab4310..ee096d7c7846c 100644
--- a/drivers/input/serio/hp_sdc.c
+++ b/drivers/input/serio/hp_sdc.c
@@ -980,7 +980,7 @@ static void hp_sdc_exit(void)
 	free_irq(hp_sdc.irq, &hp_sdc);
 	write_unlock_irq(&hp_sdc.lock);
 
-	del_timer_sync(&hp_sdc.kicker);
+	timer_shutdown_sync(&hp_sdc.kicker);
 
 	tasklet_kill(&hp_sdc.task);
 
-- 
2.53.0



