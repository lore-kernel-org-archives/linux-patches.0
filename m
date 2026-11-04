Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831209;
	b=ICUMrvzajxb7vvOxYBmP8dhKWEICIdXwsylD7MJd0cFP38sDEO1bSFsEolLYZAtAHXLn
	 aGfcD6+mLYNmrR/ze498G8tZOVudeUY8LUUhSuezydNfVFfuTiXTrkJTPqWS3MZVfrr83
	 NlX+9WMyVsjOUyxcdLdO79E+ciXsznPgUDJT7OfDSdTmkytraCeaPMfBYa5p9ulDukbm0
	 ZoTdaGgtuO+kVDkLp3s/tGg9EBZW7A7zX/RDbmK7ZXQlHbyfj2esuOXBn4y44aVVGoSf2
	 Zsoc2AXY5ncChJwRMPmwypTyqtUmJ23S12l4ZnCl4PMPDmc11K+GPb/cF5SeXOtV1Uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831209;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F2j4K4aEXXHDbMwDLNeUNJLMFbB3RX035ZyzVu9EENM=;
	b=0VXWRA3YIOzBym9dGmKbN8YOfj3tw5WSgkUOi6ccYaaiazjczsUiFybyPhVomHjmBZCR
	 2jLLurcEsVIH7Au/MtFuN4WsH/HT0TNQTACcJvhm/oTjFMvMWURXupBKxogzl6/VzZBGG
	 Nh/rJ/cZkG+AQR9/Vy5OKSyQPg3T33ZfKK+GP7Cz2EOjHLPzA45437oxMRGOurwQuZSaz
	 zjxfAjEZe/HwZldsQC6LIRMDCgI3bwEDptro6U1Rel9IJaOYB+GH+XyhDdOG757EhNz9X
	 0rirsLtMP0OrUaD9ZHftMqWdxBjcQrfek65WuOTLlgmZvlJ3/rZN4RbEZ+VXwLofbPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s5fa0t8w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFB4606A870;
	Wed,  4 Nov 2026 22:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s5fa0t8w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 713541F000C1;
	Wed,  4 Nov 2026 22:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831208;
	bh=F2j4K4aEXXHDbMwDLNeUNJLMFbB3RX035ZyzVu9EENM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s5fa0t8wDhyYwEdGfZGJDd9CGA/n4P5MN+8zvE4Bt+orFT0q+duyk8nAj23+5xvlx
	 Aapu9o1UngtLWK4C6qz66OHYYqLEu+fTpNRXznORDyGA0hBe8XjYtmqK0gTcm2rPV1
	 qKwv+PpaVqG8hG0dBDa0qAym7b3jOizi/wvtDJi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Mukesh Savaliya <mukesh.savaliya@oss.qualcomm.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0548/1005] i3c: master: Fix potential UAF in i3c_device_uevent()
Date: Wed,  4 Nov 2026 16:04:41 -0500
Message-ID: <20261104211059.246190307@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index c8ee43b70d5ec..038f7b2ec8c48 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -315,8 +315,7 @@ static int i3c_device_uevent(const struct device *dev, struct kobj_uevent_env *e
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



