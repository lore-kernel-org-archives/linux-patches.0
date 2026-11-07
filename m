Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064901;
	b=YMdRqXE655Y3wPZ0/52UwSIkjTf5QS0ottQfexKsbcbJdAUK06kBPyHE6H9B1hva446m
	 9BPyjhOxuXSPM/AF/IwqQ+qUD1IiSbww44zirndKnAC2HvBPmPJmzm7EKOyfH9nl3+V9B
	 4EtUO8rnL53H0xIeYMK8Izqi64pOWPowGLmu2ji95tXTtyl0YB+ZkuId0cvBxNb2a0Iw7
	 w0eaK59b6jSzh0FpGRsxjuX/+4optGQEJPhI0OAglTpbblbTI5dqav4duILqOBjiDeWZG
	 Wt678Np/gwq3npiB+qNiO38LTSR37jsTOMa/aKsS38YwobNmcxYDwsGjEj1QRz9R7YQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064901;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wO1ErzqQQSGorw+q/pEQ00ThJCffR97y78CaZV15G9k=;
	b=U3U9vFdhSvIZGf+8tttwrIeMHIJJmL7r/PvFEKInikFmWYvz3tnivOvlJHsz+p8+aX3E
	 lclphGBXVaHyGw1hqW/9vyvcyncgXwGdjsWCDUKSYcGLClPJv9h6GQcJkBkmh175iWxXq
	 ZDlsMc8BKCzTwQzvJk61kCI8hbw/h3fpdVq4ozDIXPfYCrgvWPbThP5IjFFOwsSYfRhAp
	 PePDehmbDAfVybT2ExP8JlOhjvESSqf0QwXuhI0GASuydDd2AYZc57ydUb6fysVRfsiTo
	 1jacLYHZMUfenqYxHoEekB5R6+D0z4FkYL43AzZH4koG+qZebuM3TBGyjc9ivj7c/rA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QSlDSdYW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9FE606A9D4;
	Sat,  7 Nov 2026 15:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QSlDSdYW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C401F008A1;
	Sat,  7 Nov 2026 15:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064900;
	bh=wO1ErzqQQSGorw+q/pEQ00ThJCffR97y78CaZV15G9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QSlDSdYWkKc5zgXtNvxj06WmTVCWt3Pj+ShCGQMbCSTVr6wXJz7x25VWudGEUJOvr
	 8heSVHMx63AW6FykMVgApub9EeMtcGJ3rkkBjMsehMdUf8mJL/XFJ3sJRyHK1dSBYi
	 NfrHVDQTozIo2C/AZxf3dB2uiC0FajhDBlPSQDp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radiy Zhambakiev <r.zhambakiev@prosoftsystems.ru>,
	Andreas Kemnade <andreas@kemnade.info>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0805/1257] mfd: tps65217: Fix NULL pointer dereference on IRQ init failure
Date: Sat,  7 Nov 2026 08:51:41 -0500
Message-ID: <20261107135001.568842412@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Radiy Zhambakiev <r.zhambakiev@prosoftsystems.ru>

[ Upstream commit 0473a5b0663663b75573bf284beb77459e07c461 ]

tps65217_probe() ignores the return value of tps65217_irq_init(), so
when the irq domain creation fails the probe still completes and the
driver ends up bound with a NULL tps->irq_domain. Unloading the
module then makes tps65217_remove() call irq_domain_remove() on the
NULL pointer and oops the kernel. On top of that, irq_find_mapping()
may fall back to the default irq domain and dispose of mappings that
belong to other interrupt controllers.

Check the return value and abort the probe on failure so the error
is reported and no inconsistent state is left for removal.

Fixes: 6556bdacf646fcaa ("mfd: tps65217: Add support for IRQs")
Cc: stable@vger.kernel.org
Signed-off-by: Radiy Zhambakiev <r.zhambakiev@prosoftsystems.ru>
Reviewed-by: Andreas Kemnade <andreas@kemnade.info>
Link: https://patch.msgid.link/20261002113624.178588-2-r.zhambakiev@prosoftsystems.ru
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/tps65217.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/tps65217.c b/drivers/mfd/tps65217.c
index c240fac0ede76..2d04d9e0ae29c 100644
--- a/drivers/mfd/tps65217.c
+++ b/drivers/mfd/tps65217.c
@@ -333,7 +333,9 @@ static int tps65217_probe(struct i2c_client *client)
 	}
 
 	if (client->irq) {
-		tps65217_irq_init(tps, client->irq);
+		ret = tps65217_irq_init(tps, client->irq);
+		if (ret)
+			return ret;
 	} else {
 		int i;
 
-- 
2.53.0



