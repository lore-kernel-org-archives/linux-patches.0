Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212084;
	b=dI91QICWxNW61P6ENmgxI/hwDsZp16rHBuBC58EiPXYKfnreDtZhkn+Rr7arb81Qnl/n
	 tYaU5L3jJzVDsH4+QE7HJozc5YtXrz5mRHDCnFNCnUN2trZ+0UyG/B6WtvXQ+o8lX83nh
	 ryIlK91lSL1DE2UnZ5VJDtYjnUe/iKsDaw2cG7WdCpucha+6GxqyUWmLleYH2sfdzI0A/
	 tkJ/CshX4D7iVEmVSk7Q0M1y0r4YARfjagUbeE7+EEUdgicDiSF1XvxWrVLtT2T9QaoSd
	 iFwzsgLez5k3uRrbrN9JLvZPke2G5Ig2GlRh6JQT7JjydqxUMrxLVOeJrGCf2UCPUew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212084;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ZScumn2svIdw8TceWRgL+kJ3JGXsxNhjahJhgJuuvtI=;
	b=1/8Dzl0TKDLEbJBaFwgltPMayvJErkQ5E06izOQg+ngCg1s1ezc1C7HkG0EaPO06b/cf
	 jYYh4ZVl9uF+p1hgOyGrt7YlNlejGEtkuUlaKK2sGJUsBwrv4SS66JOw9PNtbx1L8kc8B
	 w8HPYvqbimoaEZHc+/SKZMD0g0ZdhucHUv2lPaP0Vcoj66cH/tARxXilxig6Ug0hbHjfs
	 SWtPGYvBPNKNCc7cDBA8nzt85BYAU7uSTnNDxKqyBparcE5max26+IpL1YngWFufXWaMi
	 CEB4b7CayD1c0WiFFLocXiSrVljRVoECY7zaE+bMTGgJ1XRSpdHgTovAd63RNKWWQpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CbtBsFdI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C855606A320;
	Wed, 28 Oct 2026 18:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CbtBsFdI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DDD61F01825;
	Wed, 28 Oct 2026 18:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212084;
	bh=ZScumn2svIdw8TceWRgL+kJ3JGXsxNhjahJhgJuuvtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CbtBsFdIauiRfoT5jyflFdoAzINmlQf4YBh37B6RpZ2FMnC+EKDBbiGyPYfcjq4FA
	 p+pBGR7BSm6rF7fsTzLe4vog3Spc0/2c0OKeLpAJTYbx5AHYQet4Ny9gu1/JIX/sOP
	 ZuzTM4iSZoQ71VAlHpc3wetj1j7uzzgdUb4PEeCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0033/1887] usb: storage: realtek_cr: fix use-after-free on disconnect
Date: Wed, 28 Oct 2026 17:35:29 +0100
Message-ID: <20261028170459.979126832@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 4ffee1aebb0c0ffcda9faffd17834ea9b00d42cc ]

realtek_cr_destructor() calls timer_delete() before the chip containing
the timer is freed. The timer callback may still be running and can
rearm itself, resulting in a use-after-free.

Use timer_shutdown_sync() to wait for the callback and prevent further
rearming. Do this unconditionally because ss_en may be changed after
the timer is armed.

Move timer_setup() into init_realtek_cr() so the timer is initialized
before any failure path can invoke the destructor.

Found by static analysis.

Fixes: e931830bb877 ("Realtek cr: Add autosuspend function.")
Cc: stable <stable@kernel.org>
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Link: https://patch.msgid.link/20260727123414.44700-1-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ adapted the timer_delete() removal to the branch’s del_timer() spelling. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/storage/realtek_cr.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/storage/realtek_cr.c b/drivers/usb/storage/realtek_cr.c
index a026c6cb6e684..de82d8260d729 100644
--- a/drivers/usb/storage/realtek_cr.c
+++ b/drivers/usb/storage/realtek_cr.c
@@ -915,7 +915,6 @@ static int realtek_cr_autosuspend_setup(struct us_data *us)
 	us->proto_handler = rts51x_invoke_transport;
 
 	chip->timer_expires = 0;
-	timer_setup(&chip->rts51x_suspend_timer, rts51x_suspend_timer_fn, 0);
 	fw5895_init(us);
 
 	/* enable autosuspend function of the usb device */
@@ -933,10 +932,7 @@ static void realtek_cr_destructor(void *extra)
 		return;
 
 #ifdef CONFIG_REALTEK_AUTOPM
-	if (ss_en) {
-		del_timer(&chip->rts51x_suspend_timer);
-		chip->timer_expires = 0;
-	}
+	timer_shutdown_sync(&chip->rts51x_suspend_timer);
 #endif
 	kfree(chip->status);
 }
@@ -981,6 +977,9 @@ static int init_realtek_cr(struct us_data *us)
 
 	us->extra = chip;
 	us->extra_destructor = realtek_cr_destructor;
+#ifdef CONFIG_REALTEK_AUTOPM
+	timer_setup(&chip->rts51x_suspend_timer, rts51x_suspend_timer_fn, 0);
+#endif
 	us->max_lun = chip->max_lun = rts51x_get_max_lun(us);
 	chip->us = us;
 
-- 
2.53.0



