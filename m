Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052369;
	b=JNHRuQDaRwSHRlFVRWFejDsHf2kZNpnnM4Np8WbftTHgVEsCrjv6ppYlrvLwzXlMjUEO
	 4eKLAuFvS0SLX5vHm7VCSNoGJmcIM/vQBwQepFea3csGBDHdupQ+SRqDhk3qVCOi9vnn4
	 gwp/6VM9J28+XQRZl3IuENPblb4XayWE5vts2iNMG6mY54FNgHHaEZApgRwazv/bgcxV6
	 KnF87Sf4YlMOi7ktzgTbvgreGVktWTkUl+yLccRLBk7nuduxHK3ljjB1nvp2VymB/rrY8
	 GQ/t8K2C/MC4JBnU48VsmeBlnTQtcZT8C1boO34bs5xYUQX5+8ZYvC4S1MvEMGEX8JQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052369;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TpC9PIl82xTVobRLr3ykuUHIGEV3owylcOFvRbbvP94=;
	b=c1dwMWyw2shBfORYk21A7CGDlA4f4xswB3JRN3txe8f38j3ZzNkNq1idO3UyWnifNVSw
	 lNyRO1FWjFsXanZzqw/oMapSEjGr3Kq0bflJ1SQMkt9kBvrb3lGAtDa+oB/L02pYG0x7L
	 syRWCnj49UG3ZsZZGQEJILI7QF9j7WnCWnG8ZU+5rluj0lF3DgkkmF3mBjpOdYgu8NeKk
	 0GpTmzE+/fMq7yoWwqrwcPMqAHhtmXI3fcdtENLlXfVNMOz1SvLITtSa4ReK/zCEA2NYE
	 5Ju6MO2qWq66MDeJ1iiCm0fr8i8So/9hMVBwRf/iXl09lqYdjU6Mr7luMYdvpWNG61w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iMINIZSM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8CB606A32C;
	Thu, 19 Nov 2026 01:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iMINIZSM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 187421F000C4;
	Thu, 19 Nov 2026 01:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052369;
	bh=TpC9PIl82xTVobRLr3ykuUHIGEV3owylcOFvRbbvP94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iMINIZSM9dqcsZmDfCgesFWUDEifcTRZ0I5UFRv1s7NnAYmLcDs4D75iamlQwlwEk
	 PujAW719oLrVxbx7EFxrlMOj+twC4ev6hHcnwC8LGWN4rj2+Zsm2nknEMfVMpaMi8k
	 HEbUVnyaOxh7eDiAMECd1CKmz1ZPrpQ/soPhR4/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0540/2214] mtd: maps: l440gx: Fix double put of the ISA bridge in init_l440gx()
Date: Wed, 18 Nov 2026 15:36:56 +0100
Message-ID: <20261118150032.625801342@linuxfoundation.org>
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

[ Upstream commit 521ad948e04934b2d70ae899bc016bbb38802e90 ]

init_l440gx() takes a single reference on the PIIX4 ISA bridge with
pci_get_device() and drops it again right after the lookups, before
the flash window is set up.  The pci_assign_resource() failure path
then calls pci_dev_put() on the same device a second time, releasing a
reference that is no longer owned and underflowing the reference count.

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
index 832b880d1aaf8..85cd273ce0654 100644
--- a/drivers/mtd/maps/l440gx.c
+++ b/drivers/mtd/maps/l440gx.c
@@ -110,7 +110,6 @@ static int __init init_l440gx(void)
 
 		/* Allocate the resource region */
 		if (pci_assign_resource(pm_dev, PIIXE_IOBASE_RESOURCE) != 0) {
-			pci_dev_put(dev);
 			pci_dev_put(pm_dev);
 			printk(KERN_WARNING "Could not allocate pm iobase resource\n");
 			iounmap(l440gx_map.virt);
-- 
2.53.0



