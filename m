Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052375;
	b=bWOainCJ0saNzqt0qAr8cUfCpikNoAYKb++kAxIzJLOYnG+OwjynCb1rGCWZsh3Fj8FX
	 cefKPcPLMtzGa7CfHkOT8MtOpSwGt4Cj69N1GuWw6SQ956wE6+JwX6FLd1lPPgMl6JOBf
	 r+i1PVW2GDJHcOVMifxUZ7UBnA8+tUxSpNQqQUd7Mhj2VvI3zj0EONOehfLOp57/SFP5l
	 WcvzCGl0msq8rFlICxoeqoL+1mwVdghXk6q3kxuFR37mUpK6EsLHAEcwFALCqTtsgrkRh
	 Fq7vhx9OVTx156mQD1vlqJVZvQ6beQ/45bT5qcj+uWdmf13QiyoBIFtam/u66daDgjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052375;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hJPNNvMdsQflUCeRGehh4JDMcgOMraaqt032RSofV+I=;
	b=ETKvdQ/gGWPqfuQBSywXrCYbaAq7F9Q53D+qRF/yrjZvSizNjR51Lj3kFhxB77PZgDuJ
	 pqxlse0eoZ315kcO+LmQpJhqFy1Rc3pM2C5AUN9JlXsPsE/xfS287W8Yu+MbhOpKPLhrN
	 5pajfkpLTnJ7a7uQANQzyrwSqYHx5Gja+eHZTMNTRXbpJOBATyAcvTvLAIJ9UBGKwAGvn
	 sKdW0li+GybZk6J8LgvOnvsvp82V+4kSozYLFcyAWRYrIZpnnNYW3tRK5cT6Hv4ijh795
	 zGFyOB7VG6PKat0erjW9Z2CQZCrCjjJpcQA5M8I6SaVPpZC2fLJA7tVqb98I9AaOqpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GC4uxqSy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744B8606A332;
	Thu, 19 Nov 2026 01:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GC4uxqSy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C25CE1F000C4;
	Thu, 19 Nov 2026 01:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052375;
	bh=hJPNNvMdsQflUCeRGehh4JDMcgOMraaqt032RSofV+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GC4uxqSym7K0nH8s26hfHlJHDUn/hNj00gwRSrMRb4mLqp6qQ+cBbqoaXmEmS9p2S
	 GTBG86fKDUAh8+IEioT2wO9czfEnK8VZrdFU+opgHJCWCdrMczhBfysUn/IjK4NhUN
	 1oz9mlswLc8GiRnUww9R7Ho3SGCnxYfQN6OLQlzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0541/2214] mtd: maps: l440gx: Fix double put of the PM device in init_l440gx()
Date: Wed, 18 Nov 2026 15:36:57 +0100
Message-ID: <20261118150032.662386336@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



