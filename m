Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625389;
	b=rgqepTjjgk20hRRdC15EzCeNQffj+Mj6AZQaZhZADwPl4pKjdkHrWhwyuuQqJjz/nZrW
	 UoMLb8hgSAhKvARZCQRQLEGGESlWYzh1Z90tD5EFKQ1FfmSlWr8kROT+hq/XQLA+PexUk
	 NYGWyCJyddokJZC4T2crETfUuyJdxiFPbY6nOxH9cu8cNEHau9FsK41xCT0BlmwiOK3Vk
	 CvhiE3mMntPJ6GXWjdcuGfn1Jyk6F8QVW8SSj+6wVda+FgcJVsfELGIjg7CjltWnDc/zm
	 7LL/Exe/Juba6Dt2TNrzY7jRC5FyYt8lH+7Q+8Rf0eWnt1RMzm9cKxp95zXzjUIN0XQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625389;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pV6PbWdFJ/zw+PjQLw7MZL9aQY9JVgO+yjBndJKaMbw=;
	b=RpXxTzk5FuTwxfdtdNeyBMkeVb/Ra/uUIWB1I4lHhBBIVd8ZdEEBY437q/lvH2mocs3C
	 p/BnaM3P9WQ80sVkL4BnZcMsyQ0jJXDi/oPu2XNKFQXMJpIA41ZL8G5fZeX2eSvfI4l24
	 cx/9LX8sKf1DP/+CAzMoft1c5M3SbuTI5gloM0AG+BS3Vrb9sMKQAPoSkuy/JyTHwMKis
	 Pd7y2zIjj4GnaIl3TsswzsmVk27jcgvOnOZzEWEwXPpqUXXFrfOeKgqRDB6fpeEnuVKdf
	 BgH/CRIWqFqrU2PuAvxYFgNRReezoSoTOfV+vTpnFJPsAFuOKNPxQDYGXjJOEYSGzJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uc9JdKsU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8EB4606A31E;
	Wed, 25 Nov 2026 16:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uc9JdKsU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E7E1F000C6;
	Wed, 25 Nov 2026 16:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625389;
	bh=pV6PbWdFJ/zw+PjQLw7MZL9aQY9JVgO+yjBndJKaMbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uc9JdKsUpixy8zyhxHPR4WgBULZCExz8hHpSJle6GgaG0A8+UnsTqT9osvvBJ9BHh
	 wtl1nFmun9cd4wTib7FaJkqpcVm4h6qSnNNnJO7KGzzzAmikH/qdzwlWp19aVyhYea
	 DICs6ChEchSxgMA3kJ4U0tkr6qm9TSRdHc9rK4U0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Radu Rendec <radu@rendec.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 499/816] irqchip/mst-intc: Validate the DT interrupt range
Date: Wed, 25 Nov 2026 15:34:07 +0100
Message-ID: <20261125143900.738939190@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Pengpeng Hou <hppiscas@163.com>

[ Upstream commit 16f25d326e5d3b9fd51bc5e3916ecbffbca63e7b ]

The driver takes an inclusive interrupt range from the device tree
without checking its endpoints. A reversed range wraps the unsigned
count calculation, and a range larger than MST_INTC_MAX_IRQS exceeds the
controller capacity used by the driver.

Reject these ranges before calculating nr_irqs or creating the domain.
Check the difference after ordering the endpoints so the validation
itself cannot wrap.

The issue was found by our static-analysis tool.

Fixes: ad4c938c92af ("irqchip/irq-mst: Add MStar interrupt controller support")
Signed-off-by: Pengpeng Hou <hppiscas@163.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Assisted-by: gpt 5
Reviewed-by: Radu Rendec <radu@rendec.net>
Link: https://patch.msgid.link/20260920034236.16229-1-hppiscas@163.com
[ sashal: kept the branch's kzalloc(sizeof(*cd), GFP_KERNEL) allocation line instead of upstream's kzalloc_obj(*cd) as the patch context. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-mst-intc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/irqchip/irq-mst-intc.c b/drivers/irqchip/irq-mst-intc.c
index d771eb0346128..be6e37badb359 100644
--- a/drivers/irqchip/irq-mst-intc.c
+++ b/drivers/irqchip/irq-mst-intc.c
@@ -263,6 +263,9 @@ static int __init mst_intc_of_init(struct device_node *dn,
 	    of_property_read_u32_index(dn, "mstar,irqs-map-range", 1, &irq_end))
 		return -EINVAL;
 
+	if (irq_end < irq_start || irq_end - irq_start >= MST_INTC_MAX_IRQS)
+		return -EINVAL;
+
 	cd = kzalloc(sizeof(*cd), GFP_KERNEL);
 	if (!cd)
 		return -ENOMEM;
-- 
2.53.0



