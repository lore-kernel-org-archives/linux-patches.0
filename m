Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D1237B407;
	Sat, 12 Sep 2026 08:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200743; cv=none; b=OuCXjZc0sbG48updTDOQp13+NTBZR5c6pHPBBySo/UjdsvAOqmCZJvbRhNvtAZrrXLP18XtTr9LzrSVTgTuFlKUYg6UxFWVQPgQgDRPVgYweTB70X/F5TSf66AQScv6qHGi2jg42vJRs//scsCgKB4HMX0xBGvu0QoowpPCSx2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200743; c=relaxed/simple;
	bh=vGPJk9aZCv+h2jNOfwv8tpS+lFvDWT/6lZBBT50FAX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FrQcUHHNCyCSrvFZsfGvAuIBohS+x73VuwNfA0i8W6AvQ9eQIAC8AXGIEdRuQAbKwcAg5mPbkgMMsxSKjL9G3VygHncQjxoR6EANf/gYg4tS/X3VOP3fv6Juc53vH+u0yxFIPpIbuUD9e069pU41U//ZtrejiKYoSmmEGJtxS0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QzgUXZqG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QzgUXZqG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCC7F1F000FF;
	Sat, 12 Sep 2026 08:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200742;
	bh=fkfGd8ma/S8r/nzWIFDaw6f7RPPtwoZn7vMgi+OiFok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QzgUXZqGQqYrvvwohH/PQ9hPxhnEHMlbOpb3yk6UDkoE1u1ho2NLSkFkzeOLasJ+S
	 Snth25F1z26MYYwSYvAKofpZM/Hu2ZbccoAIyzEWqKLziFryEWeqQxbfm/8G9V/Dg9
	 IOjtWDYbyIaZrH+kqhjeKTamyo2qml1srHRlkui8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0852/1815] powerpc: implement get_direction() in cpm2
Date: Sat, 12 Sep 2026 08:43:22 +0200
Message-ID: <20260912065708.921152026@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy (CS GROUP) <chleroy@kernel.org>

[ Upstream commit ca16219e9babc874349a6ac307d56523871a9137 ]

The lack of get_direction() callback in this driver causes GPIOLIB to
emit a warning. Implement it.

Fixes: e623c4303ed1 ("gpiolib: sanitize the return value of gpio_chip::get_direction()")
Signed-off-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/c6eb70aa0e1ba6e15f947c827006aa79edace05c.1785318836.git.chleroy@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/sysdev/cpm_common.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/powerpc/sysdev/cpm_common.c b/arch/powerpc/sysdev/cpm_common.c
index 07ea605ab0e62..b5d200e3ad684 100644
--- a/arch/powerpc/sysdev/cpm_common.c
+++ b/arch/powerpc/sysdev/cpm_common.c
@@ -181,6 +181,18 @@ static int cpm2_gpio32_dir_in(struct gpio_chip *gc, unsigned int gpio)
 	return 0;
 }
 
+static int cpm2_gpio32_get_direction(struct gpio_chip *gc, unsigned int gpio)
+{
+	struct cpm2_gpio32_chip *cpm2_gc = gpiochip_get_data(gc);
+	struct cpm2_ioports __iomem *iop = cpm2_gc->regs;
+	u32 pin_mask = 1 << (31 - gpio);
+
+	if (in_be32(&iop->dir) & pin_mask)
+		return GPIO_LINE_DIRECTION_OUT;
+
+	return GPIO_LINE_DIRECTION_IN;
+}
+
 int cpm2_gpiochip_add32(struct device *dev)
 {
 	struct device_node *np = dev->of_node;
@@ -199,6 +211,7 @@ int cpm2_gpiochip_add32(struct device *dev)
 	gc->ngpio = 32;
 	gc->direction_input = cpm2_gpio32_dir_in;
 	gc->direction_output = cpm2_gpio32_dir_out;
+	gc->get_direction = cpm2_gpio32_get_direction;
 	gc->get = cpm2_gpio32_get;
 	gc->set = cpm2_gpio32_set;
 	gc->parent = dev;
-- 
2.53.0



