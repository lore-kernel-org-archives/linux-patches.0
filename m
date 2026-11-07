Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061348;
	b=U7tSS9cW4kSGfTrd4QB/TgQwPWxKiELo2zdQUybyaTda0L1Av3FS7GbWME7xSjoajHFb
	 zvYvZSlXvglUtZ97sz2xu0PPrL9muHhoUy5w7p1aCfDwZGanoVYPEh2NZ/oULY7S90Ujr
	 r6mxP7J+U1llCCSi6yDJAj2/jKB9gJfeFH+Rz2jQslC9mXGuDIYQfkJzmbWlkoOiuETIF
	 3tC3uGK1nG6li15zeWLIckM3XTsO65LUDdz3BfJDKvCpQfzC6GZnESJpefVWavtO7TCl4
	 vKmYnOU6WBnnYiuEOz0StapaL8G7lZFtaHcp9m1ZZxVZSyNzf2B1DVtDzJv4zUuz8BQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061348;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J+FcGIMmC2Ozy2m5DZJaAJl1OpzoldIxmtv1/3TiXRY=;
	b=HghZKeUz3DyzWRS3qYAK+N8SrrkZqHF4nbnho3kj93aN8Wo19DLfjpKf+psftdARiNAQ
	 qqnp14xN+3qRERdrfRRAvwdqHe7Y/fsNUxm18+5guoMCuTMj9G9THFgcVabPJweMsG094
	 KC7P7n8zl6mpw6PJkx3coV1dyBFHg/up1PuFevJ4ZUXT/pPrrYoaYB3VZffw4C6pAxlvJ
	 XLR8mvIm40ZFAuPanUBs7x+06ZVQyz1m+9x3Bb0NAxweCesjJel7H2zzpxi+YtdNKe0JH
	 sFQIslJ5JkwMYRPeTBUYRz3weK+uWCs6gwpD/XB4n4cJthjsu+EUPV+Sm3Co131Jbqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VQgJVZEa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B87606A32D;
	Sat,  7 Nov 2026 14:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VQgJVZEa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C341C1F0089F;
	Sat,  7 Nov 2026 14:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061348;
	bh=J+FcGIMmC2Ozy2m5DZJaAJl1OpzoldIxmtv1/3TiXRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VQgJVZEaGmORRkbgjDsIWYn+T+BQBQQeiWNVwPbAG3KdrU6CH99q2nOyPbswTaqf0
	 SyzzKOKDqxcA78AEjuFAj5FrXYlOsP/7XXKO+5dwYX8lMjY5YqNtBVM9Zenve8kN/b
	 cpNZDtLi+3/1EMM35glcccbk64saOPnxB0++Tk4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Mukesh Savaliya <mukesh.savaliya@oss.qualcomm.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0476/1536] i3c: master: Fix potential UAF in i3c_device_uevent()
Date: Sat,  7 Nov 2026 08:41:32 -0500
Message-ID: <20261107135010.866984823@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index bb15b621c067b..28a39b2c039b1 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -282,8 +282,7 @@ static int i3c_device_uevent(const struct device *dev, struct kobj_uevent_env *e
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



