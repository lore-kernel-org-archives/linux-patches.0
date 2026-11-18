Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043823;
	b=NEXOTuyIuev8dScB6foejhHRXOBvncN5skkXANGvl6PhiKlGIIs6JfOmN3Ss3iJxvDDx
	 qlnAjE6grT2+Fh/xHtjZ4E/oH8mcxsKfrDjLj6EaQWnIUUY7/eTY9bg0oBFh3FWZXnWpb
	 hgNHRSGpR+wrsv3HcnD8Rb1azEcAqiKLHJQaYSbcblh319pw0UJxoyhHz/ObVjTyanE1x
	 zrxpTyKanYSM1NFGb0NStMk9S5LwZbO88ht91LwuEEKJIUlEn6KcogbWnzIjittviXzFU
	 VAlEERwzDV9cXpXIwHtAC2/gdCILJBsdylGogYMY2zzo40hbdxjvcz9WJ5hq33uKhfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043823;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=abBQ/eKt1tSevym2YSpI89oE2660HfJZ9cByR/C3BVU=;
	b=K18mXXIDml5kWiBxxxKWDJiJairxZVNBfn0SvZN+Gte8H8cBHFACfIEiX6K7MgmynuSH
	 vWNaB7cb6eyuGloaTR0UyxVXHPWDvaZo8wj+YQMA+P63guszZUoLKDN2/wWzvWCjqneb/
	 K7LtsaxBfLv6XS9uWY1mbsvYasFqymo0+5iKwobTSuOpl/BHYRqo/YTRn7KPRLFtkXLkI
	 +LW7Ozc/tsDj5MSaS+rX54aMFfqYlWsIAzqnsStEWCE4br8XxiLWgmsFKS7isl3GM8aPc
	 Nz2e/x+Iiz7whfRt0I134Eufg5TDe4QM3fCs6F2leLQErJuy0xFfGm3IrZgYb4Gwnbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fQkTuE7n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF137606A32F;
	Wed, 18 Nov 2026 23:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fQkTuE7n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C0D21F000C4;
	Wed, 18 Nov 2026 23:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043823;
	bh=abBQ/eKt1tSevym2YSpI89oE2660HfJZ9cByR/C3BVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fQkTuE7nlF550KnBnvBAhgMUOW0pLGHO6lObyG0XesgXNPqT2a3JmCEdFeDWpnSo0
	 TjACS2qYi49u5pWLrXlkS98ck4zwhry+El9feg4FTaGajXf2mgkoGrUNo4L1ccCZvg
	 2NGyEZiza8+Ar45WerBxpxIQ0obrgjoWGO1eqaZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Mukesh Savaliya <mukesh.savaliya@oss.qualcomm.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0348/2857] i3c: master: Fix potential UAF in i3c_device_uevent()
Date: Wed, 18 Nov 2026 15:23:02 +0100
Message-ID: <20261118150213.969542562@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit e5e8dd2e959f470524c16ca444d001c90d6bb3ad ]

i3c_device_uevent() dereferences i3cdev->desc without holding the bus
normal-use lock.  Since the descriptor pointer can be replaced
concurrently, including when a uevent is generated from sysfs, this can
result in dereferencing a stale descriptor and lead to a use-after-free.

Use i3c_device_get_info() instead, which protects access to the
descriptor with the normal-use lock.

Commit 6cf7b65f7029 ("i3c: Use i3cdev->desc->info instead of calling
i3c_device_get_info() to avoid deadlock") replaced the accessor with a
direct descriptor dereference because i3c_device_get_info() would
recursively acquire bus->lock during device registration.

This change depends on "i3c: master: Fix recursive locking during device
registration", which moves device registration out from under bus->lock
and removes the possibility of that deadlock.  Without that change,
restoring the i3c_device_get_info() call would reintroduce the deadlock.

Fixes: 6cf7b65f7029 ("i3c: Use i3cdev->desc->info instead of calling i3c_device_get_info() to avoid deadlock")
Cc: stable@vger.kernel.org # requires "i3c: master: Fix recursive locking during device registration"
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Mukesh Savaliya <mukesh.savaliya@oss.qualcomm.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260807145638.168865-7-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index 62d0bbcf560f9..c56e607397daf 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -280,8 +280,7 @@ static int i3c_device_uevent(struct device *dev, struct kobj_uevent_env *env)
 	struct i3c_device_info devinfo;
 	u16 manuf, part, ext;
 
-	if (i3cdev->desc)
-		devinfo = i3cdev->desc->info;
+	i3c_device_get_info(i3cdev, &devinfo);
 	manuf = I3C_PID_MANUF_ID(devinfo.pid);
 	part = I3C_PID_PART_ID(devinfo.pid);
 	ext = I3C_PID_EXTRA_INFO(devinfo.pid);
-- 
2.53.0



