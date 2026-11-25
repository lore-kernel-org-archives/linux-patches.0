Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618670;
	b=HcVfNagwTLkhmXVC+I+KPMV7f+h5n0+RaO/fH7EPqKTLwUbeAgILkrNGeZOQfNOAQH3O
	 q1aC+1GMuom7J0hrQvuxHr+MbfNHcRKS8hhIOXHMLY6U5R6EtSrbYa0cftilplCP3583A
	 RWOrZrJ0eeTdn+8BLqr3gtcn3Oxox8GLWfKYp690yn2mYRLI+fXEOMR2EIRAwehont5zQ
	 qPinTleuVy8v0QV3yqOVt2xo6xdD+79p0+sCuc3p6oBelDZBThXxV3u5jwDN5ckN2xW2j
	 Y0vul9GlVkTmmJGik8qqbZRkGQFhmUWE75cDOzl9ewo8GMVnPZdX1d7fTRkYALtTYCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618670;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0wUrhvHUkRFEdu6ES38zgWzjLq/ea30aOB8Z4lc+qUg=;
	b=tPY60vTMlSuhhzZBNPnUlfS1+RLTnPUmOySpF6TMGb477try96K6zYGxN6fCJZR8qUaF
	 fwNnRbBvdrOjv1CijAUNJpDv7Sbdu8Ge62B+oIlUAVaiXIWdXjFFmtRCySGCTJuEt/caL
	 tS7CA4Iy+3NzEv9FMapjj/Bz0wfIyTKlaAEQ/SHpm9uQufG2W3wMvBz9D9etKK6fE4m7N
	 pnmUZa4NNhoFkJb1WNB59uAYDl8viRR88debeaJy4AchZuUTBzT4iEt0Qasnkt3T9S5lS
	 dekqhP9NzACep0+n9OP2SBJKkOyTZks22/yofogptSSoPLdXAGSy4/ZgqKDcZgSrj2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PQQYKwTM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9B5606A323;
	Wed, 25 Nov 2026 14:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PQQYKwTM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED911F000C6;
	Wed, 25 Nov 2026 14:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618669;
	bh=0wUrhvHUkRFEdu6ES38zgWzjLq/ea30aOB8Z4lc+qUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PQQYKwTMaKYdtfiPOJzQ/7da18ctEPtJplxhBOaFcmzCuiXiIs0BAuKGAruolzEXP
	 XsOjxH6fOLbFW4Dqr8rmw6lFmioArsXgdp6UkYr3YUYQU0K2SNdSrxk4Q1+NaUNmrf
	 9Xo7bpKPDgS//qm/OAn2hu8giKdTQoneTJ8GxzT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Isaac Adjei <code@isaacadjei.me>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0350/1005] gpio: mpfs: reject unsupported interrupt types
Date: Wed, 25 Nov 2026 15:28:08 +0100
Message-ID: <20261125143829.932132547@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Isaac Adjei <code@isaacadjei.me>

[ Upstream commit cfbd01eddaf5bfdd4f53560013fe830571a186e9 ]

The switch statement in mpfs_gpio_irq_set_type() does not handle
unsupported interrupt types. For example, IRQ_TYPE_NONE is not listed.

When an unsupported type is passed, interrupt_type remains
uninitialised. Its undefined value is then written to the GPIO control
register. The function still returns 0, making the caller believe the
operation succeeded.

Add a default case to return -EINVAL for unsupported interrupt types.

Smatch reported the following warning:

  drivers/gpio/gpio-mpfs.c:144 mpfs_gpio_irq_set_type() error: uninitialized symbol 'interrupt_type'.

I built the driver with W=1 and got no warnings. I also reran Smatch
and confirmed that the warning was resolved.

This is compile-tested only. I do not have access to PolarFire SoC
hardware for runtime testing.

Fixes: e57b53f0f36a ("gpio: mpfs: Add interrupt support")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202411080149.bOpayvf6-lkp@intel.com/
Signed-off-by: Isaac Adjei <code@isaacadjei.me>
Link: https://patch.msgid.link/20261105-gpio-mpfs-irq-type-v1-1-cbb2b0b2a807@isaacadjei.me
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mpfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpio/gpio-mpfs.c b/drivers/gpio/gpio-mpfs.c
index 7f0751d7b1c4b..0b7a48e0ac262 100644
--- a/drivers/gpio/gpio-mpfs.c
+++ b/drivers/gpio/gpio-mpfs.c
@@ -138,6 +138,8 @@ static int mpfs_gpio_irq_set_type(struct irq_data *data, unsigned int type)
 	case IRQ_TYPE_LEVEL_LOW:
 		interrupt_type = MPFS_GPIO_TYPE_INT_LEVEL_LOW;
 		break;
+	default:
+		return -EINVAL;
 	}
 
 	regmap_update_bits(mpfs_gpio->regs, MPFS_GPIO_CTRL(gpio_index),
-- 
2.53.0



