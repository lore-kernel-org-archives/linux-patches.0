Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622775;
	b=jaLLLUchVRXPHxpMCV0UxjxP6UnDdsMv+aEMf9b7kGSdQOJE5er0slmXdxXKLEjfetHr
	 X4Fj2FGlYSl2qrsFFGjft6+g4PQvDjJsmhFuR1szX9/ExL5oKaEdqFt4Nhry7yr5NRmse
	 MXhA08E7G2WLow1Jj+37Bg/C7pTvslgodGO2/vfmo63IuoYSiNlCGQxjhVSWiWfAPij57
	 K4kt/bzq8q4zoTFL6KM9NbtQKlrWiyqPZKqyHsC9w8KMjC8+wLjNp+6DS6pfL7Mn1nt1r
	 plzV5oWFvkM4u4OGvZGRsCiYl3QUe1/1PX4QXiaZlmSYL4cXOGzO2WkquIDtQKhcwOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622775;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2Dyimly4XMwC4/0v/RkvKKxAMZ4muQXkIxFtR3tBTSc=;
	b=4+iS16KL5Ak9ddobo6mjiqA85IvHCC37r72uKSxDmGZ875da6LrU8pkU8f8wZI2Ukz27
	 lXib93NlJND1xl+W1wuOuoHNP5UmUxOppMd/oiePC6AIJhp1KFHtf/56da2mluXy7EgdD
	 oaV64PfjWS5YCoUirxL87g2/soZdNnbHxNo4TCpx5CjOnjXq1airYPdRi7Ci+sJhwagx+
	 TEK7ePzD8ECTS89JgV8eQ9++x6q0T2MXwQVeBO/tN82FuJabVbjEJjD9uV33kPEPbFf0/
	 p++fHW8mdaASc7VGHo0VV434Tevghcp7I+vZ4D3zSUn1Hdzivs3/HLZfHkmKUwSYz/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OPDRSz3u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDFA606A31E;
	Wed, 25 Nov 2026 16:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OPDRSz3u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 602461F000C4;
	Wed, 25 Nov 2026 16:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622774;
	bh=2Dyimly4XMwC4/0v/RkvKKxAMZ4muQXkIxFtR3tBTSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OPDRSz3uh+yCu1dLPLb6wXoBk+YofBrrib+I3R2+hivvK8rh2dF/m+0HvkMY2Cjg4
	 PdfJnYg0Vrh2t6wg3wW/zk/LtkusMBvyE352iQ8RQraohM/4dXBoQu7ql6b39qdOOY
	 vm9biy45/nKzBw+4PL8yxGJP0jky5Qw8/XZVAMbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Radu Rendec <radu@rendec.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 598/990] irqchip/mst-intc: Validate the DT interrupt range
Date: Wed, 25 Nov 2026 15:32:45 +0100
Message-ID: <20261125143836.099327702@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
[ sashal: Context adjusted: the upstream range check is inserted above this tree's older kzalloc(sizeof(*cd), GFP_KERNEL) call instead of kzalloc_obj(*cd). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-mst-intc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/irqchip/irq-mst-intc.c b/drivers/irqchip/irq-mst-intc.c
index 7f760f555a76a..d380030eda935 100644
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



