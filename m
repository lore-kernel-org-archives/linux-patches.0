Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057125;
	b=Jiwngvwr5hO6eX7zLmvgK6k0I2AY1Tny3z9d4ZZoM8yhysjTadtG+MN86f39Ta3MOf3/
	 eJlexEj5am30u3yk0n3fV1hl00qjueEH1gnZ1QVize/d/9j9RsLOp1/fduSmFEOvZRGuJ
	 6lzm2s+vUpEWvczfA34VEVVrK5yZyiM/jy8mvEwLQnFpGmu+14TJuP3wn7momX2RhBzb+
	 ojNSmFwFvuNYvuv4uNNfryNCAW1iY/RsHNbE/BI6tYgS8Zqo4zpz9OlHyE8GX/T38S4h4
	 2R8K6xCx5dHsyduK0HGWCMr3wGqp4WSWaf7KFhiYP1M7eGQ1AoXQCDNIpIBOhPH1ZzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057125;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tgQlpWQSG4Xst6c3YSaomOErzbikFxI3ThEaad6OCLQ=;
	b=OuvcOhBieRI8DgW71jmG8TyCzeLkmFooSiFANK/S66aPhkIQMTk0U4qHjaPpSTBOtn1j
	 is6bNtNetJe65fA2XVdj1uzbk0tSykmjrgCnCrQ9tFtm4Y+XQMXJ2aUlPZSVMDpwlE8Ss
	 Jm39/pnc8YJFBdbEu4Un9AtqDoWO7pZOLOYEYfU6DHEIwTnP50AzYdHo/Yc/+Pa1b558M
	 5gx2dA+pC7yd0SVGSBDHby8Go2lx32hr9sxRL+XFXhM7aI6AlSHqJxQ3Q/+WyFAmT5rV2
	 O5JPFcgTYPcwVPmGGwAgSwR0AGLK+GbjoFEi008osW8pKAkFhQ0UDOXmZfBJhZd1CPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EcuKkodw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A132D606A31C;
	Thu, 19 Nov 2026 02:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EcuKkodw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F20FF1F000C4;
	Thu, 19 Nov 2026 02:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057125;
	bh=tgQlpWQSG4Xst6c3YSaomOErzbikFxI3ThEaad6OCLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EcuKkodwsIhGHjgwKPrvklAC2zvj5eRC1SEsMwP5TbHIBQtoKPQnCyUPtV1wYc7+O
	 Vb4eirT3wV+J3ReXbIOxlyMlzdFgxPBPIWI5bnfjDG1vmB2fMGAlxKmDbvlgtnr4Fa
	 vRf2bh7vxjrX1b5Zw59qjjv4JRpAiWax/vIszSlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Roman Demidov <roman.demidov.nn@gmail.com>
Subject: [PATCH 5.10 0021/1848] dmaengine: dw-edma-pcie: Reject devices without driver data
Date: Wed, 18 Nov 2026 15:34:19 +0100
Message-ID: <20261118145911.973917780@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <den@valinux.co.jp>

commit 11d7cfe0c119691b2dafbb699bbca90258c678aa upstream.

dw_edma_pcie_probe() treats the PCI device ID driver_data as the
template for the controller layout and copies it unconditionally. A
device bound dynamically via sysfs can match the driver without that
data, which leads to a NULL pointer dereference.

Reject such matches before enabling the device.

Fixes: 41aaff2a2ac0 ("dmaengine: Add Synopsys eDMA IP PCIe glue-logic")
Cc: stable@vger.kernel.org
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260521142153.2957432-3-den@valinux.co.jp
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Roman Demidov <roman.demidov.nn@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/dw-edma/dw-edma-pcie.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/dma/dw-edma/dw-edma-pcie.c
+++ b/drivers/dma/dw-edma/dw-edma-pcie.c
@@ -104,6 +104,9 @@ static int dw_edma_pcie_probe(struct pci
 	struct dw_edma *dw;
 	int i, mask;
 
+	if (!pdata)
+		return -ENODEV;
+
 	/* Enable PCI device */
 	err = pcim_enable_device(pdev);
 	if (err) {


