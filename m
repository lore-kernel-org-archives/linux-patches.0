Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064160;
	b=31yN7cbMixDf9MEUji+lNj3O3PEG5PO5hyhneHfKkf7i6JiRw5qwaTvNcmGQ74Ip+YQs
	 J55uCCFxlukdVNOZ+QVf6KP4DmFDaYCnjAGw3ocIPGTL9Em8zJn/LLOOJmWNhArxJXWfn
	 vqT9p8z6QkaXWziwPtBcQYS+u3LtK+Q02fFk8lh7IEEVGvMS3T92ij6/LFR9k18/WF8Pt
	 Ix/JBAjIWzPf6z9tX9ctk/bkZgjvTi4lNsPtrKX9NHUK+s0Y3zZmBGQfrMEJ0v0BxX2HR
	 O7HvQOtFo4we6wRN5ONg5ScMSdZF5UnpZrolRYiTUpInEi9SbL9bVZPejbNzjkwBnZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064160;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mEfz6VnXG/vuyXSrY+tPMF+O/Tl56j/IRdiuFpU3SKQ=;
	b=Xh8qqsg/NljsThcTuSiFRShWAeaxdOPhw2n1g+C26qXRkplum34cgZ6TtUHPDtgyWxro
	 PaamoNAoMl8qwQEIHC99AVGpfg16Kx4TxNvt/zFuJzT9gMKwkbryFHY698hqmurHoTMbC
	 KJyW/WyM12qbdbQGOVujYShM4NLOj+uQV4hZrCPc6dAIFeMdqrcPIDGhqQsoe7twAh+Ep
	 yYJZviha2uCz9uP/mJhRXCNmYUA0FdGWsHqW1N0vqStrIrq6JkHRPyu42Y2Xxi7mQoRLN
	 YTC2k1wq/NWVd3Ukx/hdncbX1F8psS6b2xLj6XG6WUCbegiO6rAgvkXloJuy/kwu+NA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dJF9Aef2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F383C606A32E;
	Sat,  7 Nov 2026 15:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dJF9Aef2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2CBF1F008A6;
	Sat,  7 Nov 2026 15:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064159;
	bh=mEfz6VnXG/vuyXSrY+tPMF+O/Tl56j/IRdiuFpU3SKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dJF9Aef2BsmaaN/DVMQE3X2V6a3M2UyZK6iSVT4VHvg5ZAQ4wAMds11YF4lA31VDx
	 oMrChdcaZO+62at2yhDXCWxxxC5/S7chrIYAEmq2+gxSQEWC67EB7be1QpGYC0xavu
	 8TuPGPQ15KVa+Ai49B/4zaudm79nB90s0g6Yp2cc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0308/1257] mtd: maps: l440gx: Fix double put of the PM device in init_l440gx()
Date: Sat,  7 Nov 2026 08:43:24 -0500
Message-ID: <20261107134947.947007066@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit e6ca524ee5b2705be30ea19ce2e55122d9f9ed8f ]

The PIIX4 PM device reference taken with pci_get_device() is dropped
again before the iobase resource is allocated.  If pci_assign_resource()
fails, the error path calls pci_dev_put() on pm_dev a second time,
releasing a reference that is no longer owned and underflowing the
reference count.

Remove the extra pci_dev_put().

Fixes: dd8e9ed6ed54 ("[MTD] Switch to pci_get_device and do ref counting")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/maps/l440gx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mtd/maps/l440gx.c b/drivers/mtd/maps/l440gx.c
index 85cd273ce0654..1df5ea5fafcac 100644
--- a/drivers/mtd/maps/l440gx.c
+++ b/drivers/mtd/maps/l440gx.c
@@ -110,7 +110,6 @@ static int __init init_l440gx(void)
 
 		/* Allocate the resource region */
 		if (pci_assign_resource(pm_dev, PIIXE_IOBASE_RESOURCE) != 0) {
-			pci_dev_put(pm_dev);
 			printk(KERN_WARNING "Could not allocate pm iobase resource\n");
 			iounmap(l440gx_map.virt);
 			return -ENXIO;
-- 
2.53.0



