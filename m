Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E56146A609;
	Tue, 21 Jul 2026 15:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649335; cv=none; b=kBni1k9BhDVODnio9FYSMQance5qscfKrGc1l6UnAV+JOTyT4sUV+QfxqtTlqeeMtbaBs01ky/wIi4tu1A4LiuplNWFWW758enWq4sCId3/1LM7VaZmftOLLh9kB2a7aqVS7GyxlWNjtFNycUF5vK8k160g6+xdljWUgzVNa3kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649335; c=relaxed/simple;
	bh=FIkKwE/U85UNY8kn9YhxK0hr4oW/FLIRqx41g9rf4u0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HuWpysJB6SiCWlzY7xJ53XjUbcbSlb4GDfJ0C3tYX0KAO2W1CImcltrogrZ4Q4DyQ7n/2GdOEERR6iQJYm+jCwh2LnE8i8ha4bTLkDFNqinRJcaw5YlhKoMYnig4a2bp2A8WaiC6eTwVrGpldzdLEkSAPNAyuKSlVmCaDndEbjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k369D/FY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k369D/FY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B673D1F000E9;
	Tue, 21 Jul 2026 15:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649334;
	bh=LvL15PtpHDdBrnTzar2pffX//jIJWl02Smg4GKuhY1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k369D/FY5k+iqbTuTWfh8Xat24xDoqdEnTrm2LW3oauOw67X5Y6ifQSgittOEJmKo
	 VDQ2g8rRvv+ba/gfT3lWvj12KLpciIezsPdKt8G2JpTHvI8ShBpz+n7WufZWkzzbbM
	 tWzfj/eLT5e78psCNbS6NkbH0UarYzoZjjRrkiUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <chleroy@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0538/2077] powerpc/8xx: implement get_direction() in cpm1
Date: Tue, 21 Jul 2026 17:03:31 +0200
Message-ID: <20260721152605.498391766@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

[ Upstream commit 052f67a1ae6ffa6e43c82193bf2e6c0dfd2e6d8f ]

The lack of get_direction() callbacks in this driver causes GPIOLIB to
emit a warning. Implement them for 16- and 32-bit variants.

Reported-by: Christophe Leroy <chleroy@kernel.org>
Closes: https://lore.kernel.org/all/63487206f6e5a93eaf9f41784317fe99d394312f.1780399750.git.chleroy@kernel.org/
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Fixes: e623c4303ed1 ("gpiolib: sanitize the return value of gpio_chip::get_direction()")
Tested-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
[Maddy: Fixed the Fixes tag]
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260603-powerpc-8xx-cpm1-get-dir-v1-1-2ae1c9a5b992@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/8xx/cpm1.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/powerpc/platforms/8xx/cpm1.c b/arch/powerpc/platforms/8xx/cpm1.c
index f00734f0590cf7..b31376bf677880 100644
--- a/arch/powerpc/platforms/8xx/cpm1.c
+++ b/arch/powerpc/platforms/8xx/cpm1.c
@@ -472,6 +472,18 @@ static int cpm1_gpio16_dir_in(struct gpio_chip *gc, unsigned int gpio)
 	return 0;
 }
 
+static int cpm1_gpio16_get_direction(struct gpio_chip *gc, unsigned int gpio)
+{
+	struct cpm1_gpio16_chip *cpm1_gc = gpiochip_get_data(gc);
+	struct cpm_ioport16 __iomem *iop = cpm1_gc->regs;
+	u16 pin_mask = 1 << (15 - gpio);
+
+	if (in_be16(&iop->dir) & pin_mask)
+		return GPIO_LINE_DIRECTION_OUT;
+
+	return GPIO_LINE_DIRECTION_IN;
+}
+
 int cpm1_gpiochip_add16(struct device *dev)
 {
 	struct device_node *np = dev->of_node;
@@ -498,6 +510,7 @@ int cpm1_gpiochip_add16(struct device *dev)
 	gc->ngpio = 16;
 	gc->direction_input = cpm1_gpio16_dir_in;
 	gc->direction_output = cpm1_gpio16_dir_out;
+	gc->get_direction = cpm1_gpio16_get_direction;
 	gc->get = cpm1_gpio16_get;
 	gc->set = cpm1_gpio16_set;
 	gc->to_irq = cpm1_gpio16_to_irq;
@@ -604,6 +617,18 @@ static int cpm1_gpio32_dir_in(struct gpio_chip *gc, unsigned int gpio)
 	return 0;
 }
 
+static int cpm1_gpio32_get_direction(struct gpio_chip *gc, unsigned int gpio)
+{
+	struct cpm1_gpio32_chip *cpm1_gc = gpiochip_get_data(gc);
+	struct cpm_ioport32b __iomem *iop = cpm1_gc->regs;
+	u32 pin_mask = 1 << (31 - gpio);
+
+	if (in_be32(&iop->dir) & pin_mask)
+		return GPIO_LINE_DIRECTION_OUT;
+
+	return GPIO_LINE_DIRECTION_IN;
+}
+
 int cpm1_gpiochip_add32(struct device *dev)
 {
 	struct device_node *np = dev->of_node;
@@ -621,6 +646,7 @@ int cpm1_gpiochip_add32(struct device *dev)
 	gc->ngpio = 32;
 	gc->direction_input = cpm1_gpio32_dir_in;
 	gc->direction_output = cpm1_gpio32_dir_out;
+	gc->get_direction = cpm1_gpio32_get_direction;
 	gc->get = cpm1_gpio32_get;
 	gc->set = cpm1_gpio32_set;
 	gc->parent = dev;
-- 
2.53.0



